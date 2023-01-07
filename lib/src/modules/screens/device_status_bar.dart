import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/src/modules/blocs/status_bar_cubit/status_bar_cubit.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage('assets/images/background1.jpg',),fit: BoxFit.cover)
        // color: colorScheme.secondary,
        color: Color(0xFC4B4B4B),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   transform: GradientRotation(90),
        //   colors: <Color>[
        //     Color(0xff000000),
        //     // Color(0xff75546e),
        //     // Color(0xff775273),
        //     // Color(0xff795079),
        //     // Color(0xff794f80),
        //     // Color(0xff784e87),
        //     // Color(0xff764d8f),
        //     // Color(0xff734d97),
        //     // Color(0xff6e4e9f),
        //     // Color(0xff664ea8),
        //     // Color(0xff5c50b1),
        //     // Color(0xff4e52bb),
        //     Color(0xff3854c4),
        //     // colorScheme.primary,
        //     // colorScheme.secondary,
        //     // colorScheme.tertiary,
        //     // Color(0xff1f005c),
        //     // Color(0xff5b0060),
        //     // Color(0xff870160),
        //     // Color(0xffac255e),
        //     // Color(0xffca485c),
        //     // Color(0xffe16b5c),
        //     // Color(0xfff39060),
        //     // Color(0xffffb56b),
        //   ],
        //   tileMode: TileMode.mirror,
        // ),
      ),
      height: 24.0,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(
        right: 16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Text.rich(
              TextSpan(
                text: 'Powered By ',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                children: [
                  TextSpan(
                    text: 'Netcore Soft',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: FaIcon(
              FontAwesomeIcons.wifi,
              size: 16.0,
              color:
                  context.watch<StatusBarCubit>().state.internetConnectionStatus
                      ? Colors.green
                      : Colors.red,
            ),
          ),
          const SizedBox(width: 6.0),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: FaIcon(
              FontAwesomeIcons.server,
              size: 16.0,
              color:
                  context.watch<StatusBarCubit>().state.serverConnectionStatus
                      ? Colors.green
                      : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
