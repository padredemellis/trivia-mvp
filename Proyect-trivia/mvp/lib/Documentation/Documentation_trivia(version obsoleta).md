
# Documentación Técnica del MVP – Juego de Trivia

## Descripción del sistema

**Por:**
- Sofía Nuñez
- Martín Suarez
- Ignacio Cabrera
- Emanuel Romero

## Introducción

Este documento describe el diseño técnico del MVP (Producto Mínimo Viable) de un juego de trivia desarrollado con Flutter y Firebase. Su objetivo es definir de forma clara cómo está pensado el sistema, qué funcionalidades incluye, cómo se organiza internamente y por qué se tomaron determinadas decisiones.

La documentación sirve como guía para el equipo de desarrollo, permitiendo entender la estructura del sistema antes de programarlo y reduciendo errores durante la implementación.

## Objetivo del sistema

El objetivo del sistema es ofrecer un juego de trivia interactivo, escalable y fácil de mantener, que permita a los usuarios responder preguntas, registrar puntajes y mejorar su experiencia mediante una interfaz intuitiva.

Además, este sistema busca ofrecer una forma interactiva y estructurada de aprendizaje mediante un juego de preguntas, combinando mecánicas de progreso y motivación.

## Requisitos del sistema

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

## Objetivo del MVP

El objetivo del MVP es construir una trivia funcional que integre mecánicas de juego con una navegación clara y un sistema de progresión simple, y así poder garantizar una experiencia jugable, estable y escalable.

Con el MVP buscamos validar la arquitectura propuesta y la separación entre lógica, interfaz y datos.

Elegimos las siguientes funcionalidades claves:

- Mapa de nodos
- Preguntas organizadas por tema
- Sistema de puntos
- Progresión simple
- Sistema anti-repetición de preguntas

### Justificación del alcance

Se decidió limitar el alcance del MVP para:

- Reducir la complejidad técnica inicial, evitando sobrecargar el desarrollo con funcionalidades avanzadas.
- Priorizar el core del juego: la mecánica principal de preguntas y progresión.
- Garantizar la estabilidad y jugabilidad, antes de agregar características más complejas (como más personajes, un sistema de tienda, preguntas de la comunidad, etc.).
- Facilitar la escalabilidad a futuro, dejando preparada la arquitectura para nuevas funcionalidades.
- Lograr el equilibrio entre front-end y back-end con una interfaz atractiva y una lógica de juego clara pero simple.

### Funcionalidades fuera del MVP

- Ranking global online.
- Preguntas generadas por IA.
- Tienda avanzada.
- Sistema social (los usuarios harán paquetes de temas de preguntas).

### Justificación

Separar el alcance permite concentrarse en el núcleo del juego y evitar sobrecargar el desarrollo con funciones que no son esenciales para validar la idea principal.

## Concepto del juego:

Inicio -> Mapa de nodos -> Selecciona nodo -> Pregunta 1 → correcta → mapa → incorrecta → otra pregunta

### Estados del juego:

HOME → MAP → QUESTION → RESULT → MAP

**Fundamentación del concepto y estado del juego:**

El diseño de este flujo se basa en tres principios:

1. **Simplicidad cognitiva:** El jugador entiende rápidamente qué hacer: entrar al juego, elegir un nodo, responder preguntas.
2. **Feedback inmediato:** Después de cada pregunta el jugador recibe retroalimentación (correcto, incorrecto) lo que permite reforzar el aprendizaje, mantener la motivación y clarificar el progreso.
3. **Modelo mental de progresión:** El mapa de nodos es una representación visual similar a niveles de un juego, mapa de campañas o sistema de misiones.

En cuanto al uso de estados, utilizamos un modelo de estados porque:

a. Nos permite visualizar la lógica del juego de forma clara.
b. Facilita la implementación en Flutter mediante controladores o máquinas de estado.
c. Reduce errores de navegación.
d. Permite escalar el juego agregando nuevos estados (Configuraciones, Tienda, Perfil).

Cada estado representa una fase específica de la experiencia del usuario:

- **HOME:** Punto de entrada y contexto del jugador.
- **MAP:** Selección de contenido y progresión.
- **QUESTION:** Interacción principal del juego.
- **RESULT:** Evaluación de la respuesta y garantía del progreso.

## Reglas del MVP:

**Nodos:**
- 20 nodos
- Cada nodo = 1 tema
- Cada nodo = 3 preguntas

