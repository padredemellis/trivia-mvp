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

/// Instancia global del Service Locator (GetIt).
/// 
/// Se utiliza para acceder a las dependencias de la aplicación desde cualquier punto
/// sin necesidad de instanciarlas manualmente, facilitando el desacoplamiento.
final sl = GetIt.instance;

/// Inicializa y registra todas las dependencias de la aplicación.
Future<void> init() async {
  
  // --- 1. REPOSITORIOS ---
  /// Se registran como LazySingletons para que la instancia solo se cree 
  /// cuando se necesite por primera vez y se mantenga en memoria.
  sl.registerLazySingleton(() => PlayerRepository());
  sl.registerLazySingleton(() => GameSessionRepository());
  sl.registerLazySingleton(() => NodeRepository());
  sl.registerLazySingleton(() => QuestionRepository());

  // --- 2. CASOS DE USO (USE CASES) ---
  /// Lógica de negocio pura. Algunos dependen de los repositorios registrados arriba.
  /// Se usa sl() para inyectar automáticamente la dependencia requerida.
  sl.registerLazySingleton(() => StartNodeUseCase(sl(), sl(), sl()));
  sl.registerLazySingleton(() => AnswerQuestionUseCase());
  sl.registerLazySingleton(() => LoseLifeUseCase());
  sl.registerLazySingleton(() => CompleteNodeUseCase(sl(), sl()));
  sl.registerLazySingleton(() => UpdateGameSessionUseCase(sl()));

  // --- 3. GAME ENGINE ---
  /// El motor central del juego. Se registra como Singleton para asegurar
  /// que toda la aplicación comparta el mismo estado de juego.
  /// 
  /// Nota: Requiere un [Player] inicial. En esta etapa de MVP, se usa un usuario
  /// invitado ('guest_user'). En producción, este registro podría moverse
  /// al flujo de autenticación.
  sl.registerLazySingleton(
    () => GameEngine(
      initialPlayer: Player(userId: 'guest_user'), 
      startNodeUC: sl(),
      answerQuestionUC: sl(),
      loseLifeUC: sl(),
      completeNodeUC: sl(),
      updateSessionUC: sl(),
    ),
  );
}