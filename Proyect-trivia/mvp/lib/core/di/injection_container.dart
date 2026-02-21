import 'package:get_it/get_it.dart';
import 'package:mvp/data/repositories/player_repository.dart';
import 'package:mvp/data/repositories/game_session_repository.dart';
import 'package:mvp/data/repositories/node_repository.dart';
import 'package:mvp/data/repositories/question_repository.dart';
import 'package:mvp/data/repositories/auth_repository.dart';
import 'package:mvp/domain/use-cases/start_node_use_case.dart';
import 'package:mvp/domain/use-cases/answer_question_use_case.dart';
import 'package:mvp/domain/use-cases/lose_life_use_case.dart';
import 'package:mvp/domain/use-cases/complete_node_use_case.dart';
import 'package:mvp/domain/use-cases/update_game_session_use_case.dart';
import 'package:mvp/domain/use-cases/login_use_case.dart';
import 'package:mvp/domain/engine/game_engine.dart';
import 'package:mvp/data/models/player.dart';

/// Instancia global del Service Locator (GetIt).
/// 
/// Se utiliza para acceder a las dependencias de la aplicación desde cualquier punto
/// sin necesidad de instanciarlas manualmente, facilitando el desacoplamiento.
final sl = GetIt.instance;

/// Inicializa y registra todas las dependencias de la aplicación.
Future<void> init() async {
  
  final sl = GetIt.instance; // sl = Service Locator

  // REPOSITORIOS
  sl.registerLazySingleton(() => PlayerRepository());
  sl.registerLazySingleton(() => GameSessionRepository());
  sl.registerLazySingleton(() => NodeRepository());
  sl.registerLazySingleton(() => QuestionRepository());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // USE CASES
  sl.registerLazySingleton(() => StartNodeUseCase(sl(), sl(), sl()));
  sl.registerLazySingleton(() => AnswerQuestionUseCase());
  sl.registerLazySingleton(() => LoseLifeUseCase());
  sl.registerLazySingleton(() => CompleteNodeUseCase(sl(), sl()));
  sl.registerLazySingleton(() => UpdateGameSessionUseCase(sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

  //  ENGINE
  sl.registerLazySingleton(
    () => GameEngine(
      initialPlayer: Player(userId: 'guest_user'), // ID temporal hasta el Login
      startNodeUC: sl(),
      answerQuestionUC: sl(),
      loseLifeUC: sl(),
      completeNodeUC: sl(),
      updateSessionUC: sl(),
    ),
  );
}