20 nodos ofrecen suficiente contenido para generar sensación de progreso sin complejidad excesiva. 1 tema por nodo asegura coherencia temática y facilita la organización del contenido. 3 preguntas por nodo proporcionan equilibrio entre duración y dificultad, evitando sesiones demasiado largas.

### Mecánica de avance:

- Respuesta correcta → nodo superado
- Respuesta incorrecta → nueva pregunta del mismo nodo
- Si respondes mal las tres preguntas → El juego muestra "Game Over", el puntaje y luego te redirige al menú principal.

**Justificación:** Este diseño evita frustración excesiva, permitiendo al jugador seguir intentando sin penalizaciones severas.

### Temas

Se definieron temas amplios y populares:

- Cine
- Videojuegos
- Cultura general

**Justificación:** Son temas universales y atractivos para un público juvenil. Permiten generar gran cantidad de preguntas y facilitan la expansión futura del contenido.

Cada tema contiene 50 preguntas para garantizar variedad, evitar repetición frecuente y soportar el sistema anti-repetición.

### Sistema de puntos:

- Respuesta correcta: +10 puntos

**Justificación:** Sistema simple y fácil de entender. Permite medir el progreso del jugador y puede ampliarse en el futuro (bonus, combos, dificultad, etc.).

### Sistema anti-repetición:

- Una pregunta no se repite hasta agotar el tema.
- Se guarda en memoria local.

**Justificación:** Mejora la experiencia del usuario evitando contenido repetitivo. Reduce la sensación de "trampa" o aburrimiento. No requiere back-end complejo en el MVP y permite migrar fácilmente a almacenamiento remoto en versiones futuras.

## Historias de Usuario

Las historias de usuario describen las funcionalidades desde el punto de vista del jugador.

### Historias prioritarias (MoSCoW)

**Must Have (obligatorias):**
- Como jugador, quiero ver un mapa con nodos para elegir niveles y entender mi progreso.
- Como jugador, quiero responder preguntas con opciones múltiples para avanzar en el juego.
- Como jugador, quiero recibir feedback inmediato de mis respuestas para aprender y mejorar.
- Como jugador, quiero personalizar mi personaje para sentir el juego como propio.

**Should Have (importantes):**
- Como jugador, quiero obtener recompensas al completar nodos para sentir motivación.
- Como jugador, quiero que mi progreso se guarde automáticamente para continuar luego.

**Could Have (opcionales):**
- Como jugador, quiero ajustar configuraciones del juego para adaptar la experiencia.
- Como jugador, quiero ver logros o estadísticas para medir mi desempeño.

**Won't Have (fuera del MVP):**
- Como jugador, quiero responder preguntas generadas por la comunidad.
- Como jugador, quiero preguntas con distintos niveles de dificultad.

### Justificación

La priorización permite definir qué funciones son esenciales para que el MVP sea jugable y cuáles pueden añadirse en versiones futuras.

## Arquitectura del sistema

### Descripción general

El sistema se organiza en tres capas principales:

- **Capa de presentación (UI):** pantallas y widgets en Flutter.
- **Capa de lógica:** motores del juego y controladores.
- **Capa de datos:** Firebase Firestore y almacenamiento local.

### Estructura de carpetas

La arquitectura propuesta separa responsabilidades:

- **core/:** definiciones globales y estados del juego.
- **models/:** representación de entidades del dominio.
- **engine/:** lógica principal del juego.
- **data/:** fuente de datos.
- **screens/:** interfaz de usuario.
- **widgets/:** componentes reutilizables.
- **controllers/:** coordinación entre UI y lógica.

### Pantallas del MVP

**HomeScreen**
- Elementos: personaje, botón Play, puntos del jugador.

**MapScreen**
- Elementos: lista de nodos (20), nodos bloqueados/desbloqueados, progreso.
- Ejemplo: [Nodo 1 (listo para entrar)] [Nodo 2 (bloqueado)] [Nodo 3 (bloqueado)]

**QuestionScreen**
- Elementos: pregunta, 4 opciones, feedback (correcto/incorrecto).

### Justificación arquitectónica

Se aplica el principio de separación de responsabilidades (Separation of Concerns): UI ≠ lógica de negocio ≠ datos ≠ modelos.

