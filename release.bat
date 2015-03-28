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
mvn -DpushChanges=false release:clean release:prepare
@ECHO.
@ECHO.
@ECHO.
@ECHO Pushing to master...
@ECHO.
git push origin master
@ECHO.
@ECHO.
@ECHO Pushing tag %1 to repository...
git push origin %1
@ECHO.
@ECHO.
@ECHO Performing release...
@ECHO.
mvn release:perform
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
git tag -d %2
@ECHO Removing github tag %2  ...
git push origin :refs/tags/%2
@ECHO Removing  pom.xml.releaseBackup
DEL  pom.xml.releaseBackup
@ECHO Removing release.properties
DEL release.properties
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
mvn release:rollback
@ECHO Cleaning....
mvn release:clean
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