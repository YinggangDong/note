@echo off
echo this is a auto-push bat~
set /p var=please enter the feature name which want push ~

echo %var%

git cehckout %var%

git merge origin/master

git push --set-upstream origin %var%

git 
