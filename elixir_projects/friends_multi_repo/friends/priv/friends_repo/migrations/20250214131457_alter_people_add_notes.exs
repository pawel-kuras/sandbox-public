defmodule Friends.Repo.Migrations.AlterPeopleAddNotes do
  use Ecto.Migration

  def change do
    alter table("people") do
      add :notes, :text
    end
  end
end
