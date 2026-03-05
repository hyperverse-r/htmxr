# Hyperverse — État & Roadmap

Fichier de suivi de l'écosystème. Mis à jour par Claude au fil des sessions.

---

## Vue d'ensemble

| Package          | Statut        | Version  | Prochain jalon                    |
|------------------|---------------|----------|-----------------------------------|
| htmxr            | stable        | 0.2.0    | CRUD verbs (delete, put, patch)   |
| htmxr.bootstrap  | en dev        | —        | fix hx_bs_button + CRUD           |
| lucidr           | soumis CRAN   | 0.1.0    | attente validation                |
| alpiner          | en dev        | —        | retirer x_page()                  |
| htmxr.daisy      | planifié      | —        | —                                 |
| supar            | planifié      | —        | POC query builder                 |
| chartrjs         | planifié      | —        | POC Chart.js → HTML endpoint      |
| posthogr         | idée          | —        | wrapper PostHog analytics         |
| htmxr.tailwind   | idée          | —        | compilation Tailwind dans R       |

---

## htmxr

**Repo :** `htmxr/` — package core, CSS-agnostique, CRAN

### En cours
- CRUD verbs : ajouter `delete`, `put`, `patch` dans `hx_attrs()` / `hx_set()`
  - Propager dans : `hx_button()`, `hx_select_input()`, `hx_slider_input()`, `hx_table()`
  - Tests : `tests/testthat/test-hx_set.R`
  - Exemple : `inst/examples/crud-delete/api.R` (bouton supprimer ligne → DELETE → outerHTML swap)

### Backlog

**Inputs manquants** (par rapport à Shiny) :
- `hx_text_input()` — `<input type="text">`
- `hx_numeric_input()` — `<input type="number">`
- `hx_textarea_input()` — `<textarea>`
- `hx_radio_input()` — boutons radio
- `hx_checkbox_input()` — case à cocher unique
- `hx_checkbox_group_input()` — groupe de cases
- `hx_date_input()` — `<input type="date">`
- `hx_file_input()` — upload fichier

**Exemples** :
- `sortable-table` : tri par colonne via `hx-get` sur `<th>`, zéro JS
- `report-download` : génération rapport Rmd async (`@async` plumber2) + lien téléchargement

**Divers** :
- Valider `target` CSS selector silencieux (ex: `"plot"` au lieu de `"#plot"` → aucune erreur)

### Décisions architecturales
- `hx_page()` est l'unique fonction de page de l'écosystème
- Les autres packages contribuent via `hx_head(xxx_script())` + `xxx_serve_assets(api)`
- Dans les routes plumber2 : paramètre réponse = `response`, paramètre requête = `request`

---

## htmxr.bootstrap

**Repo :** `htmxr.bootstrap/`

### Fonctions existantes
- `hx_bs_page()` — page complète Bootstrap ; injecte CSS + JS Bootstrap en interne, enveloppe `hx_page()`
- `hx_bs_serve_assets()` — wrapper qui appelle `hx_serve_assets()` (htmx.js) + statics Bootstrap
- `hx_bs_button(label, id = NULL, ...)` — bouton Bootstrap, htmx attrs passés en `...`
- `hx_bs_theme()` — theming Sass : override variables Bootstrap avant compilation (requiert `sass`)

### Pattern d'usage
```r
plumber2::api() |>
  hx_bs_serve_assets() |>   # htmx.js + Bootstrap CSS/JS
  pr_run()

#* @get /
#* @serializer html
function() {
  hx_bs_page(               # injecte Bootstrap automatiquement
    tags$h1("Hello!")
  )
}
```

### En cours
- Corriger `hx_bs_button()` : `(label, id = NULL, ...)` → `(id, label = NULL, ...)` (convention id en premier)
- Propager CRUD (`delete`, `put`, `patch`) dans `hx_bs_button()` après correction htmxr

### Backlog

**Bugs bloquants (`hx_bs_theme`)** — identifiés par audit 2026-02-27 :
- `enable_rounded = NA` → produit silencieusement `$enable-rounded: false;` au lieu de lever une erreur
- `enable_rounded = "yes"` → bypass de la conversion booléenne, émet du Sass valide mais sémantiquement faux

**Footgun à documenter :** `enable_dark_mode = FALSE` (via `...`) + `color_mode = "dark"` dans `hx_bs_page()` → page cassée sans avertissement. Mitigation : inspecter le theme compilé dans `hx_bs_page()` et émettre un `warning()`.

**Paramètres manquants dans `hx_bs_theme()`** (non-bloquants) :
- `font_family_base` — override branding le plus courant après les couleurs
- `border_radius_sm`, `border_radius_lg` — contrôle complet des arrondis
- `enable_dark_mode`, `enable_transitions`

**`hx_bs_button()`** — état `active` non implémenté : ajouter `active = FALSE` (classe `.active` + `aria-pressed="true"`)

