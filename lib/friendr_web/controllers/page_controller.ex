defmodule FriendrWeb.PageController do
  use FriendrWeb, :controller
  alias Friendr.Accounts
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Interest
  alias Friendr.Interest.Topic


  def home(conn, _params) do

    if conn.assigns.current_user do
      home_login(conn)
    else
      home_no_login(conn)
    end
  end

  defp home_login(conn) do
    user = conn.assigns.current_user
    changeset = User.changeset(user, %{})
    render(conn, :home, changeset: changeset, layout: false)
  end

  defp home_no_login(conn) do
    render(conn, :free, layout: false)
  end




   def update_location_login(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    changeset = User.changeset(user, user_params)
    Repo.update(changeset)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
       |> put_flash(:info, "Your location updated successfully")
       |> redirect(to: ~p"/")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update the user location.")
        |> render("home.html", user: user, changeset: changeset)
      end
  end
end
