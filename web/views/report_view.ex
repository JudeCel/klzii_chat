defmodule KlziiChat.ReportView do
  use KlziiChat.Web, :view

  def render("map.json", %{contact_list: contact_list})do
    %{
      formats: %{
        pdf: %{
          whiteboards: %{ render: true },
          messages: %{ render: true },
          custom_fields: false,
        },
        csv: %{
          whiteboards: %{ render: false },
          messages: %{ render: true },
          custom_fields: true
        },
        txt: %{
          whiteboards: %{ render: false },
          messages: %{ render: true },
          custom_fields: false,
        },
      },
      fields: %{
        default: contact_list.defaultFields,
        custom: contact_list.customFields
      }
    }
  end
end
