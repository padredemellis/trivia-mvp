# Technical Documentation of the MVP – Trivia Game

## System Description

By:
- Sofía Nuñez
- Martín Suarez
- Ignacio Cabrera
- Emanuel Romero

---

## Introduction

This document describes the technical design of the MVP (Minimum Viable Product) of a trivia game developed with Flutter and Firebase. Its objective is to clearly define how the system is designed, what functionalities it includes, how it is organized internally, and why certain decisions were made.

The documentation serves as a guide for the development team, allowing them to understand the system structure before programming it and reducing errors during implementation.

---

## System Objective

The system's objective is to offer an interactive, scalable, and easy-to-maintain trivia game that allows users to answer questions, record scores, and improve their experience through an intuitive interface.

Additionally, this system seeks to offer an interactive and structured form of learning through a question game, combining progress and motivation mechanics.

---

## System Requirements

The definition of requirements allows understanding what the system must do before describing its architecture, ensuring better design organization.

### Functional Requirements

The system must allow:
- Starting a trivia game.
- Displaying questions with multiple answer options.
- Recording the answer selected by the player.
- Calculating the player's score.
- Displaying results at the end of the game.
- Storing questions and answers in the database.
- Managing game logic through the game engine.

### Non-Functional Requirements

The system must meet the following criteria:
- **Usability:** the interface must be simple and intuitive for the user.
- **Performance:** quick system responses. In less than two seconds.
- **Scalability:** ability to add more questions and features without affecting its operation.
- **Maintainability:** modular code to facilitate future modifications.
- **Portability:** the application must be able to run on different mobile devices thanks to the use of Flutter.

---

## MVP Objective

The MVP's objective is to build a functional trivia that integrates game mechanics with clear navigation and a simple progression system, and thus we can guarantee a playable, stable, and scalable experience.

With the MVP we seek to validate the proposed architecture and the separation between logic, interface, and data.

We chose the following key functionalities:
- Node map
- Questions organized by topic
- Point system
- Simple progression
- Question anti-repetition system

---

## Scope Justification

It was decided to limit the MVP scope to:
- Reduce initial technical complexity, avoiding overloading development with advanced functionalities.
- Prioritize the game's core: the main question and progression mechanic.
- Guarantee stability and playability, before adding more complex features (such as more characters, a store system, community questions, etc.).
- Facilitate future scalability. Leaving the architecture prepared for new functionalities.
- Achieve balance between front-end and back-end with an attractive interface and clear but simple game logic.

### Functionalities Outside the MVP
- Online global ranking.
- AI-generated questions.
- Advanced store.
- Social system (users will create question topic packages)

**Justification:**  
Separating the scope allows concentrating on the game's core and avoiding overloading development with features that are not essential to validate the main idea.

---

## Game Concept

Flow:
Start -> Node map -> Select node -> Question 1 → correct → map  
                              → incorrect → another question

Game States:
HOME → MAP → QUESTION → RESULT → MAP

### Game Concept and State Rationale

The design of this flow is based on three principles:

1. Cognitive Simplicity  
   The player quickly understands what to do:
   - Enter the game
   - Choose a node
   - Answer questions
   - Return to the map

2. Immediate Feedback  
   After each question the player receives feedback (correct, incorrect) which allows:
   - Reinforcing learning
   - Maintaining motivation
   - Clarifying progress

3. Progression Mental Model  
   The node map is a visual representation for the player very similar to:
   - Game levels
   - Campaign map
   - Mission system

#### Regarding the use of states:
We use a state model because:
- It allows us to visualize game logic clearly.
- It facilitates implementation in Flutter through controllers or state machines.
- It reduces navigation errors.
- It allows scaling the game by adding new states (for example Settings, Shop, Profile).

Each state represents a specific phase of the user experience:
- **HOME:** Entry point and player context
- **MAP:** Content selection and progression
- **QUESTION:** Main game interaction
- **RESULT:** Answer evaluation
- **MAP:** Progress guarantee

---

## MVP Rules

### Nodes
- 20 nodes
- Each node = 1 topic
- Each node = 3 questions

