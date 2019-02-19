defmodule DataProcessorBackendWeb.JobScriptControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackend.Repo
  alias DataProcessorBackendWeb.JobScriptView
  alias DataProcessorBackend.InterSCity.JobScript

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

  describe ":update" do
    test "correctly update scripts", %{conn: conn} do
      script = insert(:job_script)
      params = %{"attributes" => %{"title" => "newtitle"}, "id" => script.id}
      conn = patch(conn, Routes.job_script_path(conn, :update, script.id), %{"data" => params})
      updated_script = Repo.get!(JobScript, script.id)
      assert updated_script.title != script.title
    end
  end
end
