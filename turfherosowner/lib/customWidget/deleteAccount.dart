// ignore_for_file: file_names, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';

class DeleteAccount extends StatelessWidget {
  VoidCallback onPressed;
  DeleteAccount({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      insetPadding: EdgeInsets.zero,
      content: Container(
        height: 155.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: whiteColor),
        width: 330.w,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/delete_image.svg"),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "Delete Account",
                        style: deteleAccountMain_text_style,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      "Are you sure you want to delete account ?",
                      style: deteleAccountSecond_text_style,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, top: 8.h, bottom: 8.h),
                    child: Text(
                      "you will no longer be able to log in or use the account",
                      style: deteleAccountthird_text_style,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 30.h,
                          width: 65.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: whiteColor,
                            border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: deteleButton_text_style,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: onPressed,
                        child: Container(
                          height: 30.h,
                          width: 125.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: redColor,
                            //  border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "Delete Account",
                              style: deteleAccountButtonDailog_text_style,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                right: 5.w,
                top: 5.h,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 30.h,
                    ))),
          ],
        ),
      ),
    );
  }
}

class TabletDeleteAccount extends StatelessWidget {
  VoidCallback onPressed;
  TabletDeleteAccount({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      insetPadding: EdgeInsets.zero,
      content: Container(
        height: 165.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: whiteColor),
        width: 330.w,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/delete_image.svg",
                        height: 20.h,
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "Delete Account",
                        style: TabletAppstyle.deteleAccountMain_text_style,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                    ),
                    child: Text(
                      "Are you sure you want to delete account ?",
                      style: deteleAccountSecond_text_style,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
                    child: Text(
                      "you will no longer be able to log in or use the account",
                      style: deteleAccountthird_text_style,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 35.h,
                          width: 65.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: whiteColor,
                            border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TabletAppstyle.deteleButton_text_style,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: onPressed,
                        child: Container(
                          height: 35.h,
                          width: 125.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: redColor,
                            //  border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "Delete Account",
                              style: TabletAppstyle
                                  .deteleAccountButtonDailog_text_style,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                right: 5.w,
                top: 5.h,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 30.h,
                    ))),
          ],
        ),
      ),
    );
  }
}

class TabletDeleteTurf extends StatelessWidget {
  VoidCallback onPressed;
  String name;
  TabletDeleteTurf({required this.onPressed, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      insetPadding: EdgeInsets.zero,
      content: Container(
        height: 175.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: whiteColor),
        width: 330.w,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/delete_image.svg",
                        height: 20.h,
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "Delete Account",
                        style: TabletAppstyle.deteleAccountMain_text_style,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                    ),
                    child: RichText(
                      text: TextSpan(
                          text: "Are you sure you want to delete ",
                          style: deteleAccountSecond_text_style,
                          children: [
                            TextSpan(
                              text: "$name ?",
                              style: deteleAccountthird_text_style,
                            )
                          ]),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 16.w),
                  //   child: Text(
                  //     name,
                  //     textAlign: TextAlign.center,
                  //     style: deteleAccountthird_text_style,
                  //   ),
                  // ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.w, top: 8.h, bottom: 16.h),
                    child: Text(
                      "This action will be irreversible if you proceed",
                      style: deteleAccountthird_text_style,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 35.h,
                          width: 65.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: whiteColor,
                            border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TabletAppstyle.deteleButton_text_style,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: onPressed,
                        child: Container(
                          height: 35.h,
                          width: 125.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: redColor,
                            //  border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "Delete Turf",
                              style: TabletAppstyle
                                  .deteleAccountButtonDailog_text_style,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                right: 5.w,
                top: 5.h,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 30.h,
                    ))),
          ],
        ),
      ),
    );
  }
}

class DeleteTurf extends StatelessWidget {
  VoidCallback onPressed;
  String name;
  DeleteTurf({required this.onPressed, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      insetPadding: EdgeInsets.zero,
      content: Container(
        height: 150.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: whiteColor),
        width: 330.w,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/delete_image.svg",
                        height: 20.h,
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "Delete Account",
                        style: TabletAppstyle.deteleAccountMain_text_style,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                    ),
                    child: RichText(
                      text: TextSpan(
                          text: "Are you sure you want to delete ",
                          style: deteleAccountSecond_text_style,
                          children: [
                            TextSpan(
                              text: "$name ?",
                              style: deteleAccountthird_text_style,
                            )
                          ]),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 16.w),
                  //   child: Text(
                  //     name,
                  //     textAlign: TextAlign.center,
                  //     style: deteleAccountthird_text_style,
                  //   ),
                  // ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.w, top: 8.h, bottom: 16.h),
                    child: Text(
                      "This action will be irreversible if you proceed",
                      style: deteleAccountthird_text_style,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 35.h,
                          width: 65.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: whiteColor,
                            border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TabletAppstyle.deteleButton_text_style,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: onPressed,
                        child: Container(
                          height: 35.h,
                          width: 125.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: redColor,
                            //  border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "Delete Turf",
                              style: TabletAppstyle
                                  .deteleAccountButtonDailog_text_style,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                right: 5.w,
                top: 5.h,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 30.h,
                    ))),
          ],
        ),
      ),
    );
  }
}