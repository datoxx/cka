1)

Upgrade the current version of kubernetes from 1.28.0 to 1.29.0 exactly using the kubeadm utility.
Make sure that the upgrade is carried out one node at a time starting with the controlplane node. 
To minimize downtime, the deployment gold-nginx should be rescheduled on an alternate node before upgrading each node.
Upgrade controlplane node first and drain node node01 before upgrading it. Pods for gold-nginx should run on the controlplane node subsequently.


solution:

Here is the solution for this task. Please note that the output of these commands have not been added here.

To seamlessly transition from Kubernetes v1.28 to v1.29 and gain access to the packages specific to the desired Kubernetes minor version, 
follow these essential steps during the upgrade process. This ensures that your environment is appropriately configured and aligned with the features and improvements introduced in Kubernetes v1.29.

On the controlplane node:

Use any text editor you prefer to open the file that defines the Kubernetes apt repository.

vim /etc/apt/sources.list.d/kubernetes.list
Update the version in the URL to the next available minor release, i.e v1.29.

deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /
After making changes, save the file and exit from your text editor. Proceed with the next instruction.

root@controlplane:~# kubectl drain controlplane --ignore-daemonsets
root@controlplane:~# apt update
root@controlplane:~# apt-cache madison kubeadm

Based on the version information displayed by apt-cache madison, it indicates that for Kubernetes version 1.29.0, the available package version is 1.29.0-1.1. Therefore, to install kubeadm for Kubernetes v1.29.0, use the following command:

root@controlplane:~# apt-get install kubeadm=1.29.0-1.1

Run the following command to upgrade the Kubernetes cluster.

root@controlplane:~# kubeadm upgrade plan v1.29.0
root@controlplane:~# kubeadm upgrade apply v1.29.0

Now, upgrade the version and restart Kubelet. Also, mark the node (in this case, the "controlplane" node) as schedulable.

root@controlplane:~# apt-get install kubelet=1.29.0-1.1
root@controlplane:~# systemctl daemon-reload
root@controlplane:~# systemctl restart kubelet
root@controlplane:~# kubectl uncordon controlplane
Before draining node01, if the controlplane gets taint during an upgrade, we have to remove it.

# Identify the taint first. 
root@controlplane:~# kubectl describe node controlplane | grep -i taint

# Remove the taint with help of "kubectl taint" command.
root@controlplane:~# kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-

# Verify it, the taint has been removed successfully.  
root@controlplane:~# kubectl describe node controlplane | grep -i taint
Now, drain the node01 as follows: -


#node01 Upgrade
root@controlplane:~# kubectl drain node01 --ignore-daemonsets
SSH to the node01 and perform the below steps as follows: -

Use any text editor you prefer to open the file that defines the Kubernetes apt repository.

vim /etc/apt/sources.list.d/kubernetes.list
Update the version in the URL to the next available minor release, i.e v1.29.

deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /
After making changes, save the file and exit from your text editor. Proceed with the next instruction.

root@node01:~# apt update
root@node01:~# apt-cache madison kubeadm
Based on the version information displayed by apt-cache madison, it indicates that for Kubernetes version 1.29.0, the available package version is 1.29.0-1.1. Therefore, to install kubeadm for Kubernetes v1.29.0, use the following command:

root@node01:~# apt-get install kubeadm=1.29.0-1.1
# Upgrade the node 
root@node01:~# kubeadm upgrade node
Now, upgrade the version and restart Kubelet.

root@node01:~# apt-get install kubelet=1.29.0-1.1
root@node01:~# systemctl daemon-reload
root@node01:~# systemctl restart kubelet
To exit from the specific node, type exit or logout on the terminal.

Back on the controlplane node: -

root@controlplane:~# kubectl uncordon node01
root@controlplane:~# kubectl get pods -o wide | grep gold # make sure this is 



3##################################################################################################################################################################33

2)
Print the names of all deployments in the admin2406 namespace in the following format:

DEPLOYMENT             CONTAINER_IMAGE          READY_REPLICAS         NAMESPACE

<deployment name>   <container image used>   <ready replica count>   <Namespace>
. The data should be sorted by the increasing order of the deployment name.
Example:

DEPLOYMENT   CONTAINER_IMAGE   READY_REPLICAS   NAMESPACE
deploy0       nginx:alpine          1            admin2406

Write the result to the file /opt/admin2406_data.

solution:
Run the below command to get the correct output:

kubectl -n admin2406 get deployment -o custom-columns=DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[].image,READY_REPLICAS:.status.readyReplicas,NAMESPACE:.metadata.namespace --sort-by=.metadata.name > /opt/admin2406_data


#######################################################################################################################################################################################33

3) A kubeconfig file called admin.kubeconfig has been created in /root/CKA. There is something wrong with the configuration. Troubleshoot and fix it.

solution:

Make sure the port for the kube-apiserver is correct. So for this change port from 4380 to 6443.

Run the below command to know the cluster information:

kubectl cluster-info --kubeconfig /root/CKA/admin.kubeconfig


##########################################################################################################333335555555%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


4)

Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Next upgrade the deployment to version 1.17 using rolling update.


solution:


Make use of the kubectl create command to create the deployment and explore the --record option while upgrading the deployment image.

Run the below command to create a deployment nginx-deploy:

kubectl create deployment  nginx-deploy --image=nginx:1.16

Run the below command to update the new image for nginx-deploy deployment and to record the version:

kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record


#######################################################################################################################################33

5)

A new deployment called alpha-mysql has been deployed in the alpha namespace. 
However, the pods are not running. Troubleshoot and fix the issue. 
The deployment should make use of the persistent volume alpha-pv to be mounted at /var/lib/mysql and should use the environment variable MYSQL_ALLOW_EMPTY_PASSWORD=1 to make use of an empty root password.

Important: Do not alter the persistent volume.

solution:

Use the command kubectl describe and try to fix the issue.

Solution manifest file to create a pvc called mysql-alpha-pvc as follows:

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-alpha-pvc
  namespace: alpha
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: slow



############################################################################################################################################################3



6)
  Take the backup of ETCD at the location /opt/etcd-backup.db on the controlplane node.

solution:

Take a help of command etcdctl snapshot save --help options.

export ETCDCTL_API=3
etcdctl snapshot save --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --endpoints=127.0.0.1:2379 /opt/etcd-backup.db


#############################################################################################################################################################################################3

7)

Create a pod called secret-1401 in the admin1401 namespace using the busybox image. The container within the pod should be called secret-admin and should sleep for 4800 seconds.

The container should mount a read-only secret volume called secret-volume at the path /etc/secret-volume. The secret being mounted has already been created for you and is called dotfile-secret.

solution:

Use the command kubectl run to create a pod definition file. Add secret volume and update container name in it.

Alternatively, run the following command:

kubectl run secret-1401 -n admin1401 --image=busybox --dry-run=client -oyaml --command -- sleep 4800 > admin.yaml

Add the secret volume and mount path to create a pod called secret-1401 in the admin1401 namespace as follows:

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: secret-1401
  name: secret-1401
  namespace: admin1401
spec:
  volumes:
  - name: secret-volume
    # secret volume
    secret:
      secretName: dotfile-secret
  containers:
  - command:
    - sleep
    - "4800"
    image: busybox
    name: secret-admin
    # volumes' mount path
    volumeMounts:
    - name: secret-volume
      readOnly: true
      mountPath: "/etc/secret-volume"


















