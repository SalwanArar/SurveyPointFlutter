part of 'customer_info_layout.dart';

class CommentKeyboardDialog extends StatelessWidget {
  const CommentKeyboardDialog({
    Key? key,
    required this.local,
    required this.commentController,
    required this.onOk,
  }) : super(key: key);
  final Local local;

  final TextEditingController commentController;
  final Function() onOk;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
          color: Colors.black12,
          width: 4.0,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(28.0),
        ),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.normal,
            blurRadius: 2,
            spreadRadius: 5,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            getCommentLabelLocale(local),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 64,
              vertical: 32.0,
            ),
            child: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                label: Text(
                    '${getCommentLabelLocale(local)} (${getOptionalLocale(local)})'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: FaIcon(FontAwesomeIcons.solidComments),
                ),
              ),
              keyboardType: TextInputType.none,
              autofocus: true,
              maxLength: 255,
              maxLines: 5,
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              height: size.height * 0.25,
              width: size.width * 0.8,
              child: CustomKeyboard(
                onTextInput: (String value) {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  int length = 255;
                  insertText(value, commentController, length);
                },
                onBackspace: () {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  backspace(commentController);
                },
                onDone: () {
                  BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
                  if (commentController.text.allMatches('\n').length < 5) {
                    insertText('\n', commentController, 255);
                  }
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 32.0,
              left: 48.0,
              right: 48.0,
            ),
            alignment: getReverseAlignment(local),
            child: ElevatedButton(
              onPressed: onOk,
              child: Text(
                getOkLocale(local),
              ),
            ),
          ),
        ],
      ),
      // child: AlertDialog(
      //   title: Text(
      //     getCommentLabelLocale(local),
      //     style: Theme.of(context).textTheme.labelLarge,
      //   ),
      //   content: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Column(
      //         mainAxisSize: MainAxisSize.min,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Directionality(
      //             textDirection: getDirectionally(local),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(
      //                 horizontal: 32.0,
      //                 vertical: 8.0,
      //               ),
      //               child: TextFormField(
      //                 controller: commentController,
      //                 decoration: InputDecoration(
      //                   label: Text(
      //                       '${getCommentLabelLocale(local)} (${getOptionalLocale(local)})'),
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(16),
      //                   ),
      //                   prefixIcon: const Padding(
      //                     padding: EdgeInsets.symmetric(horizontal: 8.0),
      //                     child: FaIcon(FontAwesomeIcons.solidComments),
      //                   ),
      //                 ),
      //                 keyboardType: TextInputType.none,
      //                 autofocus: true,
      //                 maxLength: 255,
      //                 maxLines: 5,
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             height: size.height * 0.25,
      //             width: size.width * 0.8,
      //             child: CustomKeyboard(
      //               onTextInput: (String value) {
      //                 BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
      //                 int length = 255;
      //                 insertText(value, commentController, length);
      //               },
      //               onBackspace: () {
      //                 BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
      //                 backspace(commentController);
      //               },
      //               onDone: () {
      //                 BlocProvider.of<SurveyCubit>(context).onTimerRefresh();
      //                 if (commentController.text.allMatches('\n').length < 5) {
      //                   insertText('\n', commentController, 255);
      //                 }
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     ElevatedButton(
      //       onPressed: onOk,
      //       child: Text(
      //         getOkLocale(local),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}

class CommentTextField extends StatelessWidget {
  const CommentTextField({
    Key? key,
    required this.onSaved,
    required this.textDirection,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String?) onSaved;
  final TextDirection textDirection;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final local = BlocProvider.of<SurveyCubit>(context).state.local;
    return Directionality(
      textDirection: textDirection,
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${getCommentLabelLocale(local)}:',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              onSaved: onSaved,
              maxLines: 5,
              controller: controller,
              decoration: InputDecoration(
                label: Text(
                  '${getCommentLabelLocale(local)} '
                  '(${getOptionalLocale(local)})',
                ),
                border: const OutlineInputBorder(),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: FaIcon(FontAwesomeIcons.solidComments),
                ),
              ),
              onTap: onTap,
              // onTap: () {
              //   showDialog(
              //     context: context,
              //     barrierDismissible: false,
              //     builder: (builderContext) {
              //       // BlocProvider.of<SurveyCubit>(context)
              //       //     .changePopUpStatus(true);
              //       return BlocProvider.value(
              //         value: BlocProvider.of<SurveyCubit>(context),
              //         child: _KeyboardPopUp(
              //           controller: controller,
              //           local: local,
              //         ),
              //       );
              //     },
              //   );
              // },
              keyboardType: TextInputType.none,
            ),
          ],
        ),
      ),
    );
  }
}
