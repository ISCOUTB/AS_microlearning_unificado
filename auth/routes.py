from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import RedirectResponse
import os
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()

# Intentamos importar authlib, pero si no está instalado exponemos endpoints stub
try:
    from authlib.integrations.starlette_client import OAuth
    oauth = OAuth()
    # Registrar proveedor Azure si están las variables necesarias
    AZ_TENANT = os.getenv('AZURE_TENANT_ID')
    AZ_CLIENT_ID = os.getenv('AZURE_CLIENT_ID')
    AZ_CLIENT_SECRET = os.getenv('AZURE_CLIENT_SECRET')
    if AZ_TENANT and AZ_CLIENT_ID and AZ_CLIENT_SECRET:
        oauth.register(
            name="azure",
            server_metadata_url=f"https://login.microsoftonline.com/{AZ_TENANT}/v2.0/.well-known/openid-configuration",
            client_id=AZ_CLIENT_ID,
            client_secret=AZ_CLIENT_SECRET,
            client_kwargs={"scope": "openid email profile"},
        )
    else:
        oauth = None
except Exception:
    OAuth = None
    oauth = None


@router.get("/auth/login")
async def login_via_azure(request: Request):
    """Redirige al login de Azure si está configurado; si no, informa que falta la dependencia/config."""
    if oauth is None:
        raise HTTPException(status_code=501, detail="Autenticación con Azure no disponible (falta authlib o variables de entorno)")
    redirect_uri = os.getenv("REDIRECT_URI") or (request.url_for("auth_callback") if hasattr(request, 'url_for') else None)
    return await oauth.azure.authorize_redirect(request, redirect_uri)


@router.get("/auth/callback")
async def auth_callback(request: Request):
    if oauth is None:
        raise HTTPException(status_code=501, detail="Autenticación con Azure no disponible (falta authlib o variables de entorno)")
    token = await oauth.azure.authorize_access_token(request)
    user = await oauth.azure.parse_id_token(request, token)
    return {"user": user}
