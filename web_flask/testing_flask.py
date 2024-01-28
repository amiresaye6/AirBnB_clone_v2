#!/usr/bin/python3
"""
A script that starts a Flask web application:
"""
from flask import Flask, render_template
airbnb_app = Flask(__name__)


@airbnb_app.route("/", strict_slashes=False)
def home():
    return render_template("index.html", pagetitle="home page")


@airbnb_app.route("/about", strict_slashes=False)
def about():
    return render_template("about.html", pagetitle="about page")


if __name__ == "__main__":

    airbnb_app.run(debug=True, host="0.0.0.0", port=5000)
