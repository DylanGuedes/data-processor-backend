defmodule DataProcessorBackendWeb.JobTemplateController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackendWeb.JobTemplateView

  plug JSONAPI.QueryParser,
    filter: ~w(title),
    sort: ~w(title inserted_at),
    view: JobTemplateView

  def index(conn, _params) do
    job_templates = JobTemplate.all()

    conn
    |> put_view(JobTemplateView)
    |> render("index.json", %{data: job_templates})
  end

  def create(conn, %{"data" => params}) do
    attrs = Map.get(params, "attributes")
    script_id = Map.get(params, "relationships") |> Map.get("job_script") |> Map.get("data") |> Map.get("id")
    script = Repo.get!(JobScript, script_id)

    case JobTemplate.create(attrs, script) do
      {:ok, template} ->
        conn
        |> put_view(JobTemplateView)
        |> render("show.json", %{data: template})

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
    template = Repo.get!(JobTemplate, id) |> Repo.preload(:job_script)

    conn
    |> render("show.json", %{data: template})
  end

  def update(conn, %{"data" => params, "id" => id}) do
    attrs = Map.get(params, "attributes")
    template = Repo.get!(JobTemplate, id)
    changeset = JobTemplate.changeset(template, attrs)

    case Repo.update(changeset) do
      {:ok, template} ->
        conn
        |> put_view(JobTemplateView)
        |> render("show.json", %{data: template})

      {:error, %Ecto.Changeset{} = changeset} ->
        errors =
          changeset.errors
          |> Enum.map(fn {field, {reason, _}} -> %{field => reason} end)

        conn
        |> put_status(422)
        |> json(%{errors: [errors]})
    end
  end
end
