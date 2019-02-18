# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :data_processor_backend,
  ecto_repos: [DataProcessorBackend.Repo]

# Configures the endpoint
config :data_processor_backend, DataProcessorBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qmJQOTUCqslAsE5jDjZSDuLR72XuQ0Gvw1Is45QpRwQKEPh9BhaN5xhuu+q0idHR",
  render_errors: [view: DataProcessorBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DataProcessorBackend.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :mime, :types, %{
  "application/vnd.api+json" => ["json"]
}

config :jsonapi,
  host: "localhost:4000",
  scheme: "http",
  field_transformation: :underscore,
  remove_links: false,
  json_library: Jason,
  namespace: "/api"
