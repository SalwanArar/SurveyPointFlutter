import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:survey_point_05/src/modules/blocs/status_bar_cubit/status_bar_cubit.dart';
import 'package:survey_point_05/src/utils/services/functions.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/src/utils/services/local_storage_service.dart';
import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../../constants/enums.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({Key? key}) : super(key: key);

  static Route<void> route() => MaterialPageRoute<void>(
        builder: (_) => const AgreementPage(),
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: getDirectionally(
        context.read<StatusBarCubit>().state.local,
      ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1,
            vertical: size.width * 0.025,
          ),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.termsTitle,
                // TODO: set headline 48, w500
                style: Theme.of(context).textTheme.displayLarge,
                // style: TextStyle(
                //   fontSize: 48.0,
                //   fontWeight: FontWeight.w500,
                // ),
              ),
              const Spacer(flex: 1),
              SizedBox(height: size.height * 0.1),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurStyle: BlurStyle.solid,
                      offset: const Offset(-1.0,-0.1),
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.3),
                    ),
                  ],
                ),
                child: Text(
                  AppLocalizations.of(context)!.terms,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              SizedBox(height: size.height * 0.1),
              const _AcceptSection(),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class AgreementSection extends StatefulWidget {
  const AgreementSection({Key? key}) : super(key: key);

  @override
  State<AgreementSection> createState() => _AgreementSectionState();
}

class _AgreementSectionState extends State<AgreementSection> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.asset(
      'assets/agreements/agreement.pdf',
      key: _pdfViewerKey,
      pageLayoutMode: PdfPageLayoutMode.continuous,
      canShowHyperlinkDialog: false,
      enableDoubleTapZooming: false,
      enableTextSelection: false,
      enableDocumentLinkAnnotation: false,
      enableHyperlinkNavigation: false,
    );
  }
}

class _AcceptSection extends StatefulWidget {
  const _AcceptSection({Key? key}) : super(key: key);

  @override
  State<_AcceptSection> createState() => _AcceptSectionState();
}

class _AcceptSectionState extends State<_AcceptSection> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    bool isLeft = getDirectionally(
          context.read<StatusBarCubit>().state.local,
        ) !=
        TextDirection.ltr;
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: EdgeInsets.only(
        left: isLeft ? 16.0 : 0.0,
        bottom: 16.0,
        right: isLeft ? 0.0 : 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CheckboxListTile(
            value: accepted,
            onChanged: (val) {
              setState(() {
                accepted = val!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              AppLocalizations.of(context)!.acceptTitle,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 28.0),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<StatusBarCubit>(context).onLocalChanged(
                    Local.en,
                  );
                },
                child: Text(
                  'English',
                  style: GoogleFonts.montserrat(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<StatusBarCubit>(context).onLocalChanged(
                    Local.ar,
                  );
                },
                child: Text(
                  'عربية',
                  style: GoogleFonts.vazirmatn(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: accepted
                    ? () {
                        setTermsAgreed(true);
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          const AuthenticationStatusChanged(
                            AuthenticationStatus.unauthenticated,
                          ),
                        );
                      }
                    : null,
                child: Text(
                  AppLocalizations.of(context)!.acceptButton,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
