#!/usr/bin/python3
"""
A script that starts a Flask web application:
"""
from flask import Flask
airbnb_app = Flask(__name__)


@airbnb_app.route("/", strict_slashes=False)
def home():
    return ("Hello HBNB!")


@airbnb_app.route("/hbnb", strict_slashes=False)
def hbnb():
    return ("HBNB")


if __name__ == "__main__":

    airbnb_app.run(debug=True, host="0.0.0.0", port=5000)
