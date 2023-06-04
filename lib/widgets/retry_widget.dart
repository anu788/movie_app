import 'package:flutter/material.dart';
import 'package:yolo_movies_app/services/size_config.dart';

// Widget to Show a retry button with an optional error message
class RetryWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;
  const RetryWidget({
    this.errorMessage,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (errorMessage != null) ...{
            Text(errorMessage!),
            SizedBox(height: 8.withHeightFactor),
          },
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
