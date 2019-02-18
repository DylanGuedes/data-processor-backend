defmodule DataProcessorBackendWeb.JobTemplateControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackendWeb.JobTemplateView

  setup do
    {:ok, conn: build_conn()}
  end

  describe ":index" do
    test "index lists job_templates", %{conn: conn} do
      job_template = insert(:job_template)

      conn = get conn, Routes.job_template_path(conn, :index)

      assert json_response(conn, 200) == _render_job_templates("index.json", %{conn: conn, data: [job_template]})
    end
  end

  # describe ":create" do
  #   test "correctly creates a new job_template", %{conn: conn} do
  #     job_template_params = %{"attributes" => build(:job_template), "type" => "job-templates"}
  #
  #     conn = post conn, Routes.job_template_path(conn, :create, %{"data" => job_template_params})
  #
  #     assert json_response(conn, 200) == _render_job_templates("index.json", %{conn: conn, data: []})
  #     assert JobTemplate.count == 1
  #   end
  # end

  defp _render_job_templates(template, assigns) do
    JobTemplateView.render(template, assigns)
    |> Jason.encode!
    |> Jason.decode!
  end
end
