# One Year, Six Ways

Six complete website directions for a one-year anniversary — built as plain HTML, CSS and JavaScript. No frameworks, no build step, no accounts, no tracking. Open a file, edit the marked bits, send her the link.

Every sample is filled in for **Nicole & Enric** (together since **Nov 25, 2025**, long distance) and uses the same photos Nicole sent over the year — so you can compare the structure instead of the words. The year is told through screens, calls and photos, not imagined dinners together.

**Start here:** open `index.html` in a browser (or run the local server below) and click through all six.

---

## The six directions

| # | Template | The idea | Best for | Interaction |
|---|----------|----------|----------|-------------|
| 01 | **Cinema** | A one-year feature film: ticket stub, film-strip timeline, contact sheet, end credits | Drama, big gestures, a story worth narrating | Scroll reveals, film grain, lights-down intro |
| 02 | **Mixtape** | Side A / Side B tracklist of memories, hand-labelled cassette, liner notes | Music people, inside jokes, a playful keepsake | Track selection, spinning reels, sticky player |
| 03 | **Arcade** | A playable co-op quest: clear four memory levels, unlock the final question | Gamers, silly energy, maximum interaction | Dialogue, level unlocks, heart-catching mini-game |
| 04 | **Constellation** | A heart-shaped constellation that draws itself as you scroll; each star is a memory | A softer gesture, long-distance, night owls | Scroll-drawn SVG, clickable stars, starfield |
| 05 | **Wrapped** | Your year in numbers, streaming-service style | Playful data, year-in-review energy, screenshots | Count-up stats, charts, scroll-snap slides |
| 06 | **Open When** | A wax-sealed envelope and six letters for the days she needs them | Words over spectacle, something she'll revisit | Envelope opening, letter modals |

---

## Preview it

From this folder:

```bash
python3 -m http.server 8000
```

Then open <http://localhost:8000>. The root page is the chooser; each template lives at `/templates/<name>/`.

You can also just double-click `index.html` — everything works from `file://` except Google Fonts, which will fall back to system fonts if you're offline.

---

## Make it yours

1. **Pick one template.** Delete the other five folders if you want a clean repo (keep a copy first if you're indecisive).
2. **Search for `✏️ EDIT`** in that template's `index.html`. Every editable block is marked. The names, dates, memories and photos are already real — change anything that doesn't sound like you.
3. **Check the names and dates.** Names, dates and copy are all inline HTML. The only computed values are dates, marked with `data-since` / `data-days`.
4. **Swap the photos.** Nicole's photos live in `assets/photos/` (optimised) with untouched originals in `assets/photos/original/`. Every template already points at them; to change one, swap the `<img>` src/alt:

   ```html
   <img src="../../assets/photos/night-cafe.jpg" alt="Nicole at the night café">
   ```

   The optimised copies are ~1.4 MB total; originals are kept but not linked. The photos are portrait, so they're shown with `object-fit:cover` — adjust `object-position` on any image that crops awkwardly.
5. **Write the letter last.** It's the part she'll reread. Use `CONTENT.md` to draft it before you touch the code.

### Template-specific notes

- **Cinema** — duplicate a `.scene` block for each memory. The credits list is a `<dl>`; keep the `dt`/`dd` pairs.
- **Mixtape** — each `.track` button has a matching `.note` right after it. Add tracks in pairs, and keep `data-title` / `data-sub` in sync with the player. To use a real song, uncomment the `<audio id="audio">` tag near the bottom and point it at an MP3.
- **Arcade** — the four level stories live in `<template id="tpl-1">` … `tpl-4`; the final letter is `tpl-5`. The level cards at the top only hold titles and blurbs. The mini-game needs no assets.
- **Constellation** — the heart is generated from the number of `.memory` cards. Add or remove cards and the constellation re-spaces itself. Keep 8–12 for the best shape.
- **Wrapped** — `data-count` values animate up; `data-days` is computed live from `<body data-since="…">`. Bar heights are inline `--h` percentages.
- **Open When** — the six letters are `<template id="l1">` … `l6`. They're written for a long-distance year; the card titles are separate, so update both if you change a topic.

### Privacy

Every page already includes `<meta name="robots" content="noindex, nofollow">`, so the site won't appear in search results. The repo itself is public, so anyone with the GitHub link can see the photos — flip it back to private after moving hosting elsewhere if you want it fully closed.

---

## Deploy

**Live now:** https://enricjake.github.io/one-year-of-us/

The repo is public and GitHub Pages is configured from `main` / root (with a `.nojekyll` file so nothing gets preprocessed). Every page has `noindex, nofollow` so the photos aren't searchable — anyone with the link can still open them.

To deploy a different folder after you pick one, replace the root `index.html` with the chosen template (and its photo paths become `assets/photos/...`), then commit and push. Pages rebuilds automatically.

If you ever want it private again: GitHub Pages on a private repo needs a paid plan, so move the site to Netlify or Vercel first, then flip the repo back to private.

---

## Repo layout

```
one-year-of-us/
├── index.html              ← chooser / gallery
├── README.md
├── CONTENT.md              ← fill-in worksheet
├── assets/previews/        ← screenshots used by the chooser
└── templates/
    ├── cinema/index.html
    ├── mixtape/index.html
    ├── arcade/index.html
    ├── constellation/index.html
    ├── wrapped/index.html
    └── letters/index.html
```

Each template is a single self-contained file. The only external request is Google Fonts (with sensible fallbacks).

---

## Ideas this was built from

A quick scan of what's out there, so you can steal more if you want:

- [Interactive website ideas for partners](https://www.yourlovepage.online/blog/interactive-website-ideas-to-surprise-your-partner) — Netflix-style episodes, runaway "No" buttons, tap-to-reveal memories
- [LoveMemo styles](https://lovememo.app/) — Cinema, Wrapped, Streaming, Video Game, Comic Book, Mixtape, Classic
- [LovePage anniversary templates](https://www.lovepage.io/for/anniversary) — days-together counters, countdowns, song + letter pages
- [r/Marriage: a site with the whole relationship story](https://www.reddit.com/r/Marriage/comments/1momjc8/for_our_anniversary_i_built_my_wife_a_website/) — timeline + gallery + special songs + live counter
- [r/webdev: anniversary gift ideas](https://www.reddit.com/r/webdev/comments/8d3yhr/what_should_i_develop_for_an_anniversary_gift/) — photo book, pivotal-date timeline, small game

The through-line: the ones people remember are **specific**, not grand. A burnt dinner beats a generic sunset. Write the details only you two know.

---

## Notes

- Everything is client-side. No analytics, no cookies, no network calls except fonts.
- Reduced-motion preferences are respected in every template.
- Tested at 1440×900 and 390×844.
- Personal use. Make her something good.
