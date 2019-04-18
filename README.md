# DataProcessorBackend

## Installation

1. Make sure you have a working Elixir and Erlang. We are currently relying on
Erlang 20 and Elixir 1.7.0 but you will be in decent shape using newer
versions as well.
2. Install elixir dependencies: `mix deps.get`
3. Make sure you have a working Postgresql. These days we preffer to use Docker
and DockerCompose to host our Postgresql server but it is just for the
ease-to-setup. The command to run it is `docker-compose up -d data-processor-postgres`
4. Create and migrate your database with `mix ecto.setup`
5. Start Phoenix endpoint with `mix phx.server`. If you are using Docker/DockerCompose
you may use `docker-compose up -d data-processor-backend`
6. DataProcessor will be available at [`localhost:4000`](http://localhost:4000).
