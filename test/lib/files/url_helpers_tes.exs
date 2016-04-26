defmodule KlziiChat.Files.UrlHelpersTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Files.{ UrlHelpers }

  test "added base domain to link" do
    String.starts_with?(UrlHelpers.add_domain("some/link"),KlziiChat.Endpoint.url)
    |> assert
  end


  test "youtube_id" do
    youtube_links = %{
      a: "http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index",
      b: "http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o",
      c: "http://www.youtube.com/v/0zM3nApSvMg?fs=1&amp;hl=en_US&amp;rel=0",
      d: "http://www.youtube.com/watch?v=0zM3nApSvMg#t=0m10s",
      f: "http://www.youtube.com/embed/0zM3nApSvMg?rel=0",
      g: "http://www.youtube.com/watch?v=0zM3nApSvMg",
      k: "http://youtu.be/0zM3nApSvMg"
    }
    assert(UrlHelpers.youtube_id(youtube_links.a) == "0zM3nApSvMg")
    assert(UrlHelpers.youtube_id(youtube_links.b) == "QdK8U-VIH_o")
    assert(UrlHelpers.youtube_id(youtube_links.c) == "0zM3nApSvMg")
    assert(UrlHelpers.youtube_id(youtube_links.d) == "0zM3nApSvMg")
    assert(UrlHelpers.youtube_id(youtube_links.f) == "0zM3nApSvMg")
    assert(UrlHelpers.youtube_id(youtube_links.g) == "0zM3nApSvMg")
    assert(UrlHelpers.youtube_id(youtube_links.k) == "0zM3nApSvMg")
  end
end
