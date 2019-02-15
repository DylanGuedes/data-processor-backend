defmodule DataProcessorBackendWeb.JobController do
  use DataProcessorBackendWeb, :controller

  def index(conn, _params) do
    # jobs = Repo.all Job

    conn
    |> put_status(:ok)
    |> render(JobsView, "index.json", %{data: jobs})
    # |> render(JobsView, "index.json", %{data: jobs})
  end
end
