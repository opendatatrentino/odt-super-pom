if [%1]==[] goto usage
@ECHO
@ECHO
@ECHO ****  GOING TO RELEASE WITH TAG %1
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
@ECHO Pushing tag %1 to repository...
git push origin %1
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
@ECHO Usage: %0 ^<mytag-x.y.z^>
EXIT /B 1