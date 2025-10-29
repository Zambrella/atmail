---
name: at-sdk
description: Use when implementing atProtocol applications, performing CRUD operations on atRecords, setting up authentication/onboarding, working with different atKey types, or implementing real-time notifications - provides SDK reference and code examples for Dart, Flutter, C, and other platforms
---

# atSDK Reference

## Overview

Reference documentation for the atSDK - the development kit for embedding atProtocol functionality into applications. Covers authentication (PKAM), atKey management, CRUD operations, and real-time notifications (monitor/notify).

## When to Use

Reference this skill when:
- Implementing atProtocol functionality in your application
- Setting up user authentication/onboarding with PKAM
- Creating or managing atKeys (Public, Self, Shared, Private, Cached)
- Performing CRUD operations (put, get, delete, getAtKeys)
- Implementing real-time messaging with monitor/notify
- Debugging atKey structure or CRUD operation issues
- Choosing between atKey types for your use case

## Quick Reference

| Operation | Method | Example |
|-----------|--------|---------|
| **Store data** | `put()` | `await atClient.put(atKey, value)` |
| **Retrieve data** | `get()` | `await atClient.get(atKey)` |
| **List keys** | `getAtKeys()` | `await atClient.getAtKeys(regex: '.*')` |
| **Delete data** | `delete()` | `await atClient.delete(atKey)` |
| **Listen for updates** | `monitor()` | `atClient.monitor(regex: 'msg.*')` |
| **Send notification** | `notify()` | `await atClient.notify(atKey, value)` |

## atKey Types

| Type | Syntax | Visibility | Use Case |
|------|--------|-----------|----------|
| **Public** | `public:location@alice` | Anyone | Public profiles, contact info |
| **Self** | `phone.wavi@alice` | Owner only | Private notes, settings |
| **Shared** | `@bob:phone.wavi@alice` | Owner + recipient | Direct messages, shared files |
| **Private** | `privatekey:pk1@alice` | Owner only | Encryption keys, credentials |
| **Cached** | `cached:@bob:phone@alice` | Local copy | Cached shared data |

## Authentication (Onboarding)

PKAM (Public Key Authentication Mechanism) authenticates users to their atServer using cryptographic keys.

**Platform-specific packages:**
- **Dart**: `at_onboarding_cli` for command-line apps
- **Flutter**: `at_onboarding_flutter` for mobile/desktop apps
- **C**: Direct PKAM authentication functions

**Common flow:**
1. User provides atSign credentials (keys file or QR code)
2. SDK authenticates to atServer using private key
3. App receives authenticated atClient instance
4. App can now perform CRUD operations

## CRUD Operations

### Create/Update
```dart
// Create atKey
final atKey = AtKey()
  ..key = 'phone'
  ..sharedWith = '@bob'
  ..namespace = 'wavi';

// Store data
await atClient.put(atKey, '555-1234');
```

### Read
```dart
// Get specific key
final value = await atClient.get(atKey);

// List all keys matching pattern
final keys = await atClient.getAtKeys(regex: '.*wavi@');
```

### Delete
```dart
await atClient.delete(atKey);
```

## Real-time Notifications

### Monitor (Listen)
```dart
// Listen for notifications matching pattern
atClient.monitor(regex: 'msg.*')
  .listen((notification) {
    print('Received: ${notification.value}');
  });
```

### Notify (Send)
```dart
// Send notification to another atSign
final notificationKey = AtKey()
  ..key = 'msg'
  ..sharedWith = '@bob';

await atClient.notify(notificationKey, 'Hello Bob!');
```

## Common Patterns

**Storing user preferences:**
```dart
// Self key - only visible to owner
final prefKey = AtKey()
  ..key = 'theme'
  ..namespace = 'myapp';
await atClient.put(prefKey, 'dark');
```

**Sharing data with specific user:**
```dart
// Shared key - visible to owner and recipient
final shareKey = AtKey()
  ..key = 'document'
  ..sharedWith = '@bob'
  ..namespace = 'myapp';
await atClient.put(shareKey, documentContent);
```

**Public profile information:**
```dart
// Public key - visible to everyone
final publicKey = AtKey()
  ..key = 'public:bio'
  ..namespace = 'myapp';
await atClient.put(publicKey, 'Software developer');
```

## SDK Support

| Platform | Package | Maturity |
|----------|---------|----------|
| **Dart/Flutter** | `at_client` | Production-ready |
| **C** | `at_c` | Embedded systems |
| **Java** | `at_java` | JVM applications |
| **Python/Go/Rust** | Community SDKs | Varying support |

## Detailed Documentation

For comprehensive guides and implementation details, see the `resources/` directory:

- **sdk-overview.md**: Introduction to atSDK architecture and capabilities
- **onboarding.md**: Platform-specific authentication implementation guides
- **atid-reference.md**: Complete atKey creation reference for all SDK variants
- **crud-operations.md**: Detailed CRUD examples with error handling and best practices
- **events.md**: Real-time messaging patterns using monitor/notify with filtering

## Common Mistakes

**Incorrect atKey syntax:**
- ❌ `@bob:phone@alice` (missing namespace)
- ✅ `@bob:phone.wavi@alice` (includes namespace)

**Missing namespace:**
- Always include namespace in production apps to avoid key collisions
- Use reverse domain notation: `com.example.myapp`

**Not handling cached keys:**
- Shared data creates cached copies on recipient's atServer
- Query both shared and cached keys for complete view

**Forgetting to monitor:**
- CRUD operations are pull-based (polling required)
- Monitor/notify enables push-based real-time updates
