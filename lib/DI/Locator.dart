import 'package:get_it/get_it.dart';
import 'package:visits_tracker/Data/RepoImpl/VisitRepoImplementation.dart';
import 'package:visits_tracker/Domain/Repository/Visitrepository.dart';
import 'package:visits_tracker/Domain/Usecases/Visitusecase.dart';

import '../Data/Services/DioHandler.dart';

var locator = GetIt.instance;

Future<void> Setup() async{

  locator.registerLazySingleton(() => DioHandler.internal());
  locator.registerLazySingleton<VisitRepository>(
        () => VisitRepositoryImpl(locator<DioHandler>().dio),
  );
  locator.registerLazySingleton<VisitUseCases>(
        () => VisitUseCases(locator<VisitRepository>()),
  );

}