import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_point_05/src/utils/services/functions.dart';
import '/src/modules/blocs/device_bloc/device_bloc.dart';
import '/src/widgets/custom_widgets.dart';

import '../../../constants/enums.dart';
import '../../models/device_info.dart';

class DeviceHeader extends StatelessWidget {
  const DeviceHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int clickedTimes = 0;
    DeviceInfo deviceInfo = context.watch<DeviceBloc>().state.deviceInfo;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: context.watch<DeviceBloc>().state.deviceStatus ==
                      DeviceAuthenticatedStatus.settings
                  ? null
                  : () {
                      if (clickedTimes == 0) {
                        clickedTimes++;
                        Future.delayed(
                          const Duration(seconds: 2),
                          () => clickedTimes = 0,
                        );
                      } else if (clickedTimes == 6) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<DeviceBloc>(context),
                            child: const PasscodeDialog(),
                          ),
                        );
                      } else {
                        clickedTimes++;
                      }
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 1.0,
                  horizontal: 32.0,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.primary,
                  ),
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child:
                    // true
                    deviceInfo.deviceLogo == null
                        ? Container(
                            height: 128.0,
                            width: 128.0,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                            // child: Image.asset(
                            //     'assets/images/my_business_logo3.png',
                            // ),
                          )
                        : CachedNetworkImage(
                            imageUrl: deviceInfo.deviceLogo!,
                            height: 128.0,
                            width: 128.0,
                            progressIndicatorBuilder: (
                              context,
                              url,
                              downloadProgress,
                            ) =>
                                Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                            imageBuilder: (context, imageProvider) => Container(
                              constraints: const BoxConstraints.expand(),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error,
                              color: colorScheme.error,
                            ),
                          ),
              ),
            ),
            Text(
              context.watch<DeviceBloc>().state.deviceInfo.organizationName,
              style: TextStyle(
                fontSize: 22.0,
                color: colorScheme.background,
                fontFamily: getFontFamily(Local.en),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
