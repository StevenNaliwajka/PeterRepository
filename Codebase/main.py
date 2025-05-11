import logging
import shutil
import time
import threading
from pathlib import Path
from uuid import uuid4

from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse, FileResponse, Response
from fastapi.staticfiles import StaticFiles
from dotenv import dotenv_values
from daily_gif import DailyGif

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

# Initialize DailyGif
try:
    gif_picker = DailyGif()
except Exception as e:
    logger.exception("Error initializing DailyGif")
    raise

# Load .env config
env_path = Path(__file__).resolve().parent.parent / "Config" / "gif_pathing.env"
config = dotenv_values(env_path)

gif_base_path = config.get("GIF_BASE_PATH")
if not gif_base_path:
    raise RuntimeError("Missing GIF_BASE_PATH in config")

gif_static_dir = Path(gif_base_path)
if not gif_static_dir.exists():
    raise RuntimeError(f"Directory not found: {gif_static_dir}")

# Mount static GIFs folder
app.mount("/static/gifs", StaticFiles(directory=gif_static_dir), name="gifs")

# Ensure staticpeter folder exists
staticpeter_dir = Path(__file__).resolve().parent.parent / "staticpeter"
staticpeter_dir.mkdir(exist_ok=True)

# === Routes ===

@app.get("/favicon.ico")
def favicon():
    return Response(status_code=204)


@app.get("/peter")
async def serve_family_guy_gif():
    try:
        gif_path = gif_picker.get_random_gif_path()
        logger.info(f"Streaming GIF file: {gif_path}")
        return StreamingResponse(
            open(gif_path, mode="rb"),
            media_type="image/gif",
            headers={
                "Cache-Control": "no-store, no-cache, must-revalidate, max-age=0",
                "Pragma": "no-cache",
                "Expires": "0",
                "Content-Disposition": f'inline; filename="{uuid4().hex}.gif"'
            }
        )
    except Exception as e:
        logger.error(f"Error streaming GIF: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/staticpeter/peter.gif")
def serve_static_peter():
    target = staticpeter_dir / "peter.gif"
    if not target.exists():
        return Response(status_code=404, content="Static Peter not yet initialized")
    return FileResponse(
        path=target,
        media_type="image/gif",
        headers={
            "Cache-Control": "public, max-age=10",  # slight caching okay here
        }
    )


# === Background Updater ===

def static_peter_updater():
    while True:
        try:
            src_gif = gif_picker.get_random_gif_path()
            dest = staticpeter_dir / "peter.gif"
            shutil.copyfile(src_gif, dest)
            logger.info(f"[staticpeter] Updated: {src_gif} -> {dest}")
        except Exception as e:
            logger.error(f"[staticpeter] Failed to update: {e}")
        time.sleep(5)


@app.on_event("startup")
def start_background_task():
    thread = threading.Thread(target=static_peter_updater, daemon=True)
    thread.start()
    logger.info("[staticpeter] Background updater started")


@app.on_event("shutdown")
async def shutdown_event():
    logger.info("[DEBUG] FastAPI shutdown event triggered.")
