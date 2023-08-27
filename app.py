from flask import *
app = Flask(__name__)
import os
import pandas as pd
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = os.path.join('/var/www/uploads')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Define allowed files
ALLOWED_EXTENSIONS = {'csv'}

@app.route('/')
def hello_geek():
    return "hello world"

@app.route('/upload', methods=['POST'])
def uploadFile():
    if request.method == 'POST':
        # upload file flask
        f = request.files.get('file')

        # Extract a "safe" version of the filepath
        data_filename = secure_filename(f.filename)

        f.save(os.path.join(app.config['UPLOAD_FOLDER'],
                            data_filename))
    return "success!"


if __name__ == "__main__":
    app.run(debug=True)