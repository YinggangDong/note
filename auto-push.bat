@echo off
echo this is a auto-push bat~
set /p var=please enter the branch name which want push :

echo [1] the branch want push: %var%

echo [2] checkout master 
git checkout master

echo [3] pull origin master
git pull origin master

echo [4] checkout target feature
git checkout %var%

echo [5] merge master
git merge master

echo [6] push target feature to origin
git push --set-upstream origin %var%

echo [7] checkout develop 
git checkout develop 

echo [8] pull origin develop
git pull origin develop

echo [9] merge target feature
git merge %var%

echo [10] push develop to origin
git push --set-upstream origin develop

echo [11] all end
echo all end

pause