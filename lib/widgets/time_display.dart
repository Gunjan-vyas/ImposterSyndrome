import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imposter_syndrome_game/providers/game_provider.dart';

class TimeRemainingDisplay extends StatelessWidget {
  const TimeRemainingDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Vote The Imposter ${(gameProvider.secondsRemaining > 0 ? "in ${gameProvider.secondsRemaining} seconds" : "Now")}',
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }
}