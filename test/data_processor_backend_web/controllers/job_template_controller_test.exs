defmodule DataProcessorBackendWeb.JobTemplateControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackendWeb.JobTemplateView

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":index" do
    test "index lists job_templates", %{conn: conn} do
      job_template = insert(:job_template)

      conn = get conn, Routes.job_template_path(conn, :index)

      assert json_response(conn, 200)
    end
  end

  describe ":create" do
    test "correctly creates a new job_template", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: params_for(:job_template)}})
      conn = post(conn, Routes.job_template_path(conn, :create), params)
      assert json_response(conn, 201)
    end
  end
end
