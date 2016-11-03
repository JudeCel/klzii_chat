# KlziiChat

## Dependencies
  * Node.js 6.x LTS
  * [Kliiko](https://github.com/DiatomEnterprises/Kliiko)
  * Elixir v1.3.2
  * [FS Listener](https://github.com/synrc/fs#backends)
  * ``` xvfb ```
  * [Wkhtmltopdf](http://wkhtmltopdf.org/downloads.html)

## Setup project

### Before run server need setup Kliiko project and run seeds.

1) Go to project folder

2) copy ``` config/dev.exs.example ``` to ``` config/dev.exs``` and change with necessary database credentials.

2) Run ``` mix deps.get ``` in project directory to install dependencies.

3) Run ``` npm install ``` in project directory to install packages.

## Run project

1) Run Phoenix ``` mix phoenix.server ```

2) Open browser: ``` http://localhost:3000/?token_dev=facilitator ```

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

### Report Preview URL's

``` :id ``` - is Session topic id  
``` http://localhost:3000/reporting/messages/:session_id/:session_topic_id ```
``` http://localhost:3000/reporting/messages_stars_only/:session_id/session_topic_id ```
``` http://localhost:3000/reporting/whiteboard/:session_id/:session_topic_id ```
``` http://localhost:3000/reporting/mini_survey/:session_id/:session_topic_id ```

### Tests
Run

 ``` mocha test```
or
 ``` npm test ```