**Beneficios:**
- Código más mantenible.
- Facilita pruebas.
- Permite escalar el proyecto.
- Reduce acoplamiento entre componentes.
- Hace posible migrar a arquitecturas más complejas (Clean Architecture, MVVM, BLoC).

En términos conceptuales, esta arquitectura es una versión simplificada de una arquitectura en capas.

### Fundamentación de las pantallas del MVP

**HomeScreen**
- Elementos: Personaje, botón Play, puntos del jugador.
- Justificación: Introduce al jugador al universo del juego, permite acceso rápido a la acción principal y muestra información clave (puntos).

**MapScreen**
- Elementos: Lista de nodos, nodos bloqueados/desbloqueados, indicador de progreso.
- Justificación: Representa visualmente el avance del jugador, genera motivación mediante desbloqueo progresivo y facilita la selección de contenido.

**QuestionScreen**
- Elementos: Pregunta, 4 opciones, feedback visual.
- Justificación: Es el núcleo del juego. La estructura de 4 opciones es estándar en trivias y el feedback refuerza la experiencia interactiva.

### Elección de MVC

Elegimos MVC porque es una arquitectura clara y fácil de entender, ideal para proyectos de tamaño pequeño o mediano como nuestro MVP.

MVC nos permite separar el sistema en tres partes:
- **Model:** los datos y la lógica del dominio del juego.
- **View:** las pantallas y la interfaz.
- **Controller:** la lógica que conecta la interfaz con el juego.

Esto nos ayuda a organizar mejor el código, evitar mezclar UI con lógica y preparar el proyecto para futuras ampliaciones.

## Diagramas para nuestro MVP

### Casos de uso:

Representa las interacciones entre el usuario y el sistema.

**Actores:**
- Player (Jugador)

**Casos de uso principales:**
- Iniciar juego
- Seleccionar nodo
- Responder pregunta
- Ver resultado
- Obtener puntos
- Progresar en el mapa

**Respuesta incorrecta:**
1. Start Game
2. Select nodo
3. View questions and options
4. Answer question
5. View result
6. Answer question
7. Game Over
8. Home

**Respuesta correcta:**
[Diagrama de flujo para respuesta correcta]

**Justificación:**
El diagrama de casos de uso permite delimitar el alcance funcional del MVP y definir claramente las interacciones entre el jugador y el sistema. Su objetivo es identificar las funcionalidades esenciales del juego y evitar la inclusión de características que no forman parte del core del MVP.

Además, este diagrama sirve como base para la toma de decisiones arquitectónicas, ya que permite priorizar las funcionalidades críticas del gameplay sobre aquellas secundarias. De esta manera, el sistema se diseña a partir de las acciones del usuario, garantizando coherencia entre la experiencia de juego y la implementación técnica.

### Diagrama de Clases

Representa la estructura interna del sistema (modelo de dominio).

**Clases Principales:**

**Player**
La clase Player representa al jugador dentro del sistema. Modela el estado del usuario y almacena información relevante para el desarrollo de la partida. Entre sus atributos se incluyen el puntaje acumulado y la lista de nodos completados, lo que permite medir el progreso del jugador dentro del mapa del juego.

El método answerQuestion representa la acción del jugador al responder una pregunta, permitiendo registrar la interacción con el sistema.

La inclusión de la clase Player en el diagrama responde a la necesidad de separar los datos del jugador de la lógica del juego, lo que facilita la persistencia de información, la escalabilidad del sistema y la posible incorporación de funcionalidades futuras, como perfiles de usuario o rankings. Player no gestionará directamente las preguntas para evitar acoplamiento; se utiliza GameEngine como intermediario.

**Node**
La clase Node representa un nodo del mapa del juego, entendido como una unidad de progreso o nivel. Cada nodo agrupa un conjunto de preguntas asociadas a un tema específico. Sus atributos incluyen un identificador, el tema asociado, la lista de preguntas, el estado de completitud y la categoría correspondiente.

La clase Node permite estructurar el mapa del juego de manera lógica, facilitando la organización del contenido y el control del avance del jugador. Además, su existencia posibilita la implementación de mecánicas de desbloqueo y progresión.

**Question**
La clase Question representa una pregunta del sistema de trivia. Contiene el texto de la pregunta, las opciones de respuesta, la respuesta correcta, el estado de si ha sido respondida y la categoría a la que pertenece.

