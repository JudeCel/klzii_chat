defmodule KlziiChat.Helpers.PagesHelper do

  @spec paginate(List.t, Integer.t, Integer.t) :: {List.t, Integer.t}
  def paginate(data, page, items_on_page) do
    {get_page_data(data, page, items_on_page), get_pages(data, items_on_page)}
  end

  @spec get_page_data(List.t, Integer.t, Integer.t) :: List.t
  def get_page_data(data, page, items_on_page) do
    Enum.take(Enum.drop(data, (page-1)*items_on_page), items_on_page)
  end

  @spec get_pages(List.t, Integer.t) :: Integer.t
  def get_pages(data, items_on_page) do
    round(Float.ceil(length(data) / items_on_page))
  end

end
