defmodule Kritikos.Sessions do
  import Ecto.Query, warn: false

  alias Kritikos.Sessions.{LiveSession, KeywordFactory}

  def start(host_id) do
    keyword = KeywordFactory.next_available()
    LiveSession.start_link(%LiveSession{host_id: host_id, keyword: keyword})
  end
end
