# Architecture

Forest to Farm's architecture is split into a backend API layer built in Ruby
on Rails backed by a MySQL database and a frontend application layer built in
Javascript on Backbone.

## Backend API

Forest to Farm's backend layer is a thin API layer built in Ruby on Rails.  It
is backed by a MySQL database and acts primarily to construct the relational
data from the database into an object model and then serve it to the frontend.
It also contains code that processes data from raw sources (CSV, Text files)
and imports it into the database.

It uses an Model/Controller/Service architecture.  Aside from the base layout, no
views are kept on the backend.  All views are processed on the frontend through
mustache templates.

The data models can be found in ``app/models/``.  The data is served from
controllers in ``app/controllers/api/v0/``.  The other 
controller ``app/controllers/plants_controller.rb`` serves merely to serve the 
layout and the frontend code.

Also managed on the backend is the code that parses the raw sources of our data
into the database.  This primarily comes from a .csv file stored in ``data``.
It is parsed using ``rake "db:load_data_from_csv[data/data.csv]"``.  The
task's code is stored in ``lib/tasks/db.rake``.  It makes use of 
the ``PlantCsvParsingService`` which lives in ``app/services``.

Tests for the backend are written with RSpec and live in ``spec/ruby``.

## Frontend

The frontend code lives in ``public/scripts`` and is primarily a Model/View
based architecture.  The models live in ``public/scripts/app/models`` and each
wraps a backend API endpoint.  The views live in ``public/scripts/app/views``
and handle both the parsing of the view templates (which live 
in ``public/scripts/app/templates``) and the handling of user interactions.