La separación de la pregunta como entidad independiente permite gestionar el contenido del juego de manera flexible, soportar mecanismos como la selección aleatoria y el sistema anti-repetición, y facilitar la expansión futura del banco de preguntas.

**GameEngine**
La clase GameEngine representa el núcleo de la lógica del juego. Su responsabilidad es implementar las reglas principales del sistema, gestionar el progreso del jugador y coordinar la interacción entre las entidades del dominio.

El método startGame permite inicializar una nueva partida, mientras que updateProgress se encarga de actualizar el estado del juego en función de las acciones del jugador, como el avance en los nodos o la acumulación de puntos.

La separación de GameEngine respecto de otras clases permite concentrar la lógica de negocio en un único componente, evitando la dispersión de reglas en la interfaz de usuario o en las entidades del dominio.

**QuestionEngine**
La clase QuestionEngine encapsula la lógica específica relacionada con la gestión de preguntas. Sus responsabilidades incluyen la selección aleatoria de preguntas y la implementación del sistema anti-repetición.

Los métodos getRandomQuestion y avoidRepetition permiten garantizar que las preguntas se presenten de manera variada y que no se repitan hasta agotar el conjunto disponible.

La existencia de QuestionEngine como componente separado de GameEngine responde al principio de responsabilidad única, evitando que el motor principal del juego concentre toda la lógica del sistema.

**GameController**
La clase GameController cumple el rol de controlador principal del sistema. Su función es coordinar la interacción entre la interfaz de usuario y la lógica del juego, gestionando los estados del sistema y las transiciones entre pantallas.

El método handleState permite controlar el flujo del juego, determinando qué estado se encuentra activo (inicio, mapa, pregunta, resultado) y qué acciones deben ejecutarse en cada caso.

La existencia de GameController permite evitar que la interfaz de usuario interactúe directamente con la lógica de negocio, lo que reduce el acoplamiento y mejora la organización del código. Esta decisión responde al patrón MVC, donde el controlador actúa como mediador entre la vista y el modelo.

**Justificación:**
El diagrama de clases representa el modelo de dominio del sistema y define las principales entidades y sus relaciones. Su objetivo es estructurar los datos y la lógica del juego de manera coherente, evitando dependencias innecesarias entre componentes.

Las clases Player, Node y Question representan las entidades fundamentales del dominio, mientras que GameEngine y QuestionEngine encapsulan la lógica de negocio. GameController actúa como intermediario entre la interfaz de usuario y la lógica del sistema, siguiendo el principio de separación de responsabilidades.

Este diseño permite una arquitectura modular, facilita el mantenimiento del código y posibilita la extensión futura del sistema sin modificar su estructura central.

### Diagrama de estados

Representa los estados del sistema y sus transiciones.

**Estados de la trivia:**
1. HOME
2. MAP
3. QUESTION
4. RESULT

[Diagrama de transiciones entre estados]

**Justificación:**
El diagrama de estados modela el comportamiento del sistema como una máquina de estados finitos (FSM), donde cada estado representa una fase específica de la experiencia del jugador.

Definimos de forma explícita las transiciones entre pantallas, reduciendo la posibilidad de estados inconsistentes o flujos de navegación erróneos. El uso de estados mejora la previsibilidad del sistema, facilita la implementación en Flutter y simplifica el testing, ya que cada transición puede ser validada de forma independiente.

Además, este modelo permite escalar el sistema fácilmente, ya que nuevos estados (como tienda, perfil o configuraciones) pueden integrarse sin alterar la lógica existente.

### Diagrama de secuencia:

Representa cómo interactúan los objetos en el tiempo. Escenario: responder una pregunta.

[Diagrama de secuencia]

**Justificación:**
El diagrama de secuencia describe la interacción entre los componentes del sistema a lo largo del tiempo, mostrando cómo se comunican la interfaz de usuario, los controladores y los motores de lógica del juego.

Su objetivo es evidenciar la separación entre la capa de presentación y la lógica de negocio, garantizando que la interfaz no tome decisiones de negocio, sino que delegue estas responsabilidades a los componentes correspondientes.

Este diseño reduce el acoplamiento entre módulos, mejora la mantenibilidad del sistema y permite modificar la lógica del juego sin afectar directamente la interfaz de usuario.

### Diagrama de Componentes:

Representa la estructura de alto nivel del sistema basado en nuestra estructura de carpetas.

[Diagrama de componentes]

