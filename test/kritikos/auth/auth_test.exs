defmodule Kritikos.AuthTest do
  use Kritikos.DataCase

  alias Kritikos.Auth

  setup do
    {:ok, user} =
      Auth.register_user(%{
        email: "test@email",
        password: "some password",
        password_confirmation: "some password",
        first_last_name: "John Doe"
      })

    [user: user]
  end

  describe "users" do
    alias Kritikos.Auth.User

    @valid_attrs %{
      email: "some@email",
      password: "some password",
      password_confirmation: "some password",
      first_last_name: "John Doe"
    }
    @invalid_attrs %{email: nil, is_active: nil, password: nil, password_confirmation: "pass"}

    def handle_virtual_fields(user) do
      %User{user | password: nil}
    end

    test "get_user/1 returns the user with given id", %{user: user} do
      user = handle_virtual_fields(user)
      assert Auth.get_user(user.id).id == user.id
    end

    test "register_user/1 with valid data creates a user" do
      {:ok, %User{} = user} = Auth.register_user(@valid_attrs)
      assert user.email == "some@email"
      assert user.is_active == true
    end

    test "register_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.register_user(@invalid_attrs)
    end
  end
end
