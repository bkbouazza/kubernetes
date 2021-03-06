minikube start --driver=docker

#INSTALL METALLB
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

#INSTALL NGINX
eval $(minikube docker-env)
cd nginx
docker build -t s-nginx . 
cd ..
kubectl apply -f config.yaml
kubectl apply -f nginx.yaml

#RUNNING DASHBOARD
#minikube dashboard &
