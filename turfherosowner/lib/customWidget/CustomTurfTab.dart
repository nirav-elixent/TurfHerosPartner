// ignore_for_file: must_be_immutable, file_names, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';

class CustomTurfTab extends StatelessWidget {
  VoidCallback onTap;
  String image, turfName;
  String rating;
  String totalRating;
  String turfKM;
  CustomTurfTab({
    required this.onTap,
    required this.image,
    required this.turfName,
    required this.rating,
    required this.totalRating,
    required this.turfKM,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ("images $image");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.w,
        height: double.maxFinite,
        margin: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                  color: greyColor.withAlpha(60),
                  offset: Offset.fromDirection(
                    1,
                  ),
                  blurRadius: 0.3,
                  spreadRadius: 0.1)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r)),
                  child: Image.network(
                    "${ApiService.baseUrl}/$image",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/images/turf_image.png",
                          fit: BoxFit.cover);
                    },
                  )),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 7.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 65.w,
                          child: Text(
                            "$turfKM KMaway",
                            style: locationAway_text_style,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: SvgPicture.asset(
                                  "assets/images/star_image.svg"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                rating,
                                style: turfName_text_style,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          turfName,
                          style: turfName_text_style,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
