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

## Exemples

Les exemples disponibles se trouvent dans `inst/examples/`. Chaque sous-dossier
contient un fichier `api.R` exécutable via `hx_run_example("<nom>")`.

Les exemples existants sont une bonne source d'inspiration pour comprendre
comment combiner les primitives htmxr. Consulter ce dossier avant de demander
des exemples ou de l'aide.

> À terme, un site vitrine (pkgdown ou autre) présentera ces exemples de façon
> visuelle.

### Convention de nommage

Les dossiers d'exemples sont nommés selon le **concept pédagogique** démontré,
pas selon le dataset ou le domaine métier utilisé.

- ✅ `select-input` — démontre `hx_select_input()` + filtrage dynamique
- ✅ `lazy-load` — démontre le pattern tbody vide chargé au `trigger="load"`
- ❌ `diamonds-explorer` — nom de usecase, pas de concept

## Décisions techniques importantes

### Conventions de nommage

- Fonctions préfixées `hx_` — pas `htmxr_`. Cette convention s'applique à
  toutes les fonctions exportées sans exception, y compris les helpers et les
  wrappers.
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

## Écosystème hyperverse

`htmxr` fait partie d'un écosystème plus large, structuré à l'image du tidyverse.
Le package ombrelle **`hyperverse`** permettra d'importer l'ensemble de l'écosystème
en une seule commande (`library(hyperverse)`).

### Packages de l'écosystème

| Package | Rôle |
|---------|------|
| `htmxr` | Core — primitives htmx (ce package) |
| `htmxr.blocks` | Building blocks UI : composants réutilisables (cards, modals, alerts) et structure de page (navbar, sidebar, layout) |
| `alpiner` | Wrapper Alpine.js — logique client déclarative |
| `framer` | Orchestrateur — scaffold, routing, déploiement (≈ golem pour htmxr) |
| `htmxr.bootstrap` | Surcouche opinionated Bootstrap sur htmxr |
| `hyperverse` | Meta-package ombrelle — charge tout l'écosystème |

### Notes

- `htmxr` et `htmxr.blocks` sont destinés à CRAN
- `htmxr.bootstrap` aussi (les points dans les noms sont acceptés par CRAN, ex: `data.table`)
- `framer` est un nom provisoire — à confirmer
- L'écosystème est CSS-agnostique au niveau core ; la dépendance CSS est optée
  explicitement via `htmxr.bootstrap` ou un équivalent

## Règles générales

- Toujours lire la documentation avant de proposer une solution
- Tester les fonctions dans la console R avant de les proposer
- Ne pas affirmer quelque chose sans l'avoir vérifié
- Le package est CSS agnostique — ne pas imposer Bootstrap ou Tailwind
