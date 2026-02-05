/*
Acá controlaremos cada estado del juego:
idle - juego sin empezar, el menu
start o home- inicio.
loading - cargando.
question - mostrando las preguntas.
win, si el usario ganá.
lose o Game Over, bueno, si el usuario es manco.

Este se comunica con la clase GameEngine.
*/
enum GameState {
  idle,       // En el menú principal
  playing,    // Jugando una pregunta
  win,        // Ganó la pregunta
  lose,       // Perdió la pregunta
  completed,  // Completó todos los nodos
}