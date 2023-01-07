part of 'custom_widgets.dart';

class CustomCenterText extends StatelessWidget {
  const CustomCenterText(
      this.data, {
        Key? key,
        this.style,
      }) : super(key: key);

  final String data;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      textAlign: TextAlign.center,
      textDirection: context.read<StatusBarCubit>().state.local == Local.ar
          ? TextDirection.rtl
          : null,
    );
  }
}
