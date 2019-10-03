#!/bin/bash
heroku maintenance:on --app kidcare-prod
dropdb prod-bcup1 -U MustakhimRehan
heroku pg:pull DATABASE_URL prod-bcup1 --app kidcare-prod

git push prod-heroku production_n:master
#heroku run rake db:migrate --app kidcare-prod

heroku restart --app kidcare-prod
heroku maintenance:off --app kidcare-prod
