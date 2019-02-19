defmodule DataProcessorBackendWeb.JobTemplateControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackendWeb.JobTemplateView
  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobTemplate

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

  describe ":update" do
    test "correctly creates a new job_template", %{conn: conn} do
      template = insert(:job_template)
      params = %{"attributes" => %{"title" => "newtemplatetitle"}, "id" => template.id}
      conn = patch(conn, Routes.job_template_path(conn, :update, template.id), %{"data" => params})
      updated_template = Repo.get!(JobTemplate, template.id)
      assert updated_template.title != template.title
    end
  end

  describe ":clone" do
    test "correctly clones a new job_template", %{conn: conn} do
      template = insert(:job_template)
      refetch_template = Repo.get!(JobTemplate, template.id)
      old_count = JobTemplate.count()
      conn = post(conn, Routes.job_template_clone_path(conn, :clone, template.id))
      resp = json_response(conn, 200)
      clone_id = resp["data"]["id"]
      refetched_clone = Repo.get!(JobTemplate, clone_id)
      assert refetched_clone.title==template.title
    end
  end
end
