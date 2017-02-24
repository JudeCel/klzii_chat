defmodule KlziiChat.ReportView do
  use KlziiChat.Web, :view

  @default_field ["gender","city", "state", "country", "postCode"]

  def render("map_struct.json", %{session: session}) do
    %{
      max_default_fileds_count: 4,
      types: %{
        statistic: %{
          name: "statistic",
          selected: false,
          formats: %{
            pdf: %{ render: false, custom_fields: false },
            csv: %{ render: true, custom_fields: false },
            txt: %{ render: false, custom_fields: false }
          },
          defaultFields: []
        },
        messages: %{
          name: "All",
          selected: true,
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: true, custom_fields: false }
          },
          defaultFields: default_fileds_list(["First Name", "Comment", "Date", "Is Star", "Is Reply"], session)
        },
        messages_stars_only: %{
          selected: false,
          name: "star only",
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: true, custom_fields: false }
          },
          defaultFields: default_fileds_list(["First Name", "Comment", "Date", "Is Reply"], session)
        },
        votes: %{
          selected: false,
          name: "Votes",
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: false, custom_fields: false }
          },
          defaultFields: default_fileds_list(["Title", "Question", "First Name", "Answer", "Date" ], session)
        },
        whiteboards: %{
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
      multiple_topics: %{"pdf" => true},
      fields: %{
        custom: Enum.concat(@default_field, session.participant_list.customFields)
      },
      includes: %{
        facilitator: true
      }
    }
  end

  def default_fileds_list(list, session) do
    case session do
      %{anonymous: true} ->
        List.insert_at(list, 0, "Anonymous")
      _ ->
        list
    end
  end
end
