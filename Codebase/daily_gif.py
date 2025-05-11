import os
import random
import json
from datetime import datetime
from pathlib import Path
from dotenv import dotenv_values
from uuid import uuid4


class DailyGif:
    def __init__(self):
        # Load .env config
        env_path = Path(__file__).resolve().parent.parent / "Config" / "gif_pathing.env"
        config = dotenv_values(env_path)

        self.base_path = str((Path(__file__).resolve().parent.parent / config.get("GIF_BASE_PATH")).resolve())
        self.base_url = config.get("GIF_BASE_URL")
        self.config_path = Path(__file__).resolve().parent.parent / "Config" / "gif_config.json"

        self.cached_date = None
        self.cached_folder = None

        if not self.base_path or not self.base_url:
            raise ValueError("Missing GIF_BASE_PATH or GIF_BASE_URL in gif_pathing.env")

    def _determine_folder(self):
        today_str = datetime.now().strftime("%Y-%m-%d")
        if self.cached_date == today_str and self.cached_folder:
            return self.cached_folder

        now = datetime.now().date().replace(year=2000)
        fallback = None

        with open(self.config_path) as f:
            config = json.load(f)

        for rule in config.get("rules", []):
            if rule.get("default"):
                fallback = rule["folder"]
                continue

            start = datetime.strptime(rule["start"], "%m-%d").replace(year=2000).date()
            end = datetime.strptime(rule["end"], "%m-%d").replace(year=2000).date()

            if start <= now <= end:
                self.cached_date = today_str
                self.cached_folder = rule["folder"]
                return self.cached_folder

        self.cached_date = today_str
        self.cached_folder = fallback
        return fallback

    def get_random_gif_url(self):
        folder = self._determine_folder()
        local_path = os.path.join(self.base_path, folder)
        web_prefix = f"{self.base_url}/{folder}"

        try:
            gif_files = [f for f in os.listdir(local_path) if f.endswith(".gif")]
        except FileNotFoundError:
            raise FileNotFoundError(f"GIF folder not found: {local_path}")

        if not gif_files:
            raise FileNotFoundError(f"No .gif files found in: {local_path}")

        selected = random.choice(gif_files)
        base_url = f"{web_prefix}/{selected}"
        return f"{base_url}?v={uuid4().hex}"

    def get_random_gif_path(self):
        folder = self._determine_folder()
        local_path = os.path.join(self.base_path, folder)

        try:
            gif_files = [f for f in os.listdir(local_path) if f.endswith(".gif")]
        except FileNotFoundError:
            raise FileNotFoundError(f"GIF folder not found: {local_path}")

        if not gif_files:
            raise FileNotFoundError(f"No .gif files found in: {local_path}")

        selected = random.choice(gif_files)
        return os.path.join(local_path, selected)


    def reset_cache(self):
        self.cached_date = None
        self.cached_folder = None
