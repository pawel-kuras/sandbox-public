# `Friends` from the Ecto Getting Started Guide

Based on the [Getting Started Guide](https://hexdocs.pm/ecto/getting-started.html)

## to query the database
```sh
❯ iex -S mix
iex(1)> Friends.get_people
```
and it should return:
```sh
14:22:46.795 [debug] QUERY OK source="people" db=21.4ms decode=26.2ms queue=1.7ms idle=879.1ms
SELECT p0."id", p0."first_name", p0."last_name", p0."age" FROM "people" AS p0 []
[
  %Friends.Person{
    __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
    id: 1,
    first_name: "Ryan",
    last_name: "Bigg",
    age: 28
  },
  %Friends.Person{
    __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
    id: 2,
    first_name: "John",
    last_name: "Smith",
    age: 27
  },
  %Friends.Person{
    __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
    id: 3,
    first_name: "Jane",
    last_name: "Smith",
    age: 26
  }
]
```

## Prereqs
1. install postgres beforehand
      - the [Getting Started Guide](https://hexdocs.pm/ecto/getting-started.html) specifically reads:
        > This guide will require you to have setup PostgreSQL beforehand.
      - to do this on macos apple silicon i ran:
          1. `brew install postgresql@17`
          2. added the following snippet to my .zshrc file:
              ```zsh
              export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
              ```
2. configure postgres:
    1. start the postgres service:
        ```sh
        brew services start postgresql@17
        ```
    2. create the postgres superuser, otherwise fails with `psql: error: connection to server on socket "/tmp/.s.PGSQL.5432" failed: FATAL:  role "postgres" does not exist`:
        ```sh
        createuser -s postgres
        ```
    3. log in as postgres user:
        ```sh
        psql -U postgres
        ```
    4. create user `friends_service` with ability to create databases
        ```sh
        CREATE USER friends_service CREATEDB;
        ```
    5. set the password for the `friends_service` (not hard-coded)
        ```sh
        \password friends_service
        ```
