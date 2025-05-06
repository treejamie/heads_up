defmodule HeadsUpWeb.Api.CategoryJSON do

  def show(%{category: category}) do
    %{
      name: category.name,
      slug: category.slug,
      incidents: Enum.map(category.incidents, fn incident ->
        %{id: incident.id, name: incident.name}
      end)
   }
  end

end
