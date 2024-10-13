import 'package:ask_qx/global/app_util.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/colors.dart';


class FollowUsScreen extends StatelessWidget {
  const FollowUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
         title: const Text(
          "Follow Us",
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: kPrimaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "Follow us on your favorite social media platforms to stay up-to-date with our latest news and insights.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Get.isDarkMode?Colors.white54:Colors.black54,
                ),
              ),
            ),
            ListTile(
              onTap: ()=>onLaunch('https://www.linkedin.com/company/qx-lab-ai/'),
              leading: Image.asset('linkedin-fill.png'.toIcon,width: 24,),
              title: const Text('LinkedIn'),
              trailing: const Text('Follow',style: TextStyle(color: Colors.blue,fontSize: 12),),
            ),
            ListTile(
              onTap: ()=>onLaunch('https://twitter.com/QxLabAI'),
              leading: Image.asset('twitter.png'.toIcon,width: 24,color: Get.isDarkMode ?Colors.white: Colors.black,),
              title: const Text('Twitter'),
              trailing: const Text('Follow',style: TextStyle(color: Colors.blue,fontSize: 12),),
            ),
             ListTile(
               onTap: ()=>onLaunch('https://www.instagram.com/qxlabai/'),
              leading: Image.asset('instagram.png'.toIcon,width: 24,),
              title: const Text('Instagram'),
               trailing: const Text('Follow',style: TextStyle(color: Colors.blue,fontSize: 12),),
            ),
            ListTile(
              onTap: () => onLaunch('https://www.facebook.com/QxLabAI'),
              leading: Image.asset('facebook.png'.toIcon,width: 24,),
              title: const Text('Facebook'),
              trailing: const Text('Follow',style: TextStyle(color: Colors.blue,fontSize: 12),),
            ),
            ListTile(
              onTap: () => onLaunch('https://www.youtube.com/@QxLabAI'),
              leading: Image.asset('youtube.png'.toIcon, width: 24),
              title: const Text('Youtube'),
              trailing: const Text('Subscribe',style: TextStyle(color: Colors.blue,fontSize: 12),),
            ),
          ],
        ),
      ),
    );
  }

  void onLaunch(String url) {
    AppUtil.launchAppUrl(url);
  }
}

