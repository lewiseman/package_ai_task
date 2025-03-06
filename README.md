# Interview App - Package Ai

## Setting Up the Ticketmaster API Key

To load the Ticketmaster API key, use one of the following methods:

### Method 1: Using Dart Define (Recommended)

Run the following command in your terminal:

```sh
flutter run --release --dart-define=TICKET_MASTER_KEY=your_api_key_here
```

Replace `your_api_key_here` with your actual Ticketmaster API key.

### Method 2: Using an Environment File

1. Create an `.env` file in the root directory and add the following line:
   ```
   TICKET_MASTER_KEY=your_api_key_here
   ```
2. Run the project using VS Code's launch configuration.

Check the `env.example` file for an example of how to structure the `.env` file.

#### Example `env.json` file:

```json
{
    "TICKET_MASTER_KEY": "your_api_key_here"
}
```

## Project Environment

- **Flutter Version:** 3.29.0
- **Android Studio Version:**
  - Android Studio Ladybug Feature Drop | 2024.2.2 Patch 1
  - Build #AI-242.23726.103.2422.13016713, built on February 5, 2025
  - Runtime: OpenJDK 21.0.5+-12932927-b750.29 (64-bit)
  - Toolkit: `sun.lwawt.macosx.LWCToolkit`
  - OS: macOS 15.3.1

## Prebuilt APK

The prebuilt APK is available in the `apk` folder:

```
/apk/app-release.apk
```

---

For any issues or setup questions, feel free to reach out!

