# Samrat Chakraborty — Full Website Package

This version includes a public website plus a private admin CMS.

## Included
- Home / profile page
- About
- Daily News / article listing
- Individual article pages
- Photo gallery
- Video gallery
- Contact page
- BJP logo placement
- Mobile responsive design
- Admin login
- Admin news publishing
- Admin photo uploads
- Editable Social Media links (Facebook, Instagram, YouTube, X, WhatsApp, Website)
- Admin video uploads
- Delete content from dashboard
- Supabase database + storage integration
- RLS policies for public published content and authenticated administration

## IMPORTANT: one-time Supabase setup
1. Create a project at Supabase.
2. Open SQL Editor and run `supabase-schema.sql`.
3. In Authentication > Users, create an admin user with email/password.
4. Copy the Project URL and anon/public key.
5. Put them into `supabase-config.js`.
6. Upload the whole folder to GitHub Pages, Netlify or Vercel.

### Supabase configuration
`supabase-config.js`:
```js
window.SUPABASE_URL = "https://YOUR-PROJECT.supabase.co";
window.SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";
```

NEVER put a `service_role` key in browser code.

## Social media workflow
Open `/admin.html` → Social Media → enter the exact Facebook/Instagram/YouTube/X/WhatsApp/Website URL → Save.
The public website shows enabled links as clickable cards. You can change or delete them later from the same dashboard.

## Daily workflow
Open `/admin.html` → login → publish article or upload photo/video.
Published content automatically appears on Home, News and Media pages.

## News editor
The article content field accepts basic HTML. For a richer editor (bold, headings, images, links, Bengali formatting) the next upgrade can integrate a visual editor such as TipTap/Quill.

## Profile photo
`assets/profile.jpg` is the supplied image currently included. Replace it with a high-resolution official portrait when available.

## Branding
The BJP lotus logo is referenced from Wikimedia Commons. Review the applicable licensing/attribution requirements before public/commercial deployment.

## Production recommendations
- Add a custom domain.
- Turn on Supabase email verification / strong admin password.
- Add an admin-only allowlist if multiple editors are needed.
- Add image compression and video size limits.
- Add SEO Open Graph images and structured data.
- Add a privacy policy and terms/contact notice if collecting visitor data.
