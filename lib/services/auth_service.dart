import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';

class AuthService{

  ///login
  static Future<bool> login({
    required String phone,
    required String password,
  })async{

    try{

      final response=
      await ApiClient.dio.post(
        '/auth/login',
        data:{
          'phone':phone,
          'password':password,
        },
      );

      final data=response.data;

      if(data['success']!=true){
        return false;
      }

      await _saveUserData(
        data['data'],
      );

      return true;

    }on DioException catch(e){

      throw Exception(
        e.response?.data['message']??
            'Login failed',
      );

    }catch(e){

      throw Exception(
        'Unexpected login error',
      );
    }
  }

  ///register
  static Future<bool> register({
    required String name,
    required String phone,
    required String password,
  })async{

    try{

      final response=
      await ApiClient.dio.post(
        '/auth/register',
        data:{
          'name':name,
          'phone':phone,
          'password':password,
        },
      );

      final data=response.data;

      if(data['success']!=true){
        return false;
      }

      await _saveUserData(
        data['data'],
      );

      return true;

    }on DioException catch(e){

      throw Exception(
        e.response?.data['message']??
            'Register failed',
      );

    }catch(e){

      throw Exception(
        'Unexpected register error',
      );
    }
  }

  ///save user data
  static Future<void> _saveUserData(
      Map<String,dynamic> data,
      )async{

    final prefs=
    await SharedPreferences.getInstance();

    await prefs.setString(
      'token',
      data['token']??'',
    );

    await prefs.setString(
      'role',
      data['role']??'',
    );

    await prefs.setInt(
      'userId',
      data['userId']??0,
    );

    await prefs.setString(
      'name',
      data['name']??'',
    );

    await prefs.setString(
      'phone',
      data['phone']??'',
    );
  }

  ///check login
  static Future<bool> isLoggedIn()async{

    final prefs=
    await SharedPreferences.getInstance();

    final token=
    prefs.getString('token');

    return token!=null&&token.isNotEmpty;
  }

  ///get token
  static Future<String?> getToken()async{

    final prefs=
    await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  ///get role
  static Future<String?> getRole()async{

    final prefs=
    await SharedPreferences.getInstance();

    return prefs.getString('role');
  }

  ///get user id
  static Future<int?> getUserId()async{

    final prefs=
    await SharedPreferences.getInstance();

    return prefs.getInt('userId');
  }

  ///get name
  static Future<String?> getName()async{

    final prefs=
    await SharedPreferences.getInstance();

    return prefs.getString('name');
  }

  ///get phone
  static Future<String?> getPhone()async{

    final prefs=
    await SharedPreferences.getInstance();

    return prefs.getString('phone');
  }

  ///logout
  static Future<void> logout()async{

    final prefs=
    await SharedPreferences.getInstance();

    await prefs.clear();
  }
}