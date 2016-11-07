defmodule KlziiChat.ReportView do
  use KlziiChat.Web, :view

  @default_field ["gender","city", "state", "country", "postCode"]

  def render("map_struct.json", %{contact_list: contact_list}) do
    %{
      max_default_fileds_count: 4,
      types: %{
        messages: %{
          multiple_topics: true,
          name: "All",
          selected: true,
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: true, custom_fields: true }
          },
          defaultFields: ["First Name", "Comment", "Date", "Is Star", "Is Reply"]
        },
        messages_stars_only: %{
          multiple_topics: true,
          selected: false,
          name: "star only",
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: true, custom_fields: true }
          },
          defaultFields: ["First Name", "Comment", "Date", "Is Reply"]
        },
        votes: %{
          multiple_topics: true,
          selected: false,
          name: "Votes",
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: true, custom_fields: true }
          },
          defaultFields: ["Title", "Question", "First Name", "Answer", "Date" ]
        },
        whiteboards: %{
          multiple_topics: true,
          selected: false,
          name: "Whiteboard",
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: false, custom_fields: false },
            txt: %{ render: false, custom_fields: false }
          },
          defaultFields: []
        },
      },
      fields: %{
        custom: Enum.concat(@default_field, contact_list.customFields)
      },
      includes: %{
        facilitator: true
      }
    }
  end
end