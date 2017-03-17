defmodule KlziiChat.Services.ConnectionLogServiceTest do
  use KlziiChat.{ModelCase}
  alias KlziiChat.Services.ConnectionLogService

  describe "node app logs info" do
    test "collect with currentResources" do
      params = %{
        "method" => "collect",
        "params" => %{
          "level" => "info",
          "message" => "HTTP GET /account-hub",
          "meta" => %{
            "application" => "klzii",
            "currentResources" => %{
              "account" => %{"admin" => true, "id" => 1, "name" => "admin", "subdomain" => "admin"},
              "accountUser" => %{"id" => 1, "role" => "admin"},
              "user" => %{"email" => "admin@insider.com", "id" => 1}},
            "req" => %{
              "headers" => %{
                "accept" => "image/webp,image/*,*/*;q=0.8",
                "accept-encoding" => "gzip, deflate, sdch",
                "accept-language" => "en-US,en;q=0.8,lv;q=0.6",
                "cache-control" => "no-cache", "connection" => "keep-alive",
                "cookie" => "dev=s%3AyWjtlUwpm0U2UBjiFShqgohZgMhUcsZA.iF0YAP5lVDMf7YdAK%2FGNltRYccDqdXZTbbLRdkDzAqo",
                "host" => "admin.focus.com:8080", "pragma" => "no-cache",
                "referer" => "http://admin.focus.com:8080/account-hub",
                "user-agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
                },
              "httpVersion" => "1.1", "method" => "GET",
              "originalUrl" => "/account-hub", "query" => %{},
              "url" => "/account-hub"
            },
            "res" => %{"statusCode" => 200},
            "responseTime" => 108}}
          }
      {:ok, connection_log} = ConnectionLogService.save(params)

      assert(connection_log.userId == 1)
      assert(connection_log.accountUserId == 1)
      assert(connection_log.accountId == 1)
    end

    test "collect without currentResources" do
      params = %{
        "method" => "collect",
        "params" => %{
          "level" => "info",
          "message" => "HTTP GET /account-hub",
          "meta" => %{
            "application" => "klzii",
            "req" => %{
              "headers" => %{
                "accept" => "image/webp,image/*,*/*;q=0.8",
                "accept-encoding" => "gzip, deflate, sdch",
                "accept-language" => "en-US,en;q=0.8,lv;q=0.6",
                "cache-control" => "no-cache", "connection" => "keep-alive",
                "cookie" => "dev=s%3AyWjtlUwpm0U2UBjiFShqgohZgMhUcsZA.iF0YAP5lVDMf7YdAK%2FGNltRYccDqdXZTbbLRdkDzAqo",
                "host" => "admin.focus.com:8080", "pragma" => "no-cache",
                "referer" => "http://admin.focus.com:8080/account-hub",
                "user-agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
                },
              "httpVersion" => "1.1", "method" => "GET",
              "originalUrl" => "/account-hub", "query" => %{},
              "url" => "/account-hub"
            },
            "res" => %{"statusCode" => 200},
            "responseTime" => 108}}
          }
      {:ok, connection_log} = ConnectionLogService.save(params)

      assert(connection_log.userId == nil)
      assert(connection_log.accountUserId == nil)
      assert(connection_log.accountId == nil)
    end
  end
end
