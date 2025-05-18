import '../../Data/Models/ActivityModel.dart';
import '../../Data/Models/CustomerModel.dart';
import '../../Data/Models/Visitsmodel.dart';

abstract class VisitRepository {
  Future<List<CustomerModel>> getCustomers();
  Future<List<VisitModel>> getVisits();
  Future<List<ActivityModel>> getActivities();
  Future<void> addVisit(VisitModel visit);
}