
import jwt
from datetime import  timedelta
import datetime

# Load keys
with open("rsa-private.pem", "r") as f:
    private_key = f.read()


# Create token payload
payload = {
    "sub": "user123",
    "name": "John Doe",
    "iss": "https://auth.example.com",
    "role": "admin",
    "iat": datetime.datetime.now(datetime.UTC),
    "exp": datetime.datetime.now(datetime.UTC) + timedelta(hours=1)
}

# Sign token with private key
token = jwt.encode(payload, private_key, algorithm="RS256")
print(f"Token: {token}")
