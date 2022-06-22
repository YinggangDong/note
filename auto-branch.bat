@echo off
set /p var=please enter the branch name ~
echo [1] create new branch: %var%

echo [2] checkout master
git checkout master

echo [3] pull origin master
git pull origin master

echo [4] create new branch %var%
git branch %var%

echo [5] checkout %var%
git checkout %var%

echo [6] push %var% to origin
git push --set-upstream origin %var%

echo [7] checkout master
git checkout master

echo [8] all end

pause
