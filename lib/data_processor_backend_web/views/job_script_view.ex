defmodule DataProcessorBackendWeb.JobScriptView do
  use DataProcessorBackendWeb, :view
  use JaSerializer.PhoenixView

  attributes [:title, :code, :language, :path, :code_sample, :updated_at]

  def code_sample(job_script, _conn) do
    String.split(job_script.code, "\n")
    |> Enum.slice(0..10)
    |> Enum.map(fn x -> String.slice(x, 0..10) end)
    |> Enum.join("\n")
  end
end
