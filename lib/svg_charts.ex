defmodule SvgCharts do
  @moduledoc """
  SVG chart renderer powered by [charts-rs](https://github.com/vicanso/charts-rs).

  Takes a JSON configuration with a `"type"` field and returns an SVG string.

  ## Supported chart types

    * `"bar"` - Vertical bar chart
    * `"horizontal_bar"` - Horizontal bar chart
    * `"line"` - Line chart
    * `"pie"` - Pie chart
    * `"radar"` - Radar/spider chart
    * `"scatter"` - Scatter plot
    * `"candlestick"` - Candlestick chart
    * `"heatmap"` - Heatmap
    * `"table"` - Table
    * `"multi"` - Multi-chart composition

  ## Examples

      {:ok, svg} = SvgCharts.render(%{
        "type" => "bar",
        "title_text" => "Downloads",
        "series_list" => [
          %{"name" => "MDEx", "data" => [120.0, 200.0, 150.0]}
        ],
        "x_axis_data" => ["Jan", "Feb", "Mar"]
      })

      svg = SvgCharts.render!(~s({"type": "line", "series_list": [{"name": "A", "data": [1.0, 2.0]}], "x_axis_data": ["X", "Y"]}))

  ## Legend layout

  Chart options are passed through to `charts-rs`. Use `"legend_margin"` to
  position a legend below title text:

      %{
        "title_text" => "Framework Comparison",
        "sub_title_text" => "Phoenix vs. Rails vs. Next.js",
        "legend_margin" => %{"top" => 60}
      }

  Set `"legend_show" => false` to omit the legend, which is often useful for a
  single-series chart.
  """

  @doc """
  Render a chart to SVG.

  Accepts a map or a JSON string. Must include a `"type"` field.
  """
  @spec render(map() | String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def render(data) when is_map(data) do
    render(Jason.encode!(data))
  end

  def render(json) when is_binary(json) do
    SvgCharts.Native.render(json)
  end

  @doc """
  Same as `render/1` but raises on error.
  """
  @spec render!(map() | String.t()) :: String.t()
  def render!(data) do
    case render(data) do
      {:ok, svg} -> svg
      {:error, msg} -> raise "SvgCharts render error: #{msg}"
    end
  end
end
