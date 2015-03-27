@echo off

if [%1]==[] goto usage
@echo This should not execute


@ECHO
@ECHO
@ECHO Preparing release...
@ECHO
mvn -DpushChanges=false release:clean release:prepare
@ECHO
@ECHO
@ECHO
@ECHO Pushing to master...
@ECHO
git push origin master
@ECHO
@ECHO
@ECHO Pushing tag $1 to repository...
git push origin $1
@ECHO
@ECHO
@ECHO Performing release...
@ECHO
mvn release:perform
@ECHO
@ECHO
@ECHO Done.
GOTO :eof
:usage
@ECHO Usage: %0 ^<artifactId-x.y.z^>
exit /B 1