**Justification:**
- 20 nodes: Offer enough content to generate a sense of progress without excessive complexity.
- 1 topic per node: Ensures thematic coherence and facilitates content organization.
- 3 questions per node: Balance between duration and difficulty, avoiding sessions that are too long.

### Advancement Mechanic
- Correct answer → node completed
- Incorrect answer → new question from the same node
- If you answer all three questions wrong → The game shows "Game Over", the score, and then redirects you to the main menu.

**Justification:**  
This design avoids excessive frustration, allowing the player to keep trying without severe penalties.

### Topics
Broad and popular topics:
- Cinema
- Video games
- General knowledge

**Justification:**
- Universal and attractive topics for a young audience.
- Allow generating a large quantity of questions.
- Facilitate future content expansion.

Each topic contains 50 questions to:
- Guarantee variety
- Avoid frequent repetition
- Support the anti-repetition system

### Point System
- Correct answer + 10

**Justification:**
- Simple and easy-to-understand system.
- Allows measuring player progress.
- Can be expanded in the future (bonuses, combos, difficulty, etc.).

### Anti-Repetition System
- A question is not repeated until the topic is exhausted
- Saved in local memory

**Justification:**
- Improves user experience by avoiding repetitive content.
- Reduces the feeling of "cheating" or boredom.
- Does not require complex back-end in the MVP.
- Allows easy migration to remote storage in future versions.

---

## User Stories (MoSCoW)

User stories describe functionalities from the player's point of view.

### Must Have (mandatory)
- As a player, I want to see a map with nodes to choose levels, to understand my progress.
- As a player, I want to answer questions with multiple options, to advance in the game.
- As a player, I want to receive immediate feedback on my answers, to learn and improve.
- As a player, I want to customize my character, to feel the game is my own.

### Should Have (important)
- As a player, I want to obtain rewards when completing nodes, to feel motivated.
- As a player, I want my progress to be saved automatically, to continue later.

### Could Have (optional)
- As a player, I want to adjust game settings, to adapt the experience.
- As a player, I want to see achievements or statistics, to measure my performance.

### Won't Have (outside the MVP)
- As a player, I want to answer questions generated by the community.
- As a player, I want questions with different difficulty levels.

**Justification:**  
Prioritization allows defining which functions are essential for the MVP to be playable and which can be added in future versions.

---

## System Architecture

### General Description

The system is organized into three main layers:
- **Presentation layer (UI):** screens and widgets in Flutter.
- **Logic layer:** game engines and controllers.
- **Data layer:** Firebase Firestore and local storage.

### Folder Structure

The proposed architecture separates responsibilities:
- `core/` : global definitions and game states
- `models/` : representation of domain entities
- `engine/` : main game logic
- `data/` : data source
- `screens/` : user interface
- `widgets/` : reusable components
- `controllers/` : coordination between UI and logic

---

## MVP Screens

### HomeScreen
Elements:
- Character
- Play button
- Player points

### MapScreen
Elements:
- List of nodes (20)
- Locked/unlocked nodes
- Progress

Example:
[Node 1 (ready to enter)] [Node 2 (locked)] [Node 3 (locked)]

### QuestionScreen
Elements:
- Question
- 4 options
- Feedback (correct/incorrect)

---

## Architectural Justification

The principle of separation of concerns is applied:  
UI ≠ business logic ≠ data ≠ models

**Benefits:**
- More maintainable code
- Facilitates testing
- Allows scaling the project
- Reduces coupling between components
- Makes it possible to migrate to more complex architectures (Clean Architecture, MVVM, BLoC)

In conceptual terms, this architecture is a simplified version of a layered architecture.

---

## Rationale for MVP Screens

### HomeScreen
Elements:
- Character
- Play button
- Player points

**Justification:**
- Introduces the player to the game universe
- Allows quick access to the main action
- Shows key information (points)

### MapScreen
Elements:
- List of nodes
- Locked/unlocked nodes
- Progress indicator

**Justification:**
- Visually represents the player's progress
- Generates motivation through progressive unlocking
- Facilitates content selection

### QuestionScreen
Elements:
- Question
- 4 options
- Visual feedback

