part of 'custom_widgets.dart';

class CustomAlertBackground extends StatelessWidget {
  const CustomAlertBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: alertBackgroundBlur,
          sigmaY: alertBackgroundBlur,
        ),
        child: Container(
          // TODO: const dialogOpacity
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(businessRadius),
            color: Colors.white.withOpacity(alertBackgroundOpacity),
          ),
        ),
      ),
    );
  }
}
