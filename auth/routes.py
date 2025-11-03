from fastapi import APIRouter, Request
from fastapi.responses import RedirectResponse
from authlib.integrations.starlette_client import OAuth
import os
from dotenv import load_dotenv

load_dotenv()
router = APIRouter()

# Configurar OAuth con Azure AD
oauth = OAuth()
oauth.register(
    name="azure",
    server_metadata_url=f"https://login.microsoftonline.com/{os.getenv('AZURE_TENANT_ID')}/v2.0/.well-known/openid-configuration",
    client_id=os.getenv("AZURE_CLIENT_ID"),
    client_secret=os.getenv("AZURE_CLIENT_SECRET"),
    client_kwargs={"scope": "openid email profile"},
)

@router.get("/auth/login")
async def login_via_azure(request: Request):
    redirect_uri = os.getenv("REDIRECT_URI")
    return await oauth.azure.authorize_redirect(request, redirect_uri)

@router.get("/auth/callback")
async def auth_callback(request: Request):
    token = await oauth.azure.authorize_access_token(request)
    user = await oauth.azure.parse_id_token(request, token)
    return {"user": user}
