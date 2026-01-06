import jwt

token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyMTIzIiwibmFtZSI6IkpvaG4gRG9lIiwiaXNzIjoiaHR0cHM6Ly9hdXRoLmV4YW1wbGUuY29tIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzY3NTQyMzkwLCJleHAiOjE3Njc1NDU5OTB9.H06AYAVLQmp9rvH70KLV83MKqiSkvmOmFtAnhqIoOK0XfyX4UWBdGorkiVRmnYuTsHDJfsgQCU10cbgVENFSaFP3aUxqeZmEVOdFOV8yjbnCb8r1Y7auSLg5zATFJv5FCH07otzlYo_DcQKIbge3TqzA9Olbk7G3AFYIF-SiAKb5hXVsuGvZa6v1mqL0daFqEI0FuYg7XiI-E_IzoYSn47Ya13duKSXRpB-Yr8i9lA0Pv0j3KVI9Cz82uPAV2YIcl72IN8AVKtH2LFdzQHxuzDjzYoQokOPiqXg6-Tue_gCQaM00TOW8kHhidhnDNFPM1E0-DSBttU1FJh_SCjV7BQ"
with open("rsa-public.pem", "r") as f:
    public_key = f.read()

# Verify token with public key
try:
    decoded = jwt.decode(token,public_key,  algorithms=["RS256"],
                        #  audience="my-api",           # Token must have aud: "my-api"
    issuer="https://auth.example.com",  # Token must have iss: "https://auth.example.com"
    subject="user123",)
    print(f"Decoded: {decoded}")
except jwt.ExpiredSignatureError:
    print("Token has expired")
except jwt.InvalidTokenError:
    print("Invalid token")
    raise