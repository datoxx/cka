kubectl get pods -o wide # see detail info
kubectl replace --force -f nginx.yaml #deleted and created new 

kubectl get pods --selector app=App1 #filter/select pod by label app=App1

kubectl get all --selector env=prod --no-headers | wc -l # get objects with env=prod labels

kubectl get pods --selector="env=prod,bu=finance,tier=frontend"  # egt pods with this labels 

# taints and tolerations
kubectl taint nodes node-name key=value:taint-effect # effect can be NoSchedule | PreferNoSchedule | NoExecute
kubectl taint nodes node1 app=blue:NoSchedule  #this is example add taint to node
kubectl describe node kubemaster | grep Taint # see details of node taint
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule- # for untaint the node

kubectl label nodes <node-name> <label-key>=<label-value> # label nodes



# daemonsets
kubectl get daemonsets 


#Multiple Schedulers
kubectl get events -o wide
kubectl logs my-custom-scheduler --namespace=kube-system # to see logs
qq