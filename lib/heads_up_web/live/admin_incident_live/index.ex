defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Incidents Admin")
      |> stream(:incidents, Admin.list_incidents())


    {:ok, socket}

  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
    <.button phx-click={JS.toggle(
        to: "#joke",
        in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
        out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
        time: 300
        )
      }>
        Toggle Joke
      </.button>
      <div id="joke" class="joke hidden">
        Why can't you trust trees?
      </div>
      <.header class="mt-6">
        {@page_title}

        <:actions>
          <.link navigate={~p"/admin/incidents/new"} class="button">
            Create Incident
          </.link>
        </:actions>

      </.header>

      <.table
        row_click={fn {_, raffle} -> JS.navigate(~p"/incidents/#{raffle.id}") end}
        id="raffles"
        rows={@streams.incidents}
        >

        <:col :let={{_dom_id, incident}} label="Name">
        <.link navigate={~p"/incidents/#{incident.id}"}>
            {incident.name}
          </.link>
        </:col>
        <:col :let={{_dom_id, incident}} label="Status">
          <.badge status={incident.status} />
        </:col>
        <:col :let={{_dom_id, incident}} label="Priority">
            {incident.priority}
        </:col>

        <:action :let={{_dom_id, incident}}>
          <.link navigate={~p"/admin/incidents/#{incident.id}/edit"}>
            Edit
          </.link>
        </:action>

        <:action :let={{dom_id, incident}}>
          <.link phx-click={delete_and_hide(dom_id, incident) }
          data-confirm="Are you sure?">
          <.icon name="hero-trash" class="h-4 w-6 ml-3" />
          </.link>
        </:action>

      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)

    {:ok, _incident} = Admin.delete_incident(incident)

    socket = stream_delete(socket, :incidents, incident)
    {:noreply, socket}
  end
  def delete_and_hide(dom_id, raffle) do
    JS.push("delete", value: %{id: raffle.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
