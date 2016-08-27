defmodule KlziiChat.Services.Validations.Resource do

  @spec validate(map, map) :: {:ok} | {:error, map}
  def validate(file, params) do
    validate_file_type(file, params)
  end

  @spec file_type_error_mesage(String.t, String.t) :: %{code: integer, type: String.t}
  def file_type_error_mesage(actual, should) do
    %{code: 415, type: "You are trying to upload #{actual} where it is allowed only #{should}."}
  end

  @spec validate_file_type(map | String.t, map) :: {:ok} | {:error, map}
  def validate_file_type(%Plug.Upload{content_type: content_type}, %{type:  type}) when type in ["image", "audio", "video"] do
    file_type = String.split(content_type, "/") |> List.first
    cond do
      file_type != type ->
        {:error, file_type_error_mesage(file_type, type)}
      true ->
        {:ok}
    end
  end
  def validate_file_type(%Plug.Upload{content_type: content_type}, %{type: type}) when type in ["file"] do
    extension = Plug.MIME.extensions(content_type) |> List.last
    allowed_extensions = KlziiChat.Uploaders.File.allowed_extensions
      |> Enum.map(fn i -> String.trim(i, ".") end)
    if extension in allowed_extensions do
      {:ok}
    else
      file_type = String.split(content_type, "/") |> List.first
      {:error, file_type_error_mesage(file_type, type)}
    end
  end
  def validate_file_type(file, %{type: type}) when is_bitstring(file) and type in ["link"] do
    cond do
      type in ["link"] ->
        youtube_url_validator(file)
      true ->
        {:error, %{code: 415, type: "Accept only links"}}
    end
  end
  def validate_file_type(file, %{type: type}) when is_bitstring(file) do
    cond do
      type in ["file", "link"] ->
        {:ok}
      true ->
        {:error, %{code: 415, type: "Accept only links"}}
    end
  end
  def validate_file_type(_, _) do
    {:error, %{code: 415, type: "File not valid"}}
  end

  @spec youtube_url_validator(String) :: {:ok} | {:error, String.t}
  def youtube_url_validator(url) do
    valid_paterns = ~r{(youtu.be/|youtube.com/embed|youtube.com/watch|youtube.com/v/|youtube.com)}
    if String.match?(url, valid_paterns) do
      {:ok}
    else
      {:error, %{code: 415, type: "Youtube url not valid"}}
    end
  end
end
