defmodule Friends.EnemiesRepo.Migrations.CreateEnemies do
  use Ecto.Migration

  def change do
    create table(:enemies) do
      add :first_name, :string
      add :last_name, :string
      add :age, :integer
      add :laugh, :string
    end
  end
end
