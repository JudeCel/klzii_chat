defmodule KlziiChat.PaginationTest do
  use KlziiChat.ModelCase, async: true
  alias KlziiChat.Helpers.{PagesHelper}

  @items_on_page 2
  @page 2
  @all_data [1, 2, 3, 4, 5]
  @data_second_page [3, 4]
  @pages_result 3

  test "pages test" do
    pages = PagesHelper.get_pages(@all_data, @items_on_page)
    assert(pages == @pages_result)
  end

  test "date data test" do
    data = PagesHelper.get_page_data(@all_data, @page, @items_on_page)
    assert(@data_second_page == data)
    assert(length(data) == @items_on_page)
  end

  test "pagination test" do
    assert({@data_second_page, @pages_result} == PagesHelper.paginate(@all_data, @page, @items_on_page))
  end

end
