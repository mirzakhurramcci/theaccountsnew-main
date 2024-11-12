import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:theaccounts/repositories/DashboardRepository.dart';
import 'package:theaccounts/repositories/auth_repo/AuthRepository.dart';
import 'package:theaccounts/screens/autorollerover/model/auto_roller_list_model.dart';
import 'package:theaccounts/screens/dashboard/custom.widgets/custom_widgets.dart';
import 'package:theaccounts/utils/AppConstants.dart';
import 'package:theaccounts/utils/globles.dart';
import 'package:theaccounts/utils/utility.dart';

import '../../ScopedModelWrapper.dart';
import 'auto_select.dart';
import 'auto_tile.dart';

enum screenState { loading, loaded, error }

class AutoRollOver extends StatefulWidget {
  const AutoRollOver({Key? key}) : super(key: key);

  @override
  State<AutoRollOver> createState() => _AutoRollOverState();
}

class _AutoRollOverState extends State<AutoRollOver> {
  DashboardRepository repository = DashboardRepository();

  screenState curentState = screenState.loading;

  AutoRollerOverList? autoRollerOverList;

  int seleted = 0;

  getAutoRollerOver({bool isReloading = false}) async {
    try {
      if (isReloading)
        setState(() {
          curentState = screenState.loading;
        });

      autoRollerOverList = await repository.getAutoRollerOver();

      if (autoRollerOverList != null) {
        setState(() {
          curentState = screenState.loaded;
          // seleted = autoRollerOverList?.data?.types?.first.value ?? 0;
        });
      } else {
        setState(() {
          curentState = screenState.error;
        });
      }
    } catch (e, s) {
      dp(msg: "Error in $e", arg: s);
      setState(() {
        curentState = screenState.error;
      });
    }
  }

  @override
  void initState() {
    getAutoRollerOver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppModel model = ScopedModel.of<AppModel>(context);

    return Scaffold(
      backgroundColor:
          model.isDarkTheme ? Color(0xff585959) : Color(0xffF4F5F5),
      appBar: AppBar(
        leading: SizedBox(),
        title: Text(
          "Auto Rollover",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xff92298D),
          ),
        ),
        elevation: 0,
        leadingWidth: 0,
        backgroundColor: model.isDarkTheme ? Color(0xff6A6B6B) : Colors.white,
        actions: [
          InkWell(
            enableFeedback: false,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: autoRollerOverList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
              child: ((autoRollerOverList?.data?.RequestStatus ?? '') ==
                      "Accepted")
                  ? resultWidget()
                  : SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Color(0xff92298D),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14, top: 8),
                                    child: Text(
                                      "If you want to continuously Rollover your Bi-monthly Profit Amount for the next 3,4,5 Closings then please select your desired option below. ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          height: 1.4),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 14,
                                      right: 14,
                                    ),
                                    child: Text(
                                      "Note: System will lock your request as per selected term.",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            currentScreen == screenState.loading
                                ? Expanded(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : currentScreen == screenState.error
                                    ? Expanded(
                                        child: Center(
                                          child: InkWell(
                                              onTap: () {
                                                getAutoRollerOver(
                                                    isReloading: true);
                                              },
                                              child: Text(
                                                  "Something went wrong please try again")),
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: autoRollerOverList
                                                  ?.data?.types?.length ??
                                              0,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            //

                                            return AutoRollTile(
                                              onPress: () {
                                                if (autoRollerOverList
                                                        ?.data?.status ??
                                                    false) {
                                                  setState(() {
                                                    seleted = autoRollerOverList
                                                            ?.data
                                                            ?.types?[index]
                                                            .value ??
                                                        0;
                                                  });

                                                  toNext(
                                                    AutoRollOveSelect(
                                                      fistNum:
                                                          autoRollerOverList
                                                                  ?.data
                                                                  ?.types?[
                                                                      index]
                                                                  .value
                                                                  .toString() ??
                                                              '',
                                                      secondNum:
                                                          autoRollerOverList
                                                                  ?.data
                                                                  ?.types?[
                                                                      index]
                                                                  .description ??
                                                              '',
                                                      id: autoRollerOverList
                                                              ?.data
                                                              ?.types?[index]
                                                              .id ??
                                                          0,
                                                    ),
                                                  );
                                                } else {
                                                  showSnackBar(
                                                      context,
                                                      (autoRollerOverList
                                                              ?.message ??
                                                          'Your auto rollover request is Pending'),
                                                      false);
                                                }
                                              },
                                              subTitle: autoRollerOverList
                                                      ?.data
                                                      ?.types?[index]
                                                      .description ??
                                                  '',
                                              textNum: autoRollerOverList?.data
                                                      ?.types?[index].value
                                                      .toString() ??
                                                  '',
                                              titleText: autoRollerOverList
                                                      ?.data
                                                      ?.types?[index]
                                                      .name ??
                                                  '',
                                              isSelected: ((autoRollerOverList
                                                          ?.data?.type) ==
                                                      autoRollerOverList?.data
                                                          ?.types?[index].id ||
                                                  seleted ==
                                                      autoRollerOverList
                                                          ?.data
                                                          ?.types?[index]
                                                          .value),
                                            );
                                          },
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  Widget resultWidget() => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //
              InkWell(
                onTap: () {
                  //

                  // while (
                  //     Navigator.canPop(knavigatorKey!.currentState!.context)) {
                  //   Navigator.pop(knavigatorKey!.currentState!.context);
                  // }
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [
                          Color(0xff754399),
                          Color(0xff7E4298),
                          Color(0xff9B4297),
                          Color(0xffAD4297),
                          Color(0xffB44297),
                        ], tileMode: TileMode.repeated)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "RECEIPT",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          "assets/newassets/tickIcon.png",
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            "Your Closing Payment will be added in your Capital amount for next ${autoRollerOverList?.data?.pending}  closing",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: kDefaultPadding,
              )
              //
            ],
          ),
        ),
      );
}
