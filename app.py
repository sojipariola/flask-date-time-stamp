# app.py
from flask import Flask, jsonify
import socket
import datetime

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify(
        timestamp=datetime.datetime.now().isoformat(),
        hostname=socket.gethostname()
    )

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
