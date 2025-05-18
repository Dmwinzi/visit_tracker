// visit_repository_impl_test.dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:visits_tracker/Data/Models/Visitsmodel.dart';
import 'package:visits_tracker/Data/RepoImpl/VisitRepoImplementation.dart';

import 'visit_repository_impl_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late VisitRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = VisitRepositoryImpl(mockDio);
  });

  group('VisitRepositoryImpl', () {
    // getCustomers tests
    test('get customers returns list of customers', () async {

      final mockResponseData = [
        {'id': 1, 'name': 'Customer A', 'created_at': '2025-05-01T12:00:00Z'},
        {'id': 2, 'name': 'Customer B', 'created_at': '2025-05-02T12:00:00Z'},
      ];

      final response = Response(
        requestOptions: RequestOptions(path: '/customers'),
        data: mockResponseData,
        statusCode: 200,
      );

      when(mockDio.get('/customers')).thenAnswer((_) async => response);

      final customers = await repository.getCustomers();

      expect(customers.length, 2);
      expect(customers[0].id, 1);
      expect(customers[0].name, 'Customer A');
      expect(customers[1].id, 2);
      expect(customers[1].name, 'Customer B');
    });


    test('get customers throws Exception', () async {
      when(mockDio.get('/customers', options: anyNamed('options')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/customers')));

      expect(() => repository.getCustomers(), throwsA(isA<Exception>()));
    });

    // getVisits tests
    test('get visits returns list of visits', () async {
      final mockResponseData = [
        {
          'id': 1,
          'customer_id': 1,
          'visit_date': '2025-05-18T12:00:00Z',
          'status': 'completed',
          'location': 'Location A',
          'notes': 'Notes here',
          'activities_done': ['1', '2'],
          'created_at': '2025-05-17T12:00:00Z',
        }
      ];

      final response = Response(
        requestOptions: RequestOptions(path: '/visits'),
        data: mockResponseData,
        statusCode: 200,
      );

      when(mockDio.get('/visits', options: anyNamed('options')))
          .thenAnswer((_) async => response);

      final visits = await repository.getVisits();

      expect(visits.length, 1);
      expect(visits[0].id, 1);
      expect(visits[0].customerId, 1);
      expect(visits[0].status, 'completed');
      expect(visits[0].location, 'Location A');
      expect(visits[0].notes, 'Notes here');
      expect(visits[0].activitiesDone, [1, 2]);
      expect(visits[0].createdAt, DateTime.parse('2025-05-17T12:00:00Z'));
    });


    test('get visits throws Exception', () async {
      when(mockDio.get('/visits', options: anyNamed('options')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/visits')));

      expect(() => repository.getVisits(), throwsA(isA<Exception>()));
    });

    // getActivities tests
    test('get activities returns list of activities', () async {
      final mockResponseData = [
        {
          'id': 1,
          'description': 'Activity A',
          'created_at': '2025-05-17T12:00:00Z'
        },
        {
          'id': 2,
          'description': 'Activity B',
          'created_at': '2025-05-17T12:05:00Z'
        },
      ];

      final response = Response(
        requestOptions: RequestOptions(path: '/activities'),
        data: mockResponseData,
        statusCode: 200,
      );

      when(mockDio.get('/activities', options: anyNamed('options')))
          .thenAnswer((_) async => response);

      final activities = await repository.getActivities();

      expect(activities.length, 2);
      expect(activities[0].id, 1);
      expect(activities[0].description, 'Activity A');
      expect(activities[0].createdAt, DateTime.parse('2025-05-17T12:00:00Z'));
    });


    test('getActivities throws Exception', () async {
      when(mockDio.get('/activities', options: anyNamed('options')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/activities')));

      expect(() => repository.getActivities(), throwsA(isA<Exception>()));
    });

    // addVisit tests
    test('add visit successfully', () async {
      final visitModel = VisitModel(
        id: 1,
        customerId: 1,
        visitDate: DateTime.parse('2025-05-18T12:00:00Z'),
        status: 'completed',
        location: 'Location A',
        notes: 'Notes here',
        activitiesDone: [1, 2],
        createdAt: DateTime.parse('2025-05-17T12:00:00Z'),
      );

      when(mockDio.post(
        '/visits',
        data: visitModel.toJson(),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/visits'),
        statusCode: 201,
      ));

      await repository.addVisit(visitModel);

      verify(mockDio.post(
        '/visits',
        data: visitModel.toJson(),
        options: anyNamed('options'),
      )).called(1);
    });

    test('addVisit throws Exception', () async {
      final visitModel = VisitModel(
        id: 1,
        customerId: 1,
        visitDate: DateTime.parse('2025-05-18T12:00:00Z'),
        status: 'completed',
        location: 'Location A',
        notes: 'Notes here',
        activitiesDone: [1, 2],
        createdAt: DateTime.parse('2025-05-17T12:00:00Z'),
      );

      when(mockDio.post(
        '/visits',
        data: visitModel.toJson(),
        options: anyNamed('options'),
      )).thenThrow(DioException(requestOptions: RequestOptions(path: '/visits')));

      expect(() => repository.addVisit(visitModel), throwsA(isA<Exception>()));
    });
  });
}
