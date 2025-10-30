---
description: An overview of Atsign's core pillars of technology
---

# atPlatform

## TL;DR

The atPlatform allows people, entities and things to communicate privately and securely without having to know about the intricacies of the underlying IP network. The atProtocol is the application protocol used to communicate and atSigns are the addresses on the protocol. All cryptographic keys are cut at the edge by the atSign owner, meaning only the receiving and sending atSigns see data in the clear.

The atPlatform can be used to send data synchronously or asynchronously and can be used as a data plane or a control plane or both simultaneously at Internet scale.

Every **atServer** is associated with _one_ **atSign**, and each atServer stores _many_ **atRecords.**

When provided an **atSign**, the **atDirectory** returns a _DNS address_ and _port number_ for its **atServer.**

The **atProtocol** is the _application layer protocol_ used to communicate with an **atServer.**

## atServer

An atServer is both a personal data service for storing encrypted data owned by an atSign, and a rendezvous point for information exchange. An atServer is responsible for the delivery of encrypted information to other atServers, from which the owners of those atSigns can then retrieve the data.

> Unless explicitly made public, atServers only store encrypted data and do not have access to the cryptographic keys, nor the ability to decrypt the stored information.


### atServer Functionality

* Cryptographic authentication of client devices.
* Cryptographic authentication of other atServers.
* Persistence of encrypted data on behalf of the controlling atSign.
* Caching of data shared by others with the controlling atSign.
* Notification of data change events to clients (edge devices) and other atServers to facilitate delivery of information shared with them.
* Synchronization of data with multiple clients (edge devices).
* TLS wire encryption from clients to atServers using SSL certificates.
* Mutually authenticated TLS 1.2/1.3 wire encryption between atServers using SSL certificates.


## atDirectory

In order for an atSign to communicate with another one on the internet, we need to locate the atServer that can send and receive information securely on its behalf.

The location of an atServer is found using the atDirectory service (`root.atsign.org:64`). This directory returns the DNS address and port number of the atServer for any atSign that it has a record for. The atDirectory service contains no information about the owner of the atSign.

## atProtocol

> The atProtocol communicates via layer 7, the application layer of the OSI model, over TCP/IP.

The atProtocol is an application protocol that enables data sharing between atSigns. The atProtocol uses TCP/IP and TLS but does not specify how data itself is encrypted, that is the job of the atSDK and atClient libraries.

## atSDK

atSDKs provide developers with atPlatform specific building tools in a number of languages and for a number of operating systems and hardware. The atSDK allows developers to rapidly develop applications that use the atPlatform.
