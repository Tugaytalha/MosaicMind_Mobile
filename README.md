# Setup Guide

## IMPORTANT NOTE

In its current state, the mobile app needs to be run using `flutter run` or from VSCode GUI. This is because the IP addresses of the Raspberry Pi devices are volatile.
So before running the program, make sure to enter the IP addresses correctly in the `selection.dart` file in the Strings named ipA1, ipA2 and so on. You will of course need to have the Flutter SDK installed on your computer to run it via `flutter run`, and the Flutter extension if you want to run the program on VSCode. To install these, follow the instructions on [this website](https://docs.flutter.dev/get-started/install/linux/android?tab=download).

To be able to receive/send data from/to the Raspberry Pi's, they need to be connected to the same network.

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
