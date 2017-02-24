defmodule KlziiChat.SessionTypeCase do
  use ExUnit.CaseTemplate

  #Make sure you copied here changes did in dashboard project file !!!

  setup do

    properties = %{
      
      "focus" => %{
        "steps" => %{
          "setUp" => %{
            "enabled" => true
          }, 
          "facilitatiorAndTopics" => %{
            "enabled" => true
          }, 
          "manageSessionEmails" => %{
            "enabled" => true
          },
          "manageSessionParticipants" => %{
            "enabled" => true,
            "sendGroupSms" => true
          }, 
          "inviteSessionObservers" => %{
            "enabled" => true,
            "sendGroupSms" => false
          }
        },
        "features" => %{
          "survay" => %{
            "enabled" => false
          },
          "unidentifiedParticipants" => %{
            "enabled" => false
          },
          "whiteboard" => %{
            "enabled" => true,
            "canWrite" => ["facilitator", "participant"]
          },
          "pinboard" => %{
            "enabled" => true
          },
          "sendSms" => %{
            "enabled" => true
          },
          "closeSession" => %{
            "enabled" => true
          },
          "dateAndTime" => %{
            "enabled" => true
          },
          "anonymous" => %{
            "enabled" => true
          },
          "colorScheme" => %{
            "type" => "focus"
          },
          "socialMediaGraphics"=> {
            "enabled"=> false
          }
        },
        "validations" => %{
          "participant" => %{
            "max" => 8
          },
          "observer" => %{
            "max" => -1
          }
        }
      },

      "forum" => %{
        "steps" => %{
          "setUp" => %{
            "enabled" => true
          }, 
          "facilitatiorAndTopics" => %{
            "enabled" => true
          }, 
          "manageSessionEmails" => %{
            "enabled" => true
          },
          "manageSessionParticipants" => %{
            "enabled" => true,
            "sendGroupSms" => false
          }, 
          "inviteSessionObservers" => %{
            "enabled" => true,
            "sendGroupSms" => false
          }
        },
        "features" => %{
          "survay" => %{
            "enabled" => false
          },
          "unidentifiedParticipants" => %{
            "enabled" => false
          },
          "whiteboard" => %{
            "enabled" => true,
            "canWrite" => ["facilitator"]
          },
          "pinboard" => %{
            "enabled" => false
          },
          "sendSms" => %{
            "enabled" => false
          },
          "closeSession" => %{
            "enabled" => true
          },
          "dateAndTime" => %{
            "enabled" => true
          },
          "anonymous" => %{
            "enabled" => true
          },
          "colorScheme" => %{
            "type" => "forum"
          },
          "socialMediaGraphics"=> {
            "enabled"=> false
          }
        },
        "validations" => %{
          "participant" => %{
            "max" => -1
          },
          "observer" => %{
            "max" => -1
          }
        }
      },

      "socialForum" => %{
        "steps" => %{
          "setUp" => %{
            "enabled" => true
          }, 
          "facilitatiorAndTopics" => %{
            "enabled" => true
          }, 
          "manageSessionEmails" => %{
            "enabled" => false
          },
          "manageSessionParticipants" => %{
            "enabled" => false
          }, 
          "inviteSessionObservers" => %{
            "enabled" => false
          }
        },
        "features" => %{
          "survay" => %{
            "enabled" => true
          },
          "unidentifiedParticipants" => %{
            "enabled" => true
          },
          "whiteboard" => %{
            "enabled" => true,
            "canWrite" => ["facilitator"]
          },
          "pinboard" => %{
            "enabled" => false
          },
          "sendSms" => %{
            "enabled" => false
          },
          "closeSession" => %{
            "enabled" => false
          },
          "dateAndTime" => %{
            "enabled" => false,
            "message" => "Yay! One less thing you have to do. Start & End Date isn't required with Social Forum"
          },
          "anonymous" => %{
            "enabled" => false
          },
          "colorScheme" => %{
            "type" => "forum"
          },
          "socialMediaGraphics"=> {
            "enabled"=> true,
            "message"=> "We're currently building an exciting tool for you to customize your social media posts and help your Chat Session stand out. We'll keep you updated on progress ☺"
          }
        },
        "validations" => %{
          "participant" => %{
            "max" => 0
          },
          "observer" => %{
            "max" => 0
          }
        }
      }

    }

    {:ok, properties: properties}
  end
end