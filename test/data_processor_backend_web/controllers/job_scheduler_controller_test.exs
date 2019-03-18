defmodule DataProcessorBackendWeb.JobSchedulerControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.ProcessingJob

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":schedule" do
    test "schedule a new processing job", %{conn: conn} do
      job_template = insert(:job_template)

      assert ProcessingJob.count==0
      conn = post conn, Routes.job_template_job_scheduler_path(conn, :schedule, job_template.id)
      response_data = json_response(conn, 200)["data"]
      assert response_data["relationships"]==%{"job-template" => %{"data" => %{"id" => "#{job_template.id}", "type" => "job-template"}}}
      assert ProcessingJob.count==1
    end
  end
end