**Explicando el diagrama de componentes:**

**Frontend: Flutter App**

**UI Screens:**
Responsabilidad: Mostrar las pantallas del juego: Inicio, Juego, Resultados, Ranking, Configuración.
Justificación: Separar la UI permite cambiar el diseño sin afectar la lógica del sistema.

**Controllers/ViewModels (MVC):**
Responsabilidad: Coordinar la lógica entre la UI y el motor del juego, manejar eventos del usuario, comunicación con Firebase.
Justificación: Aplicar MVC reduce el acoplamiento entre interfaz y lógica de negocio.

**Trivia Engine (Game Engine):**
Responsabilidad: Selección de preguntas, validación de respuestas, cálculo de puntaje, gestión de rondas y niveles.
Justificación: Separar el motor del juego permite reutilizar lógica, testear el juego sin UI y escalar el sistema.

**Backend: Firebase**

**Firebase Auth:**
Responsabilidad: Autenticación de usuarios, login con email o Google.
Justificación: Evita implementar seguridad desde cero y garantiza escalabilidad.

**Firestore Database:**
Responsabilidad: Almacenar preguntas, usuarios, puntajes, rankings.
Justificación: Es una base de datos NoSQL ideal para apps móviles con datos dinámicos.

**Justificación para el diagrama de componentes:**
Elegimos el diagrama de componentes porque permite visualizar la estructura modular del sistema y las responsabilidades de cada parte.

En nuestra trivia, separamos claramente el frontend en Flutter, el motor del juego y los servicios backend en Firebase. Esta división reduce el acoplamiento, mejora la mantenibilidad y facilita la escalabilidad del sistema.

Además, nos permite justificar el uso de MVC y mostrar cómo la lógica de negocio no depende directamente de la interfaz gráfica.

Para el MVP decidimos simplificar el diagrama de componentes y enfocarnos únicamente en los componentes esenciales del sistema. Excluimos servicios externos avanzados como analytics o funciones en la nube porque no forman parte del core funcional del juego.

Esta decisión responde a la filosofía del MVP: validar la idea con el menor nivel de complejidad posible, manteniendo una arquitectura clara y escalable.

### ¿Por qué usamos estos diagramas?

En conjunto, los diagramas UML permiten representar el sistema desde diferentes perspectivas: funcional, estructural y dinámica.

Cada diagrama cumple un rol específico dentro del diseño del sistema, contribuyendo a una comprensión integral de la arquitectura del MVP. Esta combinación de diagramas permite validar las decisiones de diseño antes de la implementación, reducir ambigüedades y asegurar coherencia entre la idea conceptual del juego y su implementación técnica.

## Diseño de la Base de Datos

### Colecciones de Firestore

**Questions**
- id
- category
- questionText
- options
- correctAnswer

**Users**
- id
- score
- progress
- characterCustomization (fuera del scope)

**Justificación:**
El diseño de la base de datos se plantea utilizando Firestore como base de datos NoSQL orientada a documentos. La estructura propuesta responde a los requerimientos del MVP de la trivia, priorizando simplicidad, escalabilidad y eficiencia en las consultas.

Se definieron dos colecciones principales: Questions y Users. Esta separación permite diferenciar claramente entre el contenido del juego y el estado del jugador, siguiendo el principio de separación de responsabilidades en el diseño de datos.

Questions es una colección separada para permitir reutilización de preguntas entre nodos y evitar duplicación de datos.

## Especificación de API interna

Para el MVP de la trivia se definen endpoints internos que estructuran la comunicación entre la lógica del juego, la interfaz de usuario y los servicios de Firebase. Estos endpoints no representan una API pública, sino una capa de organización interna del sistema.

### Endpoints definidos

- **Obtener pregunta:** Permite solicitar una nueva pregunta desde el sistema de datos o desde la lógica interna del juego.
- **Validar respuesta:** Permite verificar si la respuesta seleccionada por el jugador es correcta o incorrecta.
- **Guardar progreso:** Permite registrar el avance del jugador, como puntos acumulados y nodos completados.

### Justificación

La definición de estos endpoints permite organizar la comunicación entre los distintos componentes del sistema de forma clara y estructurada.

En lugar de que cada parte del sistema acceda directamente a Firebase o a los datos internos, se centralizan las operaciones principales en funciones bien definidas. Esto facilita el mantenimiento del código, mejora la legibilidad del proyecto y reduce errores de integración.

