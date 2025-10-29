---
description: How to authenticate to an atServer
---

# Authentication

## Dart

### Package Installation

In Dart we provide the [at_onboarding_cli](https://pub.dev/packages/at_onboarding_cli) package which handles onboarding to the atServer via files stored in the ~/.atsign/keys directory

Add the package to your project automatically using pub:

```
dart pub add at_onboarding_cli
```

### Usage

Set up the [preferences](https://pub.dev/documentation/at_onboarding_cli/latest/at_onboarding_cli/AtOnboardingPreference-class.html) to onboard to the atServer.

```dart
 AtOnboardingPreference atOnboardingConfig = AtOnboardingPreference()
    ..hiveStoragePath = '$homeDirectory/.$nameSpace/$fromAtsign/storage'
    ..namespace = nameSpace
    ..downloadPath = '$homeDirectory/.$nameSpace/files'
    ..isLocalStoreRequired = true
    ..commitLogPath = '$homeDirectory/.$nameSpace/$fromAtsign/storage/commitLog'
    ..rootDomain = rootDomain
    ..fetchOfflineNotifications = true
    ..atKeysFilePath = atsignFile
    ..atProtocolEmitted = Version(2, 0, 0);
```

Next get the onboardingService

```dart
  AtOnboardingService onboardingService = AtOnboardingServiceImpl(
      fromAtsign, atOnboardingConfig,
      atServiceFactory: atServiceFactory);
```

Finally wait to be onboarded, this returns true once complete.

```dart
await onboardingService.authenticate();
```

This can be wrapped to check that the onboard was successful with the code snippet below.

```dart

bool onboarded = false;
  Duration retryDuration = Duration(seconds: 3);
  while (!onboarded) {
    try {
      stdout.write('\r\x1b[KConnecting ... ');
      await Future.delayed(Duration(
          milliseconds:
          1000)); // Pause just long enough for the retry to be visible
      onboarded = await onboardingService.authenticate();
    } catch (exception) {
      stdout.write(
          '$exception. Will retry in ${retryDuration.inSeconds} seconds');
    }
    if (!onboarded) {
      await Future.delayed(retryDuration);
    }
  }
  stdout.writeln('Connected');
```

## Flutter

### Package Installation

In Flutter, we provide the [at_onboarding_flutter](https://pub.dev/packages/at_onboarding_flutter) package which handles secure management of these secret keys.

Add the package to your project automatically using pub:

```
flutter pub add at_onboarding_flutter
```

### Usage

Simply call the [`onboard`](https://pub.dev/documentation/at_onboarding_flutter/latest/at_onboarding/AtOnboarding/onboard.html) method whenever you want your app to open the onboarding widget.

```dart
AtOnboardingResult onboardingResult = await AtOnboarding.onboard(
  context: context,
  config: AtOnboardingConfig(
    atClientPreference: futurePreference,
    rootEnvironment: RootEnvironment.Production,
    appAPIKey: dotenv.env['API_KEY'],
    domain: 'root.atsign.org',
  ),
);
```

#### API Key setup

To get an API key for your app, first head to the [registrar website](https://my.atsign.com/dashboard), then click manage under one of your atSigns:

Then open the Advanced settings drop down and click `Generate New API Key`:
