defmodule KekoverflowWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller
  import Kekoverflow.Authorization
  alias KekoverflowWeb.Router.Helpers, as: Routes
  alias Kekoverflow.Repo

  require IEx

  def init(opts), do: opts

  def call(conn, opts) do
    user = conn.assigns.current_user
    role = user.role
    resource = Keyword.get(opts, :resource)
    action = action_name(conn)
    content =
    if conn.params["id"] do
      Repo.get!(resource, conn.params["id"])
    else
      nil
    end

    check(action, user, content, role, resource)
    |> maybe_continue(conn)
  end

  defp maybe_continue(true, conn), do: conn
  defp maybe_continue(false, conn) do
    conn
    |> put_flash(:error, "You are not authorized")
    |> redirect(to: Routes.question_path(conn, :index))
    |> halt()
  end

  defp check(action, _user, _content, role, resource) when action in [:index, :show] do
    can(role) |> read?(resource)
  end

  defp check(action, _user, _content, role, resource) when action in [:new, :create] do
    can(role) |> create?(resource)
  end

  defp check(action, user, content, role, resource) when action in [:edit, :update] do
    if content == nil do
      true
    else
      if user.id == content.user_id do
        can(role) |> update?(resource)
      else
        if role == "admin" do
          true
        else
          false
        end
      end
    end

  end

  defp check(action, user, content, role, resource) do
    if content == nil do
      true
    else
      if user.id == content.user_id do
        can(role) |> delete?(resource)
      else
        if role == "admin" do
          true
        else
          false
        end
      end
    end
  end

  defp check(_action, _user, _content, _role, _resource), do: false
  
end