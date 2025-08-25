import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class LiveAudioStreamingWidget extends StatelessWidget {
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
                Text('Live Audio Streaming', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 10),
                Text('Status: ${appState.streamingStatus}'),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: appState.isStreaming ? appState.stopStreaming : appState.startStreaming,
                    child: Text(appState.isStreaming ? 'Stop Streaming' : 'Start Streaming'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
