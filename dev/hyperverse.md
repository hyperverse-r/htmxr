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
| glitchtipr       | idée          | —        | error tracking (GlitchTip/Sentry) |
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

### Déploiement Docker (notes issues de l'exploration 2026-03-07)

#### Dockerfile minimal fonctionnel

```dockerfile
FROM rocker/r-ver:4.4

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libsodium-dev \       # ← requis par plumber2/sodium, oubli = crash au démarrage
    libcairo2-dev \       # ← requis par svglite
    libfontconfig1-dev \
    libwebp-dev \         # ← requis par ragg (dépendance plumber2)
    libharfbuzz-dev \     # ← requis par textshaping/ragg
    libfribidi-dev \      # ← requis par textshaping/ragg
    libfreetype6-dev \    # ← requis par ragg
    libpng-dev \          # ← requis par ragg
    libtiff5-dev \        # ← requis par ragg
    libjpeg-dev \         # ← requis par ragg
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('remotes', 'htmltools', 'httr2', 'svglite', 'plumber2'), repos='https://packagemanager.posit.co/cran/__linux__/noble/latest')"
RUN R -e "remotes::install_github('hyperverse-r/htmxr')"

WORKDIR /app
COPY . .
EXPOSE 8000
CMD ["Rscript", "run.R"]
```

#### run.R (entrypoint)

```r
library(plumber2)
library(htmxr)

api("api.R", doc_type = "") |>
  hx_serve_assets() |>
  (\(pr) pr$ignite(block = TRUE))()
```

Ne pas hardcoder host/port dans `run.R` — ils sont lus depuis `PLUMBER2_HOST` / `PLUMBER2_PORT` via `get_opts()`. À noter : `host` et `port` se passent à `api()`, pas à `ignite()` (découvert en lisant le source de `Plumber2$initialize`).

#### docker-compose.yml (pattern recommandé)

```yaml
services:
  hello:
    build: .
    restart: unless-stopped
    ports:
      - "127.0.0.1:8091:8080"   # port interne unique par exemple (plumber2 défaut = 8080)
    environment:
      GLITCHTIP_DSN: ${GLITCHTIP_DSN}
      PLUMBER2_HOST: "0.0.0.0"  # ← OBLIGATOIRE en Docker
    volumes:
      - ./api.R:/app/api.R        # ← montés en volume pour éviter le rebuild
      - ./glitchtip.R:/app/glitchtip.R
      - ./run.R:/app/run.R
```

**`PLUMBER2_HOST=0.0.0.0`** est indispensable. Sans ça, plumber2 bind sur `127.0.0.1` à l'intérieur du container → Docker ne peut pas forwarder le trafic. Découvert via `get_opts()` qui lit les variables d'environnement `PLUMBER2_*`.

#### Workflow rebuild vs restart

| Changement | Action |
|-----------|--------|
| `api.R`, `glitchtip.R`, `run.R` | `docker compose restart` ← fichiers montés en volume |
| Nouvelle dépendance R (`install.packages`) | `docker compose build && docker compose up -d` |
| Nouvelle dépendance système (`apt-get`) | `docker compose build && docker compose up -d` |

Nginx fait le reverse proxy vers `127.0.0.1:8091`. Chaque exemple = un service = un port interne différent.

#### Stratégie de déploiement — un sous-domaine par exemple

`hx_serve_assets()` sert les assets à `/htmxr/assets/` (chemin absolu). Si l'app est déployée sous un sous-chemin (`demo.breant.art/hello/`), les assets et les routes HTMX (`hx-get="/plot"`) cassent silencieusement car nginx ne proxifie que le préfixe `/hello/`.

**Solution retenue : un sous-domaine par exemple.**
- `hello.demo.breant.art` → exemple hello (port 8091)
- `select-input.demo.breant.art` → futur exemple (port 8092)
- etc.

Chaque exemple est à la racine de son domaine → tous les chemins absolus fonctionnent.

#### ⚠️ Problème des chemins absolus — décision à prendre

**Contexte :** toute la doc htmxr utilise des chemins absolus (`get = "/plot"`).
En déploiement **à la racine d'un domaine** (`hello.breant.art`), c'est parfait.

**Problème :** dès qu'on déploie sous un **sous-chemin** (`demo.breant.art/hello/`), les chemins absolus cassent silencieusement. HTMX envoie `GET demo.breant.art/plot` au lieu de `demo.breant.art/hello/plot`.

