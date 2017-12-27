defmodule KlziiChat.Services.PinboardResourceService do
  alias KlziiChat.{Repo, PinboardResource, SessionTopic, SessionMember, Resource, Session}
  alias KlziiChat.Services.Permissions.PinboardResource, as: PinboardResourcePermissions
  alias KlziiChat.Helpers.IntegerHelper
  import Ecto.Query, only: [from: 2]
  import Ecto

  @spec error_messages() :: Map.t
  def error_messages() do
    %{
      pinboard_is_disable: "Can't add new resource to Pinboard is disable",
      not_a_image: "Resource not an image"
    }
  end

  @spec find(integer, integer) :: %Ecto.Query{}
  def find(session_member_id, session_topic_id) do
    from(pr in PinboardResource,
      where: pr.sessionMemberId == ^session_member_id and pr.sessionTopicId == ^session_topic_id,
      preload: [:resource, :session_member]
    )
  end

  def all(session_topi_id) do
    result = from(pr in PinboardResource,
      where: pr.sessionTopicId == ^session_topi_id,
      order_by: [asc: pr.createdAt],
      preload: [:resource, :session_member]
    ) |> Repo.all
    {:ok, result}
  end

  @spec validations(boolean, integer, integer) :: {:ok} | {:error, String.t}
  def validations(has_permission, session_topic_id, resource_id) do
    with {:ok} <- is_pinboard_enable?(session_topic_id),
         {:ok} <- has_permission,
         {:ok} <- resource_is_image(resource_id),
    do:  {:ok}
  end

  @spec resource_is_image(integer) :: {:ok} | {:error, String.t}
  def resource_is_image(resource_id) do
    from(r in Resource,
      where: r.id == ^resource_id and r.type == "image"
    ) |> Repo.one
      |> case do
          nil ->
            {:error, %{code: 413, not_found: error_messages().not_a_image}}
            _ ->
            {:ok}
         end
  end

  @spec is_pinboard_enable?(integer) :: {:ok} | {:error, String.t}
  def is_pinboard_enable?(session_topic_id) do
    from(st in SessionTopic,
      join: c in assoc(st, :console),
      where: st.id == ^session_topic_id,
      where: c.pinboard == true
    ) |> Repo.one
      |> case do
          nil ->
            {:error, %{code: 403, system: error_messages().pinboard_is_disable}}
            _ ->
            {:ok}
         end
  end

  @spec add(integer, integer, integer) :: {:ok} | {:error, String.t}
  def add(session_member_id, session_topic_id, resource_id) do
    session_topic_id = IntegerHelper.get_num(session_topic_id)
    session_member = Repo.get!(SessionMember, session_member_id)
    session = Repo.get!(Session, session_member.sessionId)
      |> Repo.preload([:session_type])
    {:ok, preference} = KlziiChat.Services.Permissions.Builder.get_subscription_preference_session(session.id)

    PinboardResourcePermissions.can_add_resource(session_member, session, preference)
    |> validations(session_topic_id, resource_id)
    |> case do
        {:ok} ->
          add_resource(session_member, session_topic_id, resource_id)
        {:error, reason} ->
          {:error, reason}
      end
  end

  @spec add_resource(integer, integer, integer) :: {:ok} | {:error, String.t}
  def add_resource(session_member, session_topic_id, resource_id) do
    find(session_member.id, session_topic_id)
    |> Repo.one
    |> case do
        nil ->
          build_assoc(session_member, :pinboard_resources, %{sessionTopicId: session_topic_id, resourceId: resource_id})
          |> Repo.insert
        pinboard_resource ->
          {:ok, p_resouce} = PinboardResource.changeset(pinboard_resource, %{resourceId: resource_id}) |> Repo.update
          {:ok, find(p_resouce.sessionMemberId, p_resouce.sessionTopicId) |> Repo.one}
       end
  end

  @spec delete(integer, integer) :: {:ok, } | {:error, String.t}
  def delete(session_member_id, pinboard_resource_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    pinboard_resource = find_by_id(pinboard_resource_id)

    PinboardResourcePermissions.can_remove_resource(session_member, pinboard_resource)
    |> case do
        {:ok} ->
          case pinboard_resource.resource do
            nil ->
              {:ok, pinboard_resource}
            resource ->
              {:ok, _} = Repo.delete(resource)
              {:ok, %{id: pinboard_resource.id}}
          end
        {:error, reason} ->
          {:error, reason}
      end
  end

  def find_by_id(id)  do
    from(pr in PinboardResource, where: [id: ^id], preload: [:resource, :session_member] )
    |> Repo.one!
  end
end
