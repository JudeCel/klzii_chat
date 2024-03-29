# KlziiChat

## Dependencies
  * Node.js 6.x LTS
  * Install yarn `yarn` [yarn](https://yarnpkg.com/en/docs/install)
  * Install JS dependencies `yarn install`
  * [Kliiko](https://github.com/DiatomEnterprises/Kliiko)
  * Elixir v1.4.x
  * [FS Listener](https://github.com/synrc/fs#backends)
  * ``` xvfb ```
  * [Wkhtmltopdf](http://wkhtmltopdf.org/downloads.html)
  * [ImageMagick](http://www.imagemagick.org/)

## Setup project

### Before run server need setup Kliiko project and run seeds.

1) Go to project folder

2) Install hex ```mix local.hex --force```

3) Install rebar ```mix local.rebar --force```

4) Copy ``` config/dev.exs.example ``` to ``` config/dev.exs``` and change with necessary database credentials.

5) Run ``` mix deps.get ``` in project directory to install dependencies.

6 Run ``` yarn install ``` in project directory to install packages.

## Run project

1) Run Phoenix ``` mix phoenix.server ```

2) Open browser: ``` http://localhost:3000/?token_dev=facilitator ```

Available ``` token_dev ```

Faciitator users
 * facilitator

Participents users
 * participantone
 * participanttwo
 * participantthre
 * participantfour
 * participantfive
 * participantsix
 * participantseven
 * participanteight

Observers users
 * observerone

### Report Preview URL's

``` http://localhost:3000/reporting/messages/:session_id/:session_topic_id ```
``` http://localhost:3000/reporting/messages_stars_only/:session_id/session_topic_id ```
``` http://localhost:3000/reporting/whiteboard/:session_id/:session_topic_id ```
``` http://localhost:3000/reporting/mini_survey/:session_id/:session_topic_id ```

### Tests

Extract clean Test DB ```pg_dump -U postgres -h localhost klzii_chat_test > priv/repo/structure.sql ```

Run
1) ``` mix ecto.create ```

2) ``` psql -U postgres -h localhost kliiko_test < priv/repo/structure.sql ```

3) ``` mix test```

### Docs

  ``` mix docs ```

  Open in browser docs/index.html 
