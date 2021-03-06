defmodule KritikosWeb.SessionsController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions

  plug KritikosWeb.Plug.EnsureAuthenticated, store: :token

  def start_session(conn, params, user) do
    session_name = params["name"]
    keyword = params["keyword"]
    tags = params["tags"]
    prompt_question = params["promptQuestion"]

    case Sessions.start(%{
           user_id: user.id,
           name: session_name,
           tags: tags,
           keyword: keyword,
           prompt_question: prompt_question
         }) do
      {:ok, session} ->
        conn
        |> render("show.json", %{session: session})

      {:error, reason} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: reason})
    end
  end

  def end_session(conn, %{"keyword" => keyword}, _user) do
    case Sessions.stop(keyword) do
      {:ok, session} ->
        conn
        |> render("show.json", %{session: session})

      {:error, %Ecto.Changeset{} = cs} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: cs})

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: reason})
    end
  end

  def delete_session(conn, %{"session_id" => id}, _user) do
    case Sessions.delete(id) do
      {:ok, session} ->
        conn
        |> render("show.json", %{session: session})

      {:error, reason} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: reason})
    end
  end

  def get_session(conn, %{"keyword" => keyword}, _user) do
    case Sessions.get_open(keyword, preload: [:votes, :tags]) do
      nil ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: "session not found"})

      session ->
        conn
        |> render("show.json", %{session: session})
    end
  end

  def export_session_qr(conn, %{"keyword" => keyword}, _user) do
    binary_img = Sessions.Export.export_qr_code(keyword)
    send_download(conn, {:binary, binary_img}, filename: keyword <> ".png")
  end

  def export_session_qr_pdf_grid(conn, %{"keyword" => keyword}, _user) do
    {:ok, pdf_grid_filename} = Sessions.Export.generate_session_qr_code_grid_pdf(keyword)

    case File.read(pdf_grid_filename) do
      {:ok, pdf_grid_binary} ->
        conn
        |> send_download({:binary, pdf_grid_binary}, filename: keyword <> ".pdf")

      {:error, reason} ->
        File.rm!(pdf_grid_filename)

        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: reason})
    end
  end
end
