defmodule KlziiChat.PinboardResourceController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{PinboardResourceView, Endpoint}
  alias KlziiChat.Services.{ PinboardResourceService, ResourceService}
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_member

  def upload(conn, params, member, _) do
    %{"sessionTopicId" => session_topic_id} = params
    case ResourceService.upload(params, member.account_user.id) do
      {:ok, resource} ->
        case PinboardResourceService.add(member.session_member.id, session_topic_id, resource.id) do
          {:ok, pinboard_resource} ->
              pinboard_resource =
                Repo.preload(pinboard_resource, [:session_member, :resource])
                |> Phoenix.View.render_one(PinboardResourceView, "show.json", as: :pinboard_resource)
            Endpoint.broadcast!("session_topic:#{member.session_member.sessionId}", "new_pinboard_resource", pinboard_resource)
            json(conn, %{status: :ok, pinboard_resource: pinboard_resource})
          {:error, reason} ->
            json(conn, %{status: :error, error: reason})
        end
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  defp if_current_member(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
