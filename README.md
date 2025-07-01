# K8s-Website-Hosting

##Install minikube

# Create K8s resources

Deployment.yaml  
Service.yaml

# Do docker login

##Generate access token from dokcer webpage
```
echo "passwd" | docker login --username "username" --password-stdin
```
the creds will be stored in config.json   
./docker/config.json  

# base 64 encode 
```
cat ~/.docker/config.json | base64 -w 0
``` 
(The -w 0 (or --wrap=0) option is important to ensure the output is a single, continuous line, which is required for the Kubernetes Secret.)    
copy the string and paste it into k8s docker secret which you are creating 
```
kubectl apply -f docker-regcred.yaml  
```

**[Docker Secret is successfully created now edit your Deplolyment and include it in imagepullsecrets]**


