import Ecto.Query
alias Kritikos.Repo
alias Kritikos.Auth
alias Kritikos.Auth.{User, Profile}
alias Kritikos.Sessions
alias Kritikos.Sessions.{Session, Tag}
alias Kritikos.Votes
alias Kritikos.Votes.{Vote, Feedback}

Module.create(
  H,
  quote do
    def delete_all_inorder(list) do
      Enum.map(list, fn schema ->
        Repo.delete_all(schema)
      end)
    end
  end,
  Macro.Env.location(__ENV__)
)

IO.puts("iex config loaded")
