defmodule HeadsUp.Incidents.Incident do
  use Ecto.Schema
  import Ecto.Changeset

  schema "incidents" do
    field :name, :string
    field :priority, :integer
    field :status, Ecto.Enum, values: [:pending, :resolved, :canceled]
    field :description, :string
    field :image_path, :string, default: "/images/placeholder.jpg"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(incident, attrs) do
    incident
    |> cast(attrs, [:name, :description, :priority, :status, :image_path])
    |> validate_required([:name, :description, :priority, :status, :image_path])
    |> validate_length(:description, min: 10)
    |> validate_number(:priority, greater_than: 0, less_than: 4)
  end
end
