defmodule Exerself.User do
  use Exerself.Web, :model

  schema "users" do
    field :name, :string
    field :provider, :string
    field :uid, :string
    field :avatar, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :provider, :uid, :avatar])
    |> validate_required([:name, :provider, :uid, :avatar])
  end
end
