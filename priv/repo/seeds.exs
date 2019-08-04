# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kritikos.Repo.insert!(%Kritikos.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Kritikos.Repo
alias Kritikos.Votes.VoteLevel

Repo.delete_all(VoteLevel)
Repo.insert!(%VoteLevel{level: -1, description: "frown"})
Repo.insert!(%VoteLevel{level: 0, description: "neutral"})
Repo.insert!(%VoteLevel{level: 1, description: "happy"})
