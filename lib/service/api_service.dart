import 'package:dio/dio.dart';
import 'package:alen_solution/model/register_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://absensib1.mobileprojp.com')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST('/api/register')
  Future<RegisterResponseModel> registerUser(
    @Body() RegisterModel registerData,
  );

  // @POST('/api/login')
  // Future<LoginResponseModel> loginUser(@Body() LoginModel loginData);

  // @GET('/api/profile')
  // Future<ProfileModelResponse> getProfile();

  // @POST('/api/absen/check-in')
  // Future<AbsenResponseModel> checkIn(@Body() AbsenRequestModel dataAbsen);
}
