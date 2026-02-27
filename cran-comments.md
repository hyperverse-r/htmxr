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

2. **`\dontrun{}` in examples** — Replaced `\dontrun{}` with `\donttest{}` in
   `hx_run_example()` and `hx_serve_assets()`. These examples start a blocking HTTP
   server and cannot complete in a reasonable time during automated checks.

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
