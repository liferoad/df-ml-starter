# standard libraries
import os

# third party libraries
import setuptools

required = []
if os.path.exists("requirements.txt"):
    with open("requirements.txt") as f:
        required = f.read().splitlines()

setuptools.setup(
    name="src",
    version="0.0.1",
    install_requires=required,
    packages=["src"],
)
