import Ecto.Query
alias Kritikos.Repo
alias Kritikos.Auth
alias Kritikos.Auth.{User, Profile}
alias Kritikos.Sessions
alias Kritikos.Sessions.{Session, Tag}
alias Kritikos.Votes
alias Kritikos.Votes.{Vote, Feedback}

IO.puts("iex config loaded")
