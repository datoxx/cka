kubectl describe pod web
kubectl logs web -f --previous # see logs of previous pod
kubectl config set-context --current  --nemespace=<namespace_name> # set namespace as default

sudo journalctl -u kubelet # see componets logs which are deploy as servisce
top # see memory, cpu
df -h # see disk space 
service kubelet status # se status of kubelet
/etc/kubernets/kubelet.con # file of kubeconfig file, used by kubelet  to connect kube-apiserver
/var/lib/kubelet/config.yaml # this is a file, which  containes proprtis, which used by kubelet servie.

openssl x509 -in /var/lib/kubelet/worker-1.crt  -text # see worker node's kublet certificate


#Kubernetes resources for coreDNS are:   
. service account named coredns
. cluster-roles named coredns and kube-dns
. clusterrolebindings named coredns and kube-dns
. deployment named coredns
. configmap named coredns
. service named kube-dns.



#Debug Service issues:  https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

#DNS Troubleshooting:  https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/

#install Weave: 
curl -L https://github.com/weaveworks/weave/releases/download/latest_release/weave-daemonset-k8s-1.11.yaml | kubectl apply -f -