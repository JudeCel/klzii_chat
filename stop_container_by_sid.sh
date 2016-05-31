(docker stop "$(< cid.txt)") || echo "container not found"
