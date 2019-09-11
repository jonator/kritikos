defmodule Kritikos.Auth.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Auth.User

  @seed Application.get_env(:kritikos, :seed, "dev seed")
  @secret Application.get_env(:kritikos, :secret, "DEV_INSECURE_k7kTxvFAgeBvAVA0OR1vkPbTi8mZ5m")

  schema "auth_tokens" do
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end

  def sign(id) do
    Phoenix.Token.sign(@secret, @seed, id)
  end

  def verify(token) do
    case Phoenix.Token.verify(@secret, @seed, token, max_age: 86400) do
      {:ok, _id} -> {:ok, token}
      error -> error
    end
  end
end
