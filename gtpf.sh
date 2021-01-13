#!/bin/bash
git checkout dev
git add -A
git commit -m "tsk"
git push

git checkout staging
git merge dev
git push

git checkout t-prod
git merge staging
git push

git diff HEAD staging
git diff HEAD dev
git checkout dev

