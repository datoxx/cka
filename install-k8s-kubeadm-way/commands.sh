#creat 3 vm 1 masert and 2 worker
vagrant status # go in to virtualBox-vagrant folder and run commans there, to see status, up, ssh or destroy vm
vagrant up # setup 3 vm in virtualbox in  virtualBox-vagrant folder
vagrant ssh <vm_name> # ssh to vm by name, "logout" to out from node/vm
vagrant destroy -f  # delete all vm

#setup cluseter by kubeadm on this created  3 node/vm: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#first install runtime all nodes, https://kubernetes.io/docs/setup/production-environment/container-runtimes/

before install runtime run "Install and configure prerequisites" from above link

install containerd form this link: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

configure cgroups for contianerd: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd

#now instal kubeadm, kublete and kubectl: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl

#mow creating/configure cluster with kubeadm: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

#in muster node run:
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=172.24.25.24

#create .kube folder and move config file, which is created by kubeadm init command,  and than we can enter cluter and run kubectl commands
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#next configure pod network, by Weave Net
#this commands may help if api-server connectio nis refuse
# sudo -i
# swapoff -a
# exit
# strace -eopenat kubectl version

kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.28/net.yaml # or weave-daemonset-k8s-1.11.yaml
or 
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#after that we can go our worker ndoes aand run this command in worker nodes for join worker nodes to cluster
kubeadm join 172.24.25.24:6443 --token d9djai.mc2qc5tqhv828i02 \
        --discovery-token-ca-cert-hash sha256:9dd9a50a5e8969731ce4ab952aeced8313899dc202835f58bc9c7d4498dfa09f 