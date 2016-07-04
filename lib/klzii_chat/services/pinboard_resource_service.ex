defmodule KlziiChat.Services.PinboardResourceService do
  alias KlziiChat.{Repo, PinboardResource, SessionTopic, SessionMember, Resource}
  alias KlziiChat.Services.Permissions.PinboardResource, as: PinboardResourcePermissions
  import Ecto.Query, only: [from: 2]
  import Ecto

  @spec error_messages :: Map.t
  def error_messages do
    %{
      pinboard_is_disable: "Can't add new resource to Pinboard is disable",
      not_a_image: "Resource not an image"
    }
  end

  @spec find(integer, integer) :: %Ecto.Query{}
  def find(session_member_id, session_topic_id) do
    from(pr in PinboardResource,
      where: pr.sessionMemberId == ^session_member_id and pr.sessionTopicId == ^session_topic_id,
      preload: [:resource]
    )
  end

  def all(session_topi_id) do
    result = from(pr in PinboardResource,
      where: pr.sessionTopicId == ^session_topi_id,
      preload: [:resource]
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
            {:error, error_messages.not_a_image}
            _ ->
            {:ok}
         end
  end

  @spec is_pinboard_enable?(integer) :: {:ok} | {:error, String.t}
  def is_pinboard_enable?(session_topic_id) do
    from(st in SessionTopic,
      join: c in assoc(st, :console),
      where: c.pinboard == true
    ) |> Repo.one
      |> case do
          nil ->
            {:error, error_messages.pinboard_is_disable}
            _ ->
            {:ok}
         end
  end

  @spec add(integer, integer, integer) :: {:ok} | {:error, String.t}
  def add(session_member_id, session_topic_id, resource_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    PinboardResourcePermissions.can_add_resource(session_member)
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
          build_assoc(session_member, :pinboard_resources, %{sessionTopicId: session_topic_id, resourceId: resource_id}) |> Repo.insert
        pinboard_resource ->
          PinboardResource.changeset(pinboard_resource, %{resourceId: resource_id}) |> Repo.update
       end
  end

  @spec delete(integer, integer) :: {:ok, } | {:error, String.t}
  def delete(session_member_id, session_topic_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    pinboard_resource = find(session_member.id, session_topic_id) |> Repo.one!

    PinboardResourcePermissions.can_remove_resource(session_member, pinboard_resource)
    |> case do
        {:ok} ->
          case pinboard_resource.resource do
            nil ->
              {:ok, pinboard_resource}
            resource ->
              {:ok, resource} = Repo.delete(resource)
              {:ok, Repo.get!(PinboardResource, pinboard_resource.id)}
          end
        {:error, reason} ->
          {:error, reason}
      end
  end
end
