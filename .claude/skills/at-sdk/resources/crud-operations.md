---
description: How to do basic CRUD operations on an atServer
---

# CRUD Operations

## Flutter / Dart

In Dart, the AtClient is stored within the AtClientManager. Once an atSign has been [onboarded](onboarding.md), you will be able to access the AtClientManager for its associated atSign.

### AtClientManager

AtClientManager is a [singleton](https://en.wikipedia.org/wiki/Singleton\_pattern) model. When `AtClientManager.getInstance()` is called, it will get the AtClientManager instance for the last onboarded atSign.

```dart
AtClientManager atClientManager = AtClientManager.getInstance();
```

> If you need simultaneous access to multiple atClients, you need to create a new [isolate](https://dart.dev/language/concurrency#how-isolates-work) for each additional atClient, and onboard its atSign within the isolate.
>
> An example of this pattern can be found in [at_daemon_server](https://github.com/atsign-foundation/at_services/tree/trunk/packages/at_daemon_server/lib/src/server).

### AtClient

As previously mentioned, the AtClientManager stores the actual AtClient itself. You can retrieve the `AtClient` by calling `atClientManager.atClient`.

```dart
AtClient atClient = atClientManager.atClient;
```

#### atKey

Before you can do anything with an atRecord, you need an [atKey](../core/atrecord.md#atidentifier) to represent it.

If you don't know how to create an atKey, please see the [reference](atid-reference.md) first.

> The following examples use the self atKey `phone.wavi@<current atSign>`
>
> It is up to the developer to modify the atKey according to their use case.

#### Creating / Updating Data

To create data the `put` method is used, this method accepts text (`String`) or binary (`List<int>`).

```dart
String currentAtSign = atClient.getCurrentAtSign()!;
AtKey myID = AtKey.self('phone', namespace: 'wavi',
                        sharedBy: currentAtSign).build();
String dataToStore = "123-456-7890";
bool res = await atClient.put(myID, dataToStore);
```

```dart
// put signature
Future<bool> put(
    AtKey key,
    dynamic value,
    {bool isDedicated = false,
    PutRequestOptions? putRequestOptions});
```

**Strongly Typed Methods**

Since `put` accepts both `String` or `List<int>` as a value, the typing is dynamic. atClient also contains the strongly typed `putText` which only accepts `String` for the value, or `putBinary` which only accepts `List<int>` for the value.

**To update existing data**

Updating existing data is done by doing a put to the same atKey, this will overwrite any existing data stored in the atRecord.

```dart
List<int> binaryData = [1, 2, 3, 4];
bool res = await atClient.put(myID, binaryData);
```

The bytes `[1, 2, 3, 4]` have now replaced the string `"123-456-7890"`.

#### Reading Data

There are two parts to reading data using the atClient SDK:

1. Scanning for and listing out the atKeys for atRecords that can be retrieved
2. Retrieving the atRecord for a given atKey

**1. Scanning and listing atKeys**

There are two methods available for scanning and listing atKeys:

1. `getAtKeys` which provides the list in Class format (i.e. `List<AtKey>`)
2. `getKeys` which provides the list in String format (i.e. `List<String>`)

Both methods accept the same parameters, only the return type is different. So we will show the more commonly used getAtKeys signature:

```dart
// getAtKeys signature
Future<List<AtKey>> getAtKeys(
    {String? regex,
    String? sharedBy,
    String? sharedWith,
    bool showHiddenKeys = false});
```

_regex_

A regular expression used to filter the list of atKeys.

_sharedBy_

Filter the list of atKeys to only include ones shared by a particular atSign.

_sharedWith_

Filter the list of atKeys to only include ones shared with a particular atSign.

_showHiddenKeys_

A boolean flag to enable the inclusion of hidden atKeys (default = `false`)

**Usage**

Get all available (non-hidden) atKeys:

```dart
List<AtKey> allIDs = await atClient.getAtKeys();
```

All atKeys which end with ".wavi" in the record identifier part:

```dart
List<AtKey> waviIDs = await atClient.getAtKeys(regex: '^.*\.wavi@.+$');
```

**2. Retrieving atRecords by** atKey

To retrieve an atRecord, you must know the atKey and pass it to the `get` method.

```dart
// get signature
Future<AtValue> get(
    AtKey key,
    {bool isDedicated = false,
    GetRequestOptions? getRequestOptions});
```

Calling this function will return an AtValue, and update the atKey passed to it with any changes to the metadata.

**Usage**

```dart
AtValue atValue = await atClient.get(myID);
String? text = atValue.value;
```

#### Deleting Data

To delete data, simply call the `delete` method with the atKey for the atRecord to delete.

```dart
// delete signature
Future<bool> delete(
    AtKey key,
    {bool isDedicated = false});
```

**Usage**

```dart
bool res = await atClient.delete(myID);
```

### Additional Features

See [Additional Features](#additional-features) to learn about synchronization, which supports syncing of a local atServer, allowing CRUD operations to work even if the application has no internet access.

### API Docs

You can find the API reference for the entire package available on [pub](https://pub.dev/documentation/at_client/latest/).

The `AtClient` class API reference is available [here](https://pub.dev/documentation/at_client/latest/at_client/AtClient-class.html).
