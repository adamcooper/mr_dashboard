Mr. Dashboard
====

A dashboard rotator that allows several sites to be rotated every X seconds.

Setup
===

This integrates into Github authentication so you'll need to setup a test application https://github.com/account/applications

    # sets up the github application integration
    export GITHUB_KEY=#github client id
    export GITHUB_TOKEN=#github secret

    # setup your own settings
    cp config.yml.example config.yml

    # automatically reload the application
    bundle install
    bundle exec shotgun -p 5000

Then open [http://localhost:5000/](http://localhost:5000/)

TODO
=====

* Move the pages/sites to be DB backed
* Allow sites to be added / editing from the UI
* Introduce the ability to show a single shot page
* Add an API hook that allows single shot pages to be added

