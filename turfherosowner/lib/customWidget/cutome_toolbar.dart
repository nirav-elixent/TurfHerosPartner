// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';

class CustomToolbar extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomToolbar({required this.onTap, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 35.h,
      child: Stack(
        children: [
          Positioned(
            left: 16.r,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 33.h,
                width: 33.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: whiteColor,
                    boxShadow:  [
                      BoxShadow(
                          color: Color(0xff000000),
                          blurRadius: 2.r,
                          spreadRadius: 0.1.r)
                    ]),
                child: Center(
                    child: SvgPicture.asset("assets/images/back_image.svg")),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: Text(
                  textAlign: TextAlign.center,
                  title,
                  style: title_style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class TabletCustomToolbar extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const TabletCustomToolbar({required this.onTap, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 35.h,
      child: Stack(
        children: [
          Positioned(
            left: 16.r,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 33.h,
                width: 24.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: whiteColor,
                    boxShadow:  [
                      BoxShadow(
                          color: Color(0xff000000),
                          blurRadius: 2.r,
                          spreadRadius: 0.1.r)
                    ]),
                child: Center(
                    child: SvgPicture.asset("assets/images/back_image.svg")),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: Text(
                  textAlign: TextAlign.center,
                  title,
                  style: TabletAppstyle.title_style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}