import 'package:dio/dio.dart';
import 'package:visits_tracker/Domain/Repository/Visitrepository.dart';

import '../../Utils/ErrorHandler.dart';
import '../Models/ActivityModel.dart';
import '../Models/CustomerModel.dart';
import '../Models/Visitsmodel.dart';

class VisitRepositoryImpl implements VisitRepository {
  final Dio dio;

  VisitRepositoryImpl(this.dio);

  @override
  Future<List<CustomerModel>> getCustomers() async {
    try {
      final response = await dio.get('/customers',);
      final List data = response.data;
      return data.map((json) => CustomerModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (_) {
      throw Exception('Failed to load customers.');
    }
  }

  @override
  Future<List<VisitModel>> getVisits() async {
    try {
      final response = await dio.get('/visits');
      final List data = response.data;
      return data.map((json) => VisitModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (_) {
      throw Exception('Failed to load visits.');
    }
  }

  @override
  Future<List<ActivityModel>> getActivities() async {
    try {
      final response = await dio.get(
        '/activities'
      );
      final List data = response.data;
      return data.map((json) => ActivityModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (_) {
      throw Exception('Failed to load activities.');
    }
  }

  @override
  Future<void> addVisit(VisitModel visit) async {
    try {
      await dio.post(
        '/visits',
        data: visit.toJson()
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (_) {
      throw Exception('Failed to add visit.');
    }
  }
}
