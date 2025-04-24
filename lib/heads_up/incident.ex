defmodule HeadsUp.Incident do
  defstruct [:id, :name, :description, :priority, :status, :image_path]
end

defmodule HeadsUp.Incidents do

  @spec list_incidents() :: [
          %HeadsUp.Incident{
            description: <<_::392, _::_*64>>,
            id: 1 | 2 | 3,
            image_path: <<_::64, _::_*8>>,
            name: <<_::64, _::_*8>>,
            priority: 1 | 2,
            status: :canceled | :pending | :resolved
          },
          ...
        ]
  def list_incidents do
    [
      %HeadsUp.Incident{
        id: 1,
        name: "Lost Dog",
        description: "A friendly dog is wandering around the neighborhood. 🐶",
        priority: 2,
        status: :pending,
        image_path: "/images/lost-dog.jpg"
      },
      %HeadsUp.Incident{
        id: 2,
        name: "Flat Tire",
        description: "Our beloved ice cream truck has a flat tire! 🛞",
        priority: 1,
        status: :resolved,
        image_path: "/images/flat-tire.jpg"
      },
      %HeadsUp.Incident{
        id: 3,
        name: "Bear In The Trash",
        description: "A curious bear is digging through the trash! 🐻",
        priority: 1,
        status: :canceled,
        image_path: "/images/bear-in-trash.jpg"
      }
    ]
  end

  def get_incident(id) when is_integer(id) do
    list_incidents()
    |> Enum.find(fn i -> i.id == id end)
  end

  def get_incident(id) when is_binary(id) do
    id |> String.to_integer() |> get_incident()
  end

  def get_urgent(incident) do
    list_incidents() |> List.delete(incident)
  end
end
