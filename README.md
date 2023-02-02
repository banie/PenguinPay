# PenguinPay
Notes:
- Please set the Team value in the Signing & Capabilities to your own in order to deploy to device
- Set to portrait only to avoid UI mishaps in landscape
- Use primary and secondary default colors to make light and dark mode easier
- I'm only checking if the phone number is correct before doing the send. I figured maybe phone number is the only thing that's really needed
- If the api call fails then we don’t show any money that the recipient will receive and the send button is disabled. Could be better
- Did not have enough time to add more tests, especially the integration ones

Wanted improvements if given time:
- Putting ProgressView on sending state
- Was thinking of putting a refresh button for the rates or make pull to refresh mechanism
-Better phone number validation, such as using PhoneNumberKit
-Find and set an app icon 🙂

Some features not having:
- No saving anything to persistence in device
- No logging

Some known bugs:
- Cannot put spacing in the HStack of the selected item in picker. The flag image and the name text is right beside each other 
- Should have better UI feedback in letting user know if we don't have internet connection or the network api request failed
- I haven't checked this, but I'm pretty sure we can paste a non conforming text into the text fields, especially the phone number one where it should just be all numbers. I would guard against this if given more time

