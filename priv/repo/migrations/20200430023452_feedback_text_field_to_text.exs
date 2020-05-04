defmodule Kritikos.Repo.Migrations.FeedbackTextFieldToText do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      modify :text, :text
    end
  end
end
