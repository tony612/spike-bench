defmodule Spike.Instrumenter do
  use Prometheus.PlugPipelineInstrumenter

  def label_value(:path, conn) do
    conn.request_path
  end
end
