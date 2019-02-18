defmodule DataProcessorBackendWeb.JobScriptController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackendWeb.JobScriptView

  plug JSONAPI.QueryParser,
    filter: ~w(title),
    sort: ~w(title inserted_at),
    view: JobScriptView

  def index(conn, _params) do
    scripts = JobScript.all

    conn
    |> put_view(JobScriptView)
    |> render("index.json", %{data: scripts})
  end

  def create(conn, %{"data" => params}) do
    attrs = Map.get(params, "attributes")

    case JobScript.create(attrs) do
      {:ok, script} ->
        conn
        |> put_view(JobScriptView)
        |> render("show.json", %{data: script})

      {:error, %Ecto.Changeset{} = changeset} ->
        errors =
          changeset.errors
          |> Enum.map(fn {field, {reason, _}} -> %{field => reason} end)

        conn
        |> put_status(422)
        |> json(%{errors: [errors]})
    end
  end

  def show(conn, %{"id" => id}) do
    script = Repo.get!(JobScript, id)

    conn
    |> render("show.json", %{data: script})
  end
end
