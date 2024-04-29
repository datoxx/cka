4)
There is a script located at /root/pod-cka26-arch.sh on the student-node. 
Update this script to add a command to filter/display the label with value component of the pod called kube-apiserver-cluster1-controlplane (on cluster1) using jsonpath.


solution:

Update pod-cka26-arch.sh script:
student-node ~ ➜ vi pod-cka26-arch.sh


Add below command in it:
kubectl --context cluster1 get pod -n kube-system kube-apiserver-cluster1-controlplane  


#############################################################################################################################3333
6)

If there are no useful logs then look into the events:
kubectl get event --field-selector involvedObject.name=pod-name    # can filter by time by add this  --sort-by='.lastTimestamp'



10)
For this question, please set the context to cluster4 by running:
kubectl config use-context cluster4

cluster4-node01 node that belongs to cluster4 seems to be in the NotReady state. Fix the issue and make sure this node is in Ready state.
Note: You can ssh into the node using ssh cluster4-node01.

solution:

#see kubelet logs 
journalctl -u kubelet 




15)
We want to deploy a python based application on the cluster using a template located at /root/olive-app-cka10-str.yaml on student-node.
However, before you proceed we need to make some modifications to the YAML file as per details given below:


The YAML should also contain a persistent volume claim with name olive-pvc-cka10-str to claim a 100Mi of storage from olive-pv-cka10-str PV.


Update the deployment to add a sidecar container, which can use busybox image (you might need to add a sleep command for this container to keep it running.)

Share the python-data volume with this container and mount the same at path /usr/src. Make sure this container only has read permissions on this volume.


Finally, create a pod using this YAML and make sure the POD is in Running state.
Note: Additionally, you can expose a NodePort service for the application. The service should be named olive-svc-cka10-str and expose port 5000 with a nodePort value of 32006.
However, inclusion/exclusion of this service won't affect the validation for this task.




solution:
Update olive-app-cka10-str.yaml template so that it looks like as below:

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: olive-pvc-cka10-str
spec:
  accessModes:
  - ReadWriteMany
  storageClassName: olive-stc-cka10-str
  volumeName: olive-pv-cka10-str
  resources:
    requests:
      storage: 100Mi

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: olive-app-cka10-str
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: olive-app-cka10-str
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                  - cluster1-node01
      containers:
      - name: python
        image: poroko/flask-demo-app
        ports:
        - containerPort: 5000
        volumeMounts:
        - name: python-data
          mountPath: /usr/share/
      - name: busybox
        image: busybox
        command:
          - "bin/sh"
          - "-c"
          - "sleep 10000"
        volumeMounts:
          - name: python-data
            mountPath: "/usr/src"
            readOnly: true
      volumes:
      - name: python-data
        persistentVolumeClaim:
          claimName: olive-pvc-cka10-str
  selector:
    matchLabels:
      app: olive-app-cka10-str

---
apiVersion: v1
kind: Service
metadata:
  name: olive-svc-cka10-str
spec:
  type: NodePort
  ports:
    - port: 5000
      nodePort: 32006
  selector:
    app: olive-app-cka10-str






18)

Part I:
Create a ClusterIP service .i.e. service-3421-svcn in the spectra-1267 ns which should expose the pods namely pod-23 and pod-21 with port set to 8080 and targetport to 80.


Part II:

Store the pod names and their ip addresses from the spectra-1267 ns at /root/pod_ips_cka05_svcn where the output is sorted by their IP's.

Please ensure the format as shown below:

solution:
To store all the pod name along with their IP's , we could use imperative command as shown below:

kubectl get pods -n spectra-1267 -o=custom-columns='POD_NAME:metadata.name,IP_ADDR:status.podIP' --sort-by=.status.podIP



19)

Create a nginx pod called nginx-resolver-cka06-svcn using image nginx, expose it internally with a service called nginx-resolver-service-cka06-svcn.

Test that you are able to look up the service and pod names from within the cluster. 
Use the image: busybox:1.28 for dns lookup. Record results in /root/CKA/nginx.svc.cka06.svcn and /root/CKA/nginx.pod.cka06.svcn

solution:

