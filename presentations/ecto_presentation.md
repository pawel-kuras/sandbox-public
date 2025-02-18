# ecto

- url https://hexdocs.pm/ecto/Ecto.html

# design
- based on repository pattern (not active record pattern)
  - repository is a centralized class/module connects to DB
  - db operations sent to the repository
  - explicit
    - no lazy loading (see [Elixir-Conf-2017-Darin-Wilson](https://www.youtube.com/watch?v=YQxopjai0CU&start=455))
      - because of N+1 Query Problem
        - app slows to a crawl when viral campaign succeeds
      ```elixir
      albums = Repo.all(MyApp.Album) # + 1
      for album <- albums do
        for track <- album.tracks do # N

        end
      end
      ```

# guides
- [Getting Started Guide](https://hexdocs.pm/ecto/getting-started.html)

# setup
1. create a database with `mix ecto.create [-r <Project>.<Repo>]`
2. create a migration with `mix ecto.gen.migration <description_of_migration> [-r <Project>.<Repo>]`
    - generates migration templates in `priv/repo/migrations`
    - for example `mix ecto.gen.migration create_people -r Friends.PeopleRepo` generates a migration template in
    `elixir_projects/friends/priv/friends_repo/migrations/20250213222323_create_people.exs`, with the following content:
    ```elixir
    defmodule Friends.Repo.Migrations.CreatePeople do
      use Ecto.Migration

      # can alternatively define up and down functions, see https://hexdocs.pm/ecto_sql/Ecto.Migration.html#module-change
      def change do
        # <--- Add code here
      end
    end
    ```
3. run the migration with `mix ecto.migrate [-r <Project>.<Repo>]`
4. work with models
    - An Ecto schema is used to map any data source into an Elixir struct.
    - to work with models, need to manually create the schemas in `lib/<app-name>/<schema_name>.ex`
        ```elixir
        defmodule Friends.Person do
            use Ecto.Schema

            schema "people" do
                field :first_name, :string
                field :last_name, :string
                field :age, :integer
            end
        end
        ```
        - then can:
          ```elixir
          person = %Friends.Person{}
          Friends.Repo.insert(person) # <--- have to explicitly reference the repo (no lazy loading)
          ```
        - if want validation add a changeset
          - separate from schema requirements, because validation requirements can change depending on how you are
          updating
            - for example tracks can be part of an album, and some are singles (released outside of album )
          - see example from [Elixir-Conf-2017-Darin-Wilson](https://www.youtube.com/watch?v=YQxopjai0CU&start=455):
          ```elixir
          # for track on an album
          def changeset(%{"album_id" => _album_id} = params) do
              %Track{}
              |> cast(params, [:title, :index, :album_id])
              |> validate_required([:title, :index, :album_id])
              |> validate_number(:index, :greater_than: 0)
          end

          # for a single
          def changeset(%{"album_id" => _album_id} = params) do
              %Track{}
              |> cast(params, [:title])
              |> validate_required([:title])
          end
        ```
    - for how you can work with the models, see [ecto crud](https://hexdocs.pm/ecto/crud.html)

## queries
### queries and are composable
```elixir
# get the albums by Miles Davis...
query = from a in Album,
  join: ar in Artist
  on: ar.id == a.artist_id,
  where: ar.name == "Miles Davis"

# ...with a track longer than 10 mins
query2 = from a in query,
  join: t in Track
  on: a.id == t.album_id,
  where: t.duration > 600
```

### reusable queries
```elixir
def by_artist(query, name) do
  from a in query,
    join: ar in Artist,
    on: ar.id == a.artist_id,
    where: ar.name == ^name
end

def with_tracks_longer_than(name, duration) do
  from a in query,
    join: t in from a in query,
    on: a.id == t.album_id,
    where: t.duration > ^duration
end

q = Album
  |> by_artist("Miles Davis")
  |> with_tracks_longer_than(600)
```

### replicas
- see [replicas](https://hexdocs.pm/ecto/replicas-and-dynamic-repositories.html)
- can reference replicas, for e.g.:
```elixir
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres

  @replicas [
    MyApp.Repo.Replica1,
    MyApp.Repo.Replica2,
    MyApp.Repo.Replica3,
    MyApp.Repo.Replica4
  ]

  def replica do
    Enum.random(@replicas)
  end

  for repo <- @replicas do
    defmodule repo do
      use Ecto.Repo,
        otp_app: :my_app,
        adapter: Ecto.Adapters.Postgres,
        read_only: true
    end
  end
end
```