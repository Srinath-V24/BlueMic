import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../providers/app_state.dart';

class BluetoothConnectionWidget extends StatelessWidget {
  
  String _getDeviceName(BluetoothDevice device) {
    // First priority: device.name (the advertised Bluetooth name)
    if (device.name.isNotEmpty && device.name != "Unknown") {
      return device.name;
    }
    
    // Second priority: platformName (platform-specific name, often more descriptive)
    if (device.platformName.isNotEmpty && device.platformName != "Unknown") {
      return device.platformName;
    }
    
    // Third priority: Check if this looks like a known device pattern
    String deviceId = device.id.toString().toLowerCase();
    
    // Check for common audio device patterns in MAC addresses
    if (deviceId.contains(':')) {
      // Apple devices often have specific OUI (first 3 octets) patterns
      if (deviceId.startsWith('04:') || deviceId.startsWith('ac:87:a3') || 
          deviceId.startsWith('28:cd:c1') || deviceId.startsWith('a4:c1:38')) {
        return 'Apple Audio Device';
      }
      
      // Sony devices
      if (deviceId.startsWith('ac:9b:0a') || deviceId.startsWith('4c:b9:9b')) {
        return 'Sony Audio Device';
      }
      
      // JBL devices
      if (deviceId.startsWith('e8:07:bf')) {
        return 'JBL Speaker';
      }
      
      // For other devices, create a shorter, cleaner name
      List<String> parts = deviceId.split(':');
      if (parts.length >= 3) {
        // Take last 2 parts of MAC address for shorter identifier
        List<String> lastParts = parts.sublist(parts.length - 2);
        return 'Audio Device ${lastParts.join('').toUpperCase()}';
      }
    }
    
    // Fallback: use last 4 characters of device ID
    if (deviceId.length > 4) {
      String shortId = deviceId.replaceAll(':', '').replaceAll('-', '');
      if (shortId.length > 4) {
        return 'Device ${shortId.substring(shortId.length - 4).toUpperCase()}';
      }
    }
    
    return 'Unknown Device';
  }

  String _getDeviceInfo(BluetoothDevice device, {int? rssi}) {
    String info = device.id.toString();
    if (rssi != null) {
      info += ' (${rssi}dBm)';
    }
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Refresh connected devices when widget builds
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appState.refreshConnectedDevices();
        });
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bluetooth Connection', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 10),
                
                // Connection Status and Scan Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${appState.selectedDevice != null ? "Connected" : (appState.connectedDevices.isNotEmpty ? "Available" : "Disconnected")}'),
                          if (appState.selectedDevice != null)
                            Text('Selected: ${_getDeviceName(appState.selectedDevice!)}', 
                                 style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: appState.toggleScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appState.isScanning ? Colors.red : Colors.blue,
                      ),
                      child: Text(appState.isScanning ? 'Stop Scan' : 'Scan'),
                    ),
                  ],
                ),
                
                SizedBox(height: 10),
                
                // Connected Devices Section
                if (appState.connectedDevices.isNotEmpty) ...[
                  Text('Connected Devices:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  ...appState.connectedDevices.map((device) => ListTile(
                    dense: true,
                    leading: Icon(Icons.bluetooth_connected, color: Colors.green),
                    title: Text(_getDeviceName(device), style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_getDeviceInfo(device)),
                    trailing: appState.selectedDevice?.id == device.id 
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      // Select this already connected device
                      appState.connect(device);
                    },
                  )),
                  SizedBox(height: 10),
                ],
                
                // Available Devices Section
                Text('Available Devices:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Expanded(
                  child: () {
                    // Filter out devices that are already connected
                    List<ScanResult> availableDevices = appState.scanResults.where((result) {
                      return !appState.connectedDevices.any((connectedDevice) => 
                          connectedDevice.id == result.device.id);
                    }).toList();
                    
                    if (availableDevices.isEmpty) {
                      return Center(
                        child: Text(
                          appState.isScanning 
                              ? 'Scanning for new devices...' 
                              : appState.scanResults.isNotEmpty 
                                  ? 'All found devices are already connected.'
                                  : 'No devices found. Tap "Scan" to search.',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: availableDevices.length,
                      itemBuilder: (context, index) {
                        ScanResult result = availableDevices[index];
                        
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.bluetooth,
                            color: Colors.blue,
                          ),
                          title: Text(
                            _getDeviceName(result.device),
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          subtitle: Text(_getDeviceInfo(result.device, rssi: result.rssi)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => appState.connect(result.device),
                        );
                      },
                    );
                  }(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
