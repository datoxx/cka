kubectl drain node-1 # move nodes worload in other node
kubectl uncordon node-1 # for schedualable master node to this node
kubectl cordon node-2 # mark node as unschedualable

#upgrade cluster by kubeadm, if your cluset  manged by kubeadm
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/

kubeadm upgrade plan
kubeadm upgrade apply  v1.12.0 # before upgrade claster, you must upgrade kubeadm itself, #apt-get upgrade -y kubeadm=1.12.0-00

##upgrade worker nodes,
#kubectl drain node-1  
#apt-get upgrade -y kubeadm=1.12.0-00
#apt-get upgrade -y kublet=1.12.0-00
#kubeadm upgrade node config --kubelet-version v1.12.0
#systemctl restart kubelet
#kubectl uncordon node-1

#backup
kubectl get all --all-namespaces -o yaml > all-deploy-services.yaml # get all services in yaml file


#backup and restore etcd 
–data-dir=/var/lib/etcd  # location to store data 
#Or make snapshot 
etcdctl snapshot save -h #help command for see options
etcdctl snapshot restore -h #help command for see options

# etcdctl commands needs certificate files
#Since our ETCD database is TLS-Enabled, the following options are mandatory:
--cacert #verify certificates of TLS-enabled secure servers using this CA bundle
--cert # identify secure client using this TLS certificate file
--endpoints=[127.0.0.1:2379] #This is the default as ETCD is running on master node and exposed on localhost 2379.
--key #identify secure client using this TLS key file

export ETCDCTL_API=3 # you cen set first for next do not need speficu version 

ETCDCTL_API=3 etcdctl  snapshot save snapshot.db # make snapshot.db file
ETCDCTL_API=3 etcdctl  snapshot status snapshot.db # see status  snapshot

#full  code:
etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db

#restore 
etcdctl  --data-dir /var/lib/etcd-from-backup \
snapshot restore /opt/snapshot-pre-boot.db
# after this change etcd manifest file's volume path to be this new path: /var/lib/etcd-from-backup
# end if nesesery delete etcd pod and recreated

#For restore from this snapshot:
service kube-apiserver stop

systemctl daemon-reload
service etcd restart
service kube-apiserver start


# to see How many clusters are defined in the kubeconfig
kubectl config view 
#or 
kubectl config get-clusters 

# switch to cluster 
kubectl config use-context cluster2

ps -ef | grep etcd # for see etcd process where see default data directory used the for ETCD datastore and other infos


#Check the members of the cluster:
 ETCDCTL_API=3 etcdctl \
 --endpoints=https://127.0.0.1:2379 \
 --cacert=/etc/etcd/pki/ca.pem \
 --cert=/etc/etcd/pki/etcd.pem \
 --key=/etc/etcd/pki/etcd-key.pem \
  member list



