(docker stop "$(< cid.txt)") || echo "container not found"
docker rmi $(docker images -f "dangling=true" -q)
