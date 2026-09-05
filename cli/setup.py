from setuptools import setup, find_packages

setup(
    name="constraintforge",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "click>=8.1.0",
        "rich>=13.0.0",
    ],
    entry_points={
        "console_scripts": [
            "constraintforge=constraintforge.main:cli",
        ],
    },
)
