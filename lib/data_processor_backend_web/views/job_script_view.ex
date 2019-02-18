defmodule DataProcessorBackendWeb.JobScriptView do
  alias DataProcessorBackendWeb.JobTemplateView

  use JSONAPI.View, type: "job_scripts", namespace: "/api"

  def fields, do: [:title, :code, :language, :path]

  def relationships do
    [job_template: JobTemplateView]
  end
end
