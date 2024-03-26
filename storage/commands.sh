docker run -v /data/mysql:/var/lib/mysql mysql #mount volume
docker run --mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql #mount volume
docke run -it --name mysql --volume-driver rexray/ebs --mount src=ebs-vol,target=/var/lib/mysql mysql # mount voluem from aws ebs


kubectl get persistentvolume # get list persistentvolumes
kubectl get persistentvolumeclaim # get list persistentvolumeclaim
kubectl delete persistentvolumeclaim <claim-name> # delete  persistentvolumeclaim



kubectl exec webapp -- cat /log/app.log  #view logs in pod


