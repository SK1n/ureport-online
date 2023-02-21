import 'package:get_it/get_it.dart';
import 'package:ureport_ecaro/data/sp_utils.dart';
import 'package:ureport_ecaro/repository/network_operation/http_service.dart';
import 'package:ureport_ecaro/repository/network_operation/rapidpro_service.dart';
import 'package:ureport_ecaro/view/screens/opinion/opinion_repository.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<SPUtil>(() => SPUtil());
  locator.registerLazySingleton<HttpService>(() => HttpService());
  locator.registerLazySingleton<RapidProService>(() => RapidProService());
  locator.registerLazySingleton<OpinionRepository>(() => OpinionRepository());
}
