import connexion
import os

app = connexion.App(__name__, specification_dir="./")
app.add_api("swagger.yml")
UPLOAD_FOLDER = os.path.join("/var/www/uploads")

# Define allowed files
ALLOWED_EXTENSIONS = {"csv"}


@app.route("/")
def home_page():
    return "hello world"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
