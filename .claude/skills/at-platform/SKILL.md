---
name: at-platform
description: Use when working with atPlatform applications, implementing atSign/atRecord functionality, or need to understand atServer communication, key structures, metadata properties, or atDirectory lookups - provides reference documentation for core atPlatform concepts
---

# atPlatform Reference

## Overview

Reference documentation for the atPlatform's core technology: atSign identifiers, atRecord data format, atServer architecture, atDirectory lookup service, and atProtocol communication.

## When to Use

Reference this skill when:
- Implementing atSign authentication or key generation
- Working with atRecord storage (atKey structure, metadata, values)
- Building atServer communication or notification handling
- Need to understand atDirectory lookups or atProtocol commands
- Explaining atPlatform concepts in documentation or code
- Debugging atPlatform-specific data format or communication issues

## Quick Reference

| Concept | Description | Example |
|---------|-------------|---------|
| **atSign** | Unique identifier serving as atServer address | `@alice`, `@bob` |
| **atRecord** | Data storage format: atKey + atMetadata + atValue | `email.wavi@alice` |
| **atServer** | Personal data service and rendezvous point | Stores encrypted data |
| **atDirectory** | Lookup service for atSign locations | `root.atsign.org:64` |
| **atProtocol** | Layer 7 protocol for atServer communication | TCP/IP application layer |

## Core Concepts

### atSign
A unique identifier (e.g., `@alice`) that serves as the address for an atServer. Can be owned by people, entities, or things (IoT).

**Common operations:**
- Getting an atSign
- Generating cryptographic keys
- Authenticating with atServer

### atRecord
The data storage format used by atServers:
- **atKey**: The identifier (key in key-value pair)
- **atMetadata**: Properties describing the data (TTL, cache settings, etc.)
- **atValue**: The actual data (text or binary)

**Common operations:**
- Creating and storing records
- Setting metadata properties
- Querying and filtering records

### atServer
A personal data service for storing encrypted data owned by an atSign, and a rendezvous point for information exchange.

**Common operations:**
- Connecting to atServer
- Sending atProtocol commands
- Handling notifications

### atDirectory
A lookup service (`root.atsign.org:64`) that returns the DNS address and port number for any atSign's atServer.

**Common operations:**
- Looking up atSign locations
- Resolving atServer addresses

### atProtocol
The application layer protocol (Layer 7) used to communicate with atServers over TCP/IP.

**Common operations:**
- Sending CRUD commands
- Handling responses
- Managing connections

## Detailed Documentation

For comprehensive specifications and implementation details, see the `resources/` directory:

- **atsign.md**: Complete guide to atSigns, key generation, and authentication
- **atrecord.md**: Detailed atRecord specification including atKey syntax, metadata properties, and value formats
- **core-pillars-overview.md**: Architecture overview of atPlatform components
- **infrastructure.md**: Scaling and resilience design for production deployments

## Common Use Cases

**Storing user data:**
```
atKey: profile.myapp@alice
atMetadata: ttl=86400, ccd=false
atValue: {"name": "Alice", "email": "alice@example.com"}
```

**Sharing data with another atSign:**
```
atKey: @bob:document.myapp@alice
atMetadata: ttl=3600, ccd=true
atValue: "Shared document content"
```

**Querying records:**
- List all keys: `scan` command
- Filter by regex: `scan .*.myapp@`
- Get specific record: `lookup:atKey`
