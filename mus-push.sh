#!/bin/bash
git push prod-heroku production_n:master
heroku restart --app kidcare-prod