#!/usr/bin/python3
"""
A script that starts a Flask web application:
"""
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/', strict_slashes=False)
def hello_hbnb():
    return 'Hello HBNB!'

@app.route('/hbnb', strict_slashes=False)
def hbnb():
    return 'HBNB'

@app.route('/c/<text>', strict_slashes=False)
def c_text(text):
    # Replace underscores with spaces
    processed_text = text.replace('_', ' ')
    return f'C {processed_text}'

if __name__ == "__main__":

    app.run(debug=True, host="0.0.0.0", port=5000)
