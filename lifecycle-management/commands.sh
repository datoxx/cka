#rollouts
kubectl set image  deployment deployment-name  container-name=nginx:1.19.1 # uodate image 
kubectl rollout status deployment/myapp-deployment # rollout command
kubectl rollout history myapp-deployment #revision and history 
kubectl rollout undo deployment/myapp-deployment # back to old revision pods

#commands and arguments 
kubectl run nginx --image=nginx -- <arg1> <arg2> ... <argN>  # Start the nginx pod using the default command, but use custom arguments (arg1 .. argN) for that command
kubectl run nginx --image=nginx --command -- <cmd> <arg1> ... <argN> # Start the nginx pod using a different command and custom arguments

#env  configmap
kubectl create configmap app-config --from-literal=APP_COLOR=blue --from-literal=APP_MOD=prod # stroe value key by from terminal
kubectl create configmap app-config --from-file=<file_path> # stroe value key by file
kubectl get configmaps # see configmaps


#env secrets
kubectl create secret generic app-secret --from-literal=APP_COLOR=blue --from-literal=APP_MOD=prod # stroe value key by from terminal
kubectl create secret generic app-secret --from-file=<file_path> # stroe value key by file
kubectl get secrets #see secrets
kubectl describe secrets # hide values
kubectl get secret secret-name -o yaml # for see secrets value


echo -n 'mysql' | base64 #in linux for encode text
echo -n 'bXlzcWw=' | base64 --decode #in linux for decode secret text

# see logs
kubectl  exec -it pod-name -- cat /log/app.log # if logs stored in log file
#or
kubectl  logs pod-name  
kubectl logs pod-name -c container-name # to se specific container lgos
