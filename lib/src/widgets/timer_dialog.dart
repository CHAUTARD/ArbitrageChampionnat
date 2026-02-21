// lib/src/widgets/timer_dialog.dart
//
// Définit une boîte de dialogue affichant un compte à rebours.
// Ce widget est utilisé pour les temps morts et les changements de côté,
// et il change de couleur lorsque le temps est presque écoulé.

import 'dart:async';
import 'package:flutter/material.dart';

class TimerDialog extends StatefulWidget {
  final Duration duration;
  final String title;

  const TimerDialog({super.key, required this.duration, required this.title});

  @override
  State<TimerDialog> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  late Timer _timer;
  late ValueNotifier<Duration> _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = ValueNotifier(widget.duration);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.value.inSeconds > 0) {
        _remainingTime.value =
            _remainingTime.value - const Duration(seconds: 1);
      } else {
        _timer.cancel();
        // Maybe play a sound here in the future
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _remainingTime.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge,
      ),
      content: ValueListenableBuilder<Duration>(
        valueListenable: _remainingTime,
        builder: (context, value, child) {
          return Text(
            _formatDuration(value),
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge?.copyWith(
              fontFamily: 'Oswald',
              fontSize: 72,
              color: value.inSeconds <= 10
                  ? Colors.red.shade700
                  : theme.textTheme.displayLarge?.color,
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Fermer'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// Helper function to show the dialog easily
Future<void> showTimerDialog(
  BuildContext context, {
  required Duration duration,
  required String title,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return TimerDialog(duration: duration, title: title);
    },
  );
}
