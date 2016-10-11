defmodule KlziiChat.Helpers.PagesHelper do

  @spec paginate(List.t, Integer.t, Integer.t) :: Map.t
  def paginate(data, page, items_on_page) do
    pages = Float.ceil(length(data) / items_on_page)
    page_data = Enum.take(Enum.drop(data, (page-1)*items_on_page), items_on_page)
    {page_data, pages}
  end

end