**Justification:**
- It is the core of the game
- The 4-option structure is standard in trivia games
- Feedback reinforces the interactive experience

---

## MVC Choice

We chose MVC because it is a clear and easy-to-understand architecture, ideal for small or medium-sized projects like our MVP.

MVC allows us to separate the system into three parts:
- **Model:** the data and domain logic of the game
- **View:** the screens and interface
- **Controller:** the logic that connects the interface with the game

This helped us to:
- Better organize the code
- Avoid mixing UI with logic
- Prepare the project for future expansions

---

## Diagrams for our MVP

### Use Cases
Represents the interactions between the user and the system.

**Actors**
- Player

**Main use cases**
- Start game
- Select node
- Answer question
- View result
- Obtain points
- Progress on the map

**Justification:**  
The use case diagram allows delimiting the functional scope of the MVP and clearly defining the interactions between the player and the system. It identifies essential functionalities and serves as a basis for architectural decision-making, prioritizing critical gameplay functionalities over secondary ones.

---

## Class Diagram (Domain Model)

Represents the internal structure of the system.

**Main Classes:**

- **Player**  
  The Player class represents the player within the system. It models the user's state and stores relevant information for the game's development. Attributes include accumulated score and the list of completed nodes. The `answerQuestion` method represents the player's action when answering a question.

  Player will not directly manage questions to avoid coupling between the player and game logic; GameEngine is used as an intermediary.

- **Node**  
  The Node class represents a node on the game map, understood as a unit of progress or level. Each node groups a set of questions associated with a specific topic. Attributes include identifier, topic, questions list, completion status, and category.

- **Question**  
  The Question class represents a question in the trivia system. It contains the question text, answer options, the correct answer, the answered status, and the category to which it belongs.

- **GameEngine**  
  The GameEngine class represents the core of the game logic. Responsibilities: implement main rules, manage player progress, coordinate interaction between domain entities. Methods: `startGame`, `updateProgress`, etc.

- **QuestionEngine**  
  The QuestionEngine class encapsulates specific logic related to question management: random selection and anti-repetition. Methods: `getRandomQuestion`, `avoidRepetition`.

- **GameController**  
  The GameController coordinates interaction between the UI and game logic, managing system states and transitions between screens. Method: `handleState`.

**Justification:**  
This class diagram structures the game's data and logic coherently, avoiding unnecessary dependencies. It supports a modular architecture, facilitates maintenance, and enables future extension.

---

## State Diagram

Represents system states and their transitions.

**Trivia states:**
1. HOME
2. MAP
3. QUESTION
4. RESULT

**Justification:**  
The state diagram models the system's behavior as a finite state machine (FSM), improving predictability, facilitating implementation in Flutter, and simplifying testing. New states can be integrated without altering existing logic.

---

## Sequence Diagram

Represents how objects interact over time. Example scenario: answering a question.

**Justification:**  
The sequence diagram describes interactions between UI, controllers, and engines over time, demonstrating separation between presentation and business logic and reducing module coupling.

---

## Component Diagram

Represents the high-level structure of the system based on the folder structure.

### Explaining the Component Diagram

**Frontend: Flutter App**  
- UI Screens: Start, Game, Results, Ranking, Settings  
  - Responsibility: Display game screens  
  - Justification: Separating the UI allows changing the design without affecting system logic

**Controllers/ViewModels (MVC):**
- Responsibility:
  - Coordinate logic between UI and game engine
  - Handle user events
  - Communication with Firebase
- Justification: Applying MVC reduces coupling between interface and business logic

**Trivia Engine (Game Engine):**
- Responsibility:
  - Question selection
  - Answer validation
  - Score calculation
  - Round and level management
- Justification:
  - Reusing logic
  - Testing the game without UI
  - Scaling the system

**Backend: Firebase**
- **Firebase Auth:**
  - Responsibility: User authentication (email or Google)
  - Justification: Avoids implementing security from scratch and guarantees scalability
- **Firestore Database:**
  - Responsibility: Store Questions, Users, Scores, Rankings
  - Justification: NoSQL database ideal for mobile apps with dynamic data

