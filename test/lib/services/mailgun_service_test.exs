defmodule KlziiChat.Services.MailgunServiceTest do
  use KlziiChat.{ModelCase}
  alias KlziiChat.Services.MailgunService


  describe "get_messasge_id" do
    test "valid" do
      mail = "2ccb73bb-f9a0-2031-df63-9d2edb0dc15b@test.klzii.com"
      params = %{"Message-Id" => "<#{mail}>"}
      assert({:ok, mail} == MailgunService.get_messasge_id(params))
    end

    test "no Message-Id key" do
      assert({:error, _} = MailgunService.get_messasge_id(%{}))
    end
  end

  describe "#detect_event" do
    test "dropped" do
      params = %{
        "Message-Id" => "<2ccb73bb-f9a0-2031-df63-9d2edb0dc15b@test.klzii.com>",
        "X-Mailgun-Sid" => "WyI2MzhkZCIsICJkYWluaXNzczE4NkBnbWFpbC5jb20iLCAiZWNhMDYiXQ==",
        "attachment-1" => %Plug.Upload{content_type: "application/octet-stream",
         filename: "message.mime", path: "/tmp/plug-1484/multipart-303157-568251-1"},
        "attachment-count" => "1", "body-plain" => "", "code" => "605",
        "description" => "Not delivering to previously bounced address",
        "domain" => "test.klzii.com", "event" => "dropped",
        "message-headers" => "[[\"X-Mailgun-Sid\", \"WyI2MzhkZCIsICJkYWluaXNzczE4NkBnbWFpbC5jb20iLCAiZWNhMDYiXQ==\"], [\"Received\", \"from [127.0.0.1] (230.177.222.162.bc.googleusercontent.com [162.222.177.230]) by mxa.mailgun.org with ESMTP id 5878ab35.7f038010ef00-in02; Fri, 13 Jan 2017 10:25:57 -0000 (UTC)\"], [\"Content-Type\", [\"multipart/mixed\", {\"boundary\": \"----sinikael-?=_1-14843031567110.07414406296054232\"}]], [\"From\", \"klzii <noreply@test.klzii.com>\"], [\"To\", \"dainisss186@gmail.com\"], [\"Subject\", \"Invitation to cool session\"], [\"Message-Id\", \"<2ccb73bb-f9a0-2031-df63-9d2edb0dc15b@test.klzii.com>\"], [\"X-Mailer\", \"nodemailer (2.7.0; +https://nodemailer.com/; SMTP/2.7.2[client:2.12.0])\"], [\"Date\", \"Fri, 13 Jan 2017 10:25:56 +0000\"], [\"Mime-Version\", \"1.0\"]]",
        "reason" => "hardfail", "recipient" => "dainisss186@gmail.com",
        "signature" => "7ec191d2e12a7118b4deddc522d92c04921ab0f9895566b7b9dd7ae8dd3fa860",
        "timestamp" => "1484303157",
        "token" => "66aea1cffaadd0ae404fdc48c351c65814df85c4bfe5c843f7"
      }
      assert({:ok, update_attrs} = MailgunService.detect_event(params))
      assert(update_attrs.emailStatus, "failed")
      assert(update_attrs.webhookEvent == "dropped")
      assert(update_attrs.webhookMessage, "Not delivering to previously bounced address")
    end

    test "delivered" do
      params = %{"Message-Id" => "<20130503182626.18666.16540@test.klzii.com>",
        "body-plain" => "", "domain" => "test.klzii.com", "event" => "delivered",
        "message-headers" => "[[\"Received\", \"by luna.mailgun.net with SMTP mgrt 8734663311733; Fri, 03 May 2013 18:26:27 +0000\"], [\"Content-Type\", [\"multipart/alternative\", {\"boundary\": \"eb663d73ae0a4d6c9153cc0aec8b7520\"}]], [\"Mime-Version\", \"1.0\"], [\"Subject\", \"Test deliver webhook\"], [\"From\", \"Bob <bob@test.klzii.com>\"], [\"To\", \"Alice <alice@example.com>\"], [\"Message-Id\", \"<20130503182626.18666.16540@test.klzii.com>\"], [\"X-Mailgun-Variables\", \"{\\\"my_var_1\\\": \\\"Mailgun Variable #1\\\", \\\"my-var-2\\\": \\\"awesome\\\"}\"], [\"Date\", \"Fri, 03 May 2013 18:26:27 +0000\"], [\"Sender\", \"bob@test.klzii.com\"]]",
        "my-var-2" => "awesome", "my_var_1" => "Mailgun Variable #1",
        "recipient" => "alice@example.com",
        "signature" => "3475bb0f5b63f909c4b3658a13989fdee1de9f3573b0bf7bc9675208b12d053a",
        "timestamp" => "1484307132",
        "token" => "da100dca48f89ffd0ba021a79a3147c279f9e2c2fd2c6fc90b"
      }
      assert({:ok, update_attrs} = MailgunService.detect_event(params))
      assert(update_attrs.emailStatus == "delivered")
      assert(update_attrs.webhookEvent == "delivered")
      assert(update_attrs.webhookMessage == nil)
    end

    test "bounced" do
      params = %{"Message-Id" => "<20130503182626.18666.16540@test.klzii.com>",
        "X-Mailgun-Sid" => "WyIwNzI5MCIsICJhbGljZUBleGFtcGxlLmNvbSIsICI2Il0=",
        "attachment-1" => %Plug.Upload{content_type: "application/octet-stream",
         filename: "message.mime", path: "/tmp/plug-1484/multipart-307281-479252-1"},
        "attachment-count" => "1", "body-plain" => "", "code" => "550",
        "domain" => "test.klzii.com",
        "error" => "5.1.1 The email account that you tried to reach does not exist. Please try\n5.1.1 double-checking the recipient's email address for typos or\n5.1.1 unnecessary spaces. Learn more at\n5.1.1 http://support.example.com/mail/bin/answer.py",
        "event" => "bounced",
        "message-headers" => "[[\"Received\", \"by luna.mailgun.net with SMTP mgrt 8734663311733; Fri, 03 May 2013 18:26:27 +0000\"], [\"Content-Type\", [\"multipart/alternative\", {\"boundary\": \"eb663d73ae0a4d6c9153cc0aec8b7520\"}]], [\"Mime-Version\", \"1.0\"], [\"Subject\", \"Test bounces webhook\"], [\"From\", \"Bob <bob@test.klzii.com>\"], [\"To\", \"Alice <alice@example.com>\"], [\"Message-Id\", \"<20130503182626.18666.16540@test.klzii.com>\"], [\"List-Unsubscribe\", \"<mailto:u+na6tmy3ege4tgnldmyytqojqmfsdembyme3tmy3cha4wcndbgaydqyrgoi6wszdpovrhi5dinfzw63tfmv4gs43uomstimdhnvqws3bomnxw2jtuhusteqjgmq6tm@test.klzii.com>\"], [\"X-Mailgun-Sid\", \"WyIwNzI5MCIsICJhbGljZUBleGFtcGxlLmNvbSIsICI2Il0=\"], [\"X-Mailgun-Variables\", \"{\\\"my_var_1\\\": \\\"Mailgun Variable #1\\\", \\\"my-var-2\\\": \\\"awesome\\\"}\"], [\"Date\", \"Fri, 03 May 2013 18:26:27 +0000\"], [\"Sender\", \"bob@test.klzii.com\"]]",
        "my-var-2" => "awesome", "my_var_1" => "Mailgun Variable #1",
        "recipient" => "alice@example.com",
        "signature" => "6ba3aeb529d451de0dc63d76483c1ff55da3cd40f4dfa75a75494ad0edda3dc2",
        "timestamp" => "1484307281",
        "token" => "f5220272b16269d148b7ba03ce08c2dff68c8b56e4069308fc"
      }
      assert({:ok, update_attrs} = MailgunService.detect_event(params))
      assert(update_attrs.emailStatus == "failed")
      assert(update_attrs.webhookEvent == "bounced")
      assert(update_attrs.webhookMessage == Map.get(params, "error"))
    end
  end
end
