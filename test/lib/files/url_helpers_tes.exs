defmodule KlziiChat.Files.UrlHelpersTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Files.{ UrlHelpers }

  test "added base domain to link" do
    String.starts_with?(UrlHelpers.add_domain("some/link"),KlziiChat.Endpoint.url)
    |> assert
  end

  describe "video_service_id" do
    test "valid" do
      video_service_links = %{
        a: "http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index",
        b: "http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o",
        c: "http://www.youtube.com/v/0zM3nApSvMg?fs=1&amp;hl=en_US&amp;rel=0",
        d: "http://www.youtube.com/watch?v=0zM3nApSvMg#t=0m10s",
        e: "http://www.youtube.com/embed/0zM3nApSvMg?rel=0",
        f: "http://www.youtube.com/watch?v=0zM3nApSvMg",
        g: "http://youtu.be/0zM3nApSvMg",
        h: "https://vimeo.com/193358188",
        i: "https://player.vimeo.com/video/193358188"
      }
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.video_service_id(video_service_links.a))
      assert({:ok, "QdK8U-VIH_o" } = UrlHelpers.video_service_id(video_service_links.b))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.video_service_id(video_service_links.c))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.video_service_id(video_service_links.d))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.video_service_id(video_service_links.e))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.video_service_id(video_service_links.f))
      assert({:ok, "0zM3nApSvMg" } = UrlHelpers.video_service_id(video_service_links.g))
      assert({:ok, "193358188" } = UrlHelpers.video_service_id(video_service_links.h))
      assert({:ok, "193358188" } = UrlHelpers.video_service_id(video_service_links.i))
    end
  end

  describe "video_service_source" do
    test "valid" do
      video_service_links = %{
        a: "http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index",
        b: "http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o",
        c: "http://www.youtube.com/v/0zM3nApSvMg?fs=1&amp;hl=en_US&amp;rel=0",
        d: "http://www.youtube.com/watch?v=0zM3nApSvMg#t=0m10s",
        e: "http://www.youtube.com/embed/0zM3nApSvMg?rel=0",
        f: "http://www.youtube.com/watch?v=0zM3nApSvMg",
        g: "http://youtu.be/0zM3nApSvMg",
        h: "https://vimeo.com/193358188",
        i: "https://player.vimeo.com/video/193358188"
      }
      assert({:ok, "youtube" } = UrlHelpers.video_service_id(video_service_links.a))
      assert({:ok, "youtube" } = UrlHelpers.video_service_id(video_service_links.b))
      assert({:ok, "youtube" } = UrlHelpers.video_service_id(video_service_links.c))
      assert({:ok, "youtube" } = UrlHelpers.video_service_id(video_service_links.d))
      assert({:ok, "youtube" } = UrlHelpers.video_service_id(video_service_links.e))
      assert({:ok, "youtube" } = UrlHelpers.video_service_id(video_service_links.f))
      assert({:ok, "youtube" } = UrlHelpers.video_service_id(video_service_links.g))
      assert({:ok, "vimeo" } = UrlHelpers.video_service_id(video_service_links.h))
      assert({:ok, "vimeo" } = UrlHelpers.video_service_id(video_service_links.i))
    end
  end
end
