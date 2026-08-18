# SvgCharts

SVG chart renderer for Elixir powered by [charts-rs](https://github.com/vicanso/charts-rs).

Supports bar, line, pie, radar, scatter, candlestick, heatmap, table, and multi-chart types.

## Installation

```elixir
def deps do
  [{:svg_charts, "~> 0.5.1"}]
end
```

## Usage

```elixir
{:ok, svg} = SvgCharts.render(%{
  "type" => "bar",
  "title_text" => "Downloads",
  "series_list" => [
    %{"name" => "MDEx", "data" => [120.0, 200.0, 150.0]}
  ],
  "x_axis_data" => ["Jan", "Feb", "Mar"]
})
```

### Legend layout

Chart options are passed through to `charts-rs`. When a chart has a title or
subtitle, use `legend_margin` to leave room above the legend:

```elixir
"legend_margin" => %{"top" => 60}
```

The margin accepts `top`, `right`, `bottom`, and `left` values. To omit the
legend, which is often useful for a single-series chart, use:

```elixir
"legend_show" => false
```

See the [charts-rs documentation](https://github.com/vicanso/charts-rs) for the full JSON configuration options.

## Building from source

```
SVG_CHARTS_BUILD=true mix compile
```
