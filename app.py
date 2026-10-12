"""
Standard Flask entrypoint alias for cloud and serverless deployments (Vercel, Render, Railway, Heroku).
"""
import os
from run import app
application = app

if __name__ == "__main__":
    host = os.getenv("FLASK_HOST", "127.0.0.1")
    port = int(os.getenv("FLASK_PORT", 5000))
    debug = app.config.get("DEBUG", False)
    app.run(host=host, port=port, debug=debug)
