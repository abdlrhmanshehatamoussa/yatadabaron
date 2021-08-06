@echo off
set /p version_code=Version Code: 
set /p version_name=Version Name: 

echo Building ...

cd android
set f=version.properties
echo flutter.versionName=%version_name%>%f%
echo flutter.versionCode=%version_code%>>%f%
call gradlew.bat assembleRelease

set /p d=Do you want to deploy to production track ? [y/n]: 
if "%d%" == "y" ( 
    echo Deploying ...
    cd fastlane
    bundle exec fastlane android gp_production
    cd ../
)
cd ../