@ECHO off
@ECHO.
SET PUBLISH_SITE=true
if [%1]==[] goto usage
if [%1]==[-frb] goto :forced-rollback
if [%1]==[-mrb] goto :maven-rollback
if [%1]==[-nosite] (
    SET PUBLISH_SITE=false
    shift
)
SET firstArg=%1
if [%firstArg:~,1%]==[-] goto :wrong-tag
if [%2]==[] goto usage
if NOT [%3]==[] goto usage
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
if %errorlevel% neq 0 exit /b %errorlevel%
@ECHO.
@ECHO.
@ECHO.
@ECHO Pushing to %2...
@ECHO.
@ECHO on
git push origin %2
@ECHO off
if %errorlevel% neq 0 exit /b %errorlevel%
@ECHO.
@ECHO.
@ECHO Pushing tag %1 to repository...
@ECHO on
git push origin %1
@ECHO off
if %errorlevel% neq 0 exit /b %errorlevel%
@ECHO.
@ECHO.
@ECHO Performing release...
@ECHO.
@echo on
CALL mvn -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true release:perform
@ECHO off
if %errorlevel% neq 0 exit /b %errorlevel%
IF %PUBLISH_SITE%==[true](
    @ECHO.
    @ECHO Generating site with Josman...
    @echo on
    CALL mvn josman:site
    @ECHO off
    if %errorlevel% neq 0 exit /b %errorlevel%
    @ECHO.
    @ECHO.
    @ECHO Sending website to Github pages... (this may take some time)
    @echo on
    @echo mvn com.github.github:site-maven-plugin:site
    EXIT 1 
    @ECHO off
    if %errorlevel% neq 0 exit /b %errorlevel%
)
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
@ECHO off
if %errorlevel% neq 0 exit /b %errorlevel%
@ECHO on
CALL mvn release:clean
@ECHO off
if %errorlevel% neq 0 exit /b %errorlevel%
@ECHO.
GOTO :eof
:usage
@ECHO Usage: 
@ECHO.
@ECHO Do complete release:                              %0 [-nosite] ^<mytag-x.y.z^> ^<branch^>
@ECHO.
@ECHO Regular maven rollback:                           %0 -mrb
@ECHO.
@ECHO Forced cleaning (only if maven rollback fails):   %0 -frb ^<mytag-x.y.z^>
@ECHO.

EXIT /B 1
:wrong-tag
@ECHO Provided tag is wrong!