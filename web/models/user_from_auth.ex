defmodule UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """

  require Logger

  alias Ueberauth.Auth
  alias Exerself.User
  alias Exerself.Repo

  def find_or_create(%Auth{provider: provider, uid: uid} = auth) do
    Logger.info "UserFromAuth.find_or_create: #{inspect auth}"
    case Repo.get_by(User, %{provider: Atom.to_string(provider), uid: uid}) do
      %User{} = user -> {:ok, user}
      _ -> insert_user!(auth)
    end
  end

  defp name_from_auth(%{info: %{name: name}}) when byte_size(name) > 0 do
    name
  end

  defp name_from_auth(%{info: %{first_name: first_name, last_name: last_name}})
    when byte_size(first_name) > 0 or byte_size(last_name) > 0 do
    String.trim (first_name <> " " <> last_name)
  end

  defp name_from_auth(%{info: %{nickname: nickname}}) when byte_size(nickname) > 0 do
    nickname
  end

  defp name_from_auth(%{provider: provider}) do
    "someone from " <> Atom.to_string(provider)
  end

  defp insert_user!(auth) do
    user = Repo.insert!(User.changeset(%User{},
      %{
        name: name_from_auth(auth),
        provider: Atom.to_string(auth.provider),
        uid: auth.uid,
        avatar: auth.info.image
      }))
    {:ok, user}
  end
end
