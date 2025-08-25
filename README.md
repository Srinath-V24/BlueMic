# Blue Mic Live Streaming

A Flutter application that enables real-time audio streaming from your mobile device's microphone to connected Bluetooth speakers using A2DP protocol with minimal latency.

## Features

- 🎤 **Real-time Audio Streaming**: Captures microphone input and streams directly to Bluetooth speakers without recording/playback buffering
- 🔵 **Smart Bluetooth Management**: Automatic detection of connected Bluetooth audio devices and scanning for available devices
- 📱 **Cross-platform Support**: Works on Android and iOS devices
- 🎛️ **Intuitive UI**: Clean interface with three main sections for easy control
- ⚡ **Low Latency**: Optimized for minimal audio delay using small buffer sizes and direct streaming

## App Sections

### 1. Bluetooth Connection
- Displays currently connected Bluetooth audio devices
- Shows available devices with readable names (not MAC addresses)
- Smart filtering to avoid showing already connected devices
- One-tap scanning with start/stop functionality

### 2. Live Audio Streaming
- Start/Stop real-time audio streaming with a single button
- Visual feedback for streaming status
- Direct microphone-to-speaker audio pipeline

### 3. System Status
- Real-time display of connection status
- Audio streaming status indicators
- System health monitoring

## Technical Architecture

### Core Components
- **Audio Service**: Handles real-time audio capture and streaming using flutter_sound
- **Bluetooth Service**: Manages device discovery, connection, and system device detection
- **State Management**: Provider pattern for reactive UI updates
- **Modular Design**: Clean separation of services, providers, and widgets

### Key Dependencies
- `flutter_blue_plus`: Bluetooth Low Energy and classic device management
- `flutter_sound`: High-performance audio recording and playback
- `permission_handler`: Runtime permissions for microphone and Bluetooth access
- `provider`: State management for reactive UI
- `audio_session`: Audio session management for proper Bluetooth routing

## Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Android device with Bluetooth support (API level 24+)
- iOS device (iOS 12.0+)
- Bluetooth speaker or headphones with A2DP support

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_blue_mic
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Permissions

The app requires the following permissions:
- **Microphone**: To capture audio input
- **Bluetooth**: To scan and connect to Bluetooth devices
- **Location** (Android): Required for Bluetooth scanning on Android

These permissions are automatically requested when needed.

## Usage

1. **Connect Bluetooth Device**: 
   - Pair your Bluetooth speaker/headphones with your phone through system settings
   - Open the app to see connected devices in the Bluetooth Connection section

2. **Start Streaming**:
   - Tap "Start Streaming" in the Live Audio Streaming section
   - Speak into your phone's microphone
   - Audio will be streamed in real-time to your connected Bluetooth speaker

3. **Manage Devices**:
   - Use the "Scan" button to discover new Bluetooth devices
   - Tap on available devices to connect them

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── providers/
│   └── app_state.dart                  # Central state management
├── services/
│   ├── audio_service.dart              # Real-time audio streaming
│   └── bluetooth_service.dart          # Bluetooth device management
└── widgets/
    ├── bluetooth_connection_widget.dart # Bluetooth UI component
    ├── live_audio_streaming_widget.dart # Audio streaming UI
    └── system_status_widget.dart       # Status display UI
```

## Configuration

### Android Configuration
- Minimum SDK: 24 (Android 7.0)
- Target SDK: 34
- NDK Version: 27.0.12077973
- Required permissions in AndroidManifest.xml

### iOS Configuration
- Minimum iOS Version: 12.0
- Required permissions in Info.plist
- Audio session configuration for Bluetooth routing

## Troubleshooting

### Common Issues

1. **No audio output**: Ensure Bluetooth device is properly connected and supports A2DP
2. **Permission denied**: Grant microphone and Bluetooth permissions in app settings
3. **Connection failed**: Try turning Bluetooth off/on and re-pairing the device
4. **High latency**: Check Bluetooth codec settings and device compatibility

### Debug Information
The app provides console logging for:
- Bluetooth connection events
- Audio streaming status
- Error messages and stack traces

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on physical devices
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the excellent cross-platform framework
- flutter_blue_plus contributors for Bluetooth functionality
- flutter_sound team for audio streaming capabilities
