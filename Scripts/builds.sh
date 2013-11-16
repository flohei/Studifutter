#!/bin/bash
buildNumber=$(curl -s http://lab.flohei.de/builds/builds.php?app=$1)
echo $buildNumber
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" ./Studifutter/Studifutter-Info.plist
echo $buildNumber