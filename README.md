# OpenSearch and OpenSearch Dashboards Deployment on Minikube

This repository provides a Kubernetes setup to deploy OpenSearch and OpenSearch Dashboards on Minikube. The deployment includes a persistent volume for OpenSearch data and a ConfigMap with custom configurations for OpenSearch.

## Directory Structure

- **`manifests/`**: Kubernetes manifests for deploying OpenSearch and OpenSearch Dashboards.

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) installed and running.
- [Kubectl](https://kubernetes.io/docs/tasks/tools/) installed.

## Deployment Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/kaushal540/opensearch-minikube.git
   cd opensearch-minikube

2. **Start Minikube**:

    ```bash
    minikube start
    ```
   
3. **Setup certificates**:
   - There's a script (`generate_certs.sh`) provided to generate certificates. Execute it on console. It will create certificates under `certificates/` directory.
   - You need to replace those values from `certificate` folder to `manifests/secret.yaml` file.
   - Before copying values you need encode those values with base64. You can do by running command e.g. `base64 -i certificates/opensearch/opensearch.key -o opensearch.key.base64`

4. **Apply Kubernetes manifests**:
    
    ```bash
   kubctl apply -f manifests/namespace.yaml
   kubctl apply -f manifests/configmap.yaml
   kubctl apply -f manifests/opensearch-pv-pvc.yaml
   kubctl apply -f manifests/secret.yaml
   kubctl apply -f manifests/opensearch-deployment.yaml
   kubctl apply -f manifests/opensearch-dashboards.yaml
    ```
   
5. You need to launch security-admin job to initialize the security plugin. Before applying make sure your opensearch pod is up and running.
   
    ```bash
    kubctl apply -f manifests/opensearch-security-init.yaml
    ```

6. **Access OpenSearch and OpenSearch Dashboards**:


   - After applying all manifests, to access OpenSearch and OpenSearch Dashboards from your local machine is to use the `minikube service` command, which will open the service in your default web browser:
        ```bash
        minikube service opensearch-service -n opensearch
        minikube service opensearch-dashboards-service -n opensearch
        ```

   - Port Forwarding (Alternative Option)
   Alternatively, you can use kubectl port-forward to map local ports to the service ports in the cluster:
        ```bash
        kubectl port-forward service/opensearch-service 9200:9200 -n opensearch
        kubectl port-forward service/opensearch-dashboards-service 5601:5601 -n opensearch
        ```
   
   - Now, OpenSearch will be available.

## Customization
- **Persistent Volume**: Adjust storage size in opensearch-pv-pvc.yaml if more space is needed.
- **ConfigMap**: Update configuration in configmap.yaml as required.
- **Resources**: CPU and memory limits/requests can be modified in opensearch-deployment.yaml and opensearch-dashboards.yaml.


## Cleanup
To delete all resources created by this deployment:

```bash
kubectl delete -f manifests/
```
