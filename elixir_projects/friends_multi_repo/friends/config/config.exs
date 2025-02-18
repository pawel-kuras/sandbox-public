import Config

config :friends, Friends.FriendsRepo,
  database: "friends_repo",
  username: "postgres",
  password: "password",
  hostname: "localhost"

config :friends, Friends.EnemiesRepo,
  database: "enemies_repo",
  username: "postgres",
  password: "password",
  hostname: "localhost"

config :friends, ecto_repos: [Friends.FriendsRepo, Friends.EnemiesRepo]
