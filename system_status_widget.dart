import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SystemStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('System Status', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 10),
                _buildStatusRow('Microphone', appState.isMicrophoneActive),
                _buildStatusRow('Bluetooth', appState.isBluetoothActive),
                _buildStatusRow('Streaming', appState.isStreaming),
                if (appState.selectedDevice != null)
                  _buildInfoRow('Active Device', appState.selectedDevice!.name.isNotEmpty 
                      ? appState.selectedDevice!.name 
                      : 'Device ${appState.selectedDevice!.id.toString().substring(appState.selectedDevice!.id.toString().length - 8)}'),
                if (appState.connectedDevices.isNotEmpty)
                  _buildInfoRow('Connected Count', '${appState.connectedDevices.length} device(s)'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusRow(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            color: isActive ? Colors.green : Colors.red,
            size: 16,
          ),
          SizedBox(width: 8),
          Text('$label: '),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 16),
          SizedBox(width: 8),
          Text('$label: '),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
