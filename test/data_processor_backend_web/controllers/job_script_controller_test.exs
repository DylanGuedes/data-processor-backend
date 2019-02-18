defmodule DataProcessorBackendWeb.JobScriptControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackendWeb.JobScriptView

  setup do
    {:ok, conn: build_conn()}
  end

  describe ":index" do
    test "index lists scripts", %{conn: conn} do
      job_script = insert(:job_script)

      conn = get conn, Routes.job_script_path(conn, :index)

      assert json_response(conn, 200) == _render_job_scripts("index.json", %{conn: conn, data: [job_script]})
    end
  end

  describe ":create" do
    test "correctly creates scripts", %{conn: conn} do
      job_script_params = build(:job_script)
      IO.inspect job_script_params
      request_params = %{"attributes" => build(:job_script), "type" => "job-scripts"}

      conn = get conn, Routes.job_script_path(conn, :create, %{"data" => request_params})

      assert json_response(conn, 200)# == _render_job_scripts("index.json", %{conn: conn, data: [job_script]})
    end
  end

  defp _render_job_scripts(template, assigns) do
    JobScriptView.render(template, assigns)
    |> Jason.encode!
    |> Jason.decode!
  end
end
