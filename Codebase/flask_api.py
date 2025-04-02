from flask import Flask, redirect
from Codebase.gif_picker import get_random_gif_url

app = Flask(__name__)

@app.route("/peter", methods=["GET"])
def serve_family_guy_gif():
    try:
        gif_url = get_random_gif_url()
        return redirect(gif_url, code=302)
    except Exception as e:
        return {"error": str(e)}, 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
