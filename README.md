# FlamSpark Android App Assignment

This App was made from scratch according to the design and fucntional specifications described - [Here](https://www.notion.so/Android-iOS-native-28509afe951040c386d5bbf6142ee254)

This App has been developed from scratch using the Flutter Framework.

## NOTE:

Due to the `deleteMailsByIdsApi` & `deleteMailByIdApi` NOT working on the server side, the delete features are currently unable to work. The features have been implemented in the app.

## Getting Started

To install this app directly on your phone:

- Open the `/Release-APK` folder, where you can find different APK Builds for all the different types of Android devices.
- Install `app.apk` for universal Compatibility.

To build this project on your local Machine:

- Make sure you have Flutter Installed on your device
- CD into this repository
- run `flutter pub get`
- run `flutter build apk --split-per-abi`
- run `flutter install` to install the app on an Android Device that is connected to your desktop. You might have to enable ADB
