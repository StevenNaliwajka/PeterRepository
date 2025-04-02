import json
from datetime import datetime
from pathlib import Path

CONFIG_PATH = Path(__file__).resolve().parent.parent / "Config" / "gif_config.json"

_cached_date = None
_cached_folder = None

def determine_folder():
    global _cached_date, _cached_folder
    today_str = datetime.now().strftime("%Y-%m-%d")

    if _cached_date == today_str and _cached_folder:
        return _cached_folder

    fallback_folder = None
    now = datetime.now().date().replace(year=2000)

    with open(CONFIG_PATH) as f:
        config = json.load(f)

    for rule in config.get("rules", []):
        if rule.get("default"):
            fallback_folder = rule["folder"]
            continue

        start = datetime.strptime(rule["start"], "%m-%d").replace(year=2000).date()
        end = datetime.strptime(rule["end"], "%m-%d").replace(year=2000).date()

        if start <= now <= end:
            _cached_date = today_str
            _cached_folder = rule["folder"]
            return _cached_folder

    _cached_date = today_str
    _cached_folder = fallback_folder
    return _cached_folder

def reset_cache():
    global _cached_date, _cached_folder
    _cached_date = None
    _cached_folder = None
