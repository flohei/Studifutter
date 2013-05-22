#!/bin/bash
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ./Studifutter/Studifutter-Info.plist)
echo $buildNumber
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" ./Studifutter/Studifutter-Info.plist
echo $buildNumber