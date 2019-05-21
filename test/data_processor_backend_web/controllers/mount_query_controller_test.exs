defmodule DataProcessorBackendWeb.MountQueryControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":mount" do
    test "correctly mounts a new job_script", %{conn: conn} do
      data = %{
        language: :nice
      }
      old_count = JobScript.count
      conn = post(conn, Routes.mount_query_path(conn, :mount, data))
      new_count = JobScript.count

      assert old_count==new_count-1
    end
  end
end
