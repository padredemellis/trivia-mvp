import 'package:get_it/get_it.dart';
import 'package:mvp/data/repositories/player_repository.dart';
import 'package:mvp/data/repositories/game_session_repository.dart';
import 'package:mvp/data/repositories/node_repository.dart';
import 'package:mvp/data/repositories/question_repository.dart';
import 'package:mvp/domain/use-cases/start_node_use_case.dart';
import 'package:mvp/domain/use-cases/answer_question_use_case.dart';
import 'package:mvp/domain/use-cases/lose_life_use_case.dart';
import 'package:mvp/domain/use-cases/complete_node_use_case.dart';
import 'package:mvp/domain/use-cases/update_game_session_use_case.dart';
import 'package:mvp/domain/engine/game_engine.dart';
import 'package:mvp/data/models/player.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // 1. REPOSITORIOS
  sl.registerLazySingleton(() => PlayerRepository());
  sl.registerLazySingleton(() => GameSessionRepository());
  sl.registerLazySingleton(() => NodeRepository());
  sl.registerLazySingleton(() => QuestionRepository());

  // 2. USE CASES
  sl.registerLazySingleton(() => StartNodeUseCase(sl(), sl(), sl()));
  sl.registerLazySingleton(() => AnswerQuestionUseCase());
  sl.registerLazySingleton(() => LoseLifeUseCase());
  sl.registerLazySingleton(() => CompleteNodeUseCase(sl(), sl()));
  sl.registerLazySingleton(() => UpdateGameSessionUseCase(sl()));

  // 3. ENGINE (Lo registramos como un Singleton)
  // Nota: El Engine pide un Player inicial. Para el MVP, crearemos uno vacío
  // o lo registraremos cuando el usuario haga Login.
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
