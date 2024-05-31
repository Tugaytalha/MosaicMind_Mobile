# Setup Guide

## IMPORTANT NOTE

In its current state, the mobile app needs to be run using `flutter run` or from VSCode GUI. This is because the IP addresses of the Raspberry Pi devices are volatile.
So before running the program, make sure to enter the IP addresses correctly in the `selection.dart` file in the Strings named ipA1, ipA2 and so on. You will of course need to have the Flutter SDK installed on your computer to run it via `flutter run`, and the Flutter extension if you want to run the program on VSCode.

## Running the program

1. **Connect your phone:**
   - Plug your phone into your computer.
   - Ensure USB debugging is enabled on your phone.
   - Grant necessary permissions to your computer.

2. **Run the app:**
   - Choose one of the following options:
     - **Flutter run:** Open a terminal and run `flutter run`.
     - **VSCode:**
       - Open the project in VSCode.
       - Click on the "Run without debugging" button.
