defmodule SvgChartsTest do
  use ExUnit.Case

  test "render bar chart from map" do
    assert {:ok, svg} =
             SvgCharts.render(%{
               "type" => "bar",
               "width" => 400,
               "height" => 300,
               "series_list" => [%{"name" => "A", "data" => [10.0, 20.0, 30.0]}],
               "x_axis_data" => ["X", "Y", "Z"]
             })

    assert svg =~ "<svg"
    assert svg =~ "</svg>"
  end

  test "render line chart" do
    assert {:ok, svg} =
             SvgCharts.render(%{
               "type" => "line",
               "series_list" => [%{"name" => "A", "data" => [1.0, 2.0, 3.0]}],
               "x_axis_data" => ["A", "B", "C"]
             })

    assert svg =~ "<svg"
  end

  test "render pie chart" do
    assert {:ok, svg} =
             SvgCharts.render(%{
               "type" => "pie",
               "series_list" => [%{"name" => "A", "data" => [30.0, 70.0]}]
             })

    assert svg =~ "<svg"
  end

  test "render horizontal bar chart" do
    assert {:ok, svg} =
             SvgCharts.render(%{
               "type" => "horizontal_bar",
               "series_list" => [%{"name" => "A", "data" => [10.0, 20.0]}],
               "y_axis_data" => ["X", "Y"]
             })

    assert svg =~ "<svg"
  end

  test "render radar legend below title and subtitle" do
    svg =
      radar_config(%{"legend_margin" => %{"top" => 60}})
      |> SvgCharts.render!()

    title_y = text_y(svg, "Radar title")
    subtitle_y = text_y(svg, "Radar subtitle")
    legend_y = text_y(svg, "Radar series")

    assert title_y < subtitle_y
    assert subtitle_y < legend_y
  end

  test "hide radar legend" do
    svg =
      radar_config(%{"legend_show" => false})
      |> SvgCharts.render!()

    assert svg =~ "<svg"
    refute svg =~ "Radar series"
  end

  test "render! returns SVG directly" do
    svg =
      SvgCharts.render!(%{
        "type" => "bar",
        "series_list" => [%{"name" => "A", "data" => [10.0]}],
        "x_axis_data" => ["X"]
      })

    assert svg =~ "<svg"
  end

  test "render from JSON string" do
    json =
      ~s({"type": "bar", "series_list": [{"name": "A", "data": [10.0]}], "x_axis_data": ["X"]})

    assert {:ok, svg} = SvgCharts.render(json)
    assert svg =~ "<svg"
  end

  test "render with missing type returns error" do
    assert {:error, msg} = SvgCharts.render(%{"series_list" => []})
    assert msg =~ "type"
  end

  test "render with unknown type returns error" do
    assert {:error, msg} = SvgCharts.render(%{"type" => "nope", "series_list" => []})
    assert msg =~ "unknown chart type"
  end

  test "render! raises on error" do
    assert_raise RuntimeError, ~r/SvgCharts render error/, fn ->
      SvgCharts.render!("{invalid json")
    end
  end

  defp radar_config(overrides) do
    Map.merge(
      %{
        "type" => "radar",
        "width" => 600,
        "height" => 470,
        "title_text" => "Radar title",
        "sub_title_text" => "Radar subtitle",
        "series_list" => [%{"name" => "Radar series", "data" => [9.0, 8.0, 7.0]}],
        "indicators" => [
          %{"name" => "Performance", "max" => 10.0},
          %{"name" => "Scalability", "max" => 10.0},
          %{"name" => "Ecosystem", "max" => 10.0}
        ]
      },
      overrides
    )
  end

  defp text_y(svg, text) do
    pattern = ~r/<text[^>]*\by="([\d.]+)"[^>]*>\s*#{Regex.escape(text)}\s*<\/text>/
    [_, value] = Regex.run(pattern, svg)
    {value, ""} = Float.parse(value)
    value
  end
end
