import re

def replace_hex_color(match):
    return '#e95420'

def replace_rgba_color(match):
    return 'rgba(233, 84, 32, {})'.format(match.group(1))

with open('gnome-shell.css', 'r') as file:
    data = file.read()

data = re.sub('#ff7800', replace_hex_color, data, flags=re.IGNORECASE)

rgba_pattern = re.compile(r'rgba\(255, 120, 0, (.*?)\);', re.IGNORECASE)
data = rgba_pattern.sub(replace_rgba_color, data)

with open('gnome-shell.css', 'w') as file:
    file.write(data)
