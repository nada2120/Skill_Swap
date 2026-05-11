import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/core/theme/app_palette.dart';

class ProfileMentorHeader extends StatelessWidget {
  final String image;
  final String name;
  final String track;
  final double rate;

  const ProfileMentorHeader({
    super.key,
    required this.image,
    required this.name,
    required this.track,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppPalette.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: (){
                  Get.back();
                }
            ),
            const SizedBox(width: 4),
            ClipOval(
              child: Image.asset(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$track Developer • ",
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 14, color: Color(0xFFFFCE31)),
                          const SizedBox(width: 4),
                          Text(
                            "$rate",
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      ///////////////////////////////
      Container(
        width: double.infinity,
        color: AppPalette.primary,
        height: 216,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16,),
            ClipOval(
              child: Image.asset(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              "$track Developer",
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 14, color: Color(0xFFFFCE31)),
                const SizedBox(width: 4),
                Text(
                  "$rate",
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
    );
  }
}


