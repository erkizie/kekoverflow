# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kekoverflow,
  ecto_repos: [Kekoverflow.Repo]

# Configures the endpoint
config :kekoverflow, KekoverflowWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eFAJnU1qaSG3PgcKVnxbRE37sDS7Bk4KVAbJHr51GxIN4O56boEQp8dcIZnOvrKy",
  render_errors: [view: KekoverflowWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kekoverflow.PubSub,
  live_view: [signing_salt: "Jcbdv1s2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kekoverflow, :pow,
       user: Kekoverflow.Users.User,
       repo: Kekoverflow.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
