/*
 * Created or updated by Deepak Gupta on 01/03/24, 11:25 am
 *  Copyright (c) 2024 . All rights reserved for Ask Qx Lab.
 * Last modified 01/03/24, 11:25 am
 */

import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/model/error_model.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/repository/app_repository.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/widgets/custom_form_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class SessionManagerBottomSheet extends StatefulWidget {
  final String password;
  const SessionManagerBottomSheet({super.key,this.password = ''});

  @override
  State<SessionManagerBottomSheet> createState() => _SessionManagerBottomSheetState();
}

class _SessionManagerBottomSheetState extends State<SessionManagerBottomSheet> {

  var unit = ["Day","Hour","Minute","Second"];

  var selectedAccessUnit = "Hour";
  var selectedRefreshUnit = "Hour";

  var accessTokenExTime = 2.0.obs;
  var refreshTokenExTime = 3.0.obs;
  var isLoading = false.obs;


  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> AbsorbPointer(
        absorbing: isLoading.value,
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Session Manager(Expiry Time)",
                      style: TextStyle(
                        color: getTextColor(),
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.highlight_remove),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 0,
                thickness: 0.5,
              ),
              const SizedBox(height: 10),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(top: 16),
                  alignment: Alignment.centerLeft,
                  child: Text("Access Token",style: textStyle(),)
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: unit.map((e){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            selected: selectedAccessUnit == e,
                            label: Text(e, style: textStyle()),
                            onSelected: (v) {
                              setState(() {
                                selectedAccessUnit = e;
                                accessTokenExTime(minMax.start);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    Slider(
                      min: minMax.start,
                      max: minMax.end,
                      value: accessTokenExTime.value,
                      label: accessTokenExTime.value.toStringAsFixed(0),
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          accessTokenExTime(value);
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${minMax.start.ceil()}",style: textStyle(size: 12,color: Colors.grey),),
                          Text("${minMax.end.ceil()}",style: textStyle(size: 12,color: Colors.grey),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(top: 16),
                  alignment: Alignment.centerLeft,
                  child: Text("Refresh Token",style: textStyle(),)
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: unit.map((e){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            selected: selectedRefreshUnit == e,
                            label: Text(e, style: textStyle()),
                            onSelected: (v) {
                              setState(() {
                                selectedRefreshUnit = e;
                                refreshTokenExTime(minMaxRefresh.start+1);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    Slider(
                      min: minMaxRefresh.start,
                      max: minMaxRefresh.end,
                      value: refreshTokenExTime.value,
                      label: refreshTokenExTime.value.toStringAsFixed(0),
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          refreshTokenExTime(value);
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${minMaxRefresh.start.ceil()}",style: textStyle(size: 12,color: Colors.grey),),
                          Text("${minMaxRefresh.end.ceil()}",style: textStyle(size: 12,color: Colors.grey),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              CustomFormButton(
                innerText: "Submit",
                isLoading: isLoading.value,
                onPressed:call,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  RangeValues get minMax {
    switch(selectedAccessUnit){
      case "Day":
        return const RangeValues(1, 7);
      case "Hour":
        return const RangeValues(1, 24);
      case "Minute":
        return const RangeValues(5, 60);
      case "Second":
        return const RangeValues(60, 600);
      default:
        return const RangeValues(5, 10);
    }
  }

  RangeValues get minMaxRefresh {
    switch(selectedRefreshUnit){
      case "Day":
        return const RangeValues(1, 10);
      case "Hour":
        return const RangeValues(1, 24);
      case "Minute":
        return const RangeValues(5, 60);
      case "Second":
        return const RangeValues(60, 600);
      default:
        return const RangeValues(5, 10);
    }
  }

  void call(){
    isLoading(true);
    AppRepository().updateToken(
          "${accessTokenExTime.ceil()}${selectedAccessUnit[0].toLowerCase()}",
          "${refreshTokenExTime.ceil()}${selectedRefreshUnit[0].toLowerCase()}",
          widget.password,
        ).then((value) {
          isLoading(false);
          if(value['success']){
            Get.back();
            AppStorage.setToken(value['data']['tokens']['accessToken']);
            AppStorage.setRefreshToken(value['data']['tokens']['refreshToken']);
            ErrorHandle.success("Expiry time updated successfully");
          }else{
            final error = ErrorModel.fromJson(value['error']);
            ErrorHandle.error(error.toString());
          }
    }, onError: (e) {
      isLoading(false);
      ErrorHandle.error(e);
    });
  }

}
