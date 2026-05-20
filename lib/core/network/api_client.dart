import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import 'api_endpoints.dart';

class ApiClient{

  ApiClient._();

  ///dio instance
  static final Dio dio=Dio(
    BaseOptions(
      baseUrl:ApiEndpoints.baseUrl,
      connectTimeout:Duration(
        seconds:AppConstants.connectTimeout,
      ),
      receiveTimeout:Duration(
        seconds:AppConstants.receiveTimeout,
      ),
      headers:{
        'Content-Type':'application/json',
      },
    ),
  );

  ///initialize api client
  static Future<void> init()async{

    dio.interceptors.clear();

    dio.interceptors.add(

      InterceptorsWrapper(

        ///before request
        onRequest:(options,handler)async{

          final prefs=
          await SharedPreferences.getInstance();

          final token=
          prefs.getString(
            AppConstants.tokenKey,
          );

          if(token!=null&&token.isNotEmpty){

            options.headers['Authorization']=
            'Bearer $token';
          }

          handler.next(options);
        },

        ///response
        onResponse:(response,handler){

          handler.next(response);
        },

        ///error handling
        onError:(error,handler)async{

          if(error.response?.statusCode==401){

            final prefs=
            await SharedPreferences.getInstance();

            await prefs.clear();
          }

          handler.next(error);
        },
      ),
    );
  }
}