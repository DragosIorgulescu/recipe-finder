# RECIPE FINDER

A small demo of a recipe finder app. Tha application has 2 modes it can run in:
- **default**: Displays a UI with a regular tag input, allowing the user to input multiple ingredients and searching recipes based on them
- **LLM mode**: Displays a UI with a text area allowing the user to type in free-form, which is then interpreted by an LLM running in the browser to generate ingredient tags for lookup
  - _this requires downloading a small 8b (~4 GB) parameter model that runs in the browser, the download is handled automatically by the client_ 

## Project Structure

- Rails application at root (/) serving an API to be consumed by a client
  - The rails app is serving a simple API containing one end point at `GET /api/v1/recipes` which accepts a `ingredients` argument consisting of a comma separated list of ingredients
  - This is built using the Grape gem
- NextJS web app under (/web)
  - Serves a very basic UI which interacts with the API and an in-browser LLM (if enabled)

## Pre-requisites
  
- Postgres 14
- Ruby 3.3.5
- Node 20
- Typescript 5

## Running locally

The best way to run the app locally is via the docker-compose script. This will set up a postgres db, as well as the API and web services
                                                                     
```bash
    docker compose up
    
    # seed the db, this may take about 10 minutes depending on the machine
    docker compose run --rm api bundle exec rails db:seed
```

**Setup the database**

```bash
   docker compose run --rm api bundle exec rails db:create db:migrate
   
   # seed the db, this may take about 10 minutes depending on the machine
    docker compose run --rm api bundle exec rails db:seed 
```

The apps should now be running on the following ports:
- Rails API: port `3000`
- NextJS client: port `3001`

### Running manually
                  
At root run:

```bash
    bundle install
    bundle exec rails db:create db:migrate
    bundle exec rails db:seed
    bundle exec rails s
```

cd into `/web` and run:

```bash
    npm install
    npm run dev
```

## Deployment

The API & web services are deployed separately to fly.io

- API: at root, run `fly deploy`
- Web: cd into `/web` and run `fly deploy`


## Potential future improvements

- recipes lookup based on ingredients
  - ingredients relation to be a HABTM type relation and enforce uniqueness on the ingredients table
  - add a counter cache on the recipes table which normalizes the associated ingredients count, making lookups less taxing on the db
- paginating the recipes list response
- UI/UX improvements
  - allowing further filtering based on additional attributes once the list of recipes is returned
  - enhanced LLM interaction by allowing it to suggest similar ingredients to the ones the user has, potentially allowing for expanded list of recipes based on which ingredients can be substituted with ones the user has available 
