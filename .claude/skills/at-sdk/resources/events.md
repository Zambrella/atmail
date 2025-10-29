---
description: How to send and receive real-time messages
---

# Notifications

## Flutter / Dart

In Dart, the AtClient is stored within the AtClientManager. Once an atSign has been [onboarded](onboarding.md), you will be able to access the AtClientManager for its associated atSign.

### AtClientManager

AtClientManager is a [singleton](https://en.wikipedia.org/wiki/Singleton_pattern) model. When `AtClientManager.getInstance()` is called, it will get the AtClientManager instance for the last onboarded atSign.

```dart
AtClientManager atClientManager = AtClientManager.getInstance();
```

> **Info**
> If you need simultaneous access to multiple atClients, you need to create a new [isolate](https://dart.dev/language/concurrency#how-isolates-work) for each additional atClient, and onboard its atSign within the isolate.
>
> An example of this pattern can be found in [at_daemon_server](https://github.com/atsign-foundation/at_services/tree/trunk/packages/at_daemon_server/lib/src/server).

### AtClient

As previously mentioned, the AtClientManager stores the actual AtClient itself. You can retrieve the `AtClient` by calling `atClientManager.atClient`.

```dart
AtClient atClient = atClientManager.atClient;
```

### Monitor

You can subscribe to a stream of notifications like this:

```dart
AtClient atClient = AtClientManager.getInstance().atClient;
atClient.notificationService
  .subscribe(regex: 'message.$nameSpace@', shouldDecrypt: true)
  .listen((notification) {
      print("Got a message: ${notification.value}");
  });
```

### Notify

You can send (a.k.a. publish) a notification like this:

```dart
AtKey messageKey = (AtKey.shared('message', nameSpace)
    ..sharedWith('@bob')).build();
String message = "Hi bob, how are you?";
await atClient.notificationService.notify(
  NotificationParams.forUpdate(messageKey, value: message),
);
```
