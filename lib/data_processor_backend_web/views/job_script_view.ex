defmodule DataProcessorBackendWeb.JobScriptView do
  use DataProcessorBackendWeb, :view
  use JaSerializer.PhoenixView

  attributes [:title, :code, :language, :path]
end
