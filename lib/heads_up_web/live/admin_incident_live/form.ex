defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Categories


  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:category_options, Categories.category_name_and_id())
      |> apply_action(socket.assigns.live_action, params)
    {:ok,socket}
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
    |> assign(page_title: "Edit Incident")
    |> assign(:form, to_form(changeset))
    |> assign(:incident, incident)
  end

  def handle_event("validate", %{"incident" => incident}, socket) do
    changeset = Admin.change_incident(%Incident{}, incident)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  def handle_event("save", %{"incident" => incident_params}, socket) do
    save_raffle(socket, socket.assigns.live_action, incident_params)
  end


  defp save_raffle(socket, :new, incident_params) do
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

  defp save_raffle(socket, :edit, incident_params) do
    case Admin.update_incident(socket.assigns.incident, incident_params) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident edited for great success!")
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

      <.input
        field={@form[:category_id]}
        type="select"
        label="Category"
        prompt="Choose a category"
        options={@category_options}
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
