defmodule KlziiChat.Helpers.SessionTypeProperty do
  
  @spec get_value(Map.t, List.t) :: Object.t
  def get_value(session, path) do
    get_in(session.session_type.properties, path)
  end

end