To create a pod nginx-resolver-cka06-svcn and expose it internally:

student-node ~ ➜ kubectl run nginx-resolver-cka06-svcn --image=nginx 
student-node ~ ➜ kubectl expose pod/nginx-resolver-cka06-svcn --name=nginx-resolver-service-cka06-svcn --port=80 --target-port=80 --type=ClusterIP 

To create a pod test-nslookup. Test that you are able to look up the service and pod names from within the cluster:

student-node ~ ➜  kubectl run test-nslookup --image=busybox:1.28 --rm -it --restart=Never -- nslookup nginx-resolver-service-cka06-svcn
student-node ~ ➜  kubectl run test-nslookup --image=busybox:1.28 --rm -it --restart=Never -- nslookup nginx-resolver-service-cka06-svcn > /root/CKA/nginx.svc.cka06.svcn

Get the IP of the nginx-resolver-cka06-svcn pod and replace the dots(.) with hyphon(-) which will be used below.

student-node ~ ➜  kubectl get pod nginx-resolver-cka06-svcn -o wide
student-node ~ ➜  IP=`kubectl get pod nginx-resolver-cka06-svcn -o wide --no-headers | awk '{print $6}' | tr '.' '-'`
student-node ~ ➜  kubectl run test-nslookup --image=busybox:1.28 --rm -it --restart=Never -- nslookup $IP.default.pod > /root/CKA/nginx.pod.cka06.svcn


20)


Create a pod with name tester-cka02-svcn in dev-cka02-svcn namespace with image registry.k8s.io/e2e-test-images/jessie-dnsutils:1.3. 
Make sure to use command sleep 3600 with restart policy set to Always .


Once the tester-cka02-svcn pod is running, store the output of the command nslookup kubernetes.default from tester pod into the file /root/dns_output on student-node.

solution:


Since the "dev-cka02-svcn" namespace doesn't exist, let's create it first:

kubectl create ns dev-cka02-svcn


Create the pod as per the requirements:


kubectl apply -f - << EOF
apiVersion: v1
kind: Pod
metadata:
  name: tester-cka02-svcn
  namespace: dev-cka02-svcn
spec:
  containers:
  - name: tester-cka02-svcn
    image: registry.k8s.io/e2e-test-images/jessie-dnsutils:1.3
    command:
      - sleep
      - "3600"
  restartPolicy: Always
EOF

Now let's test if the nslookup command is working :

student-node ~ ➜  kubectl exec -n dev-cka02-svcn -i -t tester-cka02-svcn -- nslookup kubernetes.default
;; connection timed out; no servers could be reached



Looks like something is broken at the moment, if we observe the kube-system namespace, 
we will see no coredns pods are not running which is creating the problem, let's scale them for the nslookup command to work:

kubectl scale deployment -n kube-system coredns --replicas=2



Now let store the correct output into the /root/dns_output on student-node :

kubectl exec -n dev-cka02-svcn -i -t tester-cka02-svcn -- nslookup kubernetes.default >> /root/dns_output



We should have something similar to below output:

student-node ~ ➜  cat /root/dns_output

Server:         10.96.0.10
Address:        10.96.0.10#53

Name:   kubernetes.default.svc.cluster.local
Address: 10.96.0.1

##################################################################################33


lab5)

1)

There is a script located at /root/pod-cka26-arch.sh on the student-node.
 Update this script to add a command to filter/display the label with value component of the pod called kube-apiserver-cluster1-controlplane (on cluster1) using jsonpath.

solution:

kubectl --context cluster1 get pod -n kube-system kube-apiserver-cluster1-controlplane  -o jsonpath='{.metadata.labels.component}'


4)
There is a sample script located at /root/service-cka25-arch.sh on the student-node.
Update this script to add a command to filter/display the targetPort only for service service-cka25-arch using jsonpath. The service has been created under the default namespace on cluster1.

solution:
ubectl --context cluster1 get service service-cka25-arch -o jsonpath='{.spec.ports[0].targetPort}'



9)


The db-deployment-cka05-trb deployment is having 0 out of 1 PODs ready.
Figure out the issues and fix the same but make sure that you do not remove any DB related environment variables from the deployment/pod.


solution:

