---

# Documentación Técnica del MVP – Juego de Trivia "Beast Quiz" (Versión 1.1.0)

## Descripción del sistema

**Por:**

* Sofía Nuñez
* Martín Suarez
* Ignacio Cabrera
* Emanuel Romero

## Introducción

Este documento describe el diseño técnico del MVP (Producto Mínimo Viable) de un juego de trivia desarrollado con Flutter y Firebase. Su objetivo es definir de forma clara cómo está pensado el sistema, qué funcionalidades incluye, cómo se organiza internamente y por qué se tomaron determinadas decisiones.

La documentación sirve como guía para el equipo de desarrollo, permitiendo entender la estructura del sistema antes de programarlo y reduciendo errores durante la implementación.

---

## Objetivo del MVP

El objetivo del sistema es ofrecer un juego de trivia interactivo, escalable y fácil de mantener, que permita a los usuarios responder preguntas, registrar puntajes y mejorar su experiencia mediante una interfaz intuitiva.

Además, este sistema busca ofrecer una forma interactiva y estructurada de aprendizaje mediante un juego de preguntas, combinando mecánicas de progreso y motivación.

Elegimos las siguientes funcionalidades claves:

* Autenticación segura de usuarios (Google Sign-In).
* Mapa de nodos con progresión simple.
* Preguntas organizadas por tema.
* Sistema de puntos y vidas.
* Sistema anti-repetición de preguntas.
* Persistencia del progreso en la nube (Firestore).

# Requisitos del sistema

La definición de requisitos permite comprender qué debe hacer el sistema antes de describir su arquitectura, asegurando una mejor organización del diseño.

### Requisitos funcionales:

El sistema debe permitir:

- Iniciar una partida de trivia.
- Mostrar preguntas con múltiples opciones de respuesta.
- Registrar la respuesta seleccionada por el jugador.
- Calcular el puntaje del jugador.
- Mostrar los resultados al finalizar la partida.
- Almacenar preguntas y respuestas en la base de datos.
- Gestionar la lógica del juego mediante el motor de juego.

### Requisitos no funcionales

El sistema debe cumplir con los siguientes criterios:

- **Usabilidad:** la interfaz debe ser simple e intuitiva para el usuario.
- **Rendimiento:** respuestas rápidas del sistema. En menos de dos segundos.
- **Escalabilidad:** posibilidad de agregar más preguntas y funciones sin afectar su funcionamiento.
- **Mantenibilidad:** código modular que facilite futuras modificaciones.
- **Portabilidad:** la aplicación debe poder ejecutarse en diferentes dispositivos móviles gracias al uso de Flutter.

### Justificación del alcance

Se decidió limitar el alcance del MVP para:

* **Validar el flujo base (Auth + Gameplay):** Asegurar que un usuario pueda loguearse, jugar y que su progreso se guarde correctamente antes de añadir mecánicas sociales.
* **Reducir la complejidad técnica inicial:** Evitando sobrecargar el desarrollo con funcionalidades avanzadas como tiendas o rankings globales online.
* **Facilitar la escalabilidad:** Dejar la arquitectura (Clean Architecture) preparada para que nuevas funcionalidades se añadan como "Casos de Uso" sin romper el código existente.

### Funcionalidades fuera del MVP

* Ranking global online.
* Preguntas generadas por IA.
* Tienda avanzada de cosméticos.
* Sistema social (creación de paquetes de preguntas por usuarios).

**Justificación:**
Separar el alcance permite concentrarse en el núcleo del juego y evitar sobrecargar el desarrollo con funciones que no son esenciales para validar la mecánica principal y la estabilidad de la persistencia de datos.

---

## Concepto del juego y Flujo

**Inicio (Auth) -> Mapa de nodos -> Selecciona nodo -> Pregunta -> correcta/incorrecta -> evaluar vidas/progreso -> Mapa**

### Estados del juego (FSM)

El flujo se controla mediante una Máquina de Estados Finitos (FSM) con los siguientes estados definidos en `GameState`:
`idle` → `loading` → `navigating` → `playing` → `gameOver` / `nodeCompleted`

**Fundamentación del concepto y estado del juego:**
El diseño de este flujo se basa en tres principios:

