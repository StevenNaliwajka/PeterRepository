import logging
import os
from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse, Response
from fastapi.staticfiles import StaticFiles
from daily_gif import DailyGif

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()
gif_picker = DailyGif()

# Serve local GIFs folder
static_gif_path = Path(__file__).resolve().parent.parent / "GIFs"
app.mount("/static/gifs", StaticFiles(directory=static_gif_path), name="gifs")

@app.get("/")
def root():
    return {"status": "FastAPI is running", "try": "/peter"}

@app.get("/favicon.ico")
def favicon():
    return Response(status_code=204)  # No content, just suppress browser 404

@app.get("/peter")
async def serve_family_guy_gif():
    try:
        gif_url = gif_picker.get_random_gif_url()
        logger.info(f"Redirecting to GIF URL: {gif_url}")
        return RedirectResponse(gif_url, status_code=302)
    except Exception as e:
        logger.error(f"Error serving GIF: {e}")
        raise HTTPException(status_code=500, detail=str(e))
