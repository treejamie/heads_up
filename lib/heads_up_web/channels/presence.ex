defmodule HeadsUpWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :heads_up,
    pubsub_server: HeadsUp.PubSub

  def init(_opts) do
    {:ok, %{}}
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(HeadsUp.PubSub, "updates:" <> topic(id))
  end

  defp topic(incident_id) do
    "incident_onlookers:#{incident_id}"
  end

  def list_users(id) do
    list(topic(id))
    |> Enum.map(fn {username, %{metas: metas}} ->
      %{id: username, metas: metas}
    end)
  end

  def track(id, current_user) do
    track(self(), topic(id), current_user.username, %{
      online_at: System.system_time(:second)
    })
  end

  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    # the joiners
    for {username, _presence} <- joins do
      presence = %{id: username, metas: Map.fetch!(presences, username)}
      msg = {:user_joined, presence}
      Phoenix.PubSub.local_broadcast(HeadsUp.PubSub, "updates:" <> topic, msg)
    end

    # the leavers
    for {username, _presence} <- leaves do
      metas =
        case Map.fetch(presences, username) do
          {:ok, presence_metas} -> presence_metas
          :error -> []
        end

      presence = %{id: username, metas: metas}
      msg = {:user_left, presence}

      Phoenix.PubSub.local_broadcast(HeadsUp.PubSub, "updates:" <> topic, msg)
    end

    {:ok, state}
  end
end
