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
REDIRECT_URI = "http://localhost:8000/auth/callback"

# URL base de Microsoft
AUTHORITY = f"https://login.microsoftonline.com/{TENANT_ID}"

# Scopes (permisos) que pediremos al usuario
SCOPE = ["User.Read"]

# Crear instancia del cliente MSAL
app_msal = ConfidentialClientApplication(
    client_id=CLIENT_ID,
    client_credential=CLIENT_SECRET,
    authority=AUTHORITY
)

@router.get("/auth/login")
def login_institucional():
    """
    Redirige al usuario a la página de inicio de sesión institucional de Microsoft.
    """
    auth_url = app_msal.get_authorization_request_url(
        scopes=SCOPE,
        redirect_uri=REDIRECT_URI
    )
    return RedirectResponse(auth_url)

@router.get("/auth/callback")
def callback(request: Request):
    """
    Recibe el código de Microsoft y obtiene el token del usuario.
    """
    code = request.query_params.get("code")
    if not code:
        raise HTTPException(status_code=400, detail="No se recibió el código de autorización.")

    # Intercambia el código por el token
    token = app_msal.acquire_token_by_authorization_code(
        code,
        scopes=SCOPE,
        redirect_uri=REDIRECT_URI
    )

    if "access_token" not in token:
        raise HTTPException(status_code=400, detail="Error al autenticar con Microsoft")

    # Información del usuario autenticado
    user_info = token.get("id_token_claims", {})
    correo = user_info.get("preferred_username")
    nombre = user_info.get("name")

    # Aquí podrías buscar o crear el usuario en tu base de datos
    return {"mensaje": "Login institucional exitoso", "usuario": nombre, "correo": correo}
