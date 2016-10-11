defmodule KlziiChat.PaginationTest do
  use KlziiChat.ModelCase, async: true
  alias KlziiChat.Helpers.{PagesHelper}

  test "pagination test" do
    items_on_page = 2
    page = 2
    all_data = [1, 2, 3, 4, 5]
    {data, pages} = PagesHelper.paginate(all_data, page, items_on_page)

    assert length(data) == items_on_page
    assert pages == 3
  end

end
