import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_responsive.dart';

import '../../../../shared/common_ui/circle_button_icon.dart';
import '../../../../shared/core/theme/app_palette.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 108,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppPalette.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
                  children: [
                    CircleButtonIcon(icon: Icons.arrow_back_ios, onTap: () {Get.back();},),
                    SizedBox(width: 8,),
                    Text(
                      title,
                      style:  TextStyle(
                        color: Color(0xFFD6D6D6),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
      ),
    );
    // return// Stack(
    //   //children: [
    //     Container(
    //       height: 96,
    //       decoration:  BoxDecoration(color: AppColor.mainColor),
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Column(
    //           children: [
    //            // SizedBox(height: 16),
    //             Row(
    //               children: [
    //                 CircleButtonIcon(icon: Icons.arrow_back_ios, onTap: () {Get.back();},),
    //                 SizedBox(width: 8,),
    //                 Text(
    //                   title,
    //                   style:  TextStyle(
    //                     color: AppColor.grayColor,
    //                     fontSize: 22,
    //                     fontWeight: FontWeight.w600,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             //SizedBox(height: 8),
    //           ],
    //         ),
    //       ),
    //     );
    //     // AppBar(
    //     //   backgroundColor: Colors.transparent,
    //     //   elevation: 0,
    //     //   title: Text(
    //     //     title,
    //     //     style:  TextStyle(
    //     //       color: AppColor.grayColor,
    //     //       fontSize: 22,
    //     //       fontWeight: FontWeight.w600,
    //     //     ),
    //     //   ),
    //     //   leading: CircleButtonIcon(icon: Icons.arrow_back_ios, onTap: () {Get.back();},)
    //     //   // IconButton(
    //     //   //   icon: const Icon(Icons.arrow_back, color: Color(0xFFF2F5F8),),
    //     //   //   onPressed: () => Navigator.pop(context),
    //     //   // ),
    //     // ),
    //   //],
    // //);
  }
}
