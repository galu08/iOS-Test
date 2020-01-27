# iOS-Test
Reddit client 

Here you can find the code for the exercise https://github.com/deviget/iOS-Test/blob/master/_TestExample.png

Requirements:

✅ Pull to refresh
✅ Pagination
✅ Saving pictures in the gallery
✅ App state-preservation/restoration: Example on ItemDetailViewController, more information on how to tests this can be found here https://developer.apple.com/documentation/uikit/uiviewcontroller/restoring_your_app_s_state
✅ Read/Unread post indicator
✅ Dismiss post button
✅ Dismiss all posts
✅ Support split layout (master/detail project)
✅ URLSession
✅ Support all Device Orientation
✅ Support all Devices screen (iPhone/iPad)
✅ Use Storyboards


Cell:
✅ Title full length
✅ Author
✅ Entry date "X hours ago" (Also localized for plurals)
✅ Thumbnail
✅ Numbers of comments
✅ unread status


Notes:
I used Xcode 11.3
Because of the time, I didn't create a specific architecture for this project. Instead, I used a ViewModel to separate the business logic.
Also I created an Action and repository to abstract the Read/Unread posts logic. All of this information is stored in UserDefaults.


Documentation and tools: 
https://www.reddit.com/dev/api#listings
https://jsonformatter.curiousconcept.com


Some examples:

Saving photo
![](https://github.com/galu08/iOS-Test/examples/example_iphone.png)

Read/Unread status
![](https://github.com/galu08/iOS-Test/examples/example_iphone2.png)
