defmodule Kritikos.SessionsTest do
  use Kritikos.DataCase

  setup do
    {:ok, user} =
      Kritikos.Auth.register_user(%{
        email: "john@doe",
        password: "test",
        password_confirmation: "test",
        profile: %{first_last_name: "John Doe"}
      })

    [
      user: user
    ]
  end

  describe "sessions lifecycle" do
    alias Kritikos.Sessions
    alias Kritikos.Sessions.Session

    @valid_attrs %{
      end_datetime: "2010-04-17T14:00:00Z",
      keyword: "some keyword",
      start_datetime: "2010-04-17T14:00:00Z"
    }
    @update_attrs %{
      end_datetime: "2011-06-18T15:01:01Z",
      keyword: "some updated keyword",
      start_datetime: "2011-05-18T15:01:01Z"
    }
    @invalid_attrs %{end_datetime: nil, keyword: nil, start_datetime: nil}

    test "starting a session", %{user: %{profile: %{id: prof_id}}} do
      {:ok, session} = Sessions.start(prof_id, "For testing purposes", "test", [])
    end
  end
end
