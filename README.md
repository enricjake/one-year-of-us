# One Year of Us

An interactive anniversary album that Nicole fills in herself — and that both of you can see. No templates to choose from, no code to edit, no account for visitors.

Live: <https://enricjake.github.io/one-year-of-us/>

---

## What it does

- **Blank slate.** It opens empty, with a few prompt chips ("The first message", "11pm snack aisle", …) if she needs a starting point.
- **Add a memory** = a title, a date, a photo, and as many words as she wants.
- **Photos** come from the existing album in `assets/photos/`, or an upload from her device. Uploads are resized in the browser before being saved.
- **Reorder freely** by dragging cards, or with ↑ / ↓ buttons on touch screens. Edit or delete anything at any time.
- **Up to 50 memories.** The scrollable photo strip in the hero shows every memory; add buttons disable at 50.
- **A player on each memory.** Paste a YouTube or Spotify link in the editor and a click-to-play embed appears on the card, showing the video/song's real title and a preview thumbnail. YouTube titles/thumbnails come from `noembed.com`; Spotify's from `open.spotify.com/oembed`. Both are CORS-enabled. If the lookup fails, a generic label is shown. Other sites are rejected.
- **Upload your own audio.** Each editor has an "♫ Upload audio" button (MP3/M4A/WAV/OGG, up to 20 MB). Files go to a public Supabase Storage bucket and play with native controls on the card. Run [`supabase-audio-setup.sql`](supabase-audio-setup.sql) once to create the bucket.
- **Shared save state.** Every change is written to one row in Supabase as well as `localStorage`. The other device picks it up within ~8 seconds (or instantly with **Sync now** under Save & share). Last write wins.
- **Offline-safe.** If Supabase is unreachable, changes still save in the browser and the status shows "Offline — saved here".
- **A sealed letter** at the bottom — tap the envelope to open the note from Enric. The source text is in [`letter.txt`](letter.txt) and is embedded in `index.html` so the page needs no extra request.
- **Save & share** also offers `.json` export/import, print / save as PDF, and start over.
- **Escape / device back** closes whatever is open — a photo or share panel, the letter, or a playing video — and restores the card cover.

Everything else is client-side: no analytics, no cookies, no network request except Google Fonts and the Supabase REST call. `<meta name="robots" content="noindex, nofollow">` is set.

> **Access:** the capsule is intentionally open — anyone with the page URL can read and edit it. Don't put anything in the album you wouldn't mind the other person seeing (that's the point) or that you'd mind a stranger seeing if they found the link.

---

## Supabase setup (one-time)

This project is already connected — the live URL and publishable key are filled in at the top of `index.html`. The steps below are for reference or if you ever need to recreate the backend.

1. Create a free project at <https://supabase.com>.
2. Open **SQL Editor → New query**, paste the whole contents of [`supabase-setup.sql`](supabase-setup.sql), and run it. This creates the `capsule` table, its single row, and policies that let the page read and update it.
3. Also run [`supabase-audio-setup.sql`](supabase-audio-setup.sql) if you want the audio upload button to work — it creates the public `audio` bucket and its policies.
4. Open **Project Settings → API**. You need two values:
   - **Project URL** — e.g. `https://abcdefgh.supabase.co`. If you copy the REST URL including `/rest/v1/`, that's fine — the app strips it.
   - **publishable key** (`sb_publishable_…`) or the older **anon key** (`eyJ…`) — either works. Never use the `service_role` key.
5. Put those two values at the top of the script in `index.html`:

   ```js
   const SB_URL = 'https://abcdefgh.supabase.co';
   const SB_KEY = 'eyJhbGciOi…';
   ```

6. Commit and push. That's it — both devices now share the same album.

The anon key is designed to be public in client code; the row-level policies in the SQL file are what control access. Leave either constant blank to keep the album in browser-only mode (everything except syncing still works).

### How sync works

- On load, the page reads `GET /rest/v1/capsule?id=eq.1&select=data,updated_at`.
- On any change, after a 350 ms debounce it writes `PATCH /rest/v1/capsule?id=eq.1` with `{ data: { memories: [...] }, updated_at: <ISO timestamp> }`.
- Every 8 seconds (when the tab is visible) it checks `updated_at`; if it changed and differs from local state, the remote album replaces the local one.
- Uploaded photos are JPEG data URLs stored inside that JSON row. Keep the album reasonably small — a few dozen photos is fine; hundreds will make the row large. Uploaded audio is different: it lives in the `audio` Storage bucket and the row only holds its public URL.

---

## Run it locally

```bash
python3 -m http.server 8765
```

Then open <http://localhost:8765>. (Port 8000 is taken by another service on this machine.) Double-clicking `index.html` also works, though Google Fonts fall back offline.

---

## Files

```
one-year-of-us/
├── index.html          ← the whole app (HTML + CSS + JS in one file)
├── README.md
├── CONTENT.md          ← writing prompts
├── letter.txt          ← source text for the letter at the bottom
├── supabase-setup.sql  ← one-time shared-state setup
├── .nojekyll
└── assets/photos/      ← photos offered inside the picker
    └── original/       ← untouched originals, not linked
```

The six static templates and the chooser were removed when the project changed direction. They remain in git history (`0a2c747`–`19f7346`).

---

## Editing the app

Everything is in `index.html`:

- **Supabase credentials** — `SB_URL` / `SB_KEY` at the top of the script.
- **Photo picker list** — the `LIBRARY` array. Add `{ src:'assets/photos/file.jpg', label:'A friendly name' }` to offer another photo.
- **Prompt chips** — buttons with `data-prompt` in the empty state.
- **Memory limit** — `MAX_MEMORIES` (50), also enforced on import and when reading the capsule.
- **Allowed media hosts** — `mediaEmbed()` accepts YouTube and Spotify URLs only, and builds the embed URLs from them.
- **Anniversary details** — the wax seal SVG, the ribbon divider, and the footer stamp.
- **Upload size/quality** — `compress()`, currently 1400px long edge at JPEG quality 0.82.
- **Polling interval** — `setInterval(..., 8000)` in `initSync()`.
- **Storage key** — `one-year-of-us.v1` for the local cache; exported JSON includes an `app`/`version` header.

### Export format

```json
{
  "app": "one-year-of-us",
  "version": 1,
  "exportedAt": "2026-11-25T…",
  "memories": [
    { "id": "m…", "date": "", "title": "", "text": "", "photo": "" }
  ]
}
```

`photo` is either an `assets/photos/…` path or a JPEG data URL. Importing replaces the current album (locally and in the shared capsule) after a confirmation.

---

## Deploy

GitHub Pages serves `main` / root automatically (`.nojekyll` is present). Commit and push `index.html` and the site updates. The repo is public so Pages works on a free plan; `noindex, nofollow` keeps it out of search results, but anyone with the link can open it. If that changes, move hosting to Netlify/Vercel first, then flip the repo back to private.
