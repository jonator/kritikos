defmodule Kritikos.AuthTest do
  use Kritikos.DataCase

  alias Kritikos.Auth

  setup do
    {:ok, user} =
      Auth.register_user(%{
        email: "test@email",
        password: "some password",
        password_confirmation: "some password",
        profile: %{first_last_name: "John Doe"}
      })

    [user: user]
  end

  describe "users" do
    alias Kritikos.Auth.{User, Profile}

    @valid_attrs %{
      email: "some@email",
      password: "some password",
      password_confirmation: "some password",
      profile: %{first_last_name: "John Doe"}
    }
    @update_attrs %{
      email: "some@updatedemail",
      is_active: false,
      password: "some updated password"
    }
    @invalid_attrs %{email: nil, is_active: nil, password: nil}

    def handle_virtual_fields(user) do
      %User{user | password: nil}
    end

    test "get_user/1 returns the user with given id", %{user: user} do
      user = handle_virtual_fields(user)
      assert Auth.get_user(user.id).id == user.id
    end

    test "get_profile/1 returns users profile", %{user: user} do
      %Profile{} = profile = Auth.get_profile(user.profile.id)
      assert profile.user_id == user.id
      assert profile.first_last_name == "John Doe"
    end

    test "get_assoc_profile/1 gets associated profile", %{user: user} do
      %Profile{} = profile = Auth.get_assoc_profile(user)
      assert profile.id == user.profile.id
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