1. **Simplicidad cognitiva:** El jugador entiende rápidamente qué hacer: loguearse, elegir un nodo, responder.
2. **Feedback inmediato y Persistente:** El jugador sabe al instante si acertó, y sabe que su progreso está seguro en la nube gracias a su cuenta.
3. **Control estricto de UI:** Utilizamos un modelo formal de estados (FSM) gestionado por el `GameEngine` porque:
* Evita inconsistencias visuales (ej. que el usuario toque dos veces "jugar" mientras carga).
* Facilita el enrutamiento mediante el `GameOrchestrator`, que simplemente "reacciona" al estado actual.
* Reduce los errores de navegación clásicos de Flutter (`Navigator.push` anidados).



---

## Reglas del MVP

**Nodos y Temas:**

* 30 nodos en total (1 tema por nodo, 3 preguntas por nodo).
* Temas populares (Cine, Videojuegos, Cultura General).
* **Justificación:** Ofrece contenido suficiente para generar sensación de progreso sin agotar la base de datos de preguntas prematuramente.

**Mecánica de avance y Vidas:**

* El jugador inicia con **3 vidas** persistidas en su perfil.
* Respuesta correcta → +10 puntos, avanza en el nodo.
* Respuesta incorrecta → Pierde 1 vida, nueva pregunta.
* Vidas a 0 → Estado `gameOver`, se limpia la sesión activa, vuelve al menú.
* **Justificación:** Implementar vidas y puntajes anclados al perfil del usuario autenticado eleva el nivel de "riesgo/recompensa", aumentando la retención frente a un sistema sin penalizaciones.

**Sistema anti-repetición:**

* Las preguntas mostradas se guardan en la `GameSession` actual.
* **Justificación:** Mejora la experiencia evitando contenido repetitivo. Al vincular la sesión al `userId`, el jugador puede cerrar la app, volver a abrirla y el sistema sabrá exactamente qué preguntas ya vio en ese intento.

---

## Historias de Usuario (MoSCoW)

### Must Have (obligatorias)

* **Como jugador**, quiero iniciar sesión con mi cuenta de Google para que mi progreso quede guardado en la nube de forma segura.
* **Como sistema**, quiero crear un perfil automático para los jugadores nuevos para evitar flujos de registro manuales.
* **Como jugador**, quiero ver un mapa con nodos para elegir niveles y entender mi progreso.
* **Como jugador**, quiero recibir feedback inmediato de mis respuestas.

### Should Have (importantes)

* Como jugador, quiero obtener recompensas (monedas/puntos) al completar nodos para sentir motivación.
* Como sistema, quiero limpiar las sesiones de juego abandonadas para optimizar la base de datos.

### Won't Have (fuera del MVP)

* Como jugador, quiero personalizar mi personaje con objetos de una tienda.
* Como jugador, quiero recuperar vidas viendo anuncios.

**Justificación:**
La priorización alinea los esfuerzos técnicos con el valor real aportado al usuario. La inclusión de la autenticación en los *Must Have* es vital, ya que sin ella, la persistencia en la nube pierde sentido al no poder identificar a quién pertenecen los datos.

---

## Arquitectura del Sistema

### Descripción general y Evolución

El proyecto nació con una visión MVC, pero **evolucionó a Clean Architecture**. Se divide en tres capas estrictas:

1. **Presentation Layer (UI):** Widgets, Pantallas (`Home`, `MapScreen`) y el `GameOrchestrator`.
2. **Domain Layer (Reglas):** Entidades (`Player`, `Node`), Casos de Uso (`LoginUseCase`, `StartNodeUseCase`) y el `GameEngine` (Gestor de estado).
3. **Data Layer (Infraestructura):** Repositorios (`AuthRepository`, `PlayerRepository`) y la conexión a Firebase.

### El Módulo de Autenticación (Novedad v1.2.0)

Se integró Google Sign-In respetando la arquitectura:

* `AuthRepository` (Data): Habla con los SDKs de Google y FirebaseAuth. Crea el documento del usuario en Firestore si es nuevo.
* `LoginUseCase` (Domain): Es llamado por la UI. Ejecuta la validación y devuelve las credenciales.
* `Home` (Presentation): Muestra el `CircularProgressIndicator` (`_isLoading`) mientras espera el resultado, y luego inyecta el `Player` en el `GameEngine`.

### Justificación Arquitectónica (De MVC a Clean Architecture)

Se abandonó el patrón MVC porque, a medida que el juego creció (sumando sesiones, vidas y autenticación externa), los controladores centralizaban demasiada lógica y se volvían difíciles de mantener.

