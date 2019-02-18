defmodule DataProcessorBackendWeb.JobScriptController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript

  def index(conn, _params) do
    scripts = JobScript.all

    conn
    |> render("index.json-api", %{data: scripts})
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    changeset = JobScript.changeset(%JobScript{}, attrs)
    case Repo.insert(changeset) do
      {:ok, script} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: script)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    script = Repo.get!(JobScript, id)

    conn
    |> render("show.json", %{data: script})
  end
end
