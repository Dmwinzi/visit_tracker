

import '../../Data/Models/Visitsmodel.dart';
import '../Entities/ActivityEntity.dart';
import '../Entities/CustomerEntiy.dart';
import '../Entities/VisitingEntity.dart';
import '../Repository/Visitrepository.dart';

class VisitUseCases {
  final VisitRepository repository;

  VisitUseCases(this.repository);

  Future<List<CustomerEntity>> getCustomers() async {
    final customers = await repository.getCustomers();
    return customers.map((c) => CustomerEntity(id: c.id, name: c.name, createdAt: c.createdAt)).toList();
  }

  Future<List<ActivityEntity>> getActivities() async {
    final activities = await repository.getActivities();
    return activities
        .map((a) => ActivityEntity(id: a.id, description: a.description, createdAt: a.createdAt))
        .toList();
  }

  Future<List<VisitEntity>> getVisits() async {
    final visits = await repository.getVisits();
    return visits.map((visit) => VisitEntity(
      id: visit.id,
      customerId: visit.customerId,
      visitDate: visit.visitDate,
      status: visit.status,
      location: visit.location,
      notes: visit.notes,
      activitiesDone: List<int>.from(visit.activitiesDone),
      createdAt: visit.createdAt,
    )).toList();
  }


  Future<void> addVisit(VisitEntity visit) async {
    final visitModel = VisitModel(
      id: visit.id != 0 ? visit.id : null,
      customerId: visit.customerId,
      visitDate: visit.visitDate,
      status: visit.status,
      location: visit.location,
      notes: visit.notes,
      activitiesDone: List<int>.from(visit.activitiesDone),
      createdAt: visit.createdAt,
    );

    await repository.addVisit(visitModel);
  }
}
