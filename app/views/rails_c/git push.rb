git add -A
git commit -m "tsk"
git push

git checkout master_n
git merge 10fbc
git push

git checkout production_n
git merge master_n
git push

git diff HEAD master_n
git diff HEAD 10fbc
git checkout 10fbc

heroku maintenance:on --app kidcare-prod
#dropdb prod-bcup -U MustakhimRehan
#heroku pg:pull DATABASE_URL prod-bcup --app kidcare-prod
git push prod-heroku production_n:master
#heroku run rake db:migrate --app kidcare-prod
heroku restart --app kidcare-prod
heroku maintenance:off --app kidcare-prod

disc = (24.0/28.0).to_f

Taska.find([55,56]).each do |t|
t.discount=disc
t.save
end

