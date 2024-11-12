import 'dart:developer';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theaccounts/bloc/auth_bloc.dart';
import 'package:theaccounts/model/requestbody/ChangePasswordReqBody.dart';
import 'package:theaccounts/networking/ApiResponse.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/alerts.dart';
import 'package:theaccounts/screens/loginprocess/components/widgets.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/screens/widgets/GlowSetting.dart';
import 'package:theaccounts/screens/widgets/loading_dialog.dart';
import 'package:theaccounts/utils/utility.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  static const routeName = '/changePassword-screen';

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  final _duration = Duration(milliseconds: 1500);

  late AnimationController _animController;
  bool ticked = true;

  late final TextEditingController _oldpasswordtextcontroller;
  late final TextEditingController _changepasswordtextcontroller;
  late final TextEditingController _confirmpasswordtextcontroller;

  bool obsecure = true;

  late AuthBloc _bloc;

  var currentPasswordObs = true;
  var changePasswordObs = true;
  var confirmPasswordObs = true;

  @override
  void initState() {
    _bloc = AuthBloc();

    _bloc.passChangeStream.listen((event) {
      log('Password Change');
      log(event.status.name);
      log(event.message);
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WithDrawPaymentAlert(message: "Password changed successfuly."),
          ),
        );
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
    _animController = AnimationController(vsync: this, duration: _duration);
    Tween(begin: 3.0, end: 15.0).animate(_animController)
      ..addListener(() {
        setState(() {});
      });

    //-----------------------

    _oldpasswordtextcontroller = TextEditingController();
    _changepasswordtextcontroller = TextEditingController();
    _confirmpasswordtextcontroller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _animController.view,
            builder: (context, child) {
              return KeyboardVisibilityBuilder(builder: (context, visible) {
                return Padding(
                  padding: EdgeInsets.only(bottom: visible ? 200 : 12.0.h),
                  child: rootLayout(context: context),
                );
              });
            }),
      ),
    );
  }

  Widget rootLayout({required BuildContext context}) {
    Size size = MediaQuery.of(context).size;

    final confirmPassword = Container(
      child: Center(
        child: TextField(
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 13.sp),
          controller: _confirmpasswordtextcontroller,
          // obscureText: obsecure,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          obscureText: confirmPasswordObs,
          decoration: InputDecoration(
            // errorText: validatePassword(_passwordtextcontroller.text),
            // suffixIcon: IconButton(
            //     onPressed: () {
            //       setState(() {
            //         obsecure = !obsecure;
            //         print("Visibility : $obsecure");
            //       });
            //     },
            //     icon: Icon(
            //       obsecure
            //           ? Icons.remove_red_eye_outlined
            //           : Icons.remove_red_eye,
            //       color: Colors.purple,
            //     )),
            hintText: "Confirm Password",

            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 12.sp,
                  height: 1.6.h,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                ),
            suffixIcon: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  confirmPasswordObs = !confirmPasswordObs;
                });
              },
              child: Icon(
                  confirmPasswordObs ? Icons.visibility_off : Icons.visibility),
            ),
            icon: Padding(
              padding: EdgeInsets.only(left: size.width * 0.15.w),
              child: Container(
                height: 22.h,
                width: 22.w,
                child: SvgPicture.asset(
                  "assets/svg/change_pass.svg",
                ),
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );

    //change Password
    final changePassword = Container(
      child: Center(
        child: TextField(
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 13.sp),
          controller: _changepasswordtextcontroller,
          // obscureText: obsecure,
          keyboardType: TextInputType.text,
          obscureText: changePasswordObs,
          onChanged: (value) {},
          decoration: InputDecoration(
            // errorText: validatePassword(_passwordtextcontroller.text),
            // suffixIcon: IconButton(
            //     onPressed: () {
            //       setState(() {
            //         obsecure = !obsecure;
            //         print("Visibility : $obsecure");
            //       });
            //     },
            //     icon: Icon(
            //       obsecure
            //           ? Icons.remove_red_eye_outlined
            //           : Icons.remove_red_eye,
            //       color: Colors.purple,
            //     )),
            hintText: "Change Password",
            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 12.sp,
                  height: 1.6.h,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                ),
            suffixIcon: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  changePasswordObs = !changePasswordObs;
                });
              },
              child: Icon(
                  changePasswordObs ? Icons.visibility_off : Icons.visibility),
            ),
            icon: Padding(
              padding: EdgeInsets.only(left: size.width * 0.15.w),
              child: Container(
                height: 22.h,
                width: 22.w,
                child: SvgPicture.asset(
                  "assets/svg/change_pass.svg",
                ),
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );

    //userID
    final oldPassword = Container(
      child: Center(
        child: TextField(
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 13.sp),
          controller: _oldpasswordtextcontroller,
          keyboardType: TextInputType.text,
          obscureText: currentPasswordObs,
          onChanged: (value) {},
          decoration: InputDecoration(
            // errorText:
            //     "User ID must be grater then ${_usernametextcontroller.text.length}",
            hintText: "Current Password",

            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 12.sp,
                  height: 1.6.h,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                ),
            suffixIcon: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  currentPasswordObs = !currentPasswordObs;
                });
              },
              child: Icon(
                  currentPasswordObs ? Icons.visibility_off : Icons.visibility),
            ),
            icon: Padding(
              padding: EdgeInsets.only(left: size.width * 0.15.w),
              child: Container(
                height: 22.h,
                width: 22.w,
                child: SvgPicture.asset(
                  "assets/svg/change_pass.svg",
                ),
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 14.h),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          CustomTopBar(topbartitle: ""),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            height: size.height - 40.h,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.h,
                ),
                Flexible(
                  flex: 5,
                  child: GlowSetting(
                    color: Color(0xff92298D).withOpacity(0.1),
                    color1: Color(0xffBF40BF).withOpacity(0.7),
                    radius: size.height < 700 ? 155 : 130,
                    child: Center(
                      child: SizedBox(
                        height: 70.h,
                        width: 70.w,
                        child: SvgPicture.asset(
                          "assets/svg/change_password_screen.svg",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1.h,
                ),
                Flexible(flex: 2, child: CustomTextField(context, oldPassword)),
                SizedBox(
                  height: 35.h,
                ),
                Flexible(
                    flex: 2, child: CustomTextField(context, changePassword)),
                SizedBox(
                  height: 35.h,
                ),
                Flexible(
                    flex: 2, child: CustomTextField(context, confirmPassword)),
                SizedBox(
                  height: size.height * 0.06.h,
                ),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      var data = ChangePasswordReqData(
                          OldPassword: _oldpasswordtextcontroller.text,
                          NewPassword: _changepasswordtextcontroller.text,
                          ConfirmPassword: _confirmpasswordtextcontroller.text);
                      if (data.OldPassword.isEmpty) {
                        showSnackBar(
                            context, 'old Password may not be empty.', true);
                        return;
                      }
                      if (data.NewPassword.isEmpty) {
                        showSnackBar(
                            context, 'Password may not be empty.', true);
                        return;
                      }

                      if (data.ConfirmPassword.isEmpty) {
                        showSnackBar(
                            context, 'Password may not be empty.', true);
                        return;
                      }

                      if (data.NewPassword != data.ConfirmPassword) {
                        showSnackBar(
                            context,
                            'New Password and Confirm Password must be same.',
                            true);
                        return;
                      }
                      _bloc.SaveChangePassword(data);
                    },
                    child: CustomButton(
                      title: 'Change Password',
                    ),
                  ),
                ),
                SizedBox(
                  height: 80.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomTextField(BuildContext context, Widget textfield) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: isTablet() ? 70 : 60,
      width: size.width * 0.83.w,
      child: Neumorphic(
        style: NeumorphicStyle(
          lightSource: LightSource.topLeft,
          disableDepth: false,
          shadowLightColorEmboss: Theme.of(context).cardColor,
          shadowDarkColorEmboss: Color.fromARGB(255, 132, 132, 132),
          depth: -3,
          color: Theme.of(context).cardColor,
          intensity: 0.9,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
        ),
        child: Center(
          child: textfield,
        ),
      ),
    );
  }

  String validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return "";
  }
}
