#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile # Even in API mode, sometimes needed for Admin panels
bundle exec rails db:migrate