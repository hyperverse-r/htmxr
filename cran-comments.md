# htmxr — CRAN submission comments

## R CMD CHECK results

0 errors | 0 warnings | 1 note

Tested on: macOS aarch64 (Sequoia 15.6.1), R 4.4.2

## Notes

### `checking for future file timestamps`

Unable to verify current time.

---

## Resubmission — 2026-02-27

This is a resubmission addressing the notes raised during the second CRAN review:

1. **Unquoted software names in DESCRIPTION** — `R` and `JavaScript` are now quoted
   with single quotes in the `Description` field as per CRAN conventions.

2. **References in DESCRIPTION** — Added a reference to the 'htmx' project website
   (`<https://htmx.org>`) in the `Description` field. No DOI or ISBN is applicable
   as this package wraps a JavaScript library, not a statistical method.

3. **`\dontrun{}` in examples** — Per CRAN guidelines:
   - `hx_serve_assets()`: example is now fully executable (configures an API object,
     does not start a server).
   - `hx_run_example()`: `hx_run_example()` without arguments is now fully executable
     (lists available examples). The blocking call `hx_run_example("hello")` is wrapped
     in `if(interactive()){}` as it starts a server that never returns non-interactively.

---

## Resubmission — 2026-02-23

This is a resubmission addressing the notes raised during the first CRAN review:

1. **Invalid URL** — Fixed a broken URL in `vignettes/getting-started.Rmd`:
   `https://github.com/andersnotes/plumber2` replaced by `https://plumber2.posit.co/`.

2. **Possibly misspelled words in DESCRIPTION** — Technical terms (`htmx`, `htmxr`,
   `plumber2`, `Shiny`) are now quoted with single quotes in `Title` and `Description`
   as per CRAN conventions.

3. **Missing R version dependency** — Added `Depends: R (>= 4.1.0)` to `DESCRIPTION`
   since the package uses the native pipe `|>` introduced in R 4.1.0.
