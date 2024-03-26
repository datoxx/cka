openssl genrsa -out my-server.key 2048  # creates private my-server.key
openssl rsa -in my-server.key -pubout >  my-server.pem # creats pablic my-server.pem

# create certificat authority (CA)
openssl genrsa -out ca.key 2048  # creates private ca.key
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr #openssl request command, for create certificate singing request
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt  # sign certificates


# create client certificat
openssl genrsa -out admin.key 2048  # creates private admin.key
openssl req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr #openssl request command, for create certificate singing request for admin
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -out admin.crt  # sign certificates for admin 

#view certificate details
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout #see certificate details


#see logs
journalctl -u etcd.service -l # see loogs if you create cluster by scrath

kubectl logs etcd-master # see logs you create claster by kubeadm

docker logs container_id # see logs if pods down and see docker logs

# CertificateSigningRequest
kubectl get csr  # get CertificateSigningRequest objects
kubectl certificate approve <csr_name> # approve sign request
kubectl get csr <csr_name> -o yaml # view the certificate by viewing at in a yaml format in status section
echo "sertificate code in base64" | base64 --decode # decode sertificate  


#kubeconfig
kubectl config view  #view current kubeconfig file  in default filder (users home directory in .kube folder)
kubectl config view --kubeconfig=my-custom-config  #view  kubeconfig file  whihc is not in .kube folder
kubectl config use-context prod-user@production #change current context, and this make changes in config file


#role base access control RBAC  
kubectl create role developer --namespace=default --verb=list,create,delete --resource=pods # create role
kubectl create rolebinding dev-user-binding --namespace=default --role=developer --user=dev-user # create rolebinding 

kubectl get roles # list roles
kubectl get rolebindings # list rolebindings

kubectl describe rolebindings <rolebinding_name> # see more detail info about rolebindings
kubectl describe role <role_name> # see more detail info about role

kubectl auth can-i create deploument  # check if as a user can do some things
kubectl auth can-i delete nodes # check if as a user can do some things

kubectl auth can-i delete nodes --as dev-user # check admin if as a user can do some things
kubectl auth can-i delete nodes --as dev-user --namespace dev # check admin if as a user can do some things in dev namespace


# list resurces by api groups
kubectl api-resources --namespaced=true # see name space scope resurces
kubectl api-resources --namespaced=false # see cluster scope resurces

#service account
kubectl create serviceaccount <name> # create serviceaccount
kubectl create token <name_serviceaccount> # create token for serviceaccount
kubectl get serviceaccount  # get serviceaccountes
kubectl describe serviceaccount <name> # get more details serviceaccountes

kubectl set serviceaccount deploy/web-dashboard <serviceaccount_name> # set custom service account to deploy's pod 

# create secret for pull privte image form dokerhub
kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>

#network policy