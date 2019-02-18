defmodule DataProcessorBackend.InterSCity.JobTemplateSerializer do
  alias DataProcessorBackend.InterSCity.JobTemplateSerializer
  use JaSerializer

  location "/job_templates/:id"
  attributes [:title, :user_params]

  has_one :job_script,
    serializer: JobScriptSerializer,
    include: true
end
