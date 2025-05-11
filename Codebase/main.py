import logging
from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse, Response
from fastapi.staticfiles import StaticFiles
from daily_gif import DailyGif
from dotenv import dotenv_values

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()
gif_picker = DailyGif()

# Load .env config
env_path = Path(__file__).resolve().parent.parent / "Config" / "gif_pathing.env"
config = dotenv_values(env_path)

# Validate GIF_BASE_PATH
gif_base_path = config.get("GIF_BASE_PATH")
if not gif_base_path:
    logger.error("GIF_BASE_PATH not set in environment config.")
    raise RuntimeError("Missing GIF_BASE_PATH in config")

gif_static_dir = Path(gif_base_path)
if not gif_static_dir.exists():
    logger.error(f"GIF_BASE_PATH directory does not exist: {gif_static_dir}")
    raise RuntimeError(f"Directory not found: {gif_static_dir}")

# Mount static GIFs folder
app.mount("/static/gifs", StaticFiles(directory=gif_static_dir), name="gifs")

@app.get("/favicon.ico")
def favicon():
    return Response(status_code=204)  # No content, just suppress browser 404

@app.get("/")
async def serve_family_guy_gif():
    try:
        gif_url = gif_picker.get_random_gif_url()
        logger.info(f"Redirecting to GIF URL: {gif_url}")
        return RedirectResponse(gif_url, status_code=302)
    except Exception as e:
        logger.error(f"Error serving GIF: {e}")
        raise HTTPException(status_code=500, detail=str(e))
