import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toast/toast.dart';

import '/src/utils/updater/updater.dart';
import '../../blocs/status_bar_cubit/status_bar_cubit.dart';
import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../blocs/device_bloc/device_bloc.dart';
import '../../../widgets/custom_widgets.dart';
import '../../../constants/enums.dart';
import '../../../utils/services/secure_storage_service.dart';
import '../../../utils/services/local_storage_service.dart';
import '../../../utils/services/functions.dart';
import '../../models/device_info.dart';

part 'sections/settings_section_1.dart';

part 'sections/settings_section_2.dart';

part 'sections/settings_section_3.dart';

part 'sections/settings_section_4.dart';

part 'sections/settings_section_5.dart';

late bool _outOfService;
late bool _kioskMode;
late Local _locale;

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Route<void> route() => MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      );

  @override
  Widget build(BuildContext context) {
    // _outOfService = context.read<DeviceBloc>().state.deviceInfo.outOfService;
    // _locale = context.watch<StatusBarCubit>().state.local;
    _outOfService = context.select(
      (DeviceBloc bloc) => bloc.state.deviceInfo.outOfService,
    );
    _locale = context.select(
      (StatusBarCubit cubit) => cubit.state.local,
    );
    ToastContext().init(context);
    return Scaffold(
      body: Directionality(
        textDirection: getDirectionally(_locale),
        child: LayoutGrid(
          areas: '''
          div1 section1 div2
          div1 section2 div2
          div1 section3 div2
          div1 section4 div2
          div1 section5 section5
          ''',
          columnSizes: [1.0.fr, 5.0.fr, 1.0.fr],
          rowSizes: [
            0.5.fr,
            1.0.fr,
            1.0.fr,
            1.0.fr,
            1.5.fr,
          ],
          children: [
            gridArea('div1').containing(Container()),
            gridArea('div2').containing(Container()),
            gridArea('section1').containing(const _Section1()),
            gridArea('section2').containing(const _Section2()),
            gridArea('section3').containing(const _Section3()),
            gridArea('section4').containing(const _Section4()),
            gridArea('section5').containing(const _Section5()),
          ],
        ),
      ),
    );
  }
}
