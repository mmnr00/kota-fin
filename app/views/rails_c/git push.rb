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
dropdb kota-fin-dev -U MustakhimRehan
heroku pg:pull DATABASE_URL kota-fin-dev --app kota-prod

heroku pg:reset --app kota-staging
heroku pg:push kota-fin-dev DATABASE_URL  --app kota-staging

git push prod-heroku production_n:master
#heroku run rake db:migrate --app kidcare-prod

heroku restart --app kidcare-prod
heroku maintenance:off --app kidcare-prod

disc = (24.0/28.0).to_f

Taska.find([80,81]).each do |t|
t.discount = Taska.find(56).discount
t.save
end

Payinfo.all.each do |pf|
pf.fxddc = 0.00
pf.save
end

Payslip.all.each do |pf|
pf.fxddc = 0.00
pf.save
end

#MUS REHAN git try

