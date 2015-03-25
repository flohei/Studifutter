#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

target.delay(3)
captureLocalizedScreenshot("0-RestaurantList")
target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.63, y:0.54}});
captureLocalizedScreenshot("1-DayList")
target.frontMostApp().navigationBar().rightButton().tap();
target.frontMostApp().navigationBar().buttons()[2].tap();
captureLocalizedScreenshot("2-Restaurant")
target.frontMostApp().navigationBar().tapWithOptions({tapOffset:{x:0.20, y:0.10}});
target.frontMostApp().mainWindow().tableViews()[0].dragInsideWithOptions({startOffset:{x:0.65, y:0.75}, endOffset:{x:0.65, y:0.53}});
target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.55, y:0.61}});
captureLocalizedScreenshot("3-Menu")
