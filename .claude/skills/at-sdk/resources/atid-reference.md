---
description: Learn how to create atKeys for your chosen platform
---

# atKey Reference

> AtKey
>
> Please note that any reference to the word "AtKey" in this document is not associated with cryptographic keys. The atKey is the "key" of the key-value pair that makes up an atRecord.

## Flutter / Dart

### Package Installation

The [at\_commons](https://pub.dev/packages/at\_commons) package contains common elements used in a number of Atsign's Flutter and Dart packages. This package needs to be included in the application in order to create atKeys.

First add the package to your project:

```
flutter pub add at_commons
```

### Usage

See below for how to create the various types of atKeys.

#### Public atKey

To create a public atKey, first use the `AtKey.public` builder to configure it, then call `.build` to create it.

```dart
// AtKey.public signature
static PublicKeyBuilder public(String key,
    {String? namespace, String sharedBy = ''})
```

The `build` method on `PublicKeyBuilder` takes no parameters.

**Example**

`public:phone.wavi@alice`

```dart
AtKey myPublicID = AtKey.public('phone', namespace: 'wavi', sharedBy: '@alice').build();
```

#### Self atKey

To create a self atkeyD, first use the `AtKey.self` builder to configure it, then call `.build` to create it.

```dart
// AtKey.self signature
static SelfKeyBuilder self(String key,
    {String? namespace, String sharedBy = ''})
```

The `build` method on `SelfKeyBuilder` takes no parameters.

**Example**

`phone.wavi@alice`

```dart
AtKey mySelfID = AtKey.self('phone', namespace: 'wavi', sharedBy: '@alice').build();
```

#### Shared atKey

To create a shared atKey, first use the `AtKey.shared` builder to configure it, then call `.build` to create it.

```dart
// AtKey.shared signature
static SharedKeyBuilder shared(String key,
    {String? namespace, String sharedBy = ''})
```

The `build` method on `SharedKeyBuilder` takes no parameters.

**Example**

`@bob:phone.wavi@alice`

```dart
AtKey sharedKey = (AtKey.shared('phone', 'wavi')
    ..sharedWith('@bob')).build();
```

**Caching shared atKeys**

To cache a shared atKey, you can do a [cascade](https://dart.dev/language/operators#cascade-notation) call on `SharedKeyBuilder.cache`.

```dart
// Caching example
AtKey atKey = (AtKey.shared('phone', namespace: 'wavi', sharedBy: '@alice')
 ..sharedWith('@bob')
 ..cache(1000, true))
 .build();
```

### API Docs

You can find the API reference for the entire package available on [pub](https://pub.dev/documentation/at_commons/latest/).

The `AtKey` class API reference is available [here](https://pub.dev/documentation/at_commons/latest/at_commons/AtKey-class.html).
