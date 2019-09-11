defmodule Kritikos.AuthTest do
  use Kritikos.DataCase

  alias Kritikos.Auth

  describe "auth_tokens" do
    alias Kritikos.Auth.Token

    @valid_attrs %{revoked: true, revoked_at: "2010-04-17T14:00:00Z", token: "some token"}
    @update_attrs %{revoked: false, revoked_at: "2011-05-18T15:01:01Z", token: "some updated token"}
    @invalid_attrs %{revoked: nil, revoked_at: nil, token: nil}

    def token_fixture(attrs \\ %{}) do
      {:ok, token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_token()

      token
    end

    test "list_auth_tokens/0 returns all auth_tokens" do
      token = token_fixture()
      assert Auth.list_auth_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Auth.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Auth.create_token(@valid_attrs)
      assert token.revoked == true
      assert token.revoked_at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert token.token == "some token"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, %Token{} = token} = Auth.update_token(token, @update_attrs)
      assert token.revoked == false
      assert token.revoked_at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert token.token == "some updated token"
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_token(token, @invalid_attrs)
      assert token == Auth.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Auth.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Auth.change_token(token)
    end
  end
end
