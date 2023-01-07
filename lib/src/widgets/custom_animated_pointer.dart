part of 'custom_widgets.dart';

class AnimatedPointer extends StatefulWidget {
  const AnimatedPointer({Key? key}) : super(key: key);

  @override
  State<AnimatedPointer> createState() => _AnimatedPointerState();
}

class _AnimatedPointerState extends State<AnimatedPointer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) controller.repeat();
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

// Curves curves = Curves.
  /// convert 0-1 to 0-1-0
  double shake(double value) =>
      2 * (0.5 - (0.5 - Curves.bounceOut.transform(value).abs()));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) => Transform.translate(
        offset: Offset(0, 20 * shake(controller.value)),
        child: child,
      ),
      child: const FaIcon(
        FontAwesomeIcons.handPointDown,
        color: Colors.black,
        size: 48.0,
      ),
    );
  }
}
