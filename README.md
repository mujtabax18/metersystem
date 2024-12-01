# Meter Reading and Bill Tracker App

This Flutter-based application allows users to track meter readings, calculate the difference between daily readings, and manage multiple meters. Additionally, users can view the current month's available bill from the Mepco website via an integrated WebView feature.

## Features

- **Add and Track Meter Readings:** Add new meter readings with the date of reading.
- **Set Baseline:** Set a baseline reading that can be used for calculations.
- **Delete Readings:** Delete readings associated with a specific meter.
- **View Bill via WebView:** View the current month's available bill from the Mepco website directly in the app.
- **Track Multiple Meters:** Support for multiple meters, each with a name and number.

## Installation

To install and run the app, follow these steps:

### Prerequisites

Before you begin, ensure you have the following:

1. **Android Device or Emulator**: Make sure you have an Android device or emulator available to install the APK.

### Download the APK

1. Visit the **[GitHub Releases Section](https://github.com/your-repository-url/releases)** of this project.
2. Download the **latest APK release** for your device's architecture (e.g., `arm64-v8a`, `armeabi-v7a`, etc.).
3. Transfer the APK to your Android device or install it directly on an emulator.

### Install the APK

1. On your Android device, go to the **Settings** > **Security** and enable **Install from Unknown Sources** (if not already enabled).
2. Locate the downloaded APK and tap on it to install.

### WebView Integration

The app includes a WebView that allows users to view the current month's available bill from the Mepco website directly within the app. This eliminates the need to open a browser separately.

### Usage

Once the app is installed, you can start using it by following these steps:

1. **Add Meter:**
    - Tap the **+** button to add a new meter.
    - Enter the meter name and number.

2. **Add Meter Reading:**
    - Tap the **+** button under each meter to add a reading.
    - The current date will be automatically assigned to the reading.
    - The app calculates the difference from the previous reading and from the baseline.

3. **Set Baseline:**
    - You can set any meter reading as the baseline, which will be used for comparison against future readings.

4. **View Bill:**
    - Tap on the "Bill" tab in the navigation to view the current month's available bill from Mepco.

5. **Delete Readings:**
    - Tap the trash icon next to any reading to delete it.

### Known Issues

- **WebView on iOS:** Although this app is built with Flutter, the WebView feature is primarily for Android. If you're using the app on iOS, the WebView may require additional configuration.

- **Meter Reading Validation:** Ensure that meter readings are entered as valid positive integers.

### Troubleshooting

- **WebView Not Loading:** Ensure your device has an internet connection. If the WebView isn't loading the Mepco website, verify that the website is accessible in the device's browser.

- **App Crashes on Launch:** Check for any missing dependencies or permissions, especially for accessing the internet or local storage.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

For any questions or issues, please feel free to contact the repository maintainers or raise an issue in the repository.

