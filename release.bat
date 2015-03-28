@ECHO off
@ECHO.
if [%1]==[] goto usage
if [%1]==[-frb] goto :forced-rollback
if [%1]==[-mrb] goto :maven-rollback 
SET firstArg=%1
if [%firstArg:~,1%]==[-] goto :wrong-tag
if NOT [%2]==[] goto usage
@ECHO.	
@ECHO.
@ECHO ****  GOING TO RELEASE WITH TAG %1
@ECHO.
@ECHO.
@ECHO Preparing release...
@ECHO.
@ECHO on
CALL mvn -DpushChanges=false release:clean release:prepare
@ECHO off
@ECHO.
@ECHO.
@ECHO.
@ECHO Pushing to master...
@ECHO.
@ECHO on
git push origin master
@ECHO off
@ECHO.
@ECHO.
@ECHO Pushing tag %1 to repository...
@ECHO on
git push origin %1
@ECHO off
@ECHO.
@ECHO.
@ECHO Performing release...
@ECHO.
@echo on
CALL mvn release:perform
@ECHO off
@ECHO.
@ECHO.
@ECHO Done.
GOTO :eof
:forced-rollback
if [%2]==[] goto usage
if NOT [%3]==[] goto usage
@ECHO.
@ECHO.
@ECHO *******  FORCING ROLLING BACK OF MESSED UP RELEASE %2....
@ECHO.
@ECHO.
@ECHO Removing local tag %2  ...
@echo on
git tag -d %2
@echo off
@ECHO Removing github tag %2  ...
@ECHO on
@ECHO.
git push origin :refs/tags/%2
@ECHO. off
@ECHO.
@ECHO Removing  pom.xml.releaseBackup ...
DEL  pom.xml.releaseBackup
@ECHO Removing release.properties
DEL release.properties
@ECHO.
@ECHO.
@ECHO Now you may need to do a 
@ECHO.
@ECHO         git reset --hard X  
@ECHO.
@ECHO Where X is the commit SHA of the commit you want to rollback to. 
@ECHO.
@ECHO ****  CAREFUL: USING GIT RESET HARD WITH WRONG COMMIT WILL MAKE YOU LOSE ALL SUBSEQUENT COMMITS!!!!! *****
@ECHO.
GOTO :eof
:maven-rollback 
if NOT [%2]==[] goto usage
@ECHO.
@ECHO.
@ECHO *******  REGULAR MAVEN ROLLABACK....
@ECHO.
@ECHO.
@ECHO on
CALL mvn release:rollback
CALL mvn release:clean
@ECHO off
@ECHO.
GOTO :eof
:usage
@ECHO Usage: 
@ECHO.
@ECHO Do complete release:                              %0 ^<mytag-x.y.z^>
@ECHO.
@ECHO Regular maven rollback:                           %0 -mrb
@ECHO.
@ECHO Forced cleaning (only if maven rollback fails):   %0 -frb ^<mytag-x.y.z^>
@ECHO.
EXIT /B 1
:wrong-tag
@ECHO Provided tag is wrong!