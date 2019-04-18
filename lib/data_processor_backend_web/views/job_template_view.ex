defmodule DataProcessorBackendWeb.JobTemplateView do
  use DataProcessorBackendWeb, :view
  use JaSerializer.PhoenixView

  alias DataProcessorBackendWeb.JobScriptView

  attributes [:title, :user_params, :publish_strategy]

  has_one :job_script,
    serializer: JobScriptView,
    include: true
end