Además, esta organización permite que el sistema sea más fácil de escalar en el futuro. Si se decide modificar la forma en que se obtienen los datos o cómo se guarda el progreso, los cambios se realizan en un solo lugar, sin afectar a toda la aplicación.

En el contexto del MVP, esta estructura permite mantener una arquitectura simple pero ordenada, preparada para futuras ampliaciones sin aumentar innecesariamente la complejidad del sistema.

## Fundamentación de las tecnologías utilizadas

### 1) Elección de Flutter

Elegimos Flutter porque nos permite desarrollar una aplicación multiplataforma con una sola base de código. Esto significa que podemos enfocarnos en la lógica del juego y la experiencia del usuario sin duplicar esfuerzo para distintas plataformas.

Además, Flutter es muy adecuado para un MVP porque:
- Permite construir interfaces visuales de forma rápida.
- Tiene buen rendimiento.
- Facilita la iteración y los cambios.
- Está bien integrado con Firebase.

Se eligió Flutter en lugar de motores de juego como Godot porque el proyecto prioriza la lógica de preguntas sobre gráficos complejos.

En resumen, elegimos Flutter porque nos permite avanzar rápido sin perder calidad ni posibilidades de crecimiento.

### 2) Elección de Firebase

Elegimos Firebase porque nos permite tener un backend funcional sin necesidad de construir toda una infraestructura desde cero.

Para un MVP, crear un backend tradicional implicaría mucho tiempo y complejidad técnica: servidores, APIs, bases de datos, despliegue, mantenimiento, etc.

Firebase nos ofrece:
- Almacenamiento de datos.
- Autenticación.
- Persistencia del progreso del jugador.
- Escalabilidad futura.

Preferimos una solución simple pero potente, que nos permita concentrarnos en el juego y no en la infraestructura.

## Estrategia de Calidad (QA)

Para garantizar el correcto funcionamiento del MVP de la trivia, se definió una estrategia básica de aseguramiento de calidad (QA). Esta estrategia busca detectar errores tempranamente, validar las funcionalidades principales del sistema y asegurar una experiencia de usuario consistente.

Dado que se trata de un MVP y de un proyecto académico, se priorizarán pruebas simples pero efectivas, enfocadas en las funcionalidades críticas del juego.

### Tipos de pruebas

**Pruebas unitarias:**
Se aplican a componentes individuales del sistema, como funciones del motor de juego y del motor de preguntas. Su objetivo es verificar que cada módulo funcione correctamente de forma aislada, por ejemplo: validación de respuestas, cálculo de puntaje, selección de preguntas aleatorias, lógica del sistema anti-repetición.

Estas pruebas permitirán detectar errores en la lógica interna sin depender de la interfaz de usuario.

**Pruebas funcionales:**
Se enfocan en validar que las funcionalidades del sistema se comporten según lo esperado desde la perspectiva del usuario. Se verificarán, entre otros aspectos: navegación entre pantallas, flujo del juego (inicio, mapa, preguntas, resultados), interacción con nodos y preguntas, integración con Firebase.

Este tipo de pruebas permite comprobar que los distintos componentes del sistema funcionan correctamente de manera integrada.

**Pruebas manuales:**
Consisten en la ejecución directa del juego por parte del equipo de desarrollo. Se utilizarán para evaluar la experiencia de usuario, detectar errores no previstos, verificar la coherencia del flujo del juego e identificar problemas de usabilidad.

Dado el contexto del MVP, las pruebas manuales resultarán fundamentales para validar el comportamiento real de la aplicación.

### Casos de prueba críticos

Se definieron casos de prueba prioritarios, ya que representan funcionalidades esenciales del sistema.

- **Respuesta correcta suma puntos:** Se verifica que, al responder correctamente una pregunta, el sistema incremente el puntaje del jugador de acuerdo con las reglas definidas.
- **Tres errores generan Game Over:** Se comprueba que el sistema detecte correctamente el número de respuestas incorrectas y finalice la partida cuando se alcanza el límite establecido.
- **No repetición de preguntas:** Se valida que una pregunta no se repita hasta agotar el conjunto disponible dentro de una categoría o tema, asegurando el correcto funcionamiento del sistema anti-repetición.
- **Guardado de progreso:** Se verifica que el progreso del jugador (puntaje y nodos completados) se guarde correctamente y se recupere al reiniciar la aplicación.

