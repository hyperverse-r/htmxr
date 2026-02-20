# Slider input

Creates an `<input type="range">` element with optional htmx attributes.
When `label` is provided, the input is wrapped in a `<div>` containing a
`<label>` element linked via the `for` attribute.

## Usage

``` r
hx_slider_input(
  id,
  label = NULL,
  value = 50,
  min = 0,
  max = 100,
  step = 1,
  name = id,
  class = NULL,
  get = NULL,
  post = NULL,
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL,
  ...
)
```

## Arguments

- id:

  Element id. Also used as `name` by default.

- label:

  Optional label text. When provided, the input is wrapped in a `<div>`
  with a `<label>`.

- value:

  Initial value (default `50`).

- min:

  Minimum value (default `0`).

- max:

  Maximum value (default `100`).

- step:

  Step increment (default `1`).

- name:

  Form field name. Defaults to `id`.

- class:

  Optional CSS class(es) for the `<input>` element.

- get:

  URL for `hx-get`.

- post:

  URL for `hx-post`.

- target:

  CSS selector for `hx-target`.

- swap:

  Swap strategy for `hx-swap`.

- trigger:

  Trigger specification for `hx-trigger`.

- indicator:

  CSS selector for `hx-indicator`.

- swap_oob:

  Out-of-band swap targets for `hx-swap-oob`.

- confirm:

  Confirmation message for `hx-confirm`.

- ...:

  Additional HTML attributes passed to the `<input>` element.

## Value

An
[htmltools::tags](https://rstudio.github.io/htmltools/reference/builder.html)
object.

## Examples

``` r
# Simple slider
hx_slider_input("bins", label = "Number of bins:", min = 1, max = 50)
#> <div>
#>   <label for="bins">Number of bins:</label>
#>   <input type="range" id="bins" name="bins" value="50" min="1" max="50" step="1"/>
#> </div>

# Slider with htmx attributes
hx_slider_input(
  "bins",
  label = "Number of bins:",
  value = 30, min = 1, max = 50,
  get = "/plot",
  trigger = "input changed delay:300ms",
  target = "#plot"
)
#> <div>
#>   <label for="bins">Number of bins:</label>
#>   <input type="range" id="bins" name="bins" value="30" min="1" max="50" step="1" hx-get="/plot" hx-target="#plot" hx-trigger="input changed delay:300ms"/>
#> </div>
```
