defmodule Kekoverflow.Repo do
  use Ecto.Repo,
    otp_app: :kekoverflow,
    adapter: Ecto.Adapters.Postgres
end
