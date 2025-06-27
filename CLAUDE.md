# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Flutter run**: `flutter run` (standard Flutter development)
- **Build**: `flutter build` (platform-specific builds available)
- **Lint**: `dart analyze` or `flutter analyze`
- **Format**: `dart format .`
- **Code generation**: `dart run build_runner build` (for generated .mapper.dart and .g.dart files)
- **Clean build**: `dart run build_runner clean` then `dart run build_runner build`

## Architecture Overview

AtMail is a messaging application built on the atProtocol that combines email formality with instant messaging immediacy. The app uses Flutter with a clean architecture pattern.

### Core Architecture Layers

**Domain Layer** (`lib/messaging/domain/`):
- `AppConversationRepository` - Abstract repository interface
- `AppConversation`, `AppMessage` - Core domain models with status tracking
- Uses `dart_mappable` for serialization and code generation

**Repository Layer** (`lib/messaging/repository/`):
- `AppConversationRepositoryImpl` - Real-time conversation management using RxDart
- Implements atProtocol key patterns: `conv.{id}.{namespace}` and `conv.{id}.msg.{timestamp}.{namespace}`
- Uses BehaviorSubject for reactive state management
- Handles real-time notifications and periodic refresh (30 seconds)

**Presentation Layer**:
- **BLoC Pattern**: Uses `flutter_bloc` with Cubits for state management
- **Router**: Go Router with shell routes for tabbed navigation
- **UI**: Material Design components

### Key Technical Patterns

**atProtocol Integration**:
- Conversations use immutable design with fork-on-change approach
- Messages use broad-to-specific key structure for efficient querying
- Status signaling via shared keys for participant management
- Cache settings: conversations (`ccd=false`) persist beyond creator, messages (`ccd=true`) for proper deletion

**State Management**:
- Single source of truth via RxDart BehaviorSubject
- Real-time synchronization through dual notification streams
- Reactive UI updates through BLoC pattern

**Data Flow**:
- Repository maintains central conversation stream
- BLoCs subscribe to repository streams
- UI rebuilds reactively on state changes
- Background refresh ensures consistency

## Key Dependencies

- `at_client_mobile` - atProtocol client library
- `flutter_bloc` - State management
- `rxdart` - Reactive programming
- `dart_mappable` - Code generation for serialization
- `go_router` - Navigation
- `uuid` - Unique ID generation

## Environment Setup

- Requires `.env` file with `NAMESPACE` configuration
- Uses `flutter_dotenv` for environment variable management
- AtSign onboarding integration via `at_onboarding_flutter`

## Testing

- Standard Flutter testing setup with `flutter_test`
- Run tests: `flutter test`
- Uses `build_verify` for ensuring generated code is up-to-date

## Code Generation

The project uses code generation extensively:
- `.mapper.dart` files from `dart_mappable`
- `.g.dart` files from `go_router_builder`
- Always run `dart run build_runner build` after modifying mappable classes or router definitions