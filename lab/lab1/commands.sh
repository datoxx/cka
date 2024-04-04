10)
Expose the hr-web-app as service hr-web-app-service application on port 30082 on the nodes on the cluster.

The web application listens on port 8080.

solution:

Run the command:

kubectl expose deployment hr-web-app --type=NodePort --port=8080 --name=hr-web-app-service --dry-run=client -o yaml > hr-web-app-service.yaml 

to generate a service definition file.

Now, in generated service definition file add the nodePort field with the given port number under the ports section and create a service.