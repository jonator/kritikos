defmodule Kritikos.Repo.Migrations.UserStripeId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :stripe_customer_id, :string, null: true, default: nil
    end
  end
end
