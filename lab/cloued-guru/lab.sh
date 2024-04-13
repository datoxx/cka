kubectl top pod -n web --sort-by cpu --selector app=auth # see cpu used by pods,  with lable app=auth in web namespace

kubectl get pods -n web --as=system:serviceaccount:web:webautomation # check if servcie can get pods by with its role


4) lab 

- Back Up the etcd Data

From the exam server, log in to the etcd1 server and back up the etcd data to a file located at /home/cloud_user/etcd_backup.db.

Note: On the etcd1 server, you can find certificates which you can use to authenticate with etcd in /home/cloud_user/etcd-certs.

- Restore the etcd Data from the Backup

On the etcd1 server, restore your etcd data from the backup file at /home/cloud_user/etcd_backup.db.


solution:

ssh etcd1

. Back Up the etcd Data
ETCDCTL_API=3 etcdctl snapshot save /home/cloud_user/etcd_backup.db \
--endpoints=https://etcd1:2379 \
--cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
--cert=/home/cloud_user/etcd-certs/etcd-server.crt \
--key=/home/cloud_user/etcd-certs/etcd-server.key


. Restore the etcd Data from the Backup

Stop etcd:
sudo systemctl stop etcd

Delete the existing etcd data:
sudo rm -rf /var/lib/etcd

Restore etcd data from a backup:
sudo ETCDCTL_API=3 etcdctl snapshot restore /home/cloud_user/etcd_backup.db \
--initial-cluster etcd-restore=https://etcd1:2380 \
--initial-advertise-peer-urls https://etcd1:2380 \
--name etcd-restore \
--data-dir /var/lib/etcd

Set database ownership:
sudo chown -R etcd:etcd /var/lib/etcd

Start etcd:
sudo systemctl start etcd

Verify the system is working:
ETCDCTL_API=3 etcdctl get cluster.name \
--endpoints=https://etcd1:2379 \
--cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
--cert=/home/cloud_user/etcd-certs/etcd-server.crt \
--key=/home/cloud_user/etcd-certs/etcd-server.key



7) lab

#this lab about storage, used objects: sc, pv, pvc,  pod 

https://learn.acloud.guru/handson/3bc41f3f-8471-4b40-b6c4-49cbb1db6498/course/certified-kubernetes-administrator


