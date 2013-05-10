#!/bin/bash
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ./Countdown/Deadlines-Info.plist)
echo $buildNumber
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" ./Countdown/Deadlines-Info.plist
echo $buildNumber