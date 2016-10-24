defmodule KlziiChat.ReportView do
  use KlziiChat.Web, :view

  def render("map_struct.json", %{contact_list: contact_list}) do
    %{
      types: %{
        messages: %{
          selected: true,
          formats: %{
            pdf: %{ render: true },
            csv: %{ render: true },
            txt: %{ render: true }
          },
          custom_fields: false,
        },
        votes: %{
          selected: false,
          formats: %{
            pdf: %{ render: true },
            csv: %{ render: true },
            txt: %{ render: true }
          },
          custom_fields: false,
        },
        whiteboards: %{
          selected: false,
          formats: %{
            pdf: %{ render: true },
            csv: %{ render: false },
            txt: %{ render: false }
          },
          custom_fields: false,
        },
      },
      fields: %{
        default: contact_list.defaultFields,
        custom: contact_list.customFields
      },
      includes: %{
        facilitator: true
      },
      scopes: %{
        star_only: %{ star: false }
      }
    }
  end
end
