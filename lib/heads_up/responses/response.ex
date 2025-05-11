defmodule HeadsUp.Responses.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :status, Ecto.Enum, values: [:enroute, :arrived, :departed]
    field :note, :string

    belongs_to(:user, HeadsUp.Accounts.User)
    belongs_to(:incident, HeadsUp.Incidents.Incident)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:status])
    |> validate_required([:note, :status])
    |> validate_length(:note, max: 100)
    |> assoc_constraint(:user)
    |> assoc_constraint(:incident)
  end
end