**Beneficios de la arquitectura actual:**

* **Desacoplamiento total:** La pantalla `Home` no sabe que usamos Google o Firebase; solo sabe que llama a `LoginUseCase` y recibe un jugador. Si mañana cambiamos Google por Apple Sign-In, la UI no se toca.
* **Testabilidad:** Cada caso de uso (ej. `LoseLifeUseCase`) se puede probar de forma unitaria y aislada.
* **Single Source of Truth:** El `GameEngine` mantiene un estado inmutable (`GameEngineState`). Toda la app reacciona a este único flujo de datos, eliminando bugs de desincronización visual.

---

### Diagramas para nuestro MVP

El uso de diagramas UML y de flujo nos permite representar el sistema desde diferentes perspectivas: estructural, dinámica y de comportamiento. Cada diagrama cumple un rol específico para validar nuestras decisiones de diseño antes y durante la implementación.

# 1. Diagrama de Arquitectura en Capas

Muestra la separación de alto nivel del sistema en tres capas principales (Presentation, Domain, Data) y su conexión con servicios externos (Firebase / Google Auth).
Es el mapa fundamental de nuestra Clean Architecture. Lo incluimos para evidenciar que se respeta la "Regla de Dependencia": la interfaz gráfica (UI) nunca accede directamente a la base de datos (Data/External), garantizando un sistema modular y fácilmente testeable.

Fragmento de código
flowchart TD
    UI[Presentation Layer]
    Domain[Domain Layer]
    Data[Data Layer]
    External[(Firebase / Google Auth)]

    UI --> Domain
    Domain --> Data
    Data --> External

# 2. Diagrama de Componentes – Presentation Layer
Detalla cómo se estructura la interfaz gráfica, mostrando al GameOrchestrator como el nodo central que enruta a las diferentes pantallas (HomeScreen, MapScreen, TriviaScreen).
Lo incluimos para explicar a cualquier desarrollador frontend que la navegación en nuestro juego no es imperativa (no hacemos Navigator.push directamente en los botones de juego), sino reactiva. El orquestador "reacciona" al estado del motor y dibuja la pantalla correspondiente.

Fragmento de código
flowchart TD
    GameOrchestrator
    HomeScreen
    MapScreen
    TriviaScreen

    GameOrchestrator --> HomeScreen
    GameOrchestrator --> MapScreen
    GameOrchestrator --> TriviaScreen

# 3. Diagrama de Componentes – Domain Layer
Visualiza el núcleo lógico del juego. Muestra cómo el GameEngine orquesta a los distintos Casos de Uso (Use Cases) en lugar de ejecutar la lógica por sí mismo.
Este diagrama justifica el uso del principio de Responsabilidad Única (SRP). En lugar de tener un "God Object" (un motor de juego gigante y frágil), dividimos las acciones en casos de uso aislados. Esto permite modificar la forma en que se pierde una vida (LoseLifeUseCase) sin afectar la forma en que se validan las respuestas (AnswerQuestionUseCase).

Fragmento de código
flowchart TD
    GameEngine

    LoginUseCase
    StartNodeUseCase
    AnswerQuestionUseCase
    LoseLifeUseCase
    CompleteNodeUseCase
    UpdateGameSessionUseCase

    GameEngine --> StartNodeUseCase
    GameEngine --> AnswerQuestionUseCase
    GameEngine --> LoseLifeUseCase
    GameEngine --> CompleteNodeUseCase
    GameEngine --> UpdateGameSessionUseCase
    
    %% Nota: LoginUseCase es llamado directo por la UI, no por el Engine, pero pertenece al Dominio.

# 4. Diagrama de Clases del Dominio
Representa las entidades principales del juego (Player, Node, Question, GameSession) y cómo se relacionan conceptualmente entre sí.
Lo pusimos para establecer el "vocabulario ubicuo" del proyecto. Es vital para entender la separación intencional entre Player y GameSession. El Player guarda datos permanentes (identidad, vidas, puntaje global), mientras que la GameSession guarda datos volátiles (el intento actual, preguntas mostradas). Esto permite recuperar partidas interrumpidas sin "ensuciar" el perfil del jugador.

