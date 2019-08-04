defmodule Kritikos.SessionsTest do
  use Kritikos.DataCase

  alias Kritikos.Sessions

  describe "resolved_sessions" do
    alias Kritikos.Sessions.ResolvedSession

    @valid_attrs %{end_datetime: "2010-04-17T14:00:00Z", keyword: "some keyword", start_datetime: "2010-04-17T14:00:00Z"}
    @update_attrs %{end_datetime: "2011-05-18T15:01:01Z", keyword: "some updated keyword", start_datetime: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{end_datetime: nil, keyword: nil, start_datetime: nil}

    def resolved_session_fixture(attrs \\ %{}) do
      {:ok, resolved_session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sessions.create_resolved_session()

      resolved_session
    end

    test "list_resolved_sessions/0 returns all resolved_sessions" do
      resolved_session = resolved_session_fixture()
      assert Sessions.list_resolved_sessions() == [resolved_session]
    end

    test "get_resolved_session!/1 returns the resolved_session with given id" do
      resolved_session = resolved_session_fixture()
      assert Sessions.get_resolved_session!(resolved_session.id) == resolved_session
    end

    test "create_resolved_session/1 with valid data creates a resolved_session" do
      assert {:ok, %ResolvedSession{} = resolved_session} = Sessions.create_resolved_session(@valid_attrs)
      assert resolved_session.end_datetime == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert resolved_session.keyword == "some keyword"
      assert resolved_session.start_datetime == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_resolved_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_resolved_session(@invalid_attrs)
    end

    test "update_resolved_session/2 with valid data updates the resolved_session" do
      resolved_session = resolved_session_fixture()
      assert {:ok, %ResolvedSession{} = resolved_session} = Sessions.update_resolved_session(resolved_session, @update_attrs)
      assert resolved_session.end_datetime == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert resolved_session.keyword == "some updated keyword"
      assert resolved_session.start_datetime == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_resolved_session/2 with invalid data returns error changeset" do
      resolved_session = resolved_session_fixture()
      assert {:error, %Ecto.Changeset{}} = Sessions.update_resolved_session(resolved_session, @invalid_attrs)
      assert resolved_session == Sessions.get_resolved_session!(resolved_session.id)
    end

    test "delete_resolved_session/1 deletes the resolved_session" do
      resolved_session = resolved_session_fixture()
      assert {:ok, %ResolvedSession{}} = Sessions.delete_resolved_session(resolved_session)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_resolved_session!(resolved_session.id) end
    end

    test "change_resolved_session/1 returns a resolved_session changeset" do
      resolved_session = resolved_session_fixture()
      assert %Ecto.Changeset{} = Sessions.change_resolved_session(resolved_session)
    end
  end
end
