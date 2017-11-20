use Mix.Config

config :maru, Sockwithahole,
  http: [port: System.get_env("PORT") || 4000]
