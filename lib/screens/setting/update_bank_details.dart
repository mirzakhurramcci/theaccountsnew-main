import 'dart:convert';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:theaccounts/ScopedModelWrapper.dart';
import 'package:theaccounts/bloc/dashboard_bloc.dart';
import 'package:theaccounts/model/UpdateBankResponse.dart';
import 'package:theaccounts/model/requestbody/UpdateBankReqBody.dart';
import 'package:theaccounts/networking/ApiResponse.dart';
import 'package:theaccounts/screens/dashboard/custom.widgets/custom_widgets.dart';
import 'package:theaccounts/screens/dashboard/dashboard.screens/alerts.dart';
import 'package:theaccounts/screens/setting/components/setting.widgets.dart';
import 'package:theaccounts/screens/widgets/loading_dialog.dart';
import 'package:theaccounts/utils/utility.dart';

class UpdateBankDetails extends StatefulWidget {
  const UpdateBankDetails({Key? key}) : super(key: key);
  static const routeName = '/profile-screen';
  @override
  State<UpdateBankDetails> createState() => _UpdateBankDetailsState();
}

class _UpdateBankDetailsState extends State<UpdateBankDetails> {
  late UpdateBankReqData reqData;
  late TextEditingController _branchcodetextcontroller;
  //late TextEditingController _bankNametextcontroller;
  late TextEditingController _accounttitlecontroller;
  late TextEditingController _accountNocontroller;
  late TextEditingController _IBANnocontroller;
  String _selectedBank = "";
  String _selectednokRelation = '';
  late DashboardBloc _bloc;
  UpdateBankResponseData? data;
  @override
  void initState() {
    _bloc = DashboardBloc();
    _bloc.GetBankDataStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        setState(() {
          data = event.data;
          _selectedBank = data?.bankName ?? "";
        });
        reqData = UpdateBankReqData(
            bankName: data?.bankName,
            accountTitle: data?.accountTitle ?? "",
            branchCode: data?.branchCode ?? "",
            accountNo: data?.accountNo ?? "",
            iBAN: data?.iban ?? "",
            accountRelation: data?.accountRelation ?? "");
        // _bankNametextcontroller.text = data?.bankName ?? "";
        _selectedBank = data?.bankName ?? "";

        _selectednokRelation = data?.accountRelation ?? "";
        _accounttitlecontroller.text = data?.accountTitle ?? "";
        _IBANnocontroller.text = data?.iban ?? "";
        _accountNocontroller.text = data?.accountNo ?? "";
        _branchcodetextcontroller.text = data?.branchCode ?? "";
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
    _bloc.GetBankData();

    _bloc.SaveBankDataStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WithDrawPaymentAlert(
                message: " Bank Details Updated successfully"),
          ),
        );
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        //showSnackBar(context, event.message, true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WithDrawPaymentAlert(message: event.message),
          ),
        );
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    //_bankNametextcontroller = TextEditingController();
    _accounttitlecontroller = TextEditingController();
    _IBANnocontroller = TextEditingController();
    _accountNocontroller = TextEditingController();
    _branchcodetextcontroller = TextEditingController();

    super.initState();
  }

  var kFomKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: ShowUpAnimation(
              delayStart: Duration(milliseconds: 0),
              animationDuration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              direction: Direction.horizontal,
              offset: 0.7.w,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CustomTopBar(topbartitle: "Update Bank Details"),
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: KeyboardVisibilityBuilder(
                      builder: (context, visible) {
                        final viewInsets = EdgeInsets.fromWindowPadding(
                            WidgetsBinding.instance.window.viewInsets,
                            WidgetsBinding.instance.window.devicePixelRatio);
                        // print('from keyboard builder');
                        // print(visible.toString());
                        // print(viewInsets.bottom);
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: visible ? viewInsets.bottom : 12.0.h),
                          child: Form(
                            key: kFomKey,
                            child: ListView(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .shadowColor
                                              .withOpacity(0.3),
                                          blurRadius: 4.h,
                                          spreadRadius: 3.w,
                                          offset: Offset(1.w, 3.h),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                        minVerticalPadding: 10.0.h,
                                        subtitle: DropdownButton(
                                          hint: _selectedBank == ""
                                              ? Text('Select Bank')
                                              : Text(
                                                  _selectedBank,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                          isExpanded: true,
                                          iconSize: 30.0.h,
                                          style: TextStyle(fontSize: 14.sp),
                                          items: data?.bankNames?.map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Text(
                                                  val,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            reqData.bankName = val.toString();
                                            setState(
                                              () {
                                                _selectedBank = val.toString();
                                              },
                                            );
                                          },
                                        )),
                                  ),
                                ),
                                ProfileListTile(
                                  hint: "Account Title",
                                  textcontroller: _accounttitlecontroller,
                                  label: "Account Title",
                                  keyboardtype: TextInputType.text,
                                  onChanged: (String value) {
                                    reqData.accountTitle = value;
                                  },
                                  validator: (p0) {
                                    if (p0?.isEmpty ?? false) {
                                      return 'field value should not empty';
                                    }
                                    return null;
                                  },
                                ),
                                ProfileListTile(
                                  hint: "Account No",
                                  textcontroller: _accountNocontroller,
                                  label: "Account No",
                                  keyboardtype: TextInputType.text,
                                  onChanged: (String value) {
                                    reqData.accountNo = value;
                                  },
                                  validator: (p0) {
                                    if (p0?.isEmpty ?? false) {
                                      return 'field value should not empty';
                                    }
                                    return null;
                                  },
                                ),
                                ProfileListTile(
                                    hint: "IBAN No",
                                    textcontroller: _IBANnocontroller,
                                    label: "IBAN No",
                                    keyboardtype: TextInputType.text,
                                    validator: (p0) {
                                      if (p0?.isEmpty ?? false) {
                                        return 'field value should not empty';
                                      }
                                      return null;
                                    },
                                    onChanged: (String value) {
                                      reqData.iBAN = value;
                                    }),
                                ProfileListTile(
                                    hint: "Branch Code",
                                    textcontroller: _branchcodetextcontroller,
                                    label: "Branch Code",
                                    keyboardtype: TextInputType.text,
                                    validator: (p0) {
                                      if (p0?.isEmpty ?? false) {
                                        return 'field value should not empty';
                                      }
                                      return null;
                                    },
                                    onChanged: (String value) {
                                      reqData.branchCode = value;
                                    }),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .shadowColor
                                              .withOpacity(0.3),
                                          blurRadius: 4.h,
                                          spreadRadius: 3.w,
                                          offset: Offset(1.w, 3.h),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                        minVerticalPadding: 10.0.h,
                                        subtitle: DropdownButton(
                                          hint: _selectednokRelation == ""
                                              ? Text('Bank Account Relation')
                                              : Text(
                                                  _selectednokRelation,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                          isExpanded: true,
                                          iconSize: 30.0.h,
                                          style: TextStyle(fontSize: 14.sp),
                                          items: data?.accountRelationList.map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Text(
                                                  val,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            reqData.accountRelation =
                                                val.toString();
                                            setState(
                                              () {
                                                _selectednokRelation =
                                                    val.toString();
                                              },
                                            );
                                          },
                                        )),
                                  ),
                                ),
                                SizedBox(height: 35.h),
                                GestureDetector(
                                  onTap: () {
                                    if (kFomKey.currentState?.validate() ??
                                        false) {
                                      //

                                      reqData.source = AppModel().deviceID();

                                      print(jsonEncode(reqData));

                                      if (reqData.accountTitle == "" ||
                                          reqData.bankName == "" ||
                                          reqData.accountNo == "" ||
                                          reqData.iBAN == "" ||
                                          reqData.branchCode == "" ||
                                          reqData.accountRelation == "") {
                                        showSnackBar(
                                            context,
                                            'Fields can\'t be Empty, Please fill the Fields Correctly',
                                            true);
                                        return;
                                      }

                                      _bloc.SaveBankData(reqData);
                                    }
                                  },
                                  child: AnimatedLongButton(
                                    text: "Send".toUpperCase(),
                                    isBgColorWhite: false,
                                    width: MediaQuery.of(context).size.width *
                                        0.9.w,
                                    color: [
                                      Color(0xFFFF708C),
                                      Color(0xFFF2E07D),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Text customlableText({required BuildContext context, required String lable}) {
    return Text(
      lable,
      style: Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(color: Color(0xFFF15B28), fontWeight: FontWeight.w400),
    );
  }
}
