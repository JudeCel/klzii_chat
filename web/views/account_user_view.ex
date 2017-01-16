defmodule KlziiChat.AccountUserView do
  use KlziiChat.Web, :view

  def render("show.json", %{account_user: account_user})do
    %{
      "id" => account_user.id,
      "firstName" => account_user.firstName,
      "lastName" => account_user.lastName,
      "gender" => account_user.gender,
      "role" => account_user.role,
      "state" => account_user.state,
      "postalAddress" => account_user.postalAddress,
      "city" => account_user.city,
      "country" => account_user.country,
      "postCode" => account_user.postCode,
      "companyName" => account_user.companyName,
      "landlineNumber" => account_user.landlineNumber,
      "email" => account_user.email
    }
  end

  def render("track.json", %{account_user: account_user})do
    %{
      "id" => account_user.id,
      "firstName" => account_user.firstName,
      "lastName" => account_user.lastName,
      "email" => account_user.email
    }
  end
end
