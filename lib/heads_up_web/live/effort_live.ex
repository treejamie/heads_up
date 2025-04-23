defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, 2000)
    end

    socket = assign(socket, responders: 0, minutes_per_responder: 10)

    IO.inspect(self(), label: "MOUNT")

    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")
    ~H"""
    <div class="effort">
      <h1>Community</h1>
      <section>
        <div>
        <button phx-click="add">
        +
        </button>
          <%= @responders%>
        </div>
        &times;
        <div>
          <%= @minutes_per_responder %>
        </div>
        =
        <div>
        <%= @responders * @minutes_per_responder %>
        </div>
      </section>
        <form phx-submit="recalculate">
          <label>Minutes Per Responder:</label>
          <input type="number" name="minutes" value={@minutes_per_responder} />
        </form>
    </div>
    """
  end

  def handle_event("recalculate", %{"minutes" => minutes}, socket) do
    socket = assign(socket, :minutes_per_responder, String.to_integer(minutes))
    {:noreply, socket}
  end

  def handle_event("add", _, socket) do

    IO.inspect(self(), label: "ADD")

    socket = update(socket, :responders, &(&1 + 1))

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :responders, &(&1 + 3))}
  end
end
