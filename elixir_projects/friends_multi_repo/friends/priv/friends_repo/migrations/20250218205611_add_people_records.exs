defmodule Friends.FriendsRepo.Migrations.AddPeopleRecords do
  use Ecto.Migration

  def change do
    # from https://hexdocs.pm/ecto/getting-started.html#adding-ecto-to-an-application
    people = [
      %Friends.Person{first_name: "Ryan", last_name: "Bigg", age: 28},
      %Friends.Person{first_name: "John", last_name: "Smith", age: 27},
      %Friends.Person{first_name: "Jane", last_name: "Smith", age: 26},
    ]

    Enum.each(people, fn (person) -> Friends.FriendsRepo.insert(person) end)
  end
end
