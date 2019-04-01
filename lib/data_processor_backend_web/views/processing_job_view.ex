defmodule DataProcessorBackendWeb.ProcessingJobView do
  use DataProcessorBackendWeb, :view
  use JaSerializer.PhoenixView

  alias DataProcessorBackendWeb.JobTemplateView

  attributes [:uuid, :job_state, :log]

  has_one :job_template,
    serializer: JobTemplateView,
    include: true
end