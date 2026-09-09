set -g VIRTUALFISH_VERSION 2.5.9
set -g VIRTUALFISH_PYTHON_EXEC /usr/bin/python

# Resolve virtualfish across Python minor-version bumps (3.13 -> 3.14 etc.)
set -l _vf_candidates /usr/lib/python3.*/site-packages/virtualfish/virtual.fish
if set -q _vf_candidates[1]
    source $_vf_candidates[-1]
    emit virtualfish_did_setup_plugins
end
set -e _vf_candidates