**Justification for the Component Diagram:**  
The diagram visualizes the modular structure and responsibilities. For the MVP we simplified the diagram, focusing only on essential components and excluding advanced external services (analytics, cloud functions) to keep complexity low.

---

## Why Use These Diagrams?

Collectively, UML diagrams represent the system from functional, structural, and dynamic perspectives. Each diagram contributes to a comprehensive understanding of the MVP architecture and helps validate design decisions before implementation.

---

## Database Design

### Firestore Collections

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
- characterCustomization (out of scope)

**Justification:**  
Firestore is used as a document-oriented NoSQL database. Two main collections (Questions and Users) separate game content from player state, enabling reuse of questions and avoiding duplication.

---

## Internal API Specification

For the trivia MVP, internal endpoints organize communication between game logic, UI, and Firebase services (not a public API).

**Defined Endpoints**
- **Get question:** Request a new question from the data system or internal logic.
- **Validate answer:** Verify whether the selected answer is correct.
- **Save progress:** Record player advancement (points, completed nodes).

**Justification:**  
Centralizing main operations in well-defined functions facilitates maintenance, improves readability, and reduces integration errors. It eases future changes to data sources without affecting the entire application.

---

## Rationale for Technologies Used

### 1) Flutter Choice
- Cross-platform development with a single codebase.
- Quick UI development, good performance, easy iteration.
- Well integrated with Firebase.
- Preferred over game engines like Godot because the project prioritizes question logic over complex graphics.

### 2) Firebase Choice
- Functional backend without building infrastructure from scratch.
- Provides data storage, authentication, progress persistence, and future scalability.
- Allows focusing on game development rather than infrastructure.

---

## Quality Strategy (QA)

A basic QA strategy focused on critical functionalities for an MVP.

### Types of Tests

**Unit Tests**
- Verify modules in isolation: answer validation, score calculation, random selection, anti-repetition logic.

**Functional Tests**
- Validate navigation, game flow, node and question interaction, and Firebase integration.

**Manual Tests**
- Evaluate user experience, detect usability problems, and validate real behavior.

### Critical Test Cases
- Correct answer adds points.
- Three errors generate Game Over.
- No question repetition until category/topic exhaustion.
- Progress saving and recovery on app restart.

**Justification:**  
This testing approach balances rigor and simplicity appropriate for an academic MVP, ensuring stability of core features.

---

## Work Planning

### Version Control Strategy (SCM)
- Use Git and GitHub.
- Branches: `main`, `develop`, and `feature`.
- Pull requests and reviews.

**Justification:**  
Version control enables team collaboration without losing changes.

### Timeline
- **Week 1 (Feb 1–8) — Game Core**
  - Models (Player, Node, Question)
  - Question JSON
  - GameEngine
  - QuestionEngine

- **Week 2 (Feb 8–15) — Basic UI**
  - HomeScreen
  - MapScreen
  - QuestionScreen
  - Navigation

- **Week 3 (Feb 15–21) — Progress and points**
  - Save points
  - Completed nodes
  - Don't repeat questions

**Result:** Playable MVP.

---

## Project Risks and Limitations

**Limited Experience with Technologies**
- Longer development time, potential implementation difficulties.
- Considered a learning opportunity.

**Firebase Dependency**
- Dependence on external services and free plan limits.
- Migration difficulty in early stages.

**Question Engine Complexity**
- Random selection, anti-repetition, categories add logical complexity.

**Time Limitations**
- May force scope reduction and less time for testing.

**Game State Management**
- Potential navigation errors and inconsistencies.

**Limited MVP Scalability**
- Architecture prioritizes simplicity; refactoring may be required later.

**Content Quality and Quantity**
- Manually created question bank risks repetition and poor quality.

**Data Persistence and Synchronization**
- Local + remote storage may cause inconsistencies and synchronization complexity.

Despite these risks, the chosen architecture supports building a functional MVP within a manageable scope and enables future improvements.

---

## Conclusion

This documentation defines a clear structure for trivia MVP development. Technical decisions were made considering simplicity, scalability, and team learning. The proposed design allows building a functional game prepared for future improvements.