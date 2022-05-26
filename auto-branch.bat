@echo off
set /p var=please enter the feature name ~
echo %var%

git checkout master

git pull

git branch %var%

git checkout %var%

git push --set-upstream origin %var%

git checkout master

pause
