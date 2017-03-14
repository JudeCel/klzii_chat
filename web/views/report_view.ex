defmodule KlziiChat.ReportView do
  use KlziiChat.Web, :view

  @default_field ["gender","city", "state", "country", "postCode"]

  def render("map_struct.json", %{session: session}) do
    %{
      max_default_fileds_count: 4,
      types: %{
        messages: %{
          position: 0,
          section: "table",
          name: "All",
          session_types: ["focus", "forum", "socialForum"],
          selected: true,
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: true, custom_fields: false }
          },
          defaultFields: default_fileds_list(["First Name", "Comment", "Date", "Is Star", "Is Reply"], session)
        },
        messages_stars_only: %{
          position: 1,
          section: "table",
          selected: false,
          session_types: ["focus", "forum", "socialForum"],
          name: "star only",
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: true, custom_fields: false }
          },
          defaultFields: default_fileds_list(["First Name", "Comment", "Date", "Is Reply"], session)
        },
        prize_draw: %{
          position: 2,
          section: "table",
          selected: false,
          session_types: ["socialForum"],
          name: "Prize Draw",
          formats: %{
            pdf: %{ render: false, custom_fields: false },
            csv: %{ render: true, custom_fields: false },
            txt: %{ render: false, custom_fields: false }
          },
          defaultFields: default_fileds_list(["First Name", "Comment", "Date", "Is Reply"], session)
        },
        votes: %{
          position: 3,
          section: "table",
          selected: false,
          session_types: ["focus", "forum", "socialForum"],
          name: "Votes",
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: true, custom_fields: true },
            txt: %{ render: false, custom_fields: false }
          },
          defaultFields: default_fileds_list(["Title", "Question", "First Name", "Answer", "Date" ], session)
        },
        whiteboards: %{
          position: 4,
          section: "table",
          selected: false,
          session_types: ["focus", "forum", "socialForum"],
          name: "Whiteboard",
          formats: %{
            pdf: %{ render: true, custom_fields: false },
            csv: %{ render: false, custom_fields: false },
            txt: %{ render: false, custom_fields: false }
          },
          defaultFields: []
        },
        statistic: %{
          position: 5,
          section: "",
          name: "statistic",
          session_types: ["focus", "forum", "socialForum"],
          selected: false,
          formats: %{
            pdf: %{ render: false, custom_fields: false },
            csv: %{ render: true, custom_fields: false },
            txt: %{ render: false, custom_fields: false }
          },
          defaultFields: []
        },
      },
      multiple_topics: %{"pdf" => true},
      fields: %{
        custom: Enum.concat(@default_field, participant_list_custom_fields(session.participant_list))
      },
      includes: %{
        facilitator: true
      }
    }
  end

  def participant_list_custom_fields(%{__struct__: Ecto.Association.NotLoaded}), do: []
  def participant_list_custom_fields(nil), do: []
  def participant_list_custom_fields(participant_list), do: participant_list.customFields


  def default_fileds_list(list, session) do
    case session do
      %{anonymous: true} ->
        List.insert_at(list, 0, "Anonymous")
      _ ->
        list
    end
  end
end
