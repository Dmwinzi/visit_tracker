import 'package:get/get.dart';
import 'package:visits_tracker/Domain/Usecases/Visitusecase.dart';

import '../../DI/Locator.dart';
import '../../Domain/Entities/ActivityEntity.dart';
import '../../Domain/Entities/CustomerEntiy.dart';
import '../../Domain/Entities/VisitingEntity.dart';

class VisitController extends GetxController {

  final VisitUseCases usecase;

  VisitController(this.usecase);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var customers = <CustomerEntity>[].obs;
  var visits = <VisitEntity>[].obs;
  var activities = <ActivityEntity>[].obs;

  Future<void> loadCustomers() async {
    try {
      isLoading.value = true;
      final result = await usecase.getCustomers();
      customers.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadVisits() async {
    try {
      isLoading.value = true;
      final result = await usecase.getVisits();
      visits.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadActivities() async {
    try {
      isLoading.value = true;
      final result = await usecase.getActivities();
      activities.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitVisit(VisitEntity visit) async {
    try {
      isLoading.value = true;
      await usecase.addVisit(visit);
      await loadVisits();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
