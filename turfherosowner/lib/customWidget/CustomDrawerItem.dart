// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import '../const/appTextstyle/AppStyle.dart';

class DrawerItem extends StatelessWidget {
  String image, title;
  VoidCallback onTap;
  DrawerItem({
    required this.image,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.h,
              width: 28.w,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,right: 0,left: 0,bottom: 0,child: SvgPicture.asset(image))
                ],
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: accountDetailsName_text_style,
                  ),
                  SizedBox(
                    height: 4.h,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: SvgPicture.asset("assets/images/forward_grey_image.svg"),
            )
          ],
        ),
      ),
    );
  }
}
class TabletDrawerItem extends StatelessWidget {
  String image, title;
  VoidCallback onTap;
  TabletDrawerItem({
    required this.image,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.h,
              width: 28.w,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,right: 0,left: 0,bottom: 0,child: SvgPicture.asset(image))
                ],
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TabletAppstyle.accountDetailsName_text_style,
                  ),
                  SizedBox(
                    height: 4.h,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: SvgPicture.asset("assets/images/forward_grey_image.svg",height: 12.h,width: 12.w,),
            )
          ],
        ),
      ),
    );
  }
}