defmodule KlziiChat.MailTemplateResource do
  use KlziiChat.Web, :model
  use Timex.Ecto.Timestamps

  schema "MailTemplateResources" do
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    #belongs_to :session, KlziiChat.MailTemplate, [foreign_key: :mailTemplateId]
    field :mailTemplateId, :integer
    field :createdAt, Timex.Ecto.DateTime
    field :updatedAt, Timex.Ecto.DateTime
  end

end
