# SvgCharts

SVG chart renderer for Elixir powered by [charts-rs](https://github.com/vicanso/charts-rs).

Supports bar, line, pie, radar, scatter, candlestick, heatmap, table, and multi-chart types.

## Installation

```elixir
def deps do
  [{:svg_charts, "~> 0.1"}]
end
```

## Usage

```elixir
{:ok, svg} = SvgCharts.render(:bar, %{
  "title_text" => "Downloads",
  "series_list" => [
    %{"name" => "MDEx", "data" => [120.0, 200.0, 150.0]}
  ],
  "x_axis_data" => ["Jan", "Feb", "Mar"]
})
```

See the [charts-rs documentation](https://github.com/vicanso/charts-rs) for the full JSON configuration options.

## Building from source

```
SVG_CHARTS_BUILD=true mix compile
```
