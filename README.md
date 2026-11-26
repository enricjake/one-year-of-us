# One Year of Us

An interactive anniversary album that **Nicole fills in herself**. No templates to choose from, no code to edit, no account — she opens the link and makes it hers.

Live: <https://enricjake.github.io/one-year-of-us/>

---

## What it does

- **Blank slate.** It opens empty, with a few prompt chips ("The first message", "11pm snack aisle", …) if she needs a starting point.
- **Add a memory** = a title, a date, a photo, and as many words as she wants.
- **Photos** come from two places: the existing album in `assets/photos/`, or an upload from her device. Uploads are resized in the browser before being saved, so they stay fast and small.
- **Reorder freely** by dragging cards, or with the ↑ / ↓ buttons on touch screens. Edit or delete anything at any time.
- **Auto-saves** to `localStorage` in her browser. A small status in the top bar shows "Saving…" → "Saved in this browser".
- **Save & share** opens a panel to download a `.json` copy, import one back, print / save as PDF, or start over.

Everything is client-side. Nothing is uploaded, there is no backend, no analytics, and no network request except Google Fonts. The page has `<meta name="robots" content="noindex, nofollow">`.

> **Important:** her work lives only in her browser. Clearing browser data erases it, and Enric can't see it from his own device. She should use **Save & share → Download a copy** and send him the `.json` file; he restores it with **Open a saved copy**.

---

## Run it locally

```bash
python3 -m http.server 8765
```

Then open <http://localhost:8765>. (Port 8000 is taken by another service on this machine.) Double-clicking `index.html` also works — fonts fall back to system fonts offline.

---

## Files

```
one-year-of-us/
├── index.html          ← the whole interactive app (HTML + CSS + JS in one file)
├── README.md
├── CONTENT.md          ← writing prompts for her
├── .nojekyll
└── assets/photos/      ← photos she can pick from inside the page
    └── original/       ← untouched originals, not linked by the page
```

The six static templates and the chooser/gallery were removed when the project changed direction. They're still recoverable from git history (commits `0a2c747`–`19f7346`) if ever needed.

---

## Editing the app

Everything is in `index.html`:

- **Photo picker list** — the `LIBRARY` array in the script. Add an entry `{ src:'assets/photos/file.jpg', label:'A friendly name' }` to offer another existing photo.
- **Prompt chips** — the buttons with `data-prompt` in the empty state.
- **Copy** — hero text, the "How this works" note in the `#share` modal, and the footer.
- **Storage key** — `one-year-of-us.v1`. Changing it starts everyone fresh; the exported JSON format includes an `app`/`version` header for future migrations.
- **Upload size/quality** — `compress()`, currently max 1400px long edge at JPEG quality 0.82.

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

`photo` is either an `assets/photos/…` path or a JPEG data URL. Importing validates the shape and replaces the current album after a confirmation.

---

## Deploy

GitHub Pages serves `main` / root automatically (`.nojekyll` is present). Commit and push `index.html` and the site updates. The repo is public so Pages works on a free plan; `noindex, nofollow` keeps it out of search results, but anyone with the link can open it — including the photos. If that changes, move hosting to Netlify/Vercel first, then flip the repo back to private.
