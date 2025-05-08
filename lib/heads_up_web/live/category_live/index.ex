defmodule HeadsUpWeb.CategoryLive.Index do
  use HeadsUpWeb, :live_view


  alias HeadsUp.Categories
  alias HeadsUp.Categories.Category

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :category_collection, Categories.list_category())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Category")
    |> assign(:category, Categories.get_category!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Category")
    |> assign(:category, %Category{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Category")
    |> assign(:category, nil)
  end

  @impl true
  def handle_info({HeadsUpWeb.CategoryLive.FormComponent, {:saved, category}}, socket) do
    {:noreply, stream_insert(socket, :category_collection, category)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Categories.get_category!(id)
    {:ok, _} = Categories.delete_category(category)

    {:noreply, stream_delete(socket, :category_collection, category)}
  end
end
