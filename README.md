# Rhythm iOS Project (Swift based)
(Partial credit to my amazing teammates:  Coco Li, Ramses Sanchez-Hernandez)
## Introduction
Do you like being organized? Do you want to be better at managing your time? Do you love listening to music? Have you ever tried just to change the playlist but ended up surfing the internet instead of doing your work?

Try Rhythm! Rhythm will give you an awesome experience to be productive and enjoy music at the same time. Simply choose your list of music while creating each task. Rhythm will play and change your playlist FOR YOU when you start a new activity, and all you need to do is focusing on your schedule!

## User Manual with Screenshots
#### Welcome page
If you have an account already, you can sign in directly
If you have already logged in on this device, you will be kept logging in unless you choose to log out
If you don’t have an account yet, you can sign up
Once you are logged in or signed up, you will be directed to the home page

#### Home page
First item on the tab bar
If you have added activity through our app, your schedule table should be loaded
You can always pull down to refresh your time table (past activities will be deleted)
Swipe each activity to the left, you will have the option to delete the activity
Swipe each activity to the right, you will have the option to edit the activity
If you click directly on the activity
Timer: shows how much time there is left till the end of this activity
Music: you can play or pause music

#### Create activity page
Second item on the tab bar
You can choose to create a completely new activity or add from a saved template
You will be taken to a detailed page by a segue based on your choice above
If you choose to create a new activity
You are required to give the activity a name
You can give a description of the activity and assign it a color tag, but these are optional
You need to pick a start time for your activity, which cannot be a time in the past, and cannot be the same time as another existing activity
You need to pick an end time for your activity, which cannot be a time earlier than the start time
You should pick a piece of music from our list provided. You can listen to the music before you make your choice
You can choose whether you want to add this activity to the saved list. By default, it will be added
You can click on “back” if you don’t wish to add this activity
Or you can click on “Add to my Schedule” and your activity will be successfully added
Once you add the activity, a notification is set up and will remind you to come back to our app when your activity starts.


If you choose to add from saved list
You can search with the name of an activity in the search bar
Once you found the item, click on it and the text in search bar should be updated
If this is the activity you want to choose, then click “✔️”. It won’t be finally selected if you don’t click this button
The color tag (if any) will be displayed as well
The time of the activity when created will be displayed and you can change that
An item created from the save list will not be saved again to the list
All other aspects are the same with “Create a new activity”

#### Display saved list page
Third item on the tab bar
This page displays the name and description of all the items in your saved list
It will be automatically loaded when you log in
If you want to delete an activity from the list, long press the cell and you can choose to delete this activity

#### User page
Fourth item on the tab bar
This page displays your user informations: profile picture, first name, last name, and email
You can edit your first name, last name, and email
You are given the option to log out of your current account





## Technical documentation.
   ### a). A list of all CocoaPods you used and any APIs
CocoaPods Used
Firebase/Core
Firebase/Database
Firebase/Storage
Firebase/Analytics
Firebase/Auth
Firebase/Firestore
FirebaseFirestoreSwift
   ### b). A list of other outside elements and their sources - code, graphics, etc.
Graphic
Icons made by <a href="https://www.flaticon.com/authors/vitaly-gorbachev" title="Vitaly Gorbachev">Vitaly Gorbachev</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
Icons made by <a href="https://www.flaticon.com/authors/dinosoftlabs" title="DinosoftLabs">DinosoftLabs</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
https://icons8.com
https://www.flaticon.com/search?word=edit
<a href="http://www.freepik.com">Designed by pikisuperstar / Freepik</a> "Designed by pikisuperstar / Freepik"
<a href="http://www.freepik.com">Designed by pikisuperstar / Freepik</a>
"Designed by pikisuperstar / Freepik"

   ### Code/Tutorials Used
Playlist reference to firebase: https://youtu.be/g0gmAUzeKBM
Firebase media storage : https://youtu.be/MyeqhFGnJ_0
How to build countdown function in swift : https://youtu.be/iNEjh6zDUsg
How to make animation control imageview rotation: https://stackoverflow.com/questions/31478630/animate-rotation-uiimageview-in-swift
Authentication: https://www.youtube.com/watch?v=1HN7usMROt8&t=4551s
Add data and objects to firebase https://firebase.google.com/docs/firestore/manage-data/add-data
Inline Date picker: https://github.com/rajtharan-g/InlineDatePicker
Handling long press gesture: https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_long-press_gestures
Long press with collection view cell: https://stackoverflow.com/questions/29241691/how-do-i-use-uilongpressgesturerecognizer-with-a-uicollectionviewcell-in-swift
Local notification: https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app, https://learnappmaking.com/local-notifications-scheduling-swift/
Pull and update table view: https://stackoverflow.com/a/43525551

