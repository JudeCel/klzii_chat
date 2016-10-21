echo "Deploying latest production klzii_chat image from docker hub"
call gcloud container clusters get-credentials klzii-production
call kubectl delete deployment chat
call kubectl apply -f ../deploy/staging/chat.yml
call kubectl get pods