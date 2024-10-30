// ignore_for_file: depend_on_referenced_packages, must_be_immutable, prefer_const_constructors,use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/customWidget/AppBigTextFiled.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_offer_details_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class EditOfferScreen extends StatefulWidget {
  CouponList couponList;
  EditOfferScreen({required this.couponList, super.key});

  @override
  State<EditOfferScreen> createState() => _EditOfferScreenState();
}

class _EditOfferScreenState extends State<EditOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  // final variable = Get.put(editCoupen());
  final variable = Get.put(TurfCreateCouponDataViewModel());

  String selectedValue = "percentage";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(value: "percentage", child: Text("percentage")),
      DropdownMenuItem(value: "Flat", child: Text("Flat")),
    ];
    return menuItems;
  }

  late SharedPreferences prefs;
  String authToken = "";
  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void dispose() {
    Get.delete<TurfCreateCouponDataViewModel>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    variable.offerCodeController.value.text = widget.couponList.code!;
    variable.selectedValue.value = widget.couponList.discountType!;
    variable.discountValueController.value.text =
        widget.couponList.discountValue.toString();
    variable.discountAmountController.value.text =
        widget.couponList.maxDiscountAmount.toString();
    variable.userlimitController.value.text =
        widget.couponList.userLimit.toString();
    variable.descriptionsController.value.text = widget.couponList.description!;
    date();
  }

  date() {
    DateTime parsedDate = DateTime.parse(widget.couponList.startAt!);
    DateTime parsedDate2 = DateTime.parse(widget.couponList.expiresAt!);
    variable.startDate.value = DateFormat('yyyy-MM-dd').format(parsedDate);
    variable.endDate.value = DateFormat('yyyy-MM-dd').format(parsedDate2);
    variable.startDateTime.value =
        DateFormat('yyyy-MM-dd hh:mm a').format(parsedDate);
    variable.endDateTime.value =
        DateFormat('yyyy-MM-dd hh:mm a').format(parsedDate2);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayLoaderWithAppIcon(
          isLoading: variable.isLoading.value,
          circularProgressColor: appColor,
          appIcon: SizedBox(
            height: 30.h,
            width: 30.w,
            child: Padding(
              padding:  EdgeInsets.all(8.r),
              child: Image.asset(
                "assets/images/loader_image.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          child:  ScreenUtil().screenWidth < 600
            ? moblieView(context)
            : tabletView(context)),
    );
  }

  Scaffold moblieView(BuildContext context) {
    return Scaffold(
          backgroundColor: whiteColor,
          body: SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              CustomToolbar(
                  onTap: () {
                    Get.back();
                  },
                  title: "Edit Offer"),
              SizedBox(
                height: 16.h,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Obx(
                        () => codeTextField(context),
                      ),
                      Obx(() => SizedBox(
                            height: variable.offerCodeSelected.value == true
                                ? 12.h
                                : 0.h,
                          )),
                      discountTypeTextField(),
                      discountValueTextField(context),
                      Obx(
                        () => SizedBox(
                          height: variable.discountValueSelected.value == true
                              ? 12.h
                              : 0.h,
                        ),
                      ),
                      maxDiscountAmountTextField(context),
                      Obx(
                        () => SizedBox(
                          height:
                              variable.discountAmountSelected.value == true
                                  ? 12.h
                                  : 0.h,
                        ),
                      ),
                      userLimitTextField(),
                      Obx(
                        () => SizedBox(
                          height: variable.userlimitSelected.value == true
                              ? 12.h
                              : 0.h,
                        ),
                      ),
                      timePickerTextField(context),
                      SizedBox(
                        height: 12.h,
                      ),
                      descriptionsTextField(),
                      Obx(
                        () => SizedBox(
                          height: variable.descriptionsSelected.value == true
                              ? 12.h
                              : 0.h,
                        ),
                      ),
                      termsAndConditionsTextField(),
                      Obx(
                        () => SizedBox(
                          height: variable.turf_AboutSelected.value == true
                              ? 44.h
                              : 28.h,
                        ),
                      ),
                      CustomeButton(
                          title: "Update",
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (variable.startDate.isEmpty &&
                                  variable.endDate.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please select duration");
                              } else {
                                _loadBookingListData();
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please filup details");
                            }
                          })
                    ],
                  ),
                ),
              ))
            ],
          )),
        );
  }

    Scaffold tabletView(BuildContext context) {
    return Scaffold(
          backgroundColor: whiteColor,
          body: SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              TabletCustomToolbar(
                  onTap: () {
                    Get.back();
                  },
                  title: "Edit Offer"),
              SizedBox(
                height: 16.h,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Obx(
                        () => tabletCodeTextField(context),
                      ),
                      Obx(() => SizedBox(
                            height: variable.offerCodeSelected.value == true
                                ? 12.h
                                : 0.h,
                          )),
                      tabletDiscountTypeTextField(),
                      tabletDiscountValueTextField(context),
                      Obx(
                        () => SizedBox(
                          height: variable.discountValueSelected.value == true
                              ? 12.h
                              : 0.h,
                        ),
                      ),
                      tabletMaxDiscountAmountTextField(context),
                      Obx(
                        () => SizedBox(
                          height:
                              variable.discountAmountSelected.value == true
                                  ? 12.h
                                  : 0.h,
                        ),
                      ),
                      tabletUserLimitTextField(),
                      Obx(
                        () => SizedBox(
                          height: variable.userlimitSelected.value == true
                              ? 12.h
                              : 0.h,
                        ),
                      ),
                      tabletTimePickerTextField(context),
                      SizedBox(
                        height: 12.h,
                      ),
                      tabletDescriptionsTextField(),
                      Obx(
                        () => SizedBox(
                          height: variable.descriptionsSelected.value == true
                              ? 12.h
                              : 0.h,
                        ),
                      ),
                      tabletTermsAndConditionsTextField(),
                      Obx(
                        () => SizedBox(
                          height: variable.turf_AboutSelected.value == true
                              ? 44.h
                              : 28.h,
                        ),
                      ),
                      TabletCustomeButton(
                          title: "Update",
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (variable.startDate.isEmpty &&
                                  variable.endDate.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please select duration");
                              } else {
                                _loadBookingListData();
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please filup details");
                            }
                          })
                    ],
                  ),
                ),
              ))
            ],
          )),
        );
  }

  Obx termsAndConditionsTextField() {
    return Obx(() => AppBigTextFiled(
          lebel: "Terms & Conditions ",
          controller: variable.turf_AboutController.value,
          focusNode: variable.turf_AboutFocusNode.value,
          selected: variable.turf_AboutSelected.value,
          onSubmitt: (value) {},
          validator: (value) {
            if (value!.isEmpty) {
              variable.turf_AboutSelected.value = false;
              return "Please Enter your Turf name";
            } else if (variable.turf_AboutController.value.text.length < 4 &&
                value.length < 4) {
              variable.turf_AboutSelected.value = false;
              return "Please enter 4 charter";
            } else {
              variable.turf_AboutSelected.value = true;
              return null;
            }
          },
        ));
  }

    Obx tabletTermsAndConditionsTextField() {
    return Obx(() => TabletAppBigTextFiled(
          lebel: "Terms & Conditions ",
          controller: variable.turf_AboutController.value,
          focusNode: variable.turf_AboutFocusNode.value,
          selected: variable.turf_AboutSelected.value,
          onSubmitt: (value) {},
          validator: (value) {
            if (value!.isEmpty) {
              variable.turf_AboutSelected.value = false;
              return "Please Enter your Turf name";
            } else if (variable.turf_AboutController.value.text.length < 4 &&
                value.length < 4) {
              variable.turf_AboutSelected.value = false;
              return "Please enter 4 charter";
            } else {
              variable.turf_AboutSelected.value = true;
              return null;
            }
          },
        ));
  }

  Obx descriptionsTextField() {
    return Obx(
      () => AppTextFiled(
        controller: variable.descriptionsController.value,
        focusNode: variable.descriptionsFocusNode.value,
        selected: variable.descriptionsSelected.value,
        lebel: "Descriptions",
        onSubmitt: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            variable.descriptionsSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.descriptionsController.value.text.length < 4 &&
              value.length < 4) {
            variable.descriptionsSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.descriptionsSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  
  Obx tabletDescriptionsTextField() {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.descriptionsController.value,
        focusNode: variable.descriptionsFocusNode.value,
        selected: variable.descriptionsSelected.value,
        lebel: "Descriptions",
        onSubmitt: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            variable.descriptionsSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.descriptionsController.value.text.length < 4 &&
              value.length < 4) {
            variable.descriptionsSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.descriptionsSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Padding timePickerTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: textFiledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Date",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        variable.startDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime customDate =
                        DateTime.parse(widget.couponList.startAt!);
                    var expiresAt =
                        await _selectDate(context, customDate: customDate);
                    variable.startDate.value = DateFormat('yyyy-MM-dd')
                        .format(expiresAt ?? customDate);
                    variable.startDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a')
                            .format(expiresAt ?? customDate);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg"),
                )
              ],
            ),
          )),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: textFiledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expired Date",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        variable.endDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime customDate =
                        DateTime.parse(widget.couponList.expiresAt!);
                    var expiresAt =
                        await _selectDate(context, customDate: customDate);
                    variable.endDate.value = DateFormat('yyyy-MM-dd')
                        .format(expiresAt ?? customDate);
                    variable.endDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a')
                            .format(expiresAt ?? customDate);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg"),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
  
  Padding tabletTimePickerTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: textFiledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Date",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        variable.startDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime customDate =
                        DateTime.parse(widget.couponList.startAt!);
                    var expiresAt =
                        await _selectDate(context, customDate: customDate);
                    variable.startDate.value = DateFormat('yyyy-MM-dd')
                        .format(expiresAt ?? customDate);
                    variable.startDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a')
                            .format(expiresAt ?? customDate);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg",height: 16.h,width: 16.w,),
                )
              ],
            ),
          )),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: textFiledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expired Date",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        variable.endDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime customDate =
                        DateTime.parse(widget.couponList.expiresAt!);
                    var expiresAt =
                        await _selectDate(context, customDate: customDate);
                    variable.endDate.value = DateFormat('yyyy-MM-dd')
                        .format(expiresAt ?? customDate);
                    variable.endDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a')
                            .format(expiresAt ?? customDate);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg",height: 16.h,width: 16.w,),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  Obx userLimitTextField() {
    return Obx(
      () => AppTextFiled(
        controller: variable.userlimitController.value,
        focusNode: variable.userlimitFocusNode.value,
        selected: variable.userlimitSelected.value,
        lebel: "User limit",
        onSubmitt: (value) {
          // FocusScope.of(context).requestFocus(
          //     variable.turf_LocationFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.userlimitSelected.value = false;
            return "Please Enter your Discount Value";
          } else {
            variable.userlimitSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

    Obx tabletUserLimitTextField() {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.userlimitController.value,
        focusNode: variable.userlimitFocusNode.value,
        selected: variable.userlimitSelected.value,
        lebel: "User limit",
        onSubmitt: (value) {
          // FocusScope.of(context).requestFocus(
          //     variable.turf_LocationFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.userlimitSelected.value = false;
            return "Please Enter your Discount Value";
          } else {
            variable.userlimitSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx maxDiscountAmountTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.discountAmountController.value,
        focusNode: variable.discountAmountFocusNode.value,
        selected: variable.discountAmountSelected.value,
        lebel: "Max Discount Amount ",
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.userlimitFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.discountAmountSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.discountAmountController.value.text.length < 2 &&
              value.length < 2) {
            variable.discountAmountSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.discountAmountSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

    Obx tabletMaxDiscountAmountTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.discountAmountController.value,
        focusNode: variable.discountAmountFocusNode.value,
        selected: variable.discountAmountSelected.value,
        lebel: "Max Discount Amount ",
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.userlimitFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.discountAmountSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.discountAmountController.value.text.length < 2 &&
              value.length < 2) {
            variable.discountAmountSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.discountAmountSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx discountValueTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.discountValueController.value,
        focusNode: variable.discountValueFocusNode.value,
        selected: variable.discountValueSelected.value,
        lebel: "Discount Value",
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.discountAmountFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.discountValueSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.discountValueController.value.text.length < 2 &&
              value.length < 2) {
            variable.discountValueSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.discountValueSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

    Obx tabletDiscountValueTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.discountValueController.value,
        focusNode: variable.discountValueFocusNode.value,
        selected: variable.discountValueSelected.value,
        lebel: "Discount Value",
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.discountAmountFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.discountValueSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.discountValueController.value.text.length < 2 &&
              value.length < 2) {
            variable.discountValueSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.discountValueSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Stack discountTypeTextField() {
    return Stack(
      children: [
        DropdownButtonFormField(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: appColor,
                letterSpacing: 0,
                wordSpacing: 0,
                fontFamily: fontFamily),
            decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              filled: true,
              fillColor: textFiledColor,
              constraints: BoxConstraints(minHeight: 65.h),
              contentPadding: EdgeInsets.only(
                left: 16.w,
                top: 16.h,
                bottom: 16.h
              ),
            ),
            validator: (value) => value == null ? "Select a country" : null,
            dropdownColor: textFiledColor,
            value: dropdownItems
                    .any((item) => item.value == variable.selectedValue.value)
                ? variable.selectedValue.value
                : null,
            onChanged: (String? newValue) {
              variable.selectedValue.value = newValue!;
            },
            items: dropdownItems),
        Positioned(
            left: 32.w,
            top: 3.h,
            child: Text(
              "Discount Type",
              style: label_text_style,
            )),
      ],
    );
  }

  Stack tabletDiscountTypeTextField() {
    return Stack(
      children: [
        DropdownButtonFormField(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          iconSize: 24.h,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: appColor,
                letterSpacing: 0,
                wordSpacing: 0,
                fontFamily: fontFamily),
            decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              filled: true,
              fillColor: textFiledColor,
              constraints: BoxConstraints(minHeight: 65.h),
            contentPadding:
                  EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h,right: 16.w),
            ),
            validator: (value) => value == null ? "Select a country" : null,
            dropdownColor: textFiledColor,
            value: dropdownItems
                    .any((item) => item.value == variable.selectedValue.value)
                ? variable.selectedValue.value
                : null,
            onChanged: (String? newValue) {
              variable.selectedValue.value = newValue!;
            },
            items: dropdownItems),
        Positioned(
            left: 32.w,
            top: 3.h,
            child: Text(
              "Discount Type",
              style: label_text_style,
            )),
      ],
    );
  }

  AppTextFiled codeTextField(BuildContext context) {
    return AppTextFiled(
      controller: variable.offerCodeController.value,
      focusNode: variable.offerCodeFocusNode.value,
      selected: variable.offerCodeSelected.value,
      lebel: "Code",
      onSubmitt: (value) {
        FocusScope.of(context)
            .requestFocus(variable.discountValueFocusNode.value);
      },
      validator: (value) {
        if (value!.isEmpty) {
          variable.offerCodeSelected.value = false;
          return "Please Enter your Code";
        } else if (variable.offerCodeController.value.text.length < 4 &&
            value.length < 4) {
          variable.offerCodeSelected.value = false;
          return "Please enter 4 charter";
        } else {
          variable.offerCodeSelected.value = true;
          return null;
        }
      },
    );
  }

    TabletAppTextFiled tabletCodeTextField(BuildContext context) {
    return TabletAppTextFiled(
      controller: variable.offerCodeController.value,
      focusNode: variable.offerCodeFocusNode.value,
      selected: variable.offerCodeSelected.value,
      lebel: "Code",
      onSubmitt: (value) {
        FocusScope.of(context)
            .requestFocus(variable.discountValueFocusNode.value);
      },
      validator: (value) {
        if (value!.isEmpty) {
          variable.offerCodeSelected.value = false;
          return "Please Enter your Code";
        } else if (variable.offerCodeController.value.text.length < 4 &&
            value.length < 4) {
          variable.offerCodeSelected.value = false;
          return "Please enter 4 charter";
        } else {
          variable.offerCodeSelected.value = true;
          return null;
        }
      },
    );
  }

  _loadBookingListData() async {
    var body = {
      "couponId": widget.couponList.sId,
      "code": variable.offerCodeController.value.text.toString(),
      "discountType":
          variable.selectedValue.value.toString(), // percentage, flat
      "discountValue": variable.discountValueController.value.text.toString(),
      "maxDiscountAmount":
          variable.discountAmountController.value.text.toString(),
      "userLimit": variable.userlimitController.value.text.toString(),
      "startAt": variable.startDateTime.value.toString(),
      "expiresAt": variable.endDateTime.value.toString(),
      "description": variable.descriptionsController.value.text.toString()
    };

    await variable.turfCreateCouponData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      // List<dynamic> turfListJson =
      //     variable.baseResponse.value.data!["couponList"];
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (co) => TurfOfferScreen()));
      // variable.turfCouponList.value =
      //     turfListJson.map((json) => CouponList.fromJson(json)).toList();
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
  }

  Future<DateTime?> _selectDate(BuildContext context,
      {DateTime? customDate}) async {
    final DateTime initialDate =
        customDate ?? variable.selectedDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != variable.selectedDate) {
      variable.selectedDate = picked;
    }
    return picked;
  }
}

    // try {
    //   final response = await api.apiPostCall(
    //     context,
    //     "owner/coupon-add-update",
    //     body: {
    //       "couponId": widget.couponList.sId,
    //       "code": variable.offerCodeController.value.text.toString(),
    //       "discountType":
    //           variable.selectedValue.value.toString(), // percentage, flat
    //       "discountValue":
    //           variable.discountValueController.value.text.toString(),
    //       "maxDiscountAmount":
    //           variable.discountAmountController.value.text.toString(),
    //       "userLimit": variable.userlimitController.value.text.toString(),
    //       "startAt": variable.startDateTime.value.toString(),
    //       "expiresAt": variable.endDateTime.value.toString(),
    //       "description":
    //           variable.descriptionsController.value.text.toString()
    //     },
    //     headers: {
    //       'Content-type': 'application/json',
    //       "Authorization": "Bearer $authToken",
    //       "app-version": "1.0",
    //       "app-platform": Platform.isIOS ? "ios" : "android"
    //     },
    //   );
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {

    //     // ignore: unnecessary_string_interpolations
    //     Fluttertoast.showToast(msg: "${responseData.response}");
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (co) => TurfOfferScreen()));
    //     Get.delete<editCoupen>();
    //     // List<dynamic> turfListJson = responseData.data!["turfBookingList"];

    //     // variable.turfBookingList.value =
    //     //     turfListJson.map((json) => TurfBookingList.fromJson(json)).toList();
  
    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;
   
    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {
 
    //   loading.value = false;
    // }