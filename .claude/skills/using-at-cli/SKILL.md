---
name: using-at-cli
description: Use when working with atSigns, atProtocol data, or atPlatform from command line - provides atcli verb reference (update, lookup, llookup, plookup, scan), authentication requirements, and flag syntax to prevent command errors
---

# Using at_cli

## Overview

`atcli` is the command-line interface for the atProtocol. Use specific verbs for different operations - don't guess at command names.

**Core principle**: atProtocol has specific verbs with specific auth requirements. Using the wrong verb will fail.

## When to Use

Use atcli when you need to:
- Look up values stored on atSigns
- Update/create key-value pairs on atSigns
- List keys on an atSign
- Test atProtocol integrations

**When NOT to use**: For application development, prefer atClient SDK libraries.

## Quick Reference

| Verb | Purpose | Auth Required | Common Use |
|------|---------|---------------|------------|
| `update` | Create/update keys | ✅ Yes | Store data on your atSign |
| `lookup` | Read another atSign's key | ✅ Yes | Get private/shared data from others |
| `llookup` | Read your own keys locally | ✅ Yes | Check your own private data |
| `plookup` | Read public keys | ❌ No | Get publicly shared data |
| `scan` | List keys | ⚠️ Optional | List all keys (auth) or public only (no auth) |

## Core Patterns

### Lookup Public Data (no auth)

```bash
# Check bob's public email
atcli -v plookup -k email --atsign @bob
```

**Key points**:
- Use `plookup` for public data
- No auth flags needed
- Fastest lookup method

### Lookup Your Own Private Data

```bash
# Check your own api_key value
atcli -v llookup -k api_key --atsign @alice --auth --authKeyFile ~/.atsign/keys/@alice_key.atKeys
```

**Key points**:
- Use `llookup` for local (your own) keys
- Requires auth
- "Local lookup" = your own atSign

### Lookup Keys from Another atSign

```bash
# Lookup a key shared with you or that you have permission to access
atcli -v lookup -k meeting_notes --atsign @bob --auth --authKeyFile ~/.atsign/keys/@alice_key.atKeys
```

**Key points**:
- Use `lookup` for keys from another atSign (shared with you or accessible)
- Requires auth
- Different from `llookup` (your own) and `plookup` (public)

### Update/Create Keys

```bash
# Create public key
atcli -v update -k phone --value "555-1234" -p true --auth --authKeyFile ~/.atsign/keys/@alice_key.atKeys --atsign @alice

# Create private key
atcli -v update -k api_key --value "secret123" -p false --auth --authKeyFile ~/.atsign/keys/@alice_key.atKeys --atsign @alice
```

**Key points**:
- Use `update` verb (not "set" or "create")
- `-p true` for public, `-p false` for private
- Always requires auth

### Scan Keys

```bash
# List public keys only (no auth)
atcli -v scan --atsign @alice

# List all keys (with auth)
atcli -v scan --atsign @alice --auth --authKeyFile ~/.atsign/keys/@alice_key.atKeys
```

**Key points**:
- Without auth: only public keys shown
- With auth: all accessible keys shown
- Use `-r` flag for regex filtering if needed

## Flag Syntax Reference

### Auth Flags

```bash
# All these work for enabling auth:
--auth
-a true

# Provide key file:
--authKeyFile ~/.atsign/keys/@youratsign_key.atKeys
-f ~/.atsign/keys/@youratsign_key.atKeys
```

### Public/Private Flags

```bash
# Public key:
-p true
--public

# Private key:
-p false
--no-public
```

### Command vs Verb Mode

**Verb mode** (recommended - clearer):
```bash
atcli -v plookup -k email --atsign @bob
```

**Command mode** (compact):
```bash
atcli -c "plookup:email@bob"
```

Use verb mode (`-v`) for clarity. Use command mode (`-c`) only if you're familiar with atProtocol syntax.

## Common Mistakes

### ❌ Don't Guess at Verbs

```bash
# WRONG: These verbs don't exist
atcli -v get --key email ...      # No "get" verb
atcli -v set --key phone ...      # No "set" verb
atcli -v read --key data ...      # No "read" verb

# RIGHT: Use actual atProtocol verbs
atcli -v llookup --key email ...  # For local lookup
atcli -v update --key phone ...   # For create/update
atcli -v plookup --key data ...   # For public lookup
```

### ❌ Don't Confuse Lookup Types

```bash
# WRONG: Using lookup when you mean local lookup
atcli -v lookup -k api_key --atsign @alice ...

# RIGHT: llookup for your own keys
atcli -v llookup -k api_key --atsign @alice --auth ...
```

### ❌ Don't Omit Boolean Values

```bash
# WRONG: Flag without value
atcli -v update -k phone --value "555-1234" --public ...

# RIGHT: Explicit boolean
atcli -v update -k phone --value "555-1234" -p true ...
```

### ❌ Don't Guess at Key Names

```bash
# WRONG: Assuming key name without checking
atcli -v plookup -k email --atsign @bob  # What if it's called 'emailAddress'?

# RIGHT: Scan first to see available keys
atcli -v scan --atsign @bob
# Then use the actual key name you see
```

### ❌ Don't Skip Auth When Required

```bash
# WRONG: llookup without auth
atcli -v llookup -k api_key --atsign @alice

# RIGHT: llookup always needs auth
atcli -v llookup -k api_key --atsign @alice --auth --authKeyFile ~/.atsign/keys/@alice_key.atKeys
```

### ❌ Don't Mix Command and Verb Modes

```bash
# WRONG: Mixing syntax from both modes
atcli -a @alice -k file.atKeys lookup email@bob

# RIGHT: Use verb mode with correct flags
atcli -v lookup -k email --atsign @bob --auth --authKeyFile file.atKeys

# OR: Use command mode properly
atcli -c "lookup:email@bob" --auth --authKeyFile file.atKeys --atsign @alice
```

## Auth File Locations

Standard locations for atKeys files:
```
~/.atsign/keys/@youratsign_key.atKeys
```

If user provides a different path, use that path exactly.

## When in Doubt

1. **Don't know the key name?** Run `scan` first
2. **Not sure if it's public?** Try `plookup` first (no auth needed), fall back to `llookup` if access denied
3. **Wrong verb error?** Check the Quick Reference table above
4. **Auth error?** Verify the `--authKeyFile` path exists and matches the `--atsign`

## Real-World Impact

Using correct verbs and auth prevents:
- "Access denied" errors from missing auth
- "Unknown verb" errors from guessing command names
- Unnecessary auth overhead on public lookups
- Failed updates from wrong flag syntax
