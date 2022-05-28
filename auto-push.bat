@echo off
echo this is a auto-push bat~
set /p var=please enter the feature name which want push ~

echo %var%

git checkout master

git pull origin master

git checkout %var%

git merge master

git push --set-upstream origin %var%

git checkout develop 

git merge %var%

git push --set-upstream origin develop

pause