Find out the name of the DB POD:
kubectl get pod
Check the DB POD logs:
kubectl logs <pod-name>
You might see something like as below which is not that helpful:

Error from server (BadRequest): container "db" in pod "db-deployment-cka05-trb-7457c469b7-zbvx6" is waiting to start: CreateContainerConfigError
So let's look into the kubernetes events for this pod:

kubectl get event --field-selector involvedObject.name=<pod-name>
You will see some errors as below:

Error: couldn't find key db in Secret default/db-cka05-trb
Now let's look into all secrets:

kubectl get secrets db-root-pass-cka05-trb -o yaml
kubectl get secrets db-user-pass-cka05-trb -o yaml
kubectl get secrets db-cka05-trb -o yaml
Now let's look into the deployment.

Edit the deployment
kubectl edit deployment db-deployment-cka05-trb -o yaml
You will notice that some of the keys are different what are reffered in the deployment.

Change some env keys: db to database , db-user to username and db-password to password
Change a secret reference: db-user-cka05-trb to db-user-pass-cka05-trb
Finally save the changes.





18)

Create a ClusterIP service .i.e. service-3421-svcn in the spectra-1267 ns which should expose the pods namely pod-23 and pod-21 with port set to 8080 and targetport to 80.



Part II:



Store the pod names and their ip addresses from the spectra-1267 ns at /root/pod_ips_cka05_svcn where the output is sorted by their IP's.

Please ensure the format as shown below:



POD_NAME        IP_ADDR
pod-1           ip-1
pod-3           ip-2
pod-2           ip-3
...

solution:
The easiest way to route traffic to a specific pod is by the use of labels and selectors . List the pods along with their labels:

Looks like there are a lot of pods created to confuse us. But we are only concerned with the labels of pod-23 and pod-21.



As we can see both the required pods have labels mode=exam,type=external in common. Let's confirm that using kubectl too:



student-node ~ ➜  kubectl get pod -l mode=exam,type=external -n spectra-1267                                    
NAME     READY   STATUS    RESTARTS   AGE
pod-23   1/1     Running   0          9m18s
pod-21   1/1     Running   0          9m17s


Nice!! Now as we have figured out the labels, we can proceed further with the creation of the service:
student-node ~ ➜  kubectl create service clusterip service-3421-svcn -n spectra-1267 --tcp=8080:80 --dry-run=client -o yaml > service-3421-svcn.yaml

Now modify the service definition with selectors as required before applying to k8s cluster:

student-node ~ ➜  cat service-3421-svcn.yaml 
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: service-3421-svcn
  name: service-3421-svcn
  namespace: spectra-1267
spec:
  ports:
  - name: 8080-80
    port: 8080
    protocol: TCP
    targetPort: 80
  selector:
    app: service-3421-svcn  # delete 
    mode: exam    # add
    type: external  # add
  type: ClusterIP
status:
  loadBalancer: {}


To store all the pod name along with their IP's , we could use imperative command as shown below:

 kubectl get pods -n spectra-1267 -o=custom-columns='POD_NAME:metadata.name,IP_ADDR:status.podIP' --sort-by=.status.podIP



###################################################################3


5) 

Install etcd utility on cluster2-controlplane node so that we can take/restore etcd backups.
You can ssh to the controlplane node by running ssh root@cluster2-controlplane from the student-node.


solution:

SSH into cluster2-controlplane node:
student-node ~ ➜ ssh root@cluster2-controlplane

Install etcd utility:

cluster2-controlplane ~ ➜ cd /tmp
cluster2-controlplane ~ ➜ export RELEASE=$(curl -s https://api.github.com/repos/etcd-io/etcd/releases/latest | grep tag_name | cut -d '"' -f 4)
cluster2-controlplane ~ ➜ wget https://github.com/etcd-io/etcd/releases/download/${RELEASE}/etcd-${RELEASE}-linux-amd64.tar.gz
cluster2-controlplane ~ ➜ tar xvf etcd-${RELEASE}-linux-amd64.tar.gz ; cd etcd-${RELEASE}-linux-amd64
cluster2-controlplane ~ ➜ mv etcd etcdctl  /usr/local/bin/

