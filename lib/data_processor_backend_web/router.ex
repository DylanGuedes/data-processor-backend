defmodule DataProcessorBackendWeb.Router do
  use DataProcessorBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug(JSONAPI.EnsureSpec)
    plug(JSONAPI.UnderscoreParameters)
    plug(CORSPlug, origin: "http://localhost:4200")
  end

  scope "/api", DataProcessorBackendWeb do
    pipe_through :api

    resources("/spark_templates", JobController, only: [:index])
  end
end
