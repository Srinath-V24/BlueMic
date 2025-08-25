import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'widgets/bluetooth_connection_widget.dart';
import 'widgets/live_audio_streaming_widget.dart';
import 'widgets/system_status_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blue Mic Live Streaming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blue Mic Live Streaming'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Bluetooth Connection Section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: BluetoothConnectionWidget(),
              ),
              SizedBox(height: 8),
              
              // Live Audio Streaming Section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.22,
                child: LiveAudioStreamingWidget(),
              ),
              SizedBox(height: 8),
              
              // System Status Section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.22,
                child: SystemStatusWidget(),
              ),
              SizedBox(height: 16), // Extra bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
