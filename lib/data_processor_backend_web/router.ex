defmodule DataProcessorBackendWeb.Router do
  use DataProcessorBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
    plug(CORSPlug, origin: "http://localhost:4200")
  end

  scope "/api", DataProcessorBackendWeb do
    pipe_through :api

    resources("/job_templates", JobTemplateController, only: [:index, :create, :show, :update])
    resources("/job_scripts", JobScriptController, only: [:index, :create, :show])
  end
end