Fragmento de código
classDiagram
    class Player {
        String userId
        String name
        int lives
        int coins
        int points
        List completedNodes
        List unlockedNodes
    }

    class Node {
        String nodeId
        String title
        String description
        String difficulty
        List poolQuestionIds
        int questionsToShow
        int rewardCoins
        String requiredNodeId
    }

    class Question {
        String questionId
        String text
        List options
        String correctAnswer
        String category
        String questionType
    }

    class GameSession {
        String sessionId
        String userId
        String currentNodeId
        int correctCount
        int incorrectCount
        List questionsShownIds
        Map answersGiven
        int attemptNumber
        DateTime createdAt
        DateTime lastUpdated
    }

    Player --> GameSession
    Node --> GameSession
    Question --> GameSession

# 5. Diagrama de Estados (FSM del GameEngine)
Modela el comportamiento del juego como una Máquina de Estados Finitos (FSM), mostrando todos los estados posibles del GameState y las acciones que provocan transiciones entre ellos.
Se incluyó para eliminar la ambigüedad en el flujo de la aplicación. Al formalizar los estados, evitamos bugs críticos (por ejemplo, que el usuario intente responder una pregunta mientras el estado es loading). Hace que el sistema sea predecible y matemáticamente testeable.

Fragmento de código
stateDiagram-v2
    [*] --> idle

    idle --> loading : Login / startNode()
    
    loading --> navigating : Auth Success
    loading --> playing : nodeLoaded

    playing --> playing : answerCorrect / answerIncorrect

    playing --> gameOver : lives == 0
    playing --> nodeCompleted : lastQuestionAnswered

    gameOver --> navigating : resetGame()
    nodeCompleted --> navigating : returnToMap()
    
    navigating --> idle : mapLoaded

# 6. Diagrama de Secuencia – Flujo de Autenticación (Login)
Describe el paso a paso cronológico desde que el usuario toca el botón de "PLAY" hasta que el motor de juego recibe el jugador autenticado y lo manda al mapa.
El login es un proceso asíncrono crítico que involucra múltiples capas (UI, Domain, Data) y servicios externos (Google). Este diagrama se incluyó para asegurar que el equipo entienda que el estado de "cargando" y la búsqueda en la base de datos deben resolverse antes de inyectar al Player en el motor.

Fragmento de código
sequenceDiagram
    participant UI as HomeScreen
    participant LoginUseCase
    participant AuthRepository
    participant PlayerRepository
    participant GameEngine

    UI->>LoginUseCase: call()
    LoginUseCase->>AuthRepository: signInWithGoogle()
    AuthRepository-->>LoginUseCase: UserCredential
    LoginUseCase-->>UI: UserCredential
    UI->>PlayerRepository: getPlayer(uid)
    PlayerRepository-->>UI: Player (Existente o Nuevo)
    UI->>GameEngine: setAuthenticatedPlayer(Player)
    UI->>GameEngine: goToMap()

# 7. Diagrama de Secuencia – Inicio de Nodo
Explica cómo el sistema carga un nivel en específico, coordinando la obtención del nodo, la selección aleatoria de preguntas y la creación de la sesión en la base de datos.
Demuestra la complejidad que el StartNodeUseCase abstrae del GameEngine. Justifica la existencia de este caso de uso, ya que debe orquestar tres repositorios distintos (NodeRepository, QuestionRepository, GameSessionRepository) para preparar el escenario del juego de forma asíncrona.

Fragmento de código
sequenceDiagram
    participant UI
    participant GameEngine
    participant StartNodeUseCase
    participant NodeRepository
    participant QuestionRepository
    participant GameSessionRepository

    UI->>GameEngine: startNode(nodeId)
    GameEngine->>StartNodeUseCase: execute(nodeId, player)
    StartNodeUseCase->>NodeRepository: getNode(nodeId)
    StartNodeUseCase->>QuestionRepository: getQuestions()
    StartNodeUseCase->>GameSessionRepository: createSession()
    StartNodeUseCase-->>GameEngine: node + session + questions
    GameEngine-->>UI: update state (playing)

# 8. Diagrama de Secuencia – Responder Pregunta
Muestra la interacción cuando el usuario elige una opción: validación de la respuesta, actualización de la sesión en la nube, posible pérdida de vida y emisión del nuevo estado.
Representa el "core loop" (bucle principal) de la trivia. Lo incluimos para justificar la separación de la lógica de evaluación (AnswerQuestionUseCase) de la lógica de castigo (LoseLifeUseCase). Además, muestra que la persistencia ocurre en cada paso, evitando pérdida de progreso si la app se cierra inesperadamente.

