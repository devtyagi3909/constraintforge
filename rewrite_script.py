import re

with open("/Users/devtyagi/Downloads/constraintforge/getting-started.html", "r") as f:
    html = f.read()

# We'll just replace the entire file with our improved version since we need to do a full architectural pass.