### Justificación de la estrategia de calidad

La implementación de esta estrategia de pruebas permite asegurar que el MVP funcione de manera estable y confiable, a pesar de su alcance limitado.

Las pruebas contribuyen a reducir errores en funcionalidades críticas, mejorar la calidad del código, garantizar la coherencia del flujo del juego y validar que los requisitos del MVP se cumplan correctamente.

En el contexto del proyecto, esta estrategia de QA representa un equilibrio entre rigor técnico y simplicidad, adecuado para un MVP desarrollado en un entorno académico.

## Planificación de trabajo

### Estrategia de Control de Versiones (SCM)

- Uso de Git y GitHub.
- Ramas: main, develop y feature.
- Pull requests y revisiones.

**Justificación:** El control de versiones permite trabajar en equipo sin perder cambios.

### Semana 1: 1 – 8 febrero
**Core del juego**
- Modelos (Player, Node, Question)
- JSON de preguntas
- GameEngine
- QuestionEngine

### Semana 2: 8 – 15 febrero
**UI básica**
- HomeScreen
- MapScreen
- QuestionScreen
- Navegación

### Semana 3: 15 – 21 febrero
**Progreso y puntos**
- Guardar puntos
- Nodos completados
- No repetir preguntas

**Resultado:** MVP jugable.

## Riesgos y limitaciones del proyecto

Hemos identificado diversos riesgos y limitaciones que podrían afectar el alcance, el tiempo de desarrollo y la calidad del producto final.

- **Experiencia limitada en las tecnologías utilizadas:** El equipo se encuentra en etapa de aprendizaje en Dart, Flutter y Firebase, lo que puede generar mayor tiempo de desarrollo, dificultades en la implementación de ciertas funcionalidades y posibles errores de diseño o arquitectura. Sin embargo, consideramos que este riesgo también es una oportunidad de aprendizaje y crecimiento técnico.

- **Dependencia de Firebase:** El proyecto depende de Firebase como backend y base de datos, lo que implica dependencia de servicios externos, limitaciones en la personalización del backend, posibles restricciones de uso en planes gratuitos y dificultad para migrar a otra tecnología en etapas tempranas. A pesar de esto, Firebase se considera adecuado para el MVP por su facilidad de integración y rapidez de desarrollo.

- **Complejidad del motor de preguntas:** El motor de preguntas incluye funcionalidades como selección aleatoria de preguntas, sistema anti-repetición y organización por categorías y nodos. Esto puede generar aumento de la complejidad lógica, dificultad para mantener el código y posibles errores en el manejo del estado del juego.

- **Limitaciones de tiempo:** El desarrollo del MVP está condicionado por un cronograma acotado, lo que puede provocar reducción del alcance inicial, priorización de funcionalidades básicas sobre características avanzadas y menor tiempo para pruebas y optimización.

- **Gestión del estado del juego:** El manejo de estados (HOME, MAP, QUESTION, RESULT) puede generar errores de navegación entre pantallas, inconsistencias en el flujo del juego y dificultad para depurar errores relacionados con el estado.

- **Escalabilidad limitada del MVP:** Al tratarse de un MVP, la arquitectura prioriza simplicidad sobre complejidad, lo que implica limitaciones para soportar funcionalidades avanzadas en el corto plazo, necesidad de refactorización en etapas futuras y posibles cambios en el diseño de la arquitectura.

- **Calidad y cantidad del contenido:** El sistema depende de un banco de preguntas creado manualmente, lo que implica riesgo de preguntas repetitivas o mal formuladas, limitaciones en la cantidad de contenido y necesidad de curación y validación de preguntas.

- **Persistencia y sincronización de datos:** El uso de almacenamiento local combinado con Firebase puede generar inconsistencias entre datos locales y remotos, pérdida de información en ciertos escenarios y mayor complejidad en la lógica de sincronización.

A pesar de estos riesgos, se decidió avanzar con esta arquitectura porque permite construir un MVP funcional, mantener el proyecto dentro de un alcance manejable y sentar las bases para futuras mejoras.

## Conclusión

La documentación define una estructura clara para el desarrollo del MVP de la trivia. Las decisiones técnicas fueron tomadas considerando simplicidad, escalabilidad y aprendizaje del equipo. El diseño propuesto permite construir un juego funcional y preparado para futuras mejoras.