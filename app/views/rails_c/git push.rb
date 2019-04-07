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