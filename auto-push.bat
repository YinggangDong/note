@echo off
echo this is a auto-push bat~
set /p var=please enter the feature name which want push ~

echo %var%

echo checkout master and pull from origin
git checkout master

git pull origin master

echo checkout target feature and merge master
git checkout %var%

git merge master

echo push target feature to origin
git push --set-upstream origin %var%

echo checkout develop and pull from origin
git checkout develop 

git pull origin develop

echo merge new code
git merge %var%

echo push develop
git push --set-upstream origin develop

pause