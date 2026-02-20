# htmxr

## Contexte du projet

`htmxr` est un package R qui fournit des primitives pour construire des applications web avec htmx et plumber2. Il est agnostique CSS — il ne dépend d'aucun framework CSS particulier.

## Stack technique

- **R** avec conventions tidyverse
- **plumber2** comme serveur HTTP (pas plumber v1)
- **htmx** pour les interactions client
- **htmltools** pour la génération HTML
- **roxygen2** pour la documentation

## Architecture du package

```
htmxr/
├── R/
│   ├── hx_attrs.R          # hx_attrs() — helper interne hx-* attributes
│   ├── hx_example.R        # hx_run_example() — lance un exemple
│   ├── hx_page.R           # hx_page(), hx_head() — page HTML complète
│   ├── hx_serve_assets.R   # hx_serve_assets() — assets statiques
│   ├── hx_slider_input.R   # hx_slider_input() — <input type="range">
│   └── reexports.R         # réexports htmltools
├── inst/
│   ├── assets/
│   │   └── htmx/
│   │       └── 2.0.8/
│   │           └── htmx.min.js
│   └── examples/
│       └── hello/
│           └── api.R
├── man/
├── DESCRIPTION
└── NAMESPACE
```

## Décisions techniques importantes

### Conventions de nommage

- Fonctions préfixées `hx_` — pas `htmxr_`
- Paramètres htmx : `get`, `post`, `target`, `swap`, `trigger`, `indicator`, `swap_oob`, `confirm`
- Pas de `paste0()` pour construire du HTML — utiliser `htmltools::tags`

## Roadmap fonctions

### À implémenter (priorité haute)

- `hx_button(label, get, post, target, swap, trigger, indicator, swap_oob, confirm, ...)`
- `hx_select_input(id, label, choices, get, target, ...)`
- `hx_update_select(id, label, choices, ...)` — équivalent `updateSelectInput()`
- `htmxr_is_htmx(request)` — détecte si la requête vient de htmx via header `HX-Request`

### À implémenter (priorité normale)

- `hx_text_input()`
- `hx_poll()` — helper pour `hx-trigger="every Xs"`
- `hx_push_url(response, url)` — header `HX-Push-Url`

### Packages complémentaires prévus

- **alpiner** — primitives Alpine.js (package séparé)
- **forger** — framework qui orchestre htmxr + alpiner

## Règles générales

- Toujours lire la documentation avant de proposer une solution
- Tester les fonctions dans la console R avant de les proposer
- Ne pas affirmer quelque chose sans l'avoir vérifié
- Le package est CSS agnostique — ne pas imposer Bootstrap ou Tailwind