---

## lucidr

**Repo :** `lucidr/` — wrapper Lucide icons

### En cours
- Soumission CRAN v0.1.0 — 2026-03-06

### Backlog
- —

---

## alpiner

**Repo :** `alpiner/` — wrapper Alpine.js

### Fonctions existantes
- `x_script()` — `<script defer>` Alpine.js (local ou CDN via `local = FALSE`)
- `x_serve_assets(api)` — sert `alpine.min.js` via plumber2
- `x_set(tag, data, text, show, on, bind)` — ajoute des directives Alpine à n'importe quel tag htmltools
- `x_page()` + `x_head()` — page standalone Alpine (à déprécier)
- `x_run_example()` — lance un exemple (n'appelle que `x_serve_assets()`, pas `hx_serve_assets()`)

### En cours
- Déprécier `x_page()` et `x_head()` → migration vers `hx_page(hx_head(x_script(), ...))`
- Créer un premier exemple htmxr + alpiner dans `inst/examples/` (aucun exemple existant)
- `x_run_example()` à corriger : doit aussi appeler `hx_serve_assets()` si htmxr est présent

### Backlog
- Exemple dual-trigger (confetti) : `hx_trigger(response, "confetti")` déclenche simultanément
  1. canvas-confetti côté client (Alpine listener)
  2. htmx GET vers un endpoint (ex: compteur mis à jour)
- `x_serve_assets(confetti = TRUE)` — embarque canvas-confetti en opt-in

### Décisions architecturales
- `x_script()` s'utilise via `hx_page(hx_head(x_script()))` — pas `x_page()`
- Confetti : opt-in explicite, zéro overhead par défaut

---

## htmxr.daisy

**Repo :** `htmxr.daisy/` — surcouche DaisyUI (CSS standalone)

### En cours
- Développement initial

### Backlog
- Évoluer vers Tailwind quand la compilation dans R sera résolue
- `htmxr.tailwind` gérerait la compilation ; `htmxr.daisy` en dépendrait

---

## supar

**Repo :** à créer — client Supabase pour R

### Périmètre
- Requêtes via l'API REST Supabase (PostgREST) — **pas de SQL, pas de DBI**
- Authentification : `sb_sign_in()`, `sb_sign_up()`, vérification JWT
- Realtime : Supabase envoie les événements (WebSocket) → supar les reçoit → SSE vers le client via plumber2

### API envisagée
```r
# Connexion (une fois au démarrage — pattern closure)
sb <- sb_connect(url = Sys.getenv("SUPABASE_URL"), key = Sys.getenv("ANON_KEY"))

# Auth
session <- sb_sign_in(sb, email, password)   # retourne client enrichi du JWT

# Query style dbplyr — pipe-friendly
sb_table(session, "orders") |>
  sb_select("id, status, total") |>
  sb_filter(status == "pending") |>
  sb_collect()                               # → tibble

# Realtime
sb_listen(sb, table = "orders", on_change = function(payload) { ... })
```

### Décisions architecturales
- PostgREST uniquement — zéro SQL exposé
- API fonctionnelle pipe-friendly (R6 en interne seulement)
- Pattern closure pour `sb` (connexion au démarrage du serveur)
- Pattern route chain plumber2 pour le JWT par requête (`request$user`)
- Realtime : Supabase → WebSocket → R (supar) → SSE plumber2 → `hx-sse` htmx côté client
- Auth : à définir

---

## chartrjs

**Repo :** à créer — wrapper Chart.js

### Backlog
- Pattern validé : endpoint retourne HTML avec `<script type="application/json">` embarqué
- Script lit les données depuis le DOM après `htmx:afterSwap`
- POC existant : `htmxr.bootstrap/dev/chart-poc.R`
- Nom choisi car `chartr` est une fonction base R (évite le conflit)

---

## posthogr

**Repo :** à créer — wrapper PostHog analytics

### Backlog
- Analytics d'usage pour les applications construites avec htmxr
- Intégration côté serveur (plumber2) pour les events

---

## Architecture commune

Chaque package a sa propre convention d'intégration :

| Package         | Page                  | Assets                    |
|-----------------|-----------------------|---------------------------|
| htmxr           | `hx_page()`           | `hx_serve_assets(api)`    |
| htmxr.bootstrap | `hx_bs_page()`        | `hx_bs_serve_assets(api)` ← inclut htmxr |
| alpiner         | `hx_page(hx_head(x_script()))` | `hx_serve_assets(api)` + `x_serve_assets(api)` |

`hx_bs_page()` ne s'utilise **pas** avec `hx_page()` — c'est son remplaçant direct pour les apps Bootstrap.

`hx_bs_serve_assets()` appelle déjà `hx_serve_assets()` en interne — pas besoin de chaîner les deux.
