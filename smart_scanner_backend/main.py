from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from app.api.scan import router

app = FastAPI(
    title="Smart Scanner API",
    version="1.0.0"
)

app.mount(
    "/outputs",
    StaticFiles(directory="outputs"),
    name="outputs"
)

app.include_router(router)