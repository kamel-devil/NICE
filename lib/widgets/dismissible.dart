import 'package:flutter/material.dart';

class DismissibleWidget extends StatelessWidget {
  final item;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  const DismissibleWidget({
    @required this.item,
    required this.child,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(item),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      ),
      // secondaryBackground: buildSwipeActionLeft(),
      child: child,
      onDismissed: onDismissed,
    );
  }
}
