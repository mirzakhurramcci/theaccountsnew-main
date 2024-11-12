import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:theaccounts/ScopedModelWrapper.dart';
import 'package:theaccounts/repositories/auth_repo/AuthRepository.dart';
import 'package:theaccounts/screens/loginprocess/loginscreens/Auth_Service.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/utils/shared_pref.dart';
import 'package:theaccounts/utils/utility.dart';

class MainSettings extends StatefulWidget {
  const MainSettings({Key? key}) : super(key: key);

  @override
  State<MainSettings> createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
  bool darkTheme = false;

  AppModel modal = AppModel();

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(14.h),
            child: Column(
              children: [
                CustomTopBar(topbartitle: "Settings"),
                Column(
                  children: [
                    ListView(
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        SettingList(
                          labelText: 'Touch/Face ID',
                          trailinig: SettingSwitcher(),
                        ),
                        // SettingList(
                        //   labelText: 'Dashboard',
                        //   trailinig: GlowSetting(),
                        // ),
                        SettingList(
                          labelText: 'Glow',
                          trailinig: GlowSetting(),
                        ),
                        SettingList(
                          labelText: 'Dark Mode',
                          trailinig: Appearence(),
                        ),
                        // SettingList(
                        //   labelText: 'Motion',
                        //   trailinig: SettingSwitcher3(),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingSwitcher extends StatefulWidget {
  SettingSwitcher({Key? key}) : super(key: key);
  @override
  State<SettingSwitcher> createState() => _SettingSwitcherState();
}

class _SettingSwitcherState extends State<SettingSwitcher> {
  bool isTouchIDEnable = false;
  bool Autotriggered = false;
  @override
  void initState() {
    SessionData().getTouchID().then((value) {
      setState(() {
        isTouchIDEnable = value;
        print("Current TouchID value : $value");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isTouchIDEnable,
      activeColor: Color(0xff92298D),
      onChanged: (value) {
        AuthService(ctx: context)
            .authenticateUser(
                path: 'main_setting',
                type: 'thumb',
                value: value,
                message: "Scan your Finger to authenticate")
            .then((value) {
          dp(msg: "Value", arg: value);
          if (value != "True") {
            if (value == "NotSupported") {
              showSnackBar(
                  context, 'Your mobile does not support biometrics.', true);
            } else if (value == "NotEnrolled") {
              showSnackBar(context, 'No biometrics enrolled.', true);
            } else {
              setState(() {
                isTouchIDEnable = false;
              });
              showSnackBar(context, "Deactivated successfully", false);
            }
          } else {
            setState(() {
              isTouchIDEnable = value == "True";
            });
            showSnackBar(context, "Activated successfully", false);
          }
        });
      },
    );
  }
}

class Appearence extends StatefulWidget {
  Appearence({Key? key}) : super(key: key);
  @override
  State<Appearence> createState() => _AppearenceState();
}

class _AppearenceState extends State<Appearence> {
  bool isSwitched = false;
  bool isDarktheme = false;
  @override
  void initState() {
    SessionData().isDarkTheme().then((value) {
      setState(() {
        isDarktheme = value;
        isSwitched = isDarktheme;
        print("Current Theme : $isDarktheme");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      activeColor: Color(0xff92298D),
      onChanged: (value) {
        setState(() {
          isSwitched = value;
          AppModel model = ScopedModel.of(context);
          model.seThemeMode(isSwitched);
        });
      },
    );
  }
}

class GlowSetting extends StatefulWidget {
  GlowSetting({Key? key}) : super(key: key);
  @override
  State<GlowSetting> createState() => _GlowSettingState();
}

class _GlowSettingState extends State<GlowSetting> {
  bool isGlowOn = true;
  bool isSwitched = true;
  @override
  void initState() {
    SessionData().isGlow().then((value) {
      setState(() {
        isGlowOn = value;
        isSwitched = isGlowOn;
        print("Current state of Glow Setting : $isSwitched");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      activeColor: Color(0xff92298D),
      onChanged: (value) {
        setState(
          () {
            isSwitched = value;
            SessionData().setGlow(isSwitched);
            AppModel model = ScopedModel.of(context);
            model.setGlowMode(isSwitched);
          },
        );

        print("Glow Setting Changed : $isSwitched.");
      },
    );
  }
}

class SettingList extends StatelessWidget {
  const SettingList({
    Key? key,
    required this.labelText,
    this.details,
    this.trailinig,
  }) : super(key: key);
  final String labelText;
  final String? details;
  final Widget? trailinig;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 02,
                blurRadius: 9,
                offset: Offset(05, 5))
          ]),
      child: Padding(
        padding: EdgeInsets.all(10.h),
        child: ListTile(
            title: Text(
              labelText,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  // color: Color(0xFF606060),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600),
            ),
            trailing: trailinig),
      ),
    );
  }
}
