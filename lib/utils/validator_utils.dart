import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppValidatorUtil{

  static String? validateName(String? value,){
    if (value==null || value.isEmpty) {
      return 'Please enter your name';
    } else if (!RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z])?[a-zA-Z]*)*$").hasMatch(value.trim())) {
      return 'Only alphabet characters allowed';
    } else if (value.trim().length < 3 || value.trim().length > 25) {
      return 'Name should be between 3 to 25 characters';
    }
    return null;
  }

  static String? validateFirstName(String? value,String name){
    if (value== null || value.isEmpty) {
      return 'Please enter $name';
    } else if (!RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(value.trim())) {
      return 'Should not contain special symbol & number';
    } else if (value.length < 3 || value.length > 25) {
      return '${name.capitalizeFirst} should be between 3 to 25 characters';
    }
    return null;
  }

  static String? validateEmail(String? value){
      if (value == null || value.isEmpty) {
        return 'Please enter email ID';
      } else if (value.isEmail == false) {
        return 'Please enter valid email ID';
      }
      return null;
  }

  static String? validatePassword(String? value){
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password should be minimum 6 characters';
    } else if (value.length > 25) {
      return 'Password should not be more than 25 characters';
    }
    return null;
  }

   static String? validateEmpty({String? value,required String message}){
     if (value == null || value.isEmpty) {
       return 'Please enter your $message';
     }
    return null;
  }

   static String? validateVerificationCode(String? value){
     if (value == null || value.isEmpty) {
       return 'Please enter verification code';
     }else if(value.trim().length!=6){
       return 'Verification code must be 6 digits';
     }
     return null;
  }

   static String? validatePasswordNotMatch(String? value,String password){
     if (value != password) {
       return 'Password does not match';
     }
     return null;
  }

   static String? validateNewPassword(String? value){
     if (value == null || value.isEmpty) {
       return 'Please enter new password';
     }else if (value.characters.length <= 5) {
       return 'Password should be of minimum 6 characters';
     }
     return null;
   }

   static String? validateConfirmPassword(String? value,String password){
     if (value == null || value.isEmpty) {
       return 'Please enter confirm password';
     }else if (value.characters.length < 6) {
       return 'Password should be of minimum 6 characters';
     } else if (value.characters.length > 25) {
       return 'Password should not be more than 25 characters';
     } else if (value.trim() != password) {
       return 'Password does not match';
     }
     return null;
   }

}