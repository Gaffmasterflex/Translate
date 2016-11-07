# Translate
------
####  *_Author - Dean Gaffney_*
####  *_Student Number - 20067423_*
####  *_Subject - Apple Macintosh Programming_*
####  *_Lecturer - Rob O'Connor_*
##### A simple iOS translation app written in Swift, using MyMemory Translate API (https://mymemory.translated.net/doc/spec.php).

# Features

- Forked project on Github - *__Completed__*
- Wired up outlets in ViewController.swift (now *TranslatorViewController.swift*) to the Ui Components - *__Completed__*
- Added 2 required destination languages *Gaelic* and *Turkish*, *French* and *English* are also included,implemented with UiPickerView and Dictionaries - *__Completed__*
- Keyboard dissmissable by user using the return key on the keyboard - *__Completed__*
- UIActivitdyIndicator updated using EZLoadingIndicator.swift which came from this source (https://github.com/goktugyil/EZLoadingActivity) - *__Completed__*
- The deprecated call to the web API has been updated to iOS10 using session.shared.dataTask(), with completion handlers and closures to allow the UI to be updated in the main thread while the json call is occuring in the background - *__Completed__*
- UI updated using high res photos and logo for the app, along with ubuntu font and some modifcations of the navigation bar to suit the theme of the app. Auto Constraints were set and the app works best on iPhone 6s/7, this is what it was primarily tested on. The app also features extra views to add to the UI experience- *__Completed__*
- My *_Extra Feature_* - *__Completed__*
  - This was supported by pictures changing according to destination languages being changed to relate to the language that was picked. 
  - The home screen features different pictures everytime it is loaded to make the app feel more responsive.
  - I used 2 picker wheels to allow for back and forth translations between language pairs
  - I set the default language upon loading of the translator to be the default language of the system and checked to see if my app supported the language, if so the language code was used, if not then english was used.
  - I included several seperate views for the user to navigate the system.
  - I included a basic phrases concept where the user can look at some pre-translatd phrases for the supported language types.
  - I added a UI icon for the launching of the app
  - Added a splash screen for the app at launch time
  - Added a navigation controller and designed the navigation controller bar to suit the app theme.
