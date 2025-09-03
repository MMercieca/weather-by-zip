# README

## Goal

* Retrieve forecast for a given address
  * So I ddn't have time to geocode the addresses.  Instead I have a table of zip codes.  I'm not going to hide this but it's also not what the brief ased for.  Since we are caching the results by ZIP I hope this is OK.
* Cache results for 30 minutes by ZIP code
  * The brief says to only pull data once every 30 minutes.  But rather than cache it, we can save all weather retrieved from the source and keep it for a history. It would be nice to do something with that history but we'll see if there's time.
  * UPDATE: I don't think we're going to get to a history here.  But we can use the `updated_at` timestamp to know if we need to repoll.


* Implications:
  * Weather APIs seem to use lat/long and not an address.  So we'll need some geocoding here or we'll need to store a lookup table.  A lookup table is less likely to break, but I don't know if one exists.
    * It exists and I'm running out of time - https://simplemaps.com/data/us-zips. This is what we'll use
  * Retrieving a forecast will definately require talking to an API.  So we'll need to have tests around communication disruptions, rate limits, etc.  It'd be nice to implement multiple services, so we'll stub that out at least.
    * I didn't stub out multiple services, but you can see where my thinking was with how the `Forecast` model works.
  * Let's try to be good and internationalize this from the start.  We don't know what languages we'll want to support.

### Development plan

* `rails new` the app --- done
* Fill out the README with the plan --- done
* Find a weather API -- [open-metro.com](https://open-meteo.com/en/docs?location_mode=csv_coordinates&current=temperature_2m,relative_humidity_2m,precipitation,apparent_temperature)
* Design the weather database model --- done
* Retrieve weather data from API --- done
  * This is where we'll need unit testing -- sort of done
  * Are we going to translate from ZIP codes first or get it working with lat/long first?
    * We'll seed some zip codes and do translation in the next step -- ended up seeding all the zip codes
* Translate addresses to zip codes -- Since I only have zip code lookup, I'll not hide that.
* Make UI prettier / Add some personality -- I did not get this far.

### How did it go?

[Demo](demo.mp4)

Doing everything from scratch took a bit longer than expected.  I didn't have time to make the UI very pretty. I wanted to use Bootstrap and add some basic styles but it's more honest to leave it this way.

I did get some good unit tests for the `HttpService`.  Fortunately there's not too much logic in the `Forecast` model that needs testing. I figred the main things I needed to test were:

* That communication errors with any API show a helpful message
* That ZIP codes are found and valid

I use the custom `CommunicationError` for all errors in the `HttpService`.  That meant I could rescue from it with a helpful error page.

I tried to internationalize everything. I think I got all of the strings by starting at the beginning.  Internationalization is one of those things that's easily forgotten--- kind of like unit tests--- so I wanted to include that.

I wish I had time to make the UI better.  I thought my time management was pretty good so I'm a little surprised by this.  But I also included the time it took to write the README with my plan and with my closing thoughts in the three hour window.  Maybe documentation takes longer than expected. I don't know what the other applicatants will do and it was open to interpertation.  I hope I'm setting the correct expectations.

On the plus side: everything is standard Rails and I think pretty well segmented as to what goes where.  The critical business requiremnts are speced out.  The error pages don't have specs of their own, but as they're triggered in standard Rails ways I don't think I need to test the framework.

## Dependencies

* Ruby 3.1.0 (also in .tool-versionss)
* Rails 7.2.2
  * The job description calls for Rails 6, but that's past end of life.  So we'll use Rails 7 and plan to upgrade to 8 in the 3 hour time limit.
* Postgres
  * On Mac: `brew install postgresql`

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
  You must seed the database to get the ZIP codes.  It won't work otherwise.
5. Start application
  `rails s`
6. Visit https://localhost:3000 to see the app working.

## Deployment

We'll skip that for the demo.  If you want to see a deployed app of mine, you can go to [my minicast repo](https://github.com/MMercieca/minifeed) which is deployed at [https://mincast.app](https://minicast.app).