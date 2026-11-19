# Devi Banaras — professional multi-page website

## Pages
- `index.html` — Home and featured stories
- `photography.html` — searchable gallery, uploads, critique/comments
- `travel.html` — travel journal, searchable stories, uploads
- `research.html` — research interests and collaboration calls
- `community.html` — participation and collaboration
- `about.html` — personal brand introduction
- `contact.html` — contact and collaboration form
- `login.html` and `register.html` — separate account pages

All pages share `style.css`, `app.js`, and `config.js`. This is a real multi-page site, not a single page with anchor sections.

## Activate the backend
1. Create a Supabase project at https://supabase.com.
2. Replace `YOUR_EMAIL@example.com` in `setup.sql` with your intended owner email and run the SQL in Supabase SQL Editor. If you ran the SQL from the earlier website, you can reuse that existing database without rerunning it.
3. Edit **config.js** and replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_PUBLISHABLE_KEY` with the Supabase project URL and public/publishable (anon) key. NEVER put a secret/service-role key in frontend code.
4. In Supabase Authentication enable Email authentication and configure the Site URL and allowed redirect URLs to match your deployment.
5. Deploy the **entire folder** (all HTML, JS, CSS and SQL reference file) to Netlify or another static host. Test on a web server; `file://` may block JS modules. For local testing, run `python -m http.server 8000` in the folder and open http://localhost:8000.
6. Register, confirm your email if requested, and log in. You can now publish photos and travel stories, leave comments, and submit inquiries.

## Important limitations
- With no Supabase credentials, the home/gallery show **sample images only** and upload, login and contact submission remain inactive. Samples are not your photographs.
- Contact inquiries are saved in Supabase `inquiries`; **email notifications are not automatically sent**. Configure an Edge Function / webhook and an email service if inbox delivery is required.
- Current policy permits any authenticated member to publish. For an owner-curated gallery, add an approval/moderation workflow and restrict inserts to owner accounts.
- Add CAPTCHA, spam prevention, comment moderation, privacy notice, consent for identifiable photographs, and data retention policy before public launch.
- Images are stored in a public Supabase Storage bucket; do not upload private material. File size limited to 8 MB.
- Research content is informational; publication listing, research project submission dashboard, and admin controls can be added in a future version.

## Photograph uploads without Supabase (local gallery)
Open the site on a local HTTP server (e.g. `python -m http.server 8000`). On Photography or Travel click **Upload photograph**, choose a JPG/PNG/WebP image up to 8 MB, enter a title, and publish. The image is stored in browser IndexedDB and displayed in the gallery even after refreshing. This is **not a public upload**: images are not synced across browsers or devices, and deleting browser/site data removes them. Browser storage quotas apply. In private browsing, data may be cleared automatically.

To publish images for all visitors, configure Supabase in `config.js`, run `setup.sql`, register and log in. The website will then use cloud uploads. If uploads fail, check that the `portfolio` bucket and storage RLS policies exist, the account is authenticated, and the browser console for error messages.
