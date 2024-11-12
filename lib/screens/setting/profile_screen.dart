import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:theaccounts/bloc/dashboard_bloc.dart';
import 'package:theaccounts/model/UpdateProfileResponse.dart';
import 'package:theaccounts/networking/ApiResponse.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/screens/widgets/loading_dialog.dart';
import 'package:theaccounts/utils/utility.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.profileId}) : super(key: key);
  static const routeName = '/profile-screen';
  final int? profileId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DashboardBloc _bloc;
  UpdateProfileResponseData? data;
  @override
  void initState() {
    super.initState();
    _bloc = DashboardBloc();
    _bloc.UpdateProfileResponsegetStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        setState(() {
          data = event.data;
        });
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
    _bloc.GetProfileViewData(widget.profileId ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            CustomTopBar(topbartitle: "View Profile"),
            Container(
              height: MediaQuery.of(context).size.height - 100.h,
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  ShowUpAnimation(
                    delayStart: Duration(milliseconds: 0),
                    animationDuration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    direction: Direction.horizontal,
                    offset: 0.7.w,
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        customlableText(
                          lable: 'User ID',
                          subtitle: data?.userID ?? "",
                        ),
                        customlableText(
                            lable: 'Name',
                            subtitle: data?.accountHolderName ?? ""),
                        customlableText(
                            lable: 'Guardian Type',
                            subtitle: data?.guardianType ?? ""),
                        customlableText(
                            lable: 'Guardian Name',
                            subtitle: data?.fatherName ?? ""),
                        customlableText(
                            lable: 'CNIC Issued date',
                            subtitle: data?.cnicIssuedDate ?? ""),
                        customlableText(
                            lable: 'CNIC',
                            subtitle: data?.accountHolderCNIC ?? ""),
                        customlableText(
                            lable: 'Email ID', subtitle: data?.email ?? ""),
                        customlableText(
                          lable: 'Address',
                          subtitle: data?.address ?? "",
                        ),
                        customlableText(
                            lable: 'Mobile', subtitle: data?.phoneNumber ?? ""),
                        customlableText(
                            lable: 'Next Of Kin',
                            subtitle: data?.nextOfKinName ?? ""),
                        customlableText(
                            lable: 'Next Of Kin CNIC',
                            subtitle: data?.nextOfKinCNIC ?? ""),
                        customlableText(
                            lable: 'Next Of Kin Contact Number',
                            subtitle: data?.nextOfKinPhone ?? ""),
                        customlableText(
                            lable: 'Relation With Next of Kin',
                            subtitle: data?.nextOfKinRelation ?? ""),

                        // AnimatedLongButton(
                        //   text: "Send",
                        //   isBgColorWhite: false,
                        //   width: MediaQuery.of(context).size.width * 0.95.w,
                        //   color: [
                        //     Color(0xFFFF708C),
                        //     Color(0xFFF2E07D),
                        //   ],
                        // ),
                        SizedBox(
                          height: 70.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox trailingIcon() {
    return SizedBox(
      width: 24.h,
      height: 24.w,
      child: Image.asset(
        "assets/images/edit.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget customlableText({required String lable, required String subtitle}) {
    return Padding(
      padding: EdgeInsets.all(14.0.h),
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.3),
                blurRadius: 4.h,
                spreadRadius: 3.w,
                offset: Offset(1.w, 3.h),
              ),
            ],
          ),
          child: ListTile(
            minVerticalPadding: 2,
            contentPadding: EdgeInsets.only(top: 0, left: 20.w, bottom: 04.h),
            title: Text(
              lable,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Color(0xFFF15B28), fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
