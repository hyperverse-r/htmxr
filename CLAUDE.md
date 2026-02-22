# htmxr

## Commandes courantes

| Raccourci   | Tâche                      | Commande                              |
|-------------|----------------------------|---------------------------------------|
| `/check`    | Vérifier le package        | `R -e "devtools::check()"`            |
| `/test`     | Lancer les tests           | `R -e "devtools::test()"`             |
| `/document` | Mettre à jour la doc       | `R -e "devtools::document()"`         |
| `/attach`   | Mettre à jour le package   | `R -e "attachment::att_amend_desc()"` |
| `/site`     | Construire le site pkgdown | `R -e "pkgdown::build_site()"`        |
| `/format`   | Formater le code           | `air format .`                        |

## Agents

| Raccourci          | Rôle                                     | Quand l’invoquer                     |
|--------------------|------------------------------------------|--------------------------------------|
| `/htmx-expert`     | Revue fidélité et idiomaticité htmx      | Nouvelle primitive créée ou modifiée |
| `/shiny-ergonomie` | Regard dev Shiny sur l’intuitivité       | Travail sur nommage ou documentation |
| `/shiny-cas-usage` | Couverture fonctionnelle par cas d’usage | Alimenter la roadmap                 |

## Contexte du projet

`htmxr` est un package R qui fournit des primitives pour construire des
applications web avec htmx et plumber2. Il est agnostique CSS — il ne
dépend d’aucun framework CSS particulier.

## Écosystème hyperverse

`htmxr` fait partie d’un écosystème plus large, structuré à l’image du
tidyverse. Le package ombrelle **`hyperverse`** permettra d’importer
l’ensemble de l’écosystème en une seule commande
([`library(hyperverse)`](https://rdrr.io/r/base/library.html)).

### Packages de l’écosystème

| Package           | Rôle                                                                |
|-------------------|---------------------------------------------------------------------|
| `htmxr`           | Core — primitives htmx (ce package)                                 |
| `alpiner`         | Wrapper Alpine.js — logique client déclarative                      |
| `framer`          | Orchestrateur — scaffold, routing, déploiement (≈ golem pour htmxr) |
| `htmxr.bootstrap` | Surcouche opinionated Bootstrap sur htmxr                           |
| `htmxr.daisy`     | Surcouche opinionated Daisy.ui sur htmxr                            |
| `hyperverse`      | Meta-package ombrelle — charge tout l’écosystème                    |

### Notes

- `htmxr` est destiné à une publications sur le CRAN
- `htmxr.bootstrap` et les autres packages de l’hyperverse aussi (les
  points dans les noms sont acceptés par CRAN, ex: `data.table`)
- `framer` est un nom provisoire — à confirmer
- L’écosystème est CSS-agnostique au niveau core ; la dépendance CSS est
  optée explicitement via `htmxr.bootstrap` ou un équivalent

## Stack technique

- **R** avec conventions tidyverse
- **plumber2** comme serveur HTTP (pas plumber v1)
- **htmx** pour les interactions client
- **htmltools** pour la génération HTML
- **roxygen2** pour la documentation

## Architecture du package

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

## Exemples

Les exemples disponibles se trouvent dans `inst/examples/`. Chaque
sous-dossier contient un fichier `api.R` exécutable via
`hx_run_example("<nom>")`.

Les exemples existants sont une bonne source d’inspiration pour
comprendre comment combiner les primitives htmxr. Consulter ce dossier
avant de demander des exemples ou de l’aide.

> À terme, un site vitrine (pkgdown ou autre) présentera ces exemples de
> façon visuelle.

### Convention de nommage

Les dossiers d’exemples sont nommés selon le **concept pédagogique**
démontré, pas selon le dataset ou le domaine métier utilisé.

- ✅ `select-input` — démontre
  [`hx_select_input()`](https://hyperverse-r.github.io/htmxr/reference/hx_select_input.md) +
  filtrage dynamique
- ✅ `lazy-load` — démontre le pattern tbody vide chargé au
  `trigger="load"`
- ❌ `diamonds-explorer` — nom de usecase, pas de concept

## Décisions techniques importantes

### Conventions de nommage

- Fonctions préfixées `hx_` — pas `htmxr_`. Cette convention s’applique
  à toutes les fonctions exportées sans exception, y compris les helpers
  et les wrappers.
- Paramètres htmx : `get`, `post`, `target`, `swap`, `trigger`,
  `indicator`, `swap_oob`, `confirm`
- Pas de [`paste0()`](https://rdrr.io/r/base/paste.html) pour construire
  du HTML — utiliser
  [`htmltools::tags`](https://rstudio.github.io/htmltools/reference/builder.html)

## Règles générales

- Toujours lire la documentation avant de proposer une solution
- Tester les fonctions dans la console R avant de les proposer
- Ne pas affirmer quelque chose sans l’avoir vérifié
- Le package est CSS agnostique — ne pas imposer Bootstrap ou Tailwind
