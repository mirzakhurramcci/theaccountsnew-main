import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theaccounts/repositories/DashboardRepository.dart';
import 'package:theaccounts/repositories/auth_repo/AuthRepository.dart';
import 'package:theaccounts/screens/loginprocess/components/widgets.dart';
import 'package:theaccounts/screens/loginprocess/components/inputfield.widget.dart';
import 'package:theaccounts/screens/loginprocess/loginscreens/Login_Screen.dart';
import 'package:theaccounts/screens/loginprocess/loginscreens/Otp_Screen.dart';
import 'package:theaccounts/screens/loginprocess/loginscreens/new_otp_screen.dart';
import 'package:theaccounts/screens/setting/change_password.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/screens/widgets/GlowSetting.dart';
import 'package:theaccounts/utils/utility.dart';

class ForgetPsswordScreen extends StatefulWidget {
  const ForgetPsswordScreen({Key? key}) : super(key: key);
  static const routeName = '/forgetpassword-screen';

  @override
  State<ForgetPsswordScreen> createState() => _ForgetPsswordScreenState();
}

class _ForgetPsswordScreenState extends State<ForgetPsswordScreen> {
  late TextEditingController _otptextcontroller;

  @override
  void initState() {
    _otptextcontroller = TextEditingController();
    super.initState();
  }

  bool isloading = false;

  DashboardRepository dashboardRepository = DashboardRepository();

  sednOtp() async {
    setState(() {
      isloading = true;
    });
    dp(msg: "Text", arg: _otptextcontroller.text);
    try {
      if (_otptextcontroller.text.trim().isNotEmpty) {
        var responce =
            await dashboardRepository.sendOtp(_otptextcontroller.text);
        dp(msg: "Res", arg: responce);
        if (responce['status'] ?? false) {
          //

          showSnackBar(
              context,
              responce['message'] ?? "Reset password code successfully send",
              false);

          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return NewOtpScreen(
                userId: _otptextcontroller.text,
              );
            },
          ));
        } else {
          showSnackBar(
              context,
              responce['message'] ?? "Something went wrong please try again",
              true);
        }
      } else {
        showSnackBar(context, "Enter user id", true);
      }
    } catch (e, s) {
      dp(msg: "Error occur  $e", arg: s);
      setState(() {
        isloading = false;
      });
    }

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, MyHomePage.routeName);
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25.h),
              CustomTopBar(topbartitle: ""),
              SizedBox(height: 30.h),
              GlowSetting(
                color: Color(0xff92298D).withOpacity(0.1),
                color1: Color(0xffBF40BF).withOpacity(0.7),
                radius: size.height < 700 ? 150 : 170,
                child: Center(
                  child: SizedBox(
                    height: 80.h,
                    width: 80.w,
                    child: Image.asset(
                      "assets/images/pas.png",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 65.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                child: KeyboardVisibilityBuilder(builder: (context, visible) {
                  return CustomInputField(
                    textcontroller: _otptextcontroller,
                    hint: "User ID",
                    emprty_error_msg: "Otp can/t be Empty.!",
                    textinputType: TextInputType.number,
                    icon: Padding(
                      // padding: EdgeInsets.only(left: size.width * 0.2.w),
                      padding: EdgeInsets.only(left: 18),
                      child: Container(
                        height: 22.h,
                        width: 22.w,
                        child: SvgPicture.asset(
                          "assets/svg/user.svg",
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Enter your User ID, you will receive a otp on your registered email.',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 16.sp,
                        height: 1.6.w,
                        fontWeight: FontWeight.w400,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
              SizedBox(
                height: 90.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: isloading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GestureDetector(
                        onTap: () {
                          //

                          sednOtp();

                          // Navigator.of(context)
                          //     .pushReplacementNamed(ChangePassword.routeName);
                        },
                        child: CustomButton(title: 'SEND'),
                      ),
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackIconBotton extends StatelessWidget {
  const BackIconBotton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          size: 24.h,
          color: Theme.of(context).dividerColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
