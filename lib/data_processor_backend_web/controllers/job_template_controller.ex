defmodule DataProcessorBackendWeb.JobTemplateController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript

  def index(conn, _params) do
    templates = JobTemplate.all()

    conn
    |> render("index.json-api", %{data: templates})
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    changeset = JobTemplate.changeset(%JobTemplate{}, attrs)
    case Repo.insert(changeset) do
      {:ok, template} ->
        loaded_template = template |> Repo.preload(:job_script)
        conn
        |> put_status(201)
        |> render("show.json-api", data: loaded_template)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    template = Repo.get(JobTemplate, id) |> Repo.preload([:job_script])
    conn
    |> render("show.json-api", data: template, opts: [include: "job_script"])
  end

  def update(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    template = Repo.get!(JobTemplate, Map.get(attrs, "id"))
    changeset = JobTemplate
                |> Repo.get!(Map.get(attrs, "id"))
                |> JobTemplate.changeset(attrs)

    case Repo.update(changeset) do
      {:ok, template} ->
        loaded_template = template |> Repo.preload(:job_script)
        conn
        |> put_status(201)
        |> render("show.json-api", data: loaded_template)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end
end
