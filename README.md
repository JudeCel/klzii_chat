# KlziiChat

# Dependencies
  * Elixir v1.3.2
  * Node.js >= 5.11.x
  * NPM 3.8.x
  * [FS Listener](https://github.com/synrc/fs#backends)
  * ```xvfb```
  * ```wkhtmltopdf```

# Setup project
  ### This project depends to nodejs project [Kliiko](https://github.com/DiatomEnterprises/Kliiko)

### Before run server need setup Kliiko project and run seeds.

  1) Go to project folder

  2) copy ```config/dev.exs.example ``` to ``` config/dev.exs``` and changes with necessary database credentials.

  3) Install dependencies with `mix deps.get`

  4) Install Node.js dependencies with `npm install`

  5) Start Phoenix endpoint with `mix phoenix.server`

# Development
Development URL ``` http://localhost:3000/?token_dev=facilitator```

Available ``` token_dev ```

Faciitator users
 * facilitator

Participents users
 * participantone
 * participanttwo
 * participantthree
 * participantfour
 * participantfive
 * participantsix
 * participantseven
 * participanteight

Observers users
 * observerone
