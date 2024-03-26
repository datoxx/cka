https://kubernetes.io/docs/reference/kubectl/conventions/ # commands

#pods
kubectl apply -f pod-definition.yml  #create pod by file
kubectl run redis --image=redis --dry-run=client -o yaml > redis.yaml # create pod yaml file using this command output
kubectl run nginx --image nginx # create pod just command
kubectl run redis -l tier=db --image=redis:alpine # create pod with labels
kubectl run httpd --image=httpd:alpine --port=80 --expose # Create a pod called httpd using the image httpd:alpine. 
#Next, create a service of type ClusterIP by the same name (httpd). The target port for the service should be 80.
kubectl replace -f elephant.yaml --force # This command will delete the existing one first and recreate a new one from the YAML file.
kubectl get pods   #get pod 
kubectl describe pod myapp-pod  #see detail info about pod
kubectl get pods -o wide # see more detail 


#replicaset
kubectl scale --replicas=6 -f replicaset.yml # scale pods in replicasets  by file input, but it scale pods but not modify files in replicaset file
kubectl scale --replicas=6 replicaset myapp-replicaset # scale pods by type and name
kubectl get replicaset # get replicas or shortcut rs
kubectl delete replicaset myapp-replicaset # delete replicaset and it's pods
kubectl api-resources | grep replicaset  # You can check for apiVersion of replicaset
kubectl explain replicaset | grep VERSION  # check version
kubectl edit replicaset new-replica-set # edit replicaset 


kubectl get all # see all objects created 

#deploymentdd
kubectl create -f nginx-deployment.yaml # create by file
kubectl run nginx --image=nginx  # Create an NGINX Pod
kubectl run nginx --image=nginx --dry-run=client -o yaml #Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)
kubectl create deployment --image=nginx nginx  #Create a deployment
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml  #Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml  #Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run) and save it to a file.
kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml  #version 1.19+, we can specify the --replicas option to create a deployment.
kubectl set image deployment nginx nginx=nginx:1.18 # update image

#Service
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml  # Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379 
#(This will automatically use the pod's labels as selectors)
#or 
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml #(This will not use the pods labels as selectors, instead it will assume selectors as app=redis.
# You cannot pass in selectors as an option.  #So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service)

kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml  #Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes:
#(This will automatically use the pod's labels as selectors, but you cannot specify the node port. 
#You have to generate a definition file and then add the node port in manually before creating the service with the pod.
#Or
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml


#Namespaces
kubectl create namespace dev
kubectl get namespace
kubectl config set-context $(kubectl config current-context) --namespace=dev
kubectl run nginx --image=nginx --namespace=<insert-namespace-name-here>
kubectl get pods --namespace=<insert-namespace-name-here>
kubectl get pods --all-namespaces


