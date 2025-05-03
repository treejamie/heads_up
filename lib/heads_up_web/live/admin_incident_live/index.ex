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
      <.header>
        {@page_title}

        <:actions>
          <.link navigate={~p"/admin/incidents/new"} class="button">
            Create Incident
          </.link>
        </:actions>

      </.header>

      <.table id="incidents" rows={@streams.incidents}>
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
        <:action :let={{_dom_id, incident}}>
          <.link phx-click="delete" phx-value-id={incident.id} data-confirm="You sure Ham?">
          <.icon name="hero-trash" class="h-4 w-6 ml-3" />
          </.link>
        </:action>

      </.table>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)

    {:ok, _incident} = Admin.delete_incident(incident)

    socket = stream_delete(socket, :incidents, incident)
    {:noreply, socket}
  end
end
