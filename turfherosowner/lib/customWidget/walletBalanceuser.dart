// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';

class UserDetailsWidget extends StatelessWidget {
  String userName,date,turfName;
  double payAmount,ownerPoint;
   UserDetailsWidget({
   super.key,
   required this.userName,
   required this.date,
   required this.turfName,
   required this.payAmount,
   required this.ownerPoint
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(10.r),
              color: Colors.greenAccent),
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                   userName,
                    style:
                        walletTransitions_text_style,
                  ),
                  Text(
                    "$date - $turfName",
                    style: label_text_style,
                    overflow:
                        TextOverflow.ellipsis,
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "+$payAmount",
                    style:
                        walletTransitions_amount_text_style,
                  ),
                  Text(
                    "+$ownerPoint",
                    style:
                        walletReward_amount_text_style,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class TabletUserDetailsWidget extends StatelessWidget {
  String userName,date,turfName;
  double payAmount,ownerPoint;
   TabletUserDetailsWidget({
   super.key,
   required this.userName,
   required this.date,
   required this.turfName,
   required this.payAmount,
   required this.ownerPoint
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 45.h,
          width: 35.w,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(10.r),
              color: Colors.greenAccent),
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                   userName,
                    style:
                        TabletAppstyle.walletTransitions_text_style,
                  ),
                  Text(
                    "$date - $turfName",
                    style: label_text_style,
                    overflow:
                        TextOverflow.ellipsis,
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "+$payAmount",
                    style:
                        TabletAppstyle.walletTransitions_amount_text_style,
                  ),
                  Text(
                    "+$ownerPoint",
                    style:
                         TabletAppstyle.walletReward_amount_text_style,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}