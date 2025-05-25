import 'package:flutter/material.dart';

class DeferredScreenLoader extends StatelessWidget {
  final Future<void> loadLibraryFuture;
  final WidgetBuilder screenBuilder;

  const DeferredScreenLoader({
    Key? key,
    required this.loadLibraryFuture,
    required this.screenBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadLibraryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Log error: print('Error loading library: ${snapshot.error}');
            return Center(child: Text('Error loading feature. Please try again.'));
          }
          return screenBuilder(context);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
