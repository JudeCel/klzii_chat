echo "Deploying latest test klzii_admin image from docker hub"
call gcloud container clusters get-credentials klzii-test
call kubectl delete deployment chat
call kubectl apply -f ../deploy/test/chat.yml
call kubectl get pods
