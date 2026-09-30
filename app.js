const cfg = window.SUPABASE_URL && !window.SUPABASE_URL.startsWith("PASTE_") ? window.SUPABASE_URL : null;
let sb = null;
if (cfg && window.supabase) sb = window.supabase.createClient(window.SUPABASE_URL, window.SUPABASE_ANON_KEY);

document.querySelector(".menu")?.addEventListener("click",()=>document.querySelector("nav").classList.toggle("open"));

const esc = s => String(s ?? "").replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const placeholder = "https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?auto=format&fit=crop&w=900&q=80";

async function loadNews(){
 const box=document.querySelector("#latestNews"); if(!box)return;
 if(!sb){box.innerHTML='<div class="loading">Connect Supabase to load published news.</div>';return}
 const {data,error}=await sb.from("news").select("*").eq("published",true).order("published_at",{ascending:false}).limit(6);
 if(error){box.innerHTML='<div class="loading">Unable to load news right now.</div>';return}
 if(!data?.length){box.innerHTML='<div class="loading">No published news yet.</div>';return}
 box.innerHTML=data.map(n=>`<article class="news-card"><img src="${esc(n.featured_image_url||placeholder)}" alt=""><div class="body"><div class="meta">${esc(n.category||"News")} · ${new Date(n.published_at||n.created_at).toLocaleDateString()}</div><h3>${esc(n.title)}</h3><p>${esc((n.excerpt||n.content||"").replace(/<[^>]*>/g,"").slice(0,140))}…</p><a class="read" href="article.html?id=${encodeURIComponent(n.id)}">Read More →</a></div></article>`).join("");
}
async function loadMedia(type="photos"){
 const box=document.querySelector("#homeMedia");if(!box)return;
 if(!sb){box.innerHTML='<div class="loading">Connect Supabase to load media.</div>';return}
 const {data,error}=await sb.from("media").select("*").eq("published",true).eq("type",type).order("created_at",{ascending:false}).limit(6);
 if(error){box.innerHTML='<div class="loading">Unable to load media right now.</div>';return}
 if(!data?.length){box.innerHTML='<div class="loading">No published media yet.</div>';return}
 box.innerHTML=data.map(m=>`<article class="media-item">${m.type==="video"?`<video src="${esc(m.file_url)}" controls preload="metadata"></video>`:`<img src="${esc(m.file_url)}" alt="${esc(m.title||"Photo")}">`}<div class="caption"><h3>${esc(m.title||"Untitled")}</h3><small>${esc(m.caption||"")}</small></div></article>`).join("");
}
document.querySelectorAll(".media-tabs button").forEach(b=>b.addEventListener("click",()=>{document.querySelectorAll(".media-tabs button").forEach(x=>x.classList.remove("active"));b.classList.add("active");loadMedia(b.dataset.media)}));
loadNews();loadMedia();