defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin
  alias HeadsUp.Incidents.Incident

  def mount(params, _session, socket) do


    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    incident = %Incident{}
    changeset = Admin.change_incident(incident)
    socket
    |> assign(page_title: "New Incident")
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    incident = Admin.get_incident!(id)
    changeset = Admin.change_incident(incident)
    socket
    |> assign(page_title: "New Incident")
    |> assign(:form, to_form(changeset))
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


  def handle_event("validate", %{"incident" => incident}, socket) do
    changeset = Admin.change_incident(%Incident{}, incident)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>

    <.simple_form for={@form} id="incident-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:name]} label="Name" required="required" />

      <.input
        field={@form[:description]}
        type="textarea"
        label="Description"
        phx-debounce="blur"
        required="required"
      />

      <.input field={@form[:priority]} type="number" label="Priority" required="required" />

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
