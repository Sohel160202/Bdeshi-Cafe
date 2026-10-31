import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const cors = { "Access-Control-Allow-Origin":"*", "Access-Control-Allow-Headers":"authorization, x-client-info, apikey, content-type", "Content-Type":"application/json" };
const json = (body:unknown,status=200) => new Response(JSON.stringify(body), { status, headers:cors });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers:cors });
  const url = Deno.env.get("SUPABASE_URL")!;
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const admin = createClient(url, serviceKey);
  const token = req.headers.get("Authorization")?.replace("Bearer ", "");
  if (!token) return json({ error:"Unauthorized" },401);
  const { data:{ user }, error:userError } = await admin.auth.getUser(token);
  if (userError || !user) return json({ error:"Unauthorized" },401);
  const { data:actor } = await admin.from("staff_profiles").select("role").eq("id",user.id).single();
  if (!actor || actor.role !== "manager") return json({ error:"Manager access required" },403);
  const body = await req.json();
  if (body.action === "list") {
    const { data, error } = await admin.from("staff_profiles").select("id,full_name,username,role,active,created_at").order("created_at");
    return error ? json({error:error.message},400) : json({staff:data});
  }
  if (body.action === "create") {
    const username = String(body.username||"").trim().toLowerCase().replace(/[^a-z0-9._-]/g,"");
    const password = String(body.password||"");
    const fullName = String(body.full_name||username).trim();
    const role = body.role === "manager" ? "manager" : "server";
    if (username.length < 3 || password.length < 8) return json({error:"Username must be 3+ characters and password 8+ characters"},400);
    const email = `${username}@staff.bdeshicafe.local`;
    const created = await admin.auth.admin.createUser({email,password,email_confirm:true,user_metadata:{username,full_name:fullName}});
    if (created.error || !created.data.user) return json({error:created.error?.message||"Could not create account"},400);
    const { error:profileError } = await admin.from("staff_profiles").update({username,full_name:fullName,role,active:true}).eq("id",created.data.user.id);
    return profileError ? json({error:profileError.message},400) : json({ok:true});
  }
  if (body.action === "delete") {
    if (body.id === user.id) return json({error:"You cannot delete your own account"},400);
    const result = await admin.auth.admin.deleteUser(String(body.id));
    return result.error ? json({error:result.error.message},400) : json({ok:true});
  }
  return json({error:"Unknown action"},400);
});
