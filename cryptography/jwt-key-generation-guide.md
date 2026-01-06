# JWT Key Generation Guide

A comprehensive guide to understanding and generating cryptographic keys for JWT (JSON Web Token) authentication.

---

## Table of Contents

1. [Understanding the Basics](#understanding-the-basics)
2. [Symmetric vs Asymmetric Keys](#symmetric-vs-asymmetric-keys)
3. [JWT Signing Algorithms](#jwt-signing-algorithms)
4. [Key Generation with OpenSSL](#key-generation-with-openssl)
5. [Code Examples](#code-examples)
6. [Security Best Practices](#security-best-practices)
7. [Common Use Cases](#common-use-cases)

---

## Understanding the Basics

### What is a JWT?

A JSON Web Token (JWT) is a compact, URL-safe way to represent claims between two parties. It consists of three parts:

```
eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJ1c2VyMTIzIn0.signature
│                      │                        │
│                      │                        └── Signature
│                      └── Payload (claims)
└── Header
```

### Why Sign JWTs?

Signing ensures:
- **Integrity**: The token hasn't been modified
- **Authenticity**: The token came from a trusted source

---

## Symmetric vs Asymmetric Keys

### Symmetric (Shared Secret)

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   Server A                              Server B        │
│      │                                     │            │
│      │      Shared Secret: "my-secret"     │            │
│      │◄───────────────────────────────────►│            │
│      │                                     │            │
│      │  Can Sign ✅        Can Sign ✅     │            │
│      │  Can Verify ✅      Can Verify ✅   │            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

- **Same key** for signing and verifying
- Both parties must keep the secret safe
- Algorithms: HS256, HS384, HS512
- Fast and simple
- **Limitation**: Cannot prove WHO signed it

### Asymmetric (Public/Private Key Pair)

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   Auth Server                           Any Client      │
│      │                                     │            │
│   Private Key 🔐                      Public Key 🔓     │
│   (keep secret)                       (share freely)    │
│      │                                     │            │
│      │  Can Sign ✅        Can Sign ❌     │            │
│      │  Can Verify ✅      Can Verify ✅   │            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

- **Private key**: Only the issuer has it, used to sign
- **Public key**: Anyone can have it, used to verify
- Algorithms: RS256, RS384, RS512, ES256, ES384, ES512
- Provides **non-repudiation**: Proof of who signed
- **Best for**: Distributed systems, third-party verification

### Comparison Table

| Aspect | Symmetric (HS256) | Asymmetric (RS256/ES256) |
|--------|-------------------|--------------------------|
| Keys | 1 shared secret | 2 keys (public + private) |
| Who can sign | Anyone with secret | Only private key holder |
| Who can verify | Anyone with secret | Anyone with public key |
| Speed | Faster | Slower |
| Key distribution | Must be secure | Public key can be shared openly |
| Use case | Internal services | Public APIs, OAuth, OIDC |

---

## JWT Signing Algorithms

### HMAC (Symmetric)

| Algorithm | Hash Function | Output Size |
|-----------|---------------|-------------|
| HS256 | SHA-256 | 256 bits |
| HS384 | SHA-384 | 384 bits |
| HS512 | SHA-512 | 512 bits |

### RSA (Asymmetric)

| Algorithm | Hash Function | Min Key Size | Signature Size |
|-----------|---------------|--------------|----------------|
| RS256 | SHA-256 | 2048 bits | 256 bytes |
| RS384 | SHA-384 | 2048 bits | 384 bytes |
| RS512 | SHA-512 | 2048 bits | 512 bytes |

### ECDSA (Asymmetric - Recommended)

| Algorithm | Curve | Key Size | Signature Size |
|-----------|-------|----------|----------------|
| ES256 | P-256 | 256 bits | 64 bytes |
| ES384 | P-384 | 384 bits | 96 bytes |
| ES512 | P-521 | 521 bits | 132 bytes |

**Why prefer ECDSA (ES256)?**
- Smaller keys and signatures
- Faster operations
- Same security level as RSA with much smaller keys
- ES256 (256-bit) ≈ RSA 3072-bit in security

---

## Key Generation with OpenSSL

### Prerequisites

```bash
# Check OpenSSL is installed
openssl version

# Should output something like: OpenSSL 3.0.x
```

### Generate RSA Keys (RS256)

```bash
# Step 1: Generate private key (2048-bit)
openssl genrsa -out rsa-private.pem 2048

# Step 2: Extract public key from private key
openssl rsa -in rsa-private.pem -pubout -out rsa-public.pem

# Step 3: Verify the keys
openssl rsa -in rsa-private.pem -check
```

**For stronger security (4096-bit):**

```bash
openssl genrsa -out rsa-private-4096.pem 4096
openssl rsa -in rsa-private-4096.pem -pubout -out rsa-public-4096.pem
```

### Generate ECDSA Keys (ES256) - Recommended

```bash
# Step 1: Generate private key using P-256 curve
openssl ecparam -genkey -name prime256v1 -noout -out ec-private.pem

# Step 2: Extract public key
openssl ec -in ec-private.pem -pubout -out ec-public.pem

# Step 3: Verify the key
openssl ec -in ec-private.pem -check
```

**For ES384 and ES512:**

```bash
# ES384 (P-384 curve)
openssl ecparam -genkey -name secp384r1 -noout -out ec384-private.pem
openssl ec -in ec384-private.pem -pubout -out ec384-public.pem

# ES512 (P-521 curve)
openssl ecparam -genkey -name secp521r1 -noout -out ec512-private.pem
openssl ec -in ec512-private.pem -pubout -out ec512-public.pem
```

### Generate Password-Protected Private Key

```bash
# RSA with AES-256 encryption
openssl genrsa -aes256 -out rsa-private-encrypted.pem 2048
# You'll be prompted to enter a passphrase

# ECDSA with encryption
openssl ecparam -genkey -name prime256v1 | \
    openssl ec -aes256 -out ec-private-encrypted.pem
```

### View Key Details

```bash
# View RSA private key details
openssl rsa -in rsa-private.pem -text -noout

# View ECDSA private key details
openssl ec -in ec-private.pem -text -noout

# View public key
cat ec-public.pem
```

### Convert Key Formats

```bash
# PEM to PKCS#8 format (some libraries require this)
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt \
    -in ec-private.pem -out ec-private-pkcs8.pem

# PEM to DER format (binary)
openssl ec -in ec-private.pem -outform DER -out ec-private.der

# Public key PEM to DER
openssl ec -pubin -in ec-public.pem -outform DER -out ec-public.der
```

---

## Code Examples

### Python (PyJWT)

```bash
# Install the library
pip install pyjwt cryptography
```

```python
import jwt
from datetime import datetime, timedelta

# Load keys
with open("ec-private.pem", "r") as f:
    private_key = f.read()

with open("ec-public.pem", "r") as f:
    public_key = f.read()

# Create token payload
payload = {
    "sub": "user123",
    "name": "John Doe",
    "role": "admin",
    "iat": datetime.utcnow(),
    "exp": datetime.utcnow() + timedelta(hours=1)
}

# Sign token with private key
token = jwt.encode(payload, private_key, algorithm="ES256")
print(f"Token: {token}")

# Verify token with public key
try:
    decoded = jwt.decode(token, public_key, algorithms=["ES256"])
    print(f"Decoded: {decoded}")
except jwt.ExpiredSignatureError:
    print("Token has expired")
except jwt.InvalidTokenError:
    print("Invalid token")
```

### Node.js (jsonwebtoken)

```bash
# Install the library
npm install jsonwebtoken
```

```javascript
const jwt = require('jsonwebtoken');
const fs = require('fs');

// Load keys
const privateKey = fs.readFileSync('ec-private.pem');
const publicKey = fs.readFileSync('ec-public.pem');

// Create token payload
const payload = {
    sub: 'user123',
    name: 'John Doe',
    role: 'admin'
};

// Sign token with private key
const token = jwt.sign(payload, privateKey, {
    algorithm: 'ES256',
    expiresIn: '1h'
});
console.log('Token:', token);

// Verify token with public key
try {
    const decoded = jwt.verify(token, publicKey, {
        algorithms: ['ES256']
    });
    console.log('Decoded:', decoded);
} catch (err) {
    console.error('Verification failed:', err.message);
}
```

### Go

```go
package main

import (
    "crypto/ecdsa"
    "crypto/x509"
    "encoding/pem"
    "fmt"
    "io/ioutil"
    "time"

    "github.com/golang-jwt/jwt/v5"
)

func main() {
    // Load private key
    keyData, _ := ioutil.ReadFile("ec-private.pem")
    block, _ := pem.Decode(keyData)
    privateKey, _ := x509.ParseECPrivateKey(block.Bytes)

    // Create claims
    claims := jwt.MapClaims{
        "sub":  "user123",
        "name": "John Doe",
        "exp":  time.Now().Add(time.Hour).Unix(),
    }

    // Create and sign token
    token := jwt.NewWithClaims(jwt.SigningMethodES256, claims)
    tokenString, _ := token.SignedString(privateKey)
    fmt.Println("Token:", tokenString)

    // Verify with public key
    pubKeyData, _ := ioutil.ReadFile("ec-public.pem")
    pubBlock, _ := pem.Decode(pubKeyData)
    pubKey, _ := x509.ParsePKIXPublicKey(pubBlock.Bytes)

    parsed, _ := jwt.Parse(tokenString, func(t *jwt.Token) (interface{}, error) {
        return pubKey.(*ecdsa.PublicKey), nil
    })
    fmt.Println("Valid:", parsed.Valid)
}
```

---

## Security Best Practices

### Protect Your Private Keys

```bash
# Set strict file permissions
chmod 600 private.pem

# Never commit keys to version control
echo "*.pem" >> .gitignore
echo "*.key" >> .gitignore
```

### Use Environment Variables or Secret Managers

```bash
# Bad: Hardcoded in code
private_key = "-----BEGIN EC PRIVATE KEY-----..."

# Good: Environment variable
export JWT_PRIVATE_KEY=$(cat ec-private.pem)

# Better: Secret manager (GCP Secret Manager, AWS Secrets Manager, HashiCorp Vault)
```

### Key Rotation Strategy

1. Generate new key pair
2. Add new public key to verification (accept both old and new)
3. Start signing with new private key
4. After grace period, remove old public key

### Algorithm Selection

| Scenario | Recommended Algorithm |
|----------|----------------------|
| New projects | ES256 |
| Legacy compatibility | RS256 |
| Internal microservices | HS256 (if key distribution is secure) |
| High security requirements | ES384 or ES512 |

### Token Best Practices

```python
# Always set expiration
payload = {
    "exp": datetime.utcnow() + timedelta(minutes=15),  # Short-lived
    "iat": datetime.utcnow(),
    "nbf": datetime.utcnow(),  # Not valid before
}

# Include only necessary claims
# Don't put sensitive data in JWT (it's only base64 encoded, not encrypted)
```

---

## Common Use Cases

### 1. API Authentication

```
Client                          API Server
   │                                │
   │  1. Login (username/password)  │
   │ ──────────────────────────────►│
   │                                │
   │  2. JWT Token                  │
   │ ◄──────────────────────────────│
   │                                │
   │  3. Request + Bearer Token     │
   │ ──────────────────────────────►│
   │                                │
   │  4. Response                   │
   │ ◄──────────────────────────────│
```

### 2. Microservices Authentication

```
                    ┌─────────────────┐
                    │   Auth Service  │
                    │   (has private  │
                    │      key)       │
                    └────────┬────────┘
                             │ Issues JWT
                             ▼
┌──────────┐  JWT    ┌──────────┐  JWT    ┌──────────┐
│ Service A│◄───────►│ Service B│◄───────►│ Service C│
│(public   │         │(public   │         │(public   │
│  key)    │         │  key)    │         │  key)    │
└──────────┘         └──────────┘         └──────────┘

Each service can verify tokens independently using the public key
```

### 3. OAuth 2.0 / OpenID Connect

```
┌────────┐     ┌─────────────┐     ┌──────────────┐
│  User  │────►│ Application │────►│ Auth Provider│
└────────┘     └─────────────┘     │ (Google,     │
                                   │  Auth0, etc) │
                                   └──────┬───────┘
                                          │
                                    ID Token (JWT)
                                    signed with RS256/ES256
```

---

## Quick Reference Commands

```bash
# Generate ES256 key pair (recommended)
openssl ecparam -genkey -name prime256v1 -noout -out private.pem
openssl ec -in private.pem -pubout -out public.pem

# Generate RS256 key pair
openssl genrsa -out private.pem 2048
openssl rsa -in private.pem -pubout -out public.pem

# View key info
openssl ec -in private.pem -text -noout
openssl rsa -in private.pem -text -noout

# Verify key integrity
openssl ec -in private.pem -check
openssl rsa -in private.pem -check
```

---

## Additional Resources

- [JWT.io](https://jwt.io) - Decode and verify JWTs online
- [RFC 7519](https://tools.ietf.org/html/rfc7519) - JWT Specification
- [RFC 7518](https://tools.ietf.org/html/rfc7518) - JSON Web Algorithms
- [OpenSSL Documentation](https://www.openssl.org/docs/)

---

*Generated for educational purposes. Always follow your organization's security policies when handling cryptographic keys.*
