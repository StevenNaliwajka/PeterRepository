import os
import random
from dotenv import dotenv_values
from pathlib import Path

from Codebase.logic import determine_folder

# Load env values from ./Config/gif_pathing.env
env_path = Path(__file__).resolve().parent.parent / "Config" / "gif_pathing.env"
env = dotenv_values(env_path)

GIF_BASE_PATH = env.get("GIF_BASE_PATH")
GIF_BASE_URL = env.get("GIF_BASE_URL")


def get_random_gif_url():
    if not GIF_BASE_PATH or not GIF_BASE_URL:
        raise ValueError("Missing required values in gif_pathing.env")

    folder = determine_folder()
    local_path = os.path.join(GIF_BASE_PATH, folder)
    web_prefix = f"{GIF_BASE_URL}/{folder}"

    try:
        gif_files = [f for f in os.listdir(local_path) if f.endswith(".gif")]
    except FileNotFoundError:
        raise FileNotFoundError(f"GIF folder not found: {local_path}")

    if not gif_files:
        raise FileNotFoundError(f"No .gif files found in: {local_path}")

    selected = random.choice(gif_files)
    return f"{web_prefix}/{selected}"
