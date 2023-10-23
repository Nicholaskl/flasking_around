from flask import render_template
import config
from models import Transaction

app = config.connex_app
app.add_api(config.basedir / "swagger.yml")
# UPLOAD_FOLDER = os.path.join("/var/www/uploads")

# Define allowed files
ALLOWED_EXTENSIONS = {"csv"}


@app.route("/")
def home_page():
    return "hello world"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
