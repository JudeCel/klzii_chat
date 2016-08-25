defmodule KlziiChat.Files.UrlHelpersTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Files.{ UrlHelpers }

  test "added base domain to link" do
    String.starts_with?(UrlHelpers.add_domain("some/link"),KlziiChat.Endpoint.url)
    |> assert
  end

  describe "youtube_id" do
    test "valid" do
      youtube_links = %{
        a: "http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index",
        b: "http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o",
        c: "http://www.youtube.com/v/0zM3nApSvMg?fs=1&amp;hl=en_US&amp;rel=0",
        d: "http://www.youtube.com/watch?v=0zM3nApSvMg#t=0m10s",
        f: "http://www.youtube.com/embed/0zM3nApSvMg?rel=0",
        g: "http://www.youtube.com/watch?v=0zM3nApSvMg",
        k: "http://youtu.be/0zM3nApSvMg"
      }
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.youtube_id(youtube_links.a))
      assert({:ok, "QdK8U-VIH_o" } = UrlHelpers.youtube_id(youtube_links.b))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.youtube_id(youtube_links.c))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.youtube_id(youtube_links.d))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.youtube_id(youtube_links.f))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.youtube_id(youtube_links.g))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.youtube_id(youtube_links.k))
    end
  end
end
