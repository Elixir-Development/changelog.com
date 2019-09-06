defmodule ChangelogWeb.EpisodeRequestController do
  use ChangelogWeb, :controller

  alias Changelog.{EpisodeRequest, Podcast}

  plug RequireUser, "before submitting" when action in [:create]

  def new(conn, params) do
    slug = Map.get(params, "slug", "podcast")

    podcast_id = case Repo.get_by(Podcast, slug: slug) do
      podcast = %Podcast{} -> podcast.id
      _else -> 1
    end

    changeset = EpisodeRequest.submission_changeset(%EpisodeRequest{podcast_id: podcast_id})

    conn
    |> assign(:changeset, changeset)
    |> render(:new)
  end

  def create(conn = %{assigns: %{current_user: user}}, %{"episode_request" => request_params}) do
    request = %EpisodeRequest{submitter_id: user.id, status: :submitted}
    changeset = EpisodeRequest.submission_changeset(request, request_params)

    case Repo.insert(changeset) do
      {:ok, _request} ->
        conn
        |> put_flash(:success, "We received your episode request! Stay awesome 💚")
        |> redirect(to: root_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong. 😭")
        |> render(:new, changeset: changeset)
    end
  end
end
