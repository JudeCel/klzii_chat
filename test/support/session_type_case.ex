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
            "enabled" => true,
            "hideNext"=> true
          },
          "manageSessionParticipants" => %{
            "enabled" => true,
            "sendGroupSms" => true
          }, 
          "inviteSessionObservers" => %{
            "enabled" => true,
            "sendGroupSms" => false
          },
          "message" => "It's even easier to build Social Forum, so you don't need steps 3 to 5."
        },
        "features" => %{
          "survay" => %{
            "enabled" => false
          },
          "ghostParticipants" => %{
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
          "closeSessionButton" => %{
            "enabled" => true
          },
          "closeSessionToggle" => %{
            "enabled" => false
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
          "socialMediaGraphics" => %{
            "enabled" => false
          },
          "publish" => %{
            "enabled" => false
          },
          "inviteAgainTopic" => %{
            "enabled" => false
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
          "ghostParticipants" => %{
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
          "closeSessionButton" => %{
            "enabled" => true
          },
          "closeSessionToggle" => %{
            "enabled" => false
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
          "socialMediaGraphics" => %{
            "enabled" => false
          },
          "publish" => %{
            "enabled" => false
          },
          "inviteAgainTopic" => %{
            "enabled" => false
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
          "ghostParticipants" => %{
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
          "closeSessionButton" => %{
            "enabled" => false
          },
          "closeSessionToggle" => %{
            "enabled" => true
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
          "socialMediaGraphics" => %{
            "enabled"=> true,
            "message"=> "We're currently building an exciting tool for you to customize your social media posts and help your Chat Session stand out. We'll keep you updated on progress ☺"
          },
          "publish" => %{
            "enabled" => true
          },
          "inviteAgainTopic" => %{
            "enabled" => true
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
