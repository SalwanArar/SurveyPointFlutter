part of 'customer_info_layouts.dart';

class CustomerInfoBirthdateLayout extends StatelessWidget {
  const CustomerInfoBirthdateLayout({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final Local local = context.select(
      (SurveyCubit cubit) => cubit.state.local,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: CustomQuestionWidget(
            questionDetails: getBirthdateLocale(local),
          ),
        ),
        const Flexible(
          flex: 11,
          child: Center(child: _BirthdateDropdown()),
        ),
      ],
    );
  }
}

class _BirthdateDropdown extends StatefulWidget {
  const _BirthdateDropdown({
    Key? key,
  }) : super(key: key);

  @override
  State<_BirthdateDropdown> createState() => _BirthdateDropdownState();
}

class _BirthdateDropdownState extends State<_BirthdateDropdown> {
  final List<int> itemsYear = [];
  final List<String> itemsMonth = [];
  final List<int> itemsDay = [];
  int? dropdownItemYear;
  String? dropdownItemMonth;
  int? dropdownItemDay;
  late int oldDropdownValueDay;

  @override
  void initState() {
    super.initState();
    itemsYear.addAll(
      List.generate(100, (index) => DateTime.now().year - 14 - (index + 1)),
    );
  }

  int get getMonthIndex => itemsMonth.indexOf(dropdownItemMonth ?? '') + 1;

  @override
  Widget build(BuildContext context) {
    Local local = context.select((SurveyCubit cubit) => cubit.state.local);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double marginHorizontal = MediaQuery.of(context).size.width * 0.15;
    final double paddingBottom = MediaQuery.of(context).size.height * 0.15;
    ToastContext().init(context);
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: CustomDropdown<int>(
              local: local,
              label: getYearLocale,
              colorScheme: colorScheme,
              dropdownItem: dropdownItemYear,
              items: itemsYear,
              onTap: () => context.read<SurveyCubit>().onTimerRefresh(),
              onChange: (value) {
                context.read<SurveyCubit>().onTimerRefresh();
                setState(
                  () {
                    value!;
                    dropdownItemYear = value;
                    if (itemsMonth.isEmpty) {
                      itemsMonth.addAll(
                        getMonthsLocale(
                          local,
                        ),
                      );
                    } else if (getMonthIndex == 2) {
                      if (value % 400 == 0 ||
                          (value % 100 != 0 && value % 4 == 0)) {
                        if (!itemsDay.contains(29)) {
                          itemsDay.add(29);
                        }
                      } else {
                        if (itemsDay.contains(29)) {
                          if (dropdownItemDay == 29) dropdownItemDay = 28;
                          itemsDay.removeWhere(
                            (element) => element > 28,
                          );
                        }
                      }
                    }
                  },
                );
                if (dropdownItemDay != null && dropdownItemMonth != null) {
                  context.read<SurveyCubit>().onAddingInfo(
                        '$dropdownItemYear-'
                        '${getMonthIndex < 10 ? '0$getMonthIndex' : getMonthIndex}-'
                        '${dropdownItemDay! < 10 ? '0$dropdownItemDay' : dropdownItemDay}',
                        CustomerInfoType.birthday,
                      );
                }
              },
            ),
          ),
          const SizedBox(
            width: 64.0,
          ),
          Flexible(
            flex: 3,
            child: CustomDropdown(
              local: local,
              items: itemsMonth,
              dropdownItem: dropdownItemMonth,
              label: getMonthLocale,
              colorScheme: colorScheme,
              onTap: () {
                if (itemsMonth.isEmpty) {
                  Toast.show('msg');
                }
                print('Month is tapped');
                context.read<SurveyCubit>().onTimerRefresh();
              },
              onChange: (value) {
                print(value);
                setState(
                  () {
                    if (itemsDay.isEmpty) {
                      int daysCount;
                      switch (value) {
                        case 'January':
                        case 'March':
                        case 'May':
                        case 'July':
                        case 'August':
                        case 'October':
                        case 'December':
                          daysCount = 31;
                          break;
                        case 'April':
                        case 'June':
                        case 'September':
                        case 'November':
                          daysCount = 30;
                          break;
                        case 'February':
                          if (dropdownItemYear! % 400 == 0 ||
                              (dropdownItemYear! % 100 != 0 &&
                                  dropdownItemYear! % 4 == 0)) {
                            daysCount = 29;
                          } else {
                            daysCount = 28;
                          }
                          break;
                        default:
                          daysCount = 28;
                      }
                      itemsDay.addAll(
                        List.generate(
                          daysCount,
                          (index) => index + 1,
                        ),
                      );
                    } else {
                      if (dropdownItemDay != null) {
                        oldDropdownValueDay = dropdownItemDay!;
                      } else {
                        oldDropdownValueDay = 28;
                      }
                      dropdownItemDay = 28;
                      itemsDay
                          .removeWhere((element) => element > dropdownItemDay!);
                      switch (value) {
                        case 'January':
                        case 'March':
                        case 'May':
                        case 'July':
                        case 'August':
                        case 'October':
                        case 'December':
                          while (itemsDay.length < 31) {
                            itemsDay.add(itemsDay.length + 1);
                          }
                          break;
                        case 'April':
                        case 'June':
                        case 'September':
                        case 'November':
                          while (itemsDay.length < 30) {
                            itemsDay.add(itemsDay.length + 1);
                          }
                          break;
                        case 'February':
                          itemsDay.removeWhere((element) => element > 28);
                          if (dropdownItemYear! % 400 == 0 ||
                              (dropdownItemYear! % 100 != 0 &&
                                  dropdownItemYear! % 4 == 0)) {
                            itemsDay.add(29);
                          }
                          break;
                      }
                      if (itemsDay.isNotEmpty) {
                        if (itemsDay.contains(oldDropdownValueDay)) {
                          dropdownItemDay = oldDropdownValueDay;
                        } else {
                          dropdownItemDay = itemsDay.last;
                        }
                      }
                    }
                    dropdownItemMonth = value!;
                    if (dropdownItemDay != null) {
                      context.read<SurveyCubit>().onAddingInfo(
                            '$dropdownItemYear-'
                            '${getMonthIndex < 10 ? '0$getMonthIndex' : getMonthIndex}-'
                            '${dropdownItemDay! < 10 ? '0$dropdownItemDay' : dropdownItemDay}',
                            CustomerInfoType.birthday,
                          );
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(
            width: 64.0,
          ),
          Flexible(
            flex: 2,
            child: CustomDropdown(
              local: local,
              items: itemsDay,
              dropdownItem: dropdownItemDay,
              label: getDayLocale,
              colorScheme: colorScheme,
              onTap: () {
                if (dropdownItemYear == null) {
                  Toast.show('Fill Year first');
                } else if (dropdownItemMonth == null) {
                  Toast.show('Fill Month first');
                }
                context.read<SurveyCubit>().onTimerRefresh();
              },
              onChange: (value) {
                context.read<SurveyCubit>().onTimerRefresh();
                setState(
                  () {
                    dropdownItemDay = value!;
                  },
                );
                context.read<SurveyCubit>().onAddingInfo(
                    '$dropdownItemYear-'
                    '${getMonthIndex < 10 ? '0$getMonthIndex' : getMonthIndex}-'
                    '${dropdownItemDay! < 10 ? '0$dropdownItemDay' : dropdownItemDay}',
                    CustomerInfoType.birthday);
              },
            ),
          ),
        ],
      ),
    );
  }
}
