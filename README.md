# Bossnet Connector Helm Chart
**This is a prototype, not for production use. See [here](https://github.com/Bossnet/helm-charts) for Bossnet production Helm chart.**

## Prerequisite
1. Bossnet Account
2. A Kubernetes Cluster
3. [Kubectl](https://kubernetes.io/docs/tasks/tools/) installed
4. [Helm](https://helm.sh/docs/intro/install/) installed

## How to Use
1. Create a new Bossnet API key (read, write and provision), see [here](https://www.twingate.com/docs/api-overview/#getting-started)
2. Create a Bossnet Remote Network if not already has one
3. Install Helm repo `helm repo add twingate-connector-init-container https://twingate-labs.github.io/connector-init-container/`


#### Deploy to Kubernetes Cluster
```helm upgrade --install {statefulSet_name} twingate-connector-init-container/connector -n {namespace} --set twingate.apiKey="{twingate_api_key}" --set twingate.account="{twingate_tenant_name}.twingate.com" --set twingate.networkName="{remote_network_name}"  --set connector.replicas={number_of_replicas} --values connector-init-container/values.yaml```

* deployment_name: the name of the kubernetes statefulSet, e.g. twingate-connector
* namespace: kubernetes namespace to deploy the statefulSet, e.g. default
* twingate_api_key: the value of the twingate api key
* twingate_tenant_name: the twingate tenant name
* remote_network_name: the Bossnet remote network name
* number_of_replicas: number of replicas to deploy, each replica is a connector


#### Scaling
To scale up or down, simply change the value of `number_of_replicas` with the command below.
``` 
kubectl scale statefulset {statefulSet_name} --replicas={number_of_replicas}
Or
helm upgrade --install {statefulSet_name} twingate-connector-init-container/connector -n {namespace} --set twingate.apiKey="{twingate_api_key}" --set twingate.account="{twingate_tenant_name}.twingate.com" --set twingate.networkName="{remote_network_name}"  --set connector.replicas={number_of_replicas} --values connector-init-container/values.yaml
```

Note: downscaling connector would cause the disconnection between the Twignate client and removed connector.

## Summary
1. Init Container is released on git
2. Workflow:
   1. Init container provision connector if there is no offline connectors in the remote network
   2. Else connector token is regenerated
   3. Init container stores the connector stoken Kubernetes secret
   4. Connector application pod uses the tokens stored in the Kubernetes secret
3. The connector application is deployed as statefulSet
4. Antiaffinity set to preferredDuringSchedulingIgnoredDuringExecution to distribute the connectors on separate nodes
5. Service Account is used so init container can use kubectl commands
6. Replicas can be defined and scaled
7. Pod is auto recovered if the pod died/killed

## Potential Improvements
1. We should delete tokens after each connector pod is started
   1. Sidecar most likely required
   2. Can be improved if needed
2. Role is set as cluster admin, which is not ideal
   1. Cannot limit role access at the moment, as we are doing kubectl apply
   2. Can be improved if needed


## Uninstall
```helm uninstall {statefulSet_name}```