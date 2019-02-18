defmodule DataProcessorBackendWeb.JobScriptControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackendWeb.JobScriptView

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":index" do
    test "index lists scripts", %{conn: conn} do
      job_script = insert(:job_script)

      conn = get conn, Routes.job_script_path(conn, :index)

      assert json_response(conn, 200)
    end
  end

  describe ":create" do
    test "correctly creates scripts", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: params_for(:job_script)}})
      conn = post(conn, Routes.job_script_path(conn, :create), params)
      assert json_response(conn, 201)
    end
  end
end
