Trivia Game MVP
Project Description
    This project consists of developing an MVP (Minimum Viable Product) for an interactive trivia game, implemented with Flutter as the main framework and Firebase as the backend.

    The project's objective is to design and build a trivia system with a clear, modular, and scalable architecture, applying concepts of domain modeling, separation of concerns, and software engineering best practices.

    The system allows managing players, questions, game nodes, and the main trivia engine logic.

Objectives
General Objective
    Develop a functional trivia game with a well-defined and documented architecture that serves as a foundation for future extensions.

Specific Objectives
    Design the system's domain model.
    Implement the game engine logic.
    Develop the user interface with Flutter.
    Integrate Firebase for data management.
    Document the architecture, design decisions, and system diagrams.

MVP Scope
The MVP includes:

    Player registration and management.
    Question and answer system.
    Game engine.
    Node or level structure.
    Basic user interface.
    Data persistence with Firebase.

Not included (out of MVP scope):

    Advanced global ranking system.
    Monetization.
    Artificial intelligence or recommendations.
    System Architecture

The system is designed with a layer-based modular architecture:

    Presentation layer (UI): Interface developed in Flutter.
    Business logic layer: Game engine and rules.
    Domain model layer: Main system classes.
    Data layer: Firebase integration.

This separation allows:

    Reducing coupling between components.
    Facilitating maintenance and scalability.
    Improving design clarity.
    Domain Model

The main system entities are:

    Player: Represents the player.
    Question: Represents a trivia question.
    Node: Represents a game node or level.
    GameEngine: Controls the main game logic.
    Each entity was designed to represent key concepts of the problem domain and avoid unnecessary dependencies.

Diagrams
The project includes the following diagrams:

    Class diagram.
    Architecture diagram.
    State diagram.
    Game flow diagram.
    The diagrams allow visualizing the system structure and understanding the relationships between components.

Technologies Used
    Flutter (Frontend)
    Dart (Programming language)
    Firebase (Backend and database)
    Git & GitHub (Version control)

System Requirements
    Functional Requirements
    Allow player creation and management.
    Display trivia questions.
    Validate answers.
    Manage player progress.
    Control game flow.
    Non-Functional Requirements

    Usability: intuitive interface.
    Performance: adequate response times.
    Scalability: ability to add new features.
    Maintainability: modular and documented code.
    
Testing Strategy (QA)
Tests are applied at different levels:

    Unit tests: validation of engine logic.
    Integration tests: interaction between components.
    Functional tests: verification of requirements.
    The objective is to guarantee the quality and stability of the system.

Documentation
The project documentation includes:

    Technical justification of the architecture.
    Design decisions.
    System diagrams.
    Domain model description.
    Requirements analysis.
    Possible Future Improvements
    Multiplayer implementation.
    Global ranking system.
    Question customization.
    New game modes.
    Performance optimization.
    
Authors
    Sofía Nuñez
    Martín Suarez
    Ignacio Cabrera
    Emanuel Romero


Note
This project was designed as an MVP, so its main objective is to validate the architecture and system design rather than offer a complete final product.