# PicPoof
**Group #2**:
Aleksandar Bursac, Anya Popova

## Submission
We accomplished many of the core functionalities proposed for our MVP. As per the requirements: we used core data to track the completed months and reflect them the UI, and we used location services for geocoding and formatting photo locations. We added many desirable functionalities such as different gestures for the SwipingView: the tap gesture which is instant, and the drag gesture which has a smooth, user-friendly animation and reveals important and condensed information about the photos on hold. We've made a performant application capable of dealing with a great amount of photos of all sizes, and tested on several devices to ensure a consistent user experience and error handling.

![PicPoof main menu](https://github.com/aleksbrsc/PicPoof/blob/main/pp_mainmenu.png?raw=true)
![PicPoof swipe hold 1](https://github.com/aleksbrsc/PicPoof/blob/main/pp_swipehold1.png?raw=true)
![PicPoof swipe hold 2](https://github.com/aleksbrsc/PicPoof/blob/main/pp_swipehold2.png?raw=true)
![PicPoof confirmation view](https://github.com/aleksbrsc/PicPoof/blob/main/pp_confview.png?raw=true)

## Proposal
### Project Overview
A few paragraphs describing the purpose of the application and development environment:

The purpose of our application, PicPoof, is to help users quickly delete photos off their phone or move them to favourites or albums without having to manually go through their camera roll—an extensive process that is not so quantifiable, entertaining, or satisfying. Building on top of the main idea from one of the best photo cleaning apps—Swipewipe—we wish to add even more gestures for deleting images (swiping, tapping, and possibly even speaking). This is because people who’ve never used Tinder might not find the swiping gesture as intuitive, accidentally deleting/keeping photos they didn’t intend to (Swipewipe lacks feedback for when you’re deleting an image). We also intend to facilitate the organisation process by enabling users to favourite photos or move them to albums without having to leave the app.

We intend to compete with the top photo storage cleaner applications in the App Store and their main shortcomings: daily user limits or hidden costs that are heavily inconveniencing hundreds of thousands of users. Moreover, multiple users choose to pay monthly for cloud services like iCloud, just to save unorganised, bloated image galleries. We think the current apps in the market offering a solution against this are no better themselves. By constantly locking useful features behind paywalls, the most popular apps don’t offer a fully free solution for camera roll management. As for the less popular apps, we feel as though many of them lack in the department of user experience and user interface design. PicPoof aims to cover both of these weak points: being a fully free experience with a clean, user-friendly design.

PicPoof also has multiple avenues for expansion. After completing our MVP, we are planning to add ease-of-life features like customisable share messages, adding pictures to a list (for printing, sharing in bulk), progress visualisation, and possibly even collaborative cleaning.
This project will be developed with SwiftUI on Xcode, putting Apple’s PhotoKit to use for smart photo library access. If we require data persistence, we will go with CoreData to locally cache information on the user’s device, or Firebase for any cloud features. In the development process, we may consider Appetize to simulate the iOS app in a web browser to thoroughly debug our app and conduct surveys for user experience.


### User Interface Wireframes
Create a wireframe in Figma for each page of the app. The wireframe should be filled with fake data, and annotations for how it will be used. Paste images in the proposal to show the workflow.

Describe the purpose of each screen in terms of inputs, outputs and user interaction:

Fig 1: loading screen
Fig 2: The main menu:
Several options for how to browse your camera roll (flashbacks, recents, random, or by time modes like weekly, monthly, yearly) 
Navbar with mock Premium icon (to prompt for donations to get access to other features like colour themes and stuff down the line. Potentially omitted for now) and menu for other Views.
Fig 3: main menu with storage popup 
Fig 4. Fig 5.
Fig 4: Light mode Deletion View
Fig 5: Dark mode Deletion View
Fig 4 & 5: Once a user has selected a specific mode in the main menu, they will go to the Deletion View that has loaded in all the images for that mode. In the Deletion View, there is a navbar showing the date of the photo being taken on the left, and the index of the current photo out of all the remaining photos with an undo button on the right. Delete and Keep options that users can press as well as a number to identify them. Users will likely long hold later to open up photo settings if they wish to favourite or move to an album.
Fig 6: Deletion animation (connotated by the gesture of swiping to the left, will animate even if swipe gesture is not being used and tap is being used instead)
Fig 7: Keep animation with the same idea as the previous figure.
Fig 8: Confirmation View (light mode). Here the user can select which images that were added to the deletion stack to NOT delete (to let users double-check that they didn’t accidentally delete something), while doing a long hold to view the image in a greater resolution (zoom in). Once a user presses the button, there will likely be a native iOS confirmation to ensure the user gives permission to the app to delete X total photos.
Fig 9: Older prototype of main menu for dark mode and different time frame organisation (might save it and consider letting the user choose the way the main menu is displayed)

### Work Assignments
For each member of the team, define the overall tasks the team member is responsible for, divided by tier:
- Presentation (screen)
- Business logic (classes other than UI or Data)
- Data

(Work assignments must be all encompassing with each team member having to implement the UI, business logic, and data programming for the features they are responsible for)

#### Anya:

Presentation: 
- Loading screen and spinner
- Main Menu View (including the navbar; "Flashbacks," "Recents," "Random" sections; and dates grid)
- Navbar (including the menu options)
- Storage indicator

Business Logic:
- Fetching photos based on criteria (date, recents, random)
- Format of dates (for the dates grid)

Data:
- Photo entity model creation (Core Data or Realm). 
- Calculating and providing storage information

#### Aleks: 

Presentation: 
- Deletion view (including gesture implementations)
- Any UI related to photo actions (favourite, add to album, etc.)

Business Logic:
- Image management: like image loading and caching; 
- Handling swipe actions (delete, keep)
- Actions taken for photos (delete, favourite, add to album)

Data: 
- Handling data persistence (statistics or progress for completed sections)
- All other interactions with database (fetching, saving, deleting)
