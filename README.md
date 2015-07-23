# STStatusBarView
Display notices on the top of iOS device's screen in a way that is similar to the native notice bar shown during phone calls.

#Features
* Display messages in two styles (red, green). Change the background style in real time with animation.
* Works with both UINavigationController and UIViewController. The text color of status bar will change as messages are shown.
* Tap to dismiss message.

#Usages
* To show message:

    STStatusBarView *noticeView = [[STStatusBarView alloc] initWithText:@"This is a warning message."];
    [noticeView show];

* To change color:
    
  `noticeView.style = STStatusBarStyleRed;`


#Limitations
* You need to add `View controller-based status bar appearance` key to `Info.plist` and set the value to `NO` if you want `STStatusBarView` to manage the status bar text color automatically for you.
* You are *able* to show multiple `STStatusBarView` at the same time. One way of preventing this from happening is to maintain a `@property` and check if it points to something before showing a new one; set the `@property` to `nil` as soon as you have hidden it.