# Verificación rápida de endpoints y funcionalidades (CHECKLIST)

Antes de reconstruir el APK hacia la URL de producción, verifica localmente que todo funciona.

## Endpoints básicos (FastAPI)
- [ ] GET / -> 200 OK
- [ ] GET /docs -> UI Swagger
- [ ] POST /login -> devuelve cookie/session o token
- [ ] POST /usuarios -> crear usuario
- [ ] GET /videos -> listar videos
- [ ] POST /videos -> subir video (si aplica)
- [ ] GET /conjuntos -> listar conjuntos de flashcards
- [ ] POST /conjuntos -> crear conjunto
- [ ] POST /flashcards -> crear flashcard
- [ ] PUT /usuarios/{id} -> actualizar usuario

Para cada endpoint de subida (videos/flashcards) probar con curl o Postman y revisar que el backend almacene o devuelva 201/200.

## UI (móvil / web)
- [ ] Registro de usuario funciona desde la app
- [ ] Login funciona y guarda sesión
- [ ] Subir un video desde la app (o desde endpoint) y comprobarlo en la lista
- [ ] Crear flashcard y comprobarlo en la lista
- [ ] Editar usuario (nombre, email) y ver cambios en Perfil
- [ ] Ver estadísticas en Perfil

## Notas de debugging
- Si uploads fallan: revisar logs del servidor (Render/Railway) para errores de storage o permisos.
- Para producción es recomendable usar almacenamiento externo (S3, GCS) y no el filesystem en el contenedor.

