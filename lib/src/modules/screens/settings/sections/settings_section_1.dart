part of '../settings_page.dart';

class _Section1 extends StatefulWidget {
  const _Section1({Key? key}) : super(key: key);

  @override
  State<_Section1> createState() => _Section1State();
}

class _Section1State extends State<_Section1> {
  String _deviceCode = '';

  getDeviceCodeSettings() async {
    String deviceCode = await getDeviceCode() ?? '';
    setState(
      () => _deviceCode = deviceCode,
    );
  }

  @override
  void initState() {
    super.initState();
    getDeviceCodeSettings();
  }

  @override
  Widget build(BuildContext context) {
    bool directionally = getDirectionally(_locale) == TextDirection.ltr;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              text: AppLocalizations.of(context)!.deviceCode,
              children: [
                const TextSpan(
                  text: ':\t\t',
                ),
                TextSpan(
                  text: _deviceCode,
                  style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
    // return Align(
    //   alignment: directionally ? Alignment.centerLeft : Alignment.centerRight,
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         AppLocalizations.of(context)!.deviceCode,
    //         // TODO: set headline 22, w500
    //         style: const TextStyle(
    //           fontSize: 22.0,
    //           fontWeight: FontWeight.w500,
    //         ),
    //       ),
    //       const SizedBox(height: 8.0),
    //       Container(
    //         padding: const EdgeInsets.symmetric(vertical: 4.0),
    //         width: 320.0,
    //         alignment: Alignment.center,
    //         decoration: BoxDecoration(
    //           border: Border.all(width: 1.5),
    //           borderRadius: BorderRadius.circular(28.0),
    //         ),
    //         child: FutureBuilder<String?>(
    //           future: getDeviceCode(),
    //           builder: (context, snapshot) {
    //             return Text(
    //               snapshot.data ?? '',
    //               // TODO: set headline 20, bold, primary
    //               style: GoogleFonts.montserrat(
    //                 fontSize: 20.0,
    //                 fontWeight: FontWeight.bold,
    //                 color: Theme.of(context).colorScheme.primary,
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
