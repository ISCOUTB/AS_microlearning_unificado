from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import RedirectResponse
from msal import ConfidentialClientApplication
import os
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()

# 🧩 Configuración de Azure AD
CLIENT_ID = os.getenv("AZURE_CLIENT_ID")
CLIENT_SECRET = os.getenv("AZURE_CLIENT_SECRET")
TENANT_ID = os.getenv("AZURE_TENANT_ID")
REDIRECT_URI = os.getenv("REDIRECT_URI") or "http://localhost:8000/auth/callback"

AUTHORITY = f"https://login.microsoftonline.com/{TENANT_ID}"
SCOPE = ["User.Read"]

# Crear instancia del cliente MSAL si hay credenciales
app_msal = None
try:
    if CLIENT_ID and CLIENT_SECRET and TENANT_ID:
        app_msal = ConfidentialClientApplication(
            client_id=CLIENT_ID,
            client_credential=CLIENT_SECRET,
            authority=AUTHORITY
        )
except Exception:
    app_msal = None


@router.get("/auth/login")
def login_institucional():
    if app_msal is None:
        raise HTTPException(status_code=501, detail="MSAL no configurado o falta dependencia msal")
    auth_url = app_msal.get_authorization_request_url(scopes=SCOPE, redirect_uri=REDIRECT_URI)
    return RedirectResponse(auth_url)


@router.get("/auth/callback")
def callback(request: Request):
    if app_msal is None:
        raise HTTPException(status_code=501, detail="MSAL no configurado o falta dependencia msal")
    code = request.query_params.get("code")
    if not code:
        raise HTTPException(status_code=400, detail="No se recibió el código de autorización.")
    token = app_msal.acquire_token_by_authorization_code(code, scopes=SCOPE, redirect_uri=REDIRECT_URI)
    if not token or "access_token" not in token:
        raise HTTPException(status_code=400, detail="Error al autenticar con Microsoft")
    user_info = token.get("id_token_claims", {})
    correo = user_info.get("preferred_username")
    nombre = user_info.get("name")
    return {"mensaje": "Login institucional exitoso", "usuario": nombre, "correo": correo}
