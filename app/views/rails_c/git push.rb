git add -A
git commit -m "tsk"
git push

git checkout master_n
git merge 1fbc
git push

git checkout production_n
git merge master_n
git push

git diff HEAD master_n
git diff HEAD 1fbc
git checkout 1fbc

heroku maintenance:on --app kidcare-prod
dropdb prod-bcup -U MustakhimRehan
heroku pg:pull DATABASE_URL prod-bcup --app kidcare-prod
git push prod-heroku production_n:master