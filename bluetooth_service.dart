import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothService {
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  // Get already connected devices (these will be BLE devices)
  List<BluetoothDevice> get connectedDevices => FlutterBluePlus.connectedDevices;

  // Get system connected devices (including classic Bluetooth audio devices)
  Future<List<BluetoothDevice>> getSystemConnectedDevices() async {
    try {
      // This will include classic Bluetooth devices that are connected to the system
      return await FlutterBluePlus.systemDevices([]);
    } catch (e) {
      print('Error getting system devices: $e');
      return [];
    }
  }

  Future<void> startScan() async {
    if (await _requestPermissions()) {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
    }
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Future<bool> _requestPermissions() async {
    var status = await Permission.bluetoothScan.request();
    if (status.isGranted) {
      status = await Permission.bluetoothConnect.request();
      return status.isGranted;
    }
    return false;
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      await device.connect();
    } catch (e) {
      print('Connection error: $e');
      // For already connected devices, we don't need to connect again
    }
  }

  void disconnect(BluetoothDevice device) {
    device.disconnect();
  }
}
