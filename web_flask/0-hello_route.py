#!/usr/bin/python3
"""
A script that starts a Flask web application:
"""
from flask import Flask
airpnp_app = Flask(__name__)


@airpnp_app.route("/", strict_slashes=False)
def home():
    return ("Hello HBNB!")


if __name__ == "__main__":

    airpnp_app.run(debug=True, host="0.0.0.0", port=5000)