Fragmento de código
sequenceDiagram
    participant UI
    participant GameEngine
    participant AnswerQuestionUseCase
    participant LoseLifeUseCase
    participant UpdateGameSessionUseCase

    UI->>GameEngine: answerQuestion(option)
    GameEngine->>AnswerQuestionUseCase: execute(question, option)
    AnswerQuestionUseCase-->>GameEngine: isCorrect
    
    GameEngine->>UpdateGameSessionUseCase: execute(updatedSession)
    
    alt isIncorrect == true
        GameEngine->>LoseLifeUseCase: execute(player)
        LoseLifeUseCase-->>GameEngine: updatedPlayer (lives - 1)
    end
    
    GameEngine-->>UI: emit(updated state)

# 9. Diagrama de Secuencia – Finalización de Nodo
Muestra qué sucede al responder la última pregunta de un nivel: cálculo de puntos y monedas, actualización del perfil en Firestore y limpieza de la sesión activa.
Evidencia cómo se consolida el progreso volátil en progreso permanente. Se incluyó para justificar por qué se borra la GameSession (GameSessionRepository: delete session); esto es una decisión de arquitectura para evitar que la base de datos se llene de "sesiones basura" una vez que el nivel fue completado con éxito.

Fragmento de código
sequenceDiagram
    participant GameEngine
    participant CompleteNodeUseCase
    participant PlayerRepository
    participant GameSessionRepository

    GameEngine->>CompleteNodeUseCase: execute(player, session, node)
    CompleteNodeUseCase->>PlayerRepository: update player
    CompleteNodeUseCase->>GameSessionRepository: delete session
    CompleteNodeUseCase-->>GameEngine: rewards & updatedPlayer
    GameEngine-->>UI: emit(nodeCompleted)

# 10. Diagrama Interno del GameEngineState
Detalla la estructura exacta del objeto de estado inmutable que el GameEngine emite constantemente a la interfaz gráfica.
En una arquitectura reactiva, el estado es la única fuente de la verdad para la vista. Este diagrama justifica qué información tiene disponible la UI en cualquier momento dado, demostrando que la interfaz no necesita calcular nada, solo leer propiedades como currentQuestionIndex o isLoading.

Fragmento de código
classDiagram
    class GameEngineState {
        Player player
        GameState status
        Node? currentNode
        GameSession? currentSession
        List~Question~ currentQuestions
        int currentQuestionIndex
        bool isLoading
        String? errorMessage
        int coinsEarned
        int pointsEarned
    }

    class Player
    class Node
    class GameSession
    class Question
    class GameState

    GameEngineState --> Player
    GameEngineState --> Node
    GameEngineState --> GameSession
    GameEngineState --> Question
    GameEngineState --> GameState
# 11. Diagrama de Dependencias entre Use Cases
Mapea claramente qué casos de uso interactúan con qué repositorios, y cómo el motor los consume.
Sirve como mapa de Inyección de Dependencias (DI). Lo incluimos para justificar por qué ciertos casos de uso (como AnswerQuestionUseCase o LoseLifeUseCase) son clasificados como "Lógica Pura" (Pure logic) que no tocan repositorios; esto los hace ultrarrápidos y facilita escribir tests unitarios sin necesidad de "mockear" bases de datos.

Fragmento de código
flowchart TD
    GameEngine

    LoginUseCase
    StartNodeUseCase
    AnswerQuestionUseCase
    LoseLifeUseCase
    CompleteNodeUseCase
    UpdateGameSessionUseCase

    AuthRepository
    PlayerRepository
    NodeRepository
    QuestionRepository
    GameSessionRepository

    %% GameEngine orchestration
    GameEngine --> StartNodeUseCase
    GameEngine --> AnswerQuestionUseCase
    GameEngine --> LoseLifeUseCase
    GameEngine --> CompleteNodeUseCase
    GameEngine --> UpdateGameSessionUseCase

    %% UseCase dependencies
    LoginUseCase --> AuthRepository

    StartNodeUseCase --> NodeRepository
    StartNodeUseCase --> QuestionRepository
    StartNodeUseCase --> GameSessionRepository

    AnswerQuestionUseCase -.-> |Pure logic| None
    LoseLifeUseCase -.-> |Pure logic| None

    CompleteNodeUseCase --> PlayerRepository
    CompleteNodeUseCase --> GameSessionRepository

    UpdateGameSessionUseCase --> GameSessionRepository

