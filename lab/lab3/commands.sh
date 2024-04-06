9) We have created a new deployment called nginx-deploy. scale the deployment to 3 replicas. Has the replica's increased? Troubleshoot the issue and fix it.

solution:

Use the command kubectl scale to increase the replica count to 3.

kubectl scale deploy nginx-deploy --replicas=3

The controller-manager is responsible for scaling up pods of a replicaset. 

If you inspect the control plane components in the kube-system namespace, you will see that the controller-manager is not running.
kubectl get pods -n kube-system

The command running inside the controller-manager pod is incorrect.
After fix all the values in the file and wait for controller-manager pod to restart.

Alternatively, you can run sed command to change all values at once:
sed -i 's/kube-contro1ler-manager/kube-controller-manager/g' /etc/kubernetes/manifests/kube-controller-manager.yaml

This will fix the issues in controller-manager yaml file.
At last, inspect the deployment by using below command:

kubectl get deploy

