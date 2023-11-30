import 'package:flutter/material.dart';



class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages(){

    final messages = <String>[
    'Charging movies...',
    'Preparing top rated movies...',
    'It is almost ready...'
    ];

    return Stream.periodic(const Duration(seconds: 2), (step) {
      return messages[step]; 
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Wait a second please...'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(
            strokeWidth: 3,
          ),
          const SizedBox(height: 10),

          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if ( !snapshot.hasData ) return const Text('Charging...');

              return Text( snapshot.data! );
            },
          )
        ],
      ),
    );
  }
}