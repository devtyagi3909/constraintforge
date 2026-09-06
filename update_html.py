import re

with open('/Users/devtyagi/Downloads/constraintforge/getting-started.html', 'r') as f:
    content = f.read()

# 1. Remove emojis and symbols like [✓]
content = content.replace('[✓]', '[OK]')
content = content.replace('✓', '')

# 2. Remove the "Why ConstraintForge" section in the HTML body
# The section likely starts with an <h2> or <h2 id="why-constraintforge"> and ends before the next <h2>
# Let's just use regex to strip out the specific section. We can find the exact text by searching.
# Instead of guessing the exact HTML structure, I will read the file and replace blocks.
