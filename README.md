# voice_memo_app


## How to run the app locally
Here is how to run the app from the terminal: 


```bash

flutter clean

flutter pub get

cd ios
pod repo update
pod install --repo-update
cd ..

flutter run --verbose


```

## How to push the app to testflight

```bash
flutter build ipa


```

Then Drag and drop the build/ios/ipa/*.ipa app bundle into the Transporter app on your mac.




## Notes for Developer

- Setting Icon to the right on home screen
- Name change if it includes number (prolific ID)
- Font type of button change

## Colors
- Primary: Color(0xFF2A454E);
- Accent: Color(0xFFffd85f);
- #ffd95f


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
