# README

A small demo of a recipe finder app. 

## Project Structure

- Rails application at root (/) serving an API to be consumed by a client
- NextJS web app under (/web)

## Pre-requisites
  
- Postgres 14
- Ruby 3.3.5
- Node 20
- Typescript 5

## Running locally

The best way to run the app locally is via the docker-compose script:
                                                                     
```bash
    docker compose up
    
```

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Improvements

- update recipe - ingredients relation to be a HABTM type relation and enforce uniqueness on the ingredients table
