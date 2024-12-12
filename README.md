# SnapWalls Flutter Project

SnapWalls is a Flutter application designed to provide users with a stunning collection of wallpapers. Users can explore, download, and favorite wallpapers seamlessly while enjoying a user-friendly experience.

---

## Features

- **Beautiful Wallpapers**: Browse through an exquisite collection of wallpapers fetched from the Pexels API.
- **Download Wallpapers**: Users can download wallpapers directly to their devices.
- **Favorite Wallpapers**: Mark wallpapers as favorites for quick access.
- **Smooth Performance**: Leveraging isolates for heavy tasks like downloading to keep the UI responsive.
- **Ad Integration**: Monetization using Google Ads.
- **Pagination**: Load wallpapers dynamically with seamless pagination (future implementation).
- **Environment Configuration**: Separate configurations for different environments (future implementation).

---

## Tech Stack

- **Flutter**: Cross-platform framework for developing beautiful mobile applications.
- **Dart**: The programming language powering the Flutter framework.
- **Riverpod**: State management solution for scalable and maintainable architecture.
- **Dio**: Robust HTTP client for API calls and network operations.
- **Pexels API**: Source for fetching high-quality wallpapers.
- **Platform Channels**: Bridge for communication between Flutter and native code for downloading wallpapers in a foreground service.
- **Isolates**: Used to handle heavy tasks like downloading without blocking the main UI thread.
- **Google Ads**: Integrated for in-app advertising.
- **Shorebird**: Planned integration for seamless code push updates.

---

## Platform-Specific Implementations

- **Android**: 
  - Foreground service implemented using native Kotlin code via platform channels for downloading wallpapers.
  - Proper handling of permissions and notifications for background tasks.

- **iOS** (Planned): 
  - Native download service will be implemented using platform channels for iOS compatibility.

---

## Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/snap-wall.git
   cd snap-wall
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure API Key**:
   - Obtain an API key from [Pexels API](https://www.pexels.com/api/).
   - Add the API key to your project by creating an `.env` file (planned feature).

4. **Run the App**:
   ```bash
   flutter run
   ```

---

## Future Enhancements

- **Code Push**: Integrate Shorebird for real-time updates.
- **iOS Foreground Service**: Implement native downloading service for iOS.
- **Enhanced Pagination**: Optimize for large data sets.
- **Environment Variables**: Implement `.env` for API keys and configurations.

---

## Contributing

Contributions are welcome! If you'd like to contribute, please fork the repository and create a pull request with your proposed changes.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

Feel free to let me know if you'd like to refine or add anything!