# 12. Diagrama Completo – Clean Architecture Integrada
Es la "foto completa" del sistema. Une la Interfaz, el Dominio, los Datos y las dependencias externas en un solo flujo jerárquico.
Justifica la solidez de la arquitectura al mostrar visualmente que la UI y la Base de Datos están en los extremos opuestos del espectro, comunicándose de manera limpia y unidireccional a través del centro lógico (Dominio).

Fragmento de código
flowchart TB
    %% Presentation Layer
    subgraph Presentation Layer
        UI[Flutter Screens]
        GameOrchestrator
    end

    %% Domain Layer
    subgraph Domain Layer
        GameEngine
        GameEngineState
        LoginUseCase
        StartNodeUseCase
        AnswerQuestionUseCase
        LoseLifeUseCase
        CompleteNodeUseCase
        UpdateGameSessionUseCase
        Player
        Node
        Question
        GameSession
    end

    %% Data Layer
    subgraph Data Layer
        AuthRepository
        PlayerRepository
        NodeRepository
        QuestionRepository
        GameSessionRepository
    end

    %% External
    subgraph External
        Firestore[(Firebase Firestore)]
        GoogleAuth[(Google Identity)]
    end

    %% Dependencies
    UI --> GameOrchestrator
    UI --> LoginUseCase
    GameOrchestrator --> GameEngine

    LoginUseCase --> AuthRepository

    GameEngine --> StartNodeUseCase
    GameEngine --> AnswerQuestionUseCase
    GameEngine --> LoseLifeUseCase
    GameEngine --> CompleteNodeUseCase
    GameEngine --> UpdateGameSessionUseCase

    StartNodeUseCase --> NodeRepository
    StartNodeUseCase --> QuestionRepository
    StartNodeUseCase --> GameSessionRepository

    CompleteNodeUseCase --> PlayerRepository
    CompleteNodeUseCase --> GameSessionRepository
    
    UpdateGameSessionUseCase --> GameSessionRepository

    AuthRepository --> GoogleAuth
    AuthRepository --> Firestore
    PlayerRepository --> Firestore
    NodeRepository --> Firestore
    QuestionRepository --> Firestore
    GameSessionRepository --> Firestore

# 13. Diseño de la Base de Datos (Firestore ER Diagram)
Define la estructura de las colecciones NoSQL (Users, nodes, questions, game_sessions), sus propiedades y cómo se relacionan lógicamente mediante sus identificadores (IDs).
Es esencial para entender cómo se organizan los datos en la nube para maximizar el rendimiento. La separación en colecciones individuales evita el uso de "documentos gigantes anidados", optimizando los costos de lectura en Firebase. Además, justifica el uso del UID de Google Auth como llave primaria (PK) en la colección USERS, permitiendo lecturas directas ultra-rápidas al iniciar sesión.