**Solutions évaluées :**

| Approche | Verdict |
|----------|---------|
| Chemins relatifs dans la doc (`get = "plot"`) | Change toute la doc, contre-intuitif |
| `sub_filter` nginx | Fragile : à maintenir, rate les réponses partielles HTMX |
| Un domaine/sous-domaine par exemple | ✅ Contournement propre à court terme |
| `hx_set_base_path("/hello")` dans htmxr | ✅ **Vraie solution** — à implémenter |

**Décision actuelle :** déploiement par sous-domaine (`hello.demo.breant.art`).
**Feature à planifier :** `BASE_PATH` dans htmxr (analogue à `APPLICATION_ROOT` Flask, `root_path` FastAPI).

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

### Périmètre
- Product analytics : qui utilise quoi, comment, quand
- Capture d'events + identify (profil utilisateur) + feature flags
- Intégration naturelle avec htmxr/plumber2, mais standalone aussi
- PostHog est open source et self-hostable

### API envisagée
```r
ph <- ph_connect(api_key = Sys.getenv("POSTHOG_KEY"))

ph_capture(ph, distinct_id = "user_123", event = "report_generated",
           properties = list(format = "pdf"))

ph_identify(ph, distinct_id = "user_123",
            properties = list(email = "john@acme.com", plan = "pro"))

ph_feature_flag(ph, distinct_id = "user_123", flag = "new_dashboard")
# → TRUE / FALSE / "variant-a"
```

---

## glitchtipr

**Repo :** à créer — error tracking pour R

### Périmètre
- Capturer, grouper et contextualiser les erreurs R en production
- GlitchTip en priorité (open source, self-hostable, MIT)
- Compatible API Sentry → fonctionne aussi avec Sentry si besoin
- Standalone — utile hors htmxr (Shiny, scripts, pipelines)

### API envisagée
```r
gt <- gt_connect(dsn = Sys.getenv("GLITCHTIP_DSN"))

# gt_capture wrappe l'expression : capture, reporte, et propage l'erreur
gt_capture(gt, {
  ma_fonction()
}, context = list(user = "user_123"))
```

**Implémentation interne : `withCallingHandlers` plutôt que `tryCatch`**
- `withCallingHandlers` capture l'erreur sans dérouler la call stack → stack complète disponible dans GlitchTip
- L'erreur continue de se propager naturellement après le report
- `tryCatch` déroulait la stack et nécessitait un `stop(e)` explicite pour re-raiser

### Quelles erreurs tracker ? — bonne pratique à documenter

**Tracker :**
- ✅ Erreurs métier (`db_connection_error`, `parsing_error`, calcul qui plante…)
- ✅ Erreurs inattendues / non gérées (500)
- ✅ Erreurs dans des processus critiques (génération rapport, sync données)

**Ne pas tracker :**
- ❌ 404 — bruit, souvent des bots qui scannent
- ❌ 401/403 — comportement attendu (auth)
- ❌ Erreurs de validation utilisateur — formulaire mal rempli, c'est normal

**Règle d'or :** GlitchTip doit rester **actionnable**. Chaque erreur qui remonte doit signifier "quelqu'un doit investiguer". Noyer le tracking dans des 404 = ignorer toutes les alertes à terme.

`glitchtipr` devra documenter ce filtre et potentiellement proposer un helper `gt_ignore_http(codes = c(404, 401, 403))`.

### Typage des erreurs — bonne pratique à documenter

Dans GlitchTip, le type d'erreur affiché correspond à `class(err)[1]`. Par défaut, `stop("message")` crée une `simpleError` — l'équivalent d'une `Exception` générique. Peu informatif en prod.

**Pattern recommandé avec `rlang::abort()` :**
```r
# ❌ Difficile à monitorer
stop("Connexion base de données échouée")
# → GlitchTip affiche : simpleError

# ✅ Typé, filtrable dans GlitchTip
rlang::abort("Connexion base de données échouée", class = "db_connection_error")
# → GlitchTip affiche : db_connection_error
```

`glitchtipr` devra documenter ce pattern et encourager les devs R à typer leurs erreurs — c'est un changement de culture pour l'écosystème R où `stop()` nu est la norme.

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
