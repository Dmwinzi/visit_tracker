import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../DI/Locator.dart';
import '../../Domain/Entities/ActivityEntity.dart';
import '../../Domain/Entities/CustomerEntiy.dart';
import '../../Domain/Entities/VisitingEntity.dart';
import '../../Domain/Usecases/Visitusecase.dart';

class VisitController extends GetxController {
  final VisitUseCases usecase = locator.get<VisitUseCases>();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool submitLoading = false.obs;

  RxList<CustomerEntity> customers = <CustomerEntity>[].obs;
  RxList<VisitEntity> visits = <VisitEntity>[].obs;
  RxList<ActivityEntity> activities = <ActivityEntity>[].obs;

  RxString searchQuery = ''.obs;
  RxnInt selectedActivityId = RxnInt(null);

  RxBool hasLoadedActivities = false.obs;

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
    if (hasLoadedActivities.value) return;

    try {
      isLoading.value = true;
      final result = await usecase.getActivities();
      activities.assignAll(result);

      if (activities.isNotEmpty && selectedActivityId.value == null) {
        selectedActivityId.value = activities.first.id;
      }

      hasLoadedActivities.value = true;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitVisit(VisitEntity visit) async {
    try {
      submitLoading.value = true;
      await usecase.addVisit(visit);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      submitLoading.value = false;
    }
  }

  List<VisitEntity> get filteredVisits {
    if (searchQuery.value.isEmpty) return visits;
    final query = searchQuery.value.toLowerCase();
    return visits.where((visit) {
      return visit.location.toLowerCase().contains(query) ||
          visit.notes.toLowerCase().contains(query) ||
          visit.status.toLowerCase().contains(query) ||
          visit.visitDate.toString().contains(query);
    }).toList();
  }
}
