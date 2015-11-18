#Introduction
1. The assignment consumes the JSON feed from URL and displays the feeds in the table.
2. The assignment will work on portrait and landscape mode.Tested in iOS9.1. Please verify the output screenshots in the folder /OutputScreenSnaps
3. The app will work on iPhone(4s,5,5s,6,6+,6s,6s+)

# Known Issues:

1. Few of the image link reference from JSON array is invalid.
2. Image URL refers to (http://). So added ATS in plist to avoid issues for downloading the image.

# Review Comments:

The following review comments are completed :

* The app look and feel is good, do not use white back ground color for the table view section header, while scrolling white rectangle area shown. The section title and the refresh button shall be top aligned , the refresh button touches/overlaps with battery charge icon. -  Fixed
* Do not use stringWithContentsOfURL which is synchronous call and blocking the UI update(show blank screen), use asynchronous loading of back end data and handle the errors(no network, timeout, etc.,) - Fixed
* Use Model to store the data instead of plain dictionary, arrange the project file in the following folders(Model, ViewControllers, NetworkManager and Common, etc.,), use contacts.h to declare the contents to be used in the application - Fixed
* Remove Main.storyboard, every view should be created dynamically by coding and should not use XIB or Story board - Fixed
* Remove the images and add the images into Assets.xcassets - Fixed
* More comments can be added between the codes to make the code readable - Fixed
* When change the orientation to landscape, the status bar becomes blank in iPhone 6 simulator, please check - Fixed

#Output :

Portrait :

![ScreenShot](https://github.com/smanojarun87/AssignmentManoj/blob/master/OutputScreenSnaps/6Portrait.png
)

Landscape :

![ScreenShot](https://github.com/smanojarun87/AssignmentManoj/blob/master/OutputScreenSnaps/6Landscape.png)

#BuildOutput :

![ScreenShot](https://github.com/smanojarun87/AssignmentManoj/blob/master/OutputScreenSnaps/BuildWithoutError.png)
