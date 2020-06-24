# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kekoverflow.Repo.insert!(%Kekoverflow.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Kekoverflow.{Repo, Answers.Answer}

Repo.insert! %Answer{body: "Here is solution for you", rate: 2, user_id: 1, question_id: 1}