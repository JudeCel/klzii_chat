if docker images -f "dangling=true" -q | wc -l != 0
  then
	docker rmi -f $(docker images -f "dangling=true" -q)
fi
