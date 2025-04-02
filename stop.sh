#!/bin/bash

PID_FILE="./flask_api.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "No running Flask API found."
    exit 1
fi

PID=$(cat "$PID_FILE")
echo "Stopping Flask API with PID $PID"
kill "$PID" && rm "$PID_FILE"
echo "Flask API stopped."
