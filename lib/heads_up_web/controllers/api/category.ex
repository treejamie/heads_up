defmodule HeadsUpWeb.Api.CategoryController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Categories

  def show(conn, %{"id" => id}) do
    render(conn, :show, category: Categories.get_category_with_incidents!(id))
  end

end
