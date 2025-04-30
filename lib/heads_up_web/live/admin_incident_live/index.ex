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
      </.table>
    """
  end

end
