FROM bitwalker/alpine-elixir-phoenix:1.7.0

EXPOSE 4545
ENV PORT=4545

# Cache elixir deps
COPY . .

RUN mix do deps.get, deps.compile
