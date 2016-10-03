defmodule KlziiChat.PinboardResourceController do
  use KlziiChat.Web, :controller
  import KlziiChat.ErrorHelpers, only: [error_view: 1]
  alias KlziiChat.{Endpoint}
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
            preloaded_resourve = Repo.preload(pinboard_resource, [:session_member, :resource])
            Endpoint.broadcast!("session_topic:#{session_topic_id}", "new_pinboard_resource", preloaded_resourve)
            json(conn, %{status: :ok})
          {:error, reason} ->
            put_status(conn, reason.code)
            |> json(error_view(reason))
        end
      {:error, reason} ->
        put_status(conn, reason.code)
        |> json(error_view(reason))
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
