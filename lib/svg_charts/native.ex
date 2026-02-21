defmodule SvgCharts.Native do
  @moduledoc false

  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :svg_charts,
    crate: "svg_charts_nif",
    base_url: "https://github.com/neilberkman/svg_charts/releases/download/v#{version}",
    force_build: System.get_env("SVG_CHARTS_BUILD") in ["1", "true"],
    version: version,
    nif_versions: ["2.17", "2.16", "2.15"],
    targets: [
      "aarch64-apple-darwin",
      "aarch64-unknown-linux-gnu",
      "x86_64-apple-darwin",
      "x86_64-unknown-linux-gnu"
    ]

  def render(_json), do: :erlang.nif_error(:nif_not_loaded)
end
