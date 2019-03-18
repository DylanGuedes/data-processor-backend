defmodule DataProcessorBackendWeb.JobSchedulerController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.ProcessingJob
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackendWeb.ProcessingJobView

  def schedule(conn, %{"job_template_id" => template_id}) do
    template = JobTemplate.find!(template_id)
    job = JobTemplate.schedule_job(template)

    conn
    |> put_view(ProcessingJobView)
    |> render("show.json-api", %{data: (job |> Repo.preload(:job_template))})
  end
end
