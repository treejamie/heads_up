defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin
  alias HeadsUp.Incidents.Incident

  def mount(_params, _session, socket) do
    changeset = Incident.changeset(%Incident{}, %{})

    socket =
      socket
      |> assign(page_title: "New Incident")
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  def handle_event("save", %{"incident" => incident_params}, socket) do
    case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident created a success!")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>

    <.simple_form for={@form} id="incident-form" phx-submit="save">
      <.input field={@form[:name]} label="Name" />

      <.input field={@form[:description]} type="textarea" label="Description" />

      <.input field={@form[:priority]} type="number" label="Priority" />

      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Choose a status"
        options={[:pending, :resolved, :canceled]}
      />

      <.input field={@form[:image_path]} label="Image" />

      <:actions>
        <.button phx-disable-with="Saving...">Save Incident</.button>
      </:actions>

      <:actions>
        <.back navigate={~p"/admin/incidents"}>Back</.back>
      </:actions>
    </.simple_form>
    """
  end
end
