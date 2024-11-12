import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:theaccounts/repositories/auth_repo/AuthRepository.dart';
import 'package:theaccounts/screens/dashboard/custom.widgets/custom_widgets.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/hidecapital.screen.dart';
import 'package:theaccounts/screens/setting/bimonthly_ratio.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/closingPayment.dart';
import 'package:theaccounts/screens/setting/change_password.dart';
import 'package:theaccounts/screens/setting/image_galleryscreen.dart';
import 'package:theaccounts/screens/setting/profile_screen.dart';
import 'package:theaccounts/screens/setting/subreference/sub_refence_user.dart';
import 'package:theaccounts/screens/setting/subreference/sub_reference_sub.dart';
import 'package:theaccounts/screens/setting/update_bank_details.dart';
import 'package:theaccounts/screens/setting/update_profile.dart';
import 'package:theaccounts/screens/setting/capital_history.dart';
import 'package:theaccounts/screens/setting/last_deposite.dart';
import 'package:theaccounts/screens/setting/payment_history.dart';
import 'package:theaccounts/screens/setting/recieved_amount.dart';
import 'package:theaccounts/utils/shared_pref.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/utils/utility.dart';

import '../../../utils/fcm_notifcatin_utils.dart';
import '../../setting/referenceIn_screen.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  static const routeName = '/Dashboard-screen';

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  //

  List<String> grid_menu_name = [
    "Capital \nHistory",
    "Payment \History",
    "Received Amount",
    "Closing \nPayment",
    "Bimonthly \nRatio",
    "Image\nGallery",
    "Update \nProfile",
    "Update Bank Details",
    "Last Deposit",
    "View Personal \nProfile ",
    // "Password",
  ];

  List<String> grid_menu_icons = [
    "assets/svg/capital_history.svg",
    "assets/svg/closing_payment_history.svg",
    "assets/svg/received_amount.svg",
    "assets/svg/closing_payment.svg",
    "assets/svg/ratio.svg",
    "assets/svg/image_gallery.svg",
    "assets/svg/update_profile.svg",
    "assets/svg/update_bank_details.svg",
    "assets/svg/lastamount.svg",
    "assets/svg/personal_profile.svg",
    // "assets/svg/change_pass.svg",
  ];

  List<Widget> views = [
    CapitalHistory(), //0
    PaymentHistory(), //1
    RecievedAmount(), //2
    ClosingPaymentScreen(), //3
    BimonthlyRatioScreen(), //4
    ImageGalleryScreen(),
    UpdateProfile(),
    UpdateBankDetails(),
    LastDepositeScreen(),
    ProfileScreen(),
    // ChangePassword(),
  ];

  NotificationUtils notificationUtils = NotificationUtils();

  Size size({required BuildContext context}) {
    return MediaQuery.of(context).size;
  }

  bool isDarkEnable = false;
  bool isRefrenceAllowed = false;
  bool IsSubReferenceAllowed = false;
  int selectedIndex = 0;

  @override
  void initState() {
    //

    SessionData().getUserProfile().then((value) {
      // ,
      //

      isRefrenceAllowed = kReleaseMode ? value.IsRefrenceInAllowed : true;

      IsSubReferenceAllowed =
          kReleaseMode ? value.IsSubReferenceAllowed ?? false : true;

      if (isRefrenceAllowed) {
        //

        grid_menu_name.insert(10, 'Reference \nIn');

        grid_menu_icons.insert(10, 'assets/svg/ref_in.svg');
        ReferenceInScreen.showData = value.IsShowDataAllowed ?? false;

        views.insert(10, ReferenceInScreen());
      }

      if (IsSubReferenceAllowed) {
        grid_menu_name.insert(11, 'Sub Reference');

        grid_menu_icons.insert(11, 'assets/newassets/subRefenceIn.svg');

        views.insert(11, SubRefenceSubUserScreen());
      }

      setState(() {});
    });

    //

    notificationUtils.initMessaging();

    super.initState();
  }

  fc() async {
    dp(msg: "Fcm= ", arg: await FirebaseMessaging.instance.getToken());
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    fc();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, HideCapitalScreen.routeName);
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: AnimatedBottomBar(),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            height: size(context: context).height,
            width: size(context: context).width,
            child: dashboardbody(context),
          ),
        ),
      ),
    );
  }

  Widget dashboardbody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 2,
          child: CustomTopBar(topbartitle: 'Dashboard'),
        ),
        SizedBox(
          height: 10.h,
        ),
        Flexible(
          flex: 12,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.2),
                        blurRadius: 34.h,
                        spreadRadius: 8.w,
                        offset: Offset(2, 5)),
                  ]),
              alignment: Alignment.center,
              child: ShowUpAnimation(
                delayStart: Duration(milliseconds: 0),
                animationDuration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                direction: Direction.horizontal,
                offset: 0.7,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    // mainAxisExtent: 100,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: grid_menu_name.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: Duration(milliseconds: 300),
                              child: views[index]),
                        );
                      },
                      child: Container(
                        // height: size(context: context).height / 9,
                        // width: size(context: context).width / 9,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.4),
                                blurRadius: 0.7.h,
                                spreadRadius: 0.8.w,
                                // offset: Offset(0.2, 0.3),
                                blurStyle: BlurStyle.outer),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              grid_menu_icons[index],
                              height: (index == 10 || index == 11 || index == 8)
                                  ? 30.h
                                  : 25.h,
                              width: (index == 10 || index == 11 || index == 8)
                                  ? 30.h
                                  : 25.w,
                              fit: BoxFit.contain,
                              color: isDarkThemeEnabled(context)
                                  ? Colors.white
                                  : null,
                              // color: Color.fromARGB(255, 107, 4, 91),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 08.w, vertical: 08.h),
                              child: FittedBox(
                                child: SizedBox(
                                  width: 90.w,
                                  child: Text(
                                    grid_menu_name[index],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        // Spacer(),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }
}
