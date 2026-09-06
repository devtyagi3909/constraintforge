import re

with open('/Users/devtyagi/Downloads/constraintforge/getting-started.html', 'r') as f:
    html = f.read()

# 1. Remove Emojis
html = html.replace('⚡ ', '')
html = html.replace('📈 ', '')
html = html.replace('🕒 ', '')
html = html.replace('🌳 ', '')
html = html.replace('🔨 ', '')
html = html.replace('[✓]', '[OK]')

# 2. Remove "Why ConstraintForge" Nav Link
html = re.sub(r'<a href="#why-constraintforge".*?</a>\n', '', html)

# 3. Remove the entire "Why ConstraintForge" section
html = re.sub(r'<section id="why-constraintforge">.*?</section>', '', html, flags=re.DOTALL)

# 4. Replace the introduction paragraph with a sleek 1-liner
sleek_intro = r"""<p style="font-size: 1.1rem; color: var(--text-muted); font-weight: 400; max-width: 600px;">Structural timing diagnostics in milliseconds. No synthesis, no routing, just deterministic O(|V|+|E|) math.</p>"""
html = re.sub(r'<p>Welcome to <strong>ConstraintForge</strong>.*?</p>', sleek_intro, html, flags=re.DOTALL)

with open('/Users/devtyagi/Downloads/constraintforge/getting-started.html', 'w') as f:
    f.write(html)
