from flask import Flask, render_template, request, redirect
from pymongo import MongoClient
from dotenv import load_dotenv
import os
from datetime import datetime

load_dotenv()

app = Flask(__name__)
# MongoDB connection
client = MongoClient(os.getenv("MONGO_URI"))
db = client["quicknote"]
notes_collection = db["notes"]

@app.route("/")
def index():
    notes = notes_collection.find().sort("created_at", -1)
    return render_template("index.html", notes=notes)

@app.route("/add", methods=["POST"])
def add_note():
    text = request.form.get("text")

    if text:
        notes_collection.insert_one({
            "text": text,
            "created_at": datetime.utcnow()
        })

    return redirect("/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)