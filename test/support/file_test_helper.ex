defmodule KlziiChat.FileTestHelper do
  def clean_up_uploads_dir do
    {:ok, _} = File.rm_rf("priv/static/uploads/#{to_string(Mix.env)}")
  end
end