Fragmento de código
erDiagram
    %% Relaciones lógicas (Referencias por ID)
    USERS ||--o{ GAME_SESSIONS : "posee (userId)"
    NODES ||--o{ GAME_SESSIONS : "se juega en (currentNodeId)"
    NODES }|--|{ QUESTIONS : "agrupa (poolQuestionIds)"

    %% Estructura de la colección Users / players
    USERS {
        string id PK "UID de Google Auth"
        string name "Nombre del jugador"
        int lives "Vidas restantes (default: 3)"
        int coins "Monedas acumuladas"
        int points "Puntos totales"
        array completedNodes "Lista de IDs de nodos completados"
        array unlockedNodes "Lista de IDs de nodos disponibles"
        timestamp createdAt "Fecha de creación"
        timestamp updatedAt "Última actualización"
    }

    %% Estructura de la colección nodes
    NODES {
        string nodeId PK "Identificador único"
        string title "Título del tema"
        string description "Descripción del nodo"
        string difficulty "Dificultad"
        array poolQuestionIds "IDs de preguntas disponibles"
        int questionsToShow "Cantidad a mostrar por partida"
        int rewardCoins "Premio por completar"
        string requiredNodeId "Nodo previo requerido"
    }

    %% Estructura de la colección questions
    QUESTIONS {
        string questionId PK "Identificador único"
        string text "Texto de la pregunta"
        array options "Lista de 4 opciones"
        string correctAnswer "Respuesta correcta"
        string category "Categoría temática"
        string questionType "Tipo de pregunta (ej. múltiple)"
    }

    %% Estructura de la colección game_sessions
    GAME_SESSIONS {
        string sessionId PK "Identificador de la partida"
        string userId FK "Referencia al jugador"
        string currentNodeId FK "Referencia al nodo actual"
        int correctCount "Respuestas correctas"
        int incorrectCount "Respuestas incorrectas"
        array questionsShownIds "Evita repetir en la sesión"
        map answersGiven "Registro de {questionId: booleano}"
        int attemptNumber "Número de intento en este nodo"
        timestamp createdAt "Inicio de sesión"
        timestamp lastUpdated "Última interacción"
    }
---

## Especificación de Operaciones Internas (Casos de Uso)

En lugar de endpoints de API tradicionales, nuestro sistema móvil utiliza **Use Cases** interactuando con Firestore:

* `LoginUseCase`: Autentica y asegura la creación del perfil.
* `StartNodeUseCase`: Obtiene el nodo, extrae las preguntas y crea la sesión.
* `AnswerQuestionUseCase`: Comprueba la veracidad de la opción elegida.
* `UpdateGameSessionUseCase`: Envía los contadores actualizados a la nube.

**Justificación:**
Encapsular estas operaciones en Casos de Uso equivale a tener "endpoints internos". Si mañana el juego migra de Firestore a un backend propio (ej. Node.js o Python), **solo se modificarán los repositorios**; los casos de uso y la interfaz seguirán funcionando intactos.

---

## Fundamentación de las tecnologías utilizadas

### 1) Flutter

Elegimos Flutter porque nos permite desarrollar para iOS y Android con un solo código base, priorizando UI reactivas y animaciones fluidas sobre motores gráficos pesados (Godot/Unity) que no son necesarios para una trivia 2D.

### 2) Firebase (Auth + Firestore)

Para un MVP, levantar un backend propio (con JWT, servidores, bases de datos SQL y protección contra ataques) retrasaría el proyecto meses.
**Justificación:** - **Firebase Auth** resuelve la seguridad, gestión de tokens y la integración nativa con Google Sign-In de forma gratuita y escalable.

* **Firestore** nos da persistencia en tiempo real, vital para guardar el estado de la sesión (`GameSession`) tras cada pregunta sin percibir latencia.

---

## Estrategia de Calidad (QA)

**Pruebas Unitarias:**

* Validar que `LoseLifeUseCase` descuente correctamente y dispare "Game Over" cuando corresponda.
* Mock de `AuthRepository` para asegurar que `LoginUseCase` maneje rechazos de inicio de sesión sin crashear la app.

**Pruebas de Integración:**

* Asegurar que al completar un nodo (`CompleteNodeUseCase`), el `PlayerRepository` se actualice en la nube y el `GameSessionRepository` borre la sesión activa.

**Pruebas Manuales:**

* Forzar pérdida de conexión durante el login o al responder una pregunta para validar la robustez de la UI.

**Justificación:**
En un sistema con persistencia remota, el mayor riesgo es la pérdida de sincronización. Enfocar el QA en las transiciones de estado y la validación de guardado garantiza que el jugador no sienta que el juego "le roba" progreso o vidas.

---

## Riesgos y Limitaciones del Proyecto

* **Dependencia de Google Identity:** Si el servicio de Google falla o el usuario no tiene cuenta, no puede jugar. (Mitigación futura: Añadir "Login como Invitado").
* **Costos de Lectura en Firestore:** En la etapa MVP las lecturas son asumibles, pero guardar la `GameSession` por cada pregunta respondida genera muchas escrituras. Si el juego escala masivamente, esta lógica deberá optimizarse (ej. guardando en caché local y sincronizando solo al finalizar el nodo).
* **Manejo de estados asíncronos:** La transición entre la pantalla de Login y el Mapa requiere que los datos del usuario se descarguen correctamente. Redes lentas pueden generar cuellos de botella en la pantalla de carga.

---

## Conclusión

El MVP de "Beast Quiz" ha trascendido el estado de prototipo académico para convertirse en una aplicación con **arquitectura profesional**.

La adopción de Clean Architecture, junto a una FSM (Máquina de Estados) estricta y la integración completa de **Autenticación en la nube**, permite que el juego no solo sea funcional, sino seguro y preparado para escalar. Las decisiones técnicas tomadas protegen el código del "efecto espagueti", asegurando que futuras mecánicas (tiendas, multijugador, torneos) puedan integrarse sobre una base sólida y bien estructurada.