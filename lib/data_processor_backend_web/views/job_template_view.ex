defmodule DataProcessorBackendWeb.JobTemplateView do
  use JSONAPI.View, type: "job_templates", namespace: "/api"

  alias DataProcessorBackendWeb.JobScriptView

  def fields, do: [:title, :user_params]

  def relationships do
    [job_script: JobScriptView]
  end
end
