from flask import *
import os
import pandas as pd
from werkzeug.utils import secure_filename
from datetime import datetime

app = Flask(__name__)
UPLOAD_FOLDER = os.path.join('/var/www/uploads')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Define allowed files
ALLOWED_EXTENSIONS = {'csv'}

@app.route('/')
def home_page():
    return "hello world"

@app.route('/upload', methods=['POST'])
def uploadFile():
    if request.method == 'POST':
        # upload file flask
        f = request.files.get('file')

        # Extract a "safe" version of the filepath
        data_filename = secure_filename(f.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'],
                            data_filename)
        
        f.save(filepath)
        
        # Open the file in a pandas data frame
        new_df = pd.read_csv(filepath,
                         encoding='unicode_escape')
        
        new_df['date']= pd.to_datetime(new_df['date'], dayfirst=True)
        
        df = pd.read_csv("/var/www/db/db.csv")
        df['date'] = pd.to_datetime(df['date'])

        # Sort the data frame by date
        new_df.sort_values("date")

        # Check if the earliest is later than the latest in pre-existing DF
        # (Easy check to avoid collisions for now...)
        if new_df["date"].iloc[0] > df["date"].iloc[-1]:
            new = pd.concat([df, new_df], axis=0, ignore_index=True)
            

        # Then if so, we can add the data frame to the current one
        # Export the dataframe as a CSV to /var/www/db/db.csv
        new.to_csv("/var/www/db/db.csv")

    return "success!"


if __name__ == "__main__":
    app.run(debug=True)