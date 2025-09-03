# README

## Goal

* Retrieve forecast for a given address
* Cache results for 30 minutes by ZIP code
  * The brief says to only pull data once every 30 minutes.  But rather than cache it, we can save all weather retrieved from the source and keep it for a history. It would be nice to do something with that history but we'll see if there's time.


* Implications:
  * Weather APIs seem to use lat/long and not an address.  So we'll need some geocoding here or we'll need to store a lookup table.  A lookup table is less likely to break, but I don't know if one exists.
    * Turns out that data does exist [https://download.geonames.org/export/dump/](https://download.geonames.org/export/dump/)
  * Retrieving a forecast will definately require talking to an API.  So we'll need to have tests around communication disruptions, rate limits, etc.  It'd be nice to implement multiple services, so we'll stub that out at least.
  * Let's try to be good and internationalize this from the start.  We don't know what languages we'll want to support.

### Development plan

* `rails new` the app --- done
* Fill out the README with the plan --- done
* Find a weather API -- [open-metro.com](https://open-meteo.com/en/docs?location_mode=csv_coordinates&current=temperature_2m,relative_humidity_2m,precipitation,apparent_temperature)
* Design the weather database model --- done
* Retrieve weather data from API
  * This is where we'll need unit testing
  * Are we going to translate from ZIP codes first or get it working with lat/long first?
    * We'll seed some zip codes and do translation in the next step
* Translate addresses to zip codes
* Make UI prettier / Add some personality

## Dependencies

* Ruby 3.1.0 (also in .tool-versionss)
* Rails 7.2.2
  * The job description calls for Rails 6, but that's past end of life.  So we'll use Rails 7 and plan to upgrade to 8 in the 3 hour time limit.
* Postgres

## Setup

1. Install Ruby
   Likely Ruby is installed. I recommend using ASDF to manage Ruby versions [Install ASDF](https://asdf-vm.com/guide/getting-started.html)
2. Install Rails
  `sudo gem install rails -v 7.2.2.2`
3. Install gems
  `bundle install`
4. Setup database
```
  bundle exec rails db:create
  bundle exec raild db:migrate
  bundle exec rails db:seed
```
5. Start application
  `rails s`

## Deployment

We'll skip that for the demo.  If you want to see a deployed app of mine, you can go to [my minicast repo](https://github.com/MMercieca/minifeed) which is deployed at [https://mincast.app](https://minicast.app).