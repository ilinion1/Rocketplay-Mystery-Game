import 'package:flutter/material.dart';
import 'package:mystery/source/features/pair_element/card_widget.dart';

class MysteryLevel extends StatelessWidget {
  const MysteryLevel({
    super.key,
    required this.type,
    required this.cardFlips,
    required dynamic Function(int) onItemPressed,
    required this.isDone,
    this.success,
  }) : _mysteryonItemPressed = onItemPressed;

  final List<int> type;
  final List<bool> cardFlips;
  final List<bool> isDone;
  final bool? success;

  final Function(int) _mysteryonItemPressed;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
      ),
      itemBuilder: (context, index) => MysteryCardWidget(
        value: type[index],
        isFlipped: cardFlips[index],
        isDone: isDone[index],
        color: (success == null)
            ? Colors.black
            : success!
                ? Colors.green
                : Colors.red,
        onPressed: () => _mysteryonItemPressed(index),
      ),
      itemCount: type.length,
    );
  }
}
