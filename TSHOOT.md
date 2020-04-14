# Some useful commands for the control plane and work load clusters

```bash
source <(kubectl completion zsh)

kind get clusters
test

kind get nodes --name=test
test-control-plane

kubectl config get-contexts
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
*         kind-test   kind-test   kind-test

kubectl get nodes
NAME                 STATUS   ROLES    AGE     VERSION
test-control-plane   Ready    master   7h41m   v1.17.0

kubectl get pods -A
NAMESPACE                           NAME                                                             READY   STATUS    RESTARTS   AGE
capa-system                         capa-controller-manager-599ccd4476-xd5hb                         2/2     Running   0          4m36s
capi-kubeadm-bootstrap-system       capi-kubeadm-bootstrap-controller-manager-5bb9bfdc46-ssxvd       2/2     Running   0          4m40s
capi-kubeadm-control-plane-system   capi-kubeadm-control-plane-controller-manager-77466c7666-xzhhn   2/2     Running   0          4m38s
capi-system                         capi-controller-manager-5798474d9f-4zkh4                         2/2     Running   0          4m41s
capi-webhook-system                 capa-controller-manager-6584765496-9zpps                         2/2     Running   0          4m38s
capi-webhook-system                 capi-controller-manager-5d64dd9dfb-dq5rx                         2/2     Running   0          4m42s
capi-webhook-system                 capi-kubeadm-bootstrap-controller-manager-7c78fff45-msj8n        2/2     Running   0          4m40s
capi-webhook-system                 capi-kubeadm-control-plane-controller-manager-58465bb88f-prswh   2/2     Running   0          4m39s
cert-manager                        cert-manager-69b4f77ffc-86stx                                    1/1     Running   0          5m5s
cert-manager                        cert-manager-cainjector-576978ffc8-nxdnv                         1/1     Running   0          5m5s
cert-manager                        cert-manager-webhook-c67fbc858-4pzp8                             1/1     Running   0          5m5s
kube-system                         coredns-6955765f44-8kw85                                         1/1     Running   0          5m52s
kube-system                         coredns-6955765f44-s22v9                                         1/1     Running   0          5m52s
kube-system                         etcd-test-control-plane                                          1/1     Running   0          6m7s
kube-system                         kindnet-s72dv                                                    1/1     Running   0          5m52s
kube-system                         kube-apiserver-test-control-plane                                1/1     Running   0          6m7s
kube-system                         kube-controller-manager-test-control-plane                       1/1     Running   0          6m7s
kube-system                         kube-proxy-5j77n                                                 1/1     Running   0          5m52s
kube-system                         kube-scheduler-test-control-plane                                1/1     Running   0          6m7s
local-path-storage                  local-path-provisioner-7745554f7f-bwt24                          1/1     Running   0          5m52s

kubectl get services -A
NAMESPACE                           NAME                                                            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
capa-system                         capa-controller-manager-metrics-service                         ClusterIP   10.96.205.2     <none>        8443/TCP                 13m
capi-kubeadm-bootstrap-system       capi-kubeadm-bootstrap-controller-manager-metrics-service       ClusterIP   10.96.132.224   <none>        8443/TCP                 13m
capi-kubeadm-control-plane-system   capi-kubeadm-control-plane-controller-manager-metrics-service   ClusterIP   10.96.212.190   <none>        8443/TCP                 13m
capi-system                         capi-controller-manager-metrics-service                         ClusterIP   10.96.11.0      <none>        8443/TCP                 13m
capi-webhook-system                 capa-webhook-service                                            ClusterIP   10.96.121.184   <none>        443/TCP                  13m
capi-webhook-system                 capi-kubeadm-bootstrap-webhook-service                          ClusterIP   10.96.32.150    <none>        443/TCP                  13m
capi-webhook-system                 capi-kubeadm-control-plane-webhook-service                      ClusterIP   10.96.213.31    <none>        443/TCP                  13m
capi-webhook-system                 capi-webhook-service                                            ClusterIP   10.96.99.131    <none>        443/TCP                  13m
cert-manager                        cert-manager                                                    ClusterIP   10.96.203.115   <none>        9402/TCP                 13m
cert-manager                        cert-manager-webhook                                            ClusterIP   10.96.135.140   <none>        443/TCP                  13m
default                             kubernetes                                                      ClusterIP   10.96.0.1       <none>        443/TCP                  14m
kube-system                         kube-dns                                                        ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   14m
```

```bash
kubectl get awsclusters.infrastructure.cluster.x-k8s.io -A
NAMESPACE   NAME        CLUSTER     READY   VPC                     BASTION IP
mycluster   mycluster   mycluster   true    vpc-0d32ab222fed66162   [AWS Public IPv4]

kubectl get AWSMachineTemplate -A
NAMESPACE   NAME                      AGE
mycluster   mycluster-control-plane   22m
mycluster   mycluster-md-0            22m

kubectl get KubeadmControlPlane -A
NAMESPACE   NAME                      READY   INITIALIZED   REPLICAS   READY REPLICAS   UPDATED REPLICAS   UNAVAILABLE REPLICAS
mycluster   mycluster-control-plane           true          1                           1                  1

kubectl get machines.cluster.x-k8s.io -A
NAMESPACE   NAME                             PROVIDERID                    PHASE
mycluster   mycluster-control-plane-prfvv    aws:////i-0f5fe1ad5049ef57e   Running
mycluster   mycluster-md-0-b49f58fb5-znllm   aws:////i-07d19531b0c02d946   Running
```

```bash
kubectl scale KubeadmControlPlane mycluster-control-plane --replicas=3 -n mycluster
kubeadmcontrolplane.controlplane.cluster.x-k8s.io/mycluster-control-plane scaled

kubectl get KubeadmControlPlane -A
NAMESPACE   NAME                      READY   INITIALIZED   REPLICAS   READY REPLICAS   UPDATED REPLICAS   UNAVAILABLE REPLICAS
mycluster   mycluster-control-plane           true          3                           3                  3

kubectl get machines.cluster.x-k8s.io -A
NAMESPACE   NAME                             PROVIDERID                    PHASE
mycluster   mycluster-control-plane-prfvv    aws:////i-0f5fe1ad5049ef57e   Running
mycluster   mycluster-control-plane-qvf6m    aws:////i-0427b50ad34c69ecb   Running
mycluster   mycluster-control-plane-w48xm    aws:////i-0d45e5e36e354f3c0   Running
mycluster   mycluster-md-0-b49f58fb5-znllm   aws:////i-07d19531b0c02d946   Running
```

```bash
kubectl scale machinedeployments.cluster.x-k8s.io mycluster-md-0 --replicas=2 -n mycluster
machinedeployment.cluster.x-k8s.io/mycluster-md-0 scaled

kubectl get machines.cluster.x-k8s.io -A
NAMESPACE   NAME                             PROVIDERID                    PHASE
mycluster   mycluster-control-plane-prfvv    aws:////i-0f5fe1ad5049ef57e   Running
mycluster   mycluster-control-plane-qvf6m    aws:////i-0427b50ad34c69ecb   Running
mycluster   mycluster-control-plane-w48xm    aws:////i-0d45e5e36e354f3c0   Running
mycluster   mycluster-md-0-b49f58fb5-92qs5   aws:////i-04c89d8baf8bba443   Provisioning
mycluster   mycluster-md-0-b49f58fb5-znllm   aws:////i-07d19531b0c02d946   Running
```

```bash
kubectl --namespace=mycluster get secret
NAME                            TYPE                                  DATA   AGE
default-token-47hwt             kubernetes.io/service-account-token   3      40m
mycluster-ca                    Opaque                                2      35m
mycluster-control-plane-4kq7b   cluster.x-k8s.io/secret               1      9m58s
mycluster-control-plane-d4kkz   cluster.x-k8s.io/secret               1      35m
mycluster-control-plane-jfdl7   cluster.x-k8s.io/secret               1      14m
mycluster-etcd                  Opaque                                2      35m
mycluster-kubeconfig            Opaque                                1      35m
mycluster-md-0-r5wl5            cluster.x-k8s.io/secret               1      32m
mycluster-md-0-v4d28            cluster.x-k8s.io/secret               1      2m1s
mycluster-proxy                 Opaque                                2      35m
mycluster-sa                    Opaque                                2      35m

kubectl --namespace=mycluster get secret mycluster-md-0-v4d28 -o jsonpath='{.data.value}' | base64 -d
## template: jinja
#cloud-config

write_files:
-   path: /tmp/kubeadm-join-config.yaml
    owner: root:root
    permissions: '0640'
    content: |
      ---
      apiVersion: kubeadm.k8s.io/v1beta1
      discovery:
        bootstrapToken:
          apiServerEndpoint: mycluster-apiserver-663170527.eu-west-2.elb.amazonaws.com:6443
          caCertHashes:
          - sha256:28b1a50ad4d74e0a001768c9c05ecf728b8232a345135a6f216a9d2832b54e38
          token: f2pyii.qsm89i86cz5vr1zx
          unsafeSkipCAVerification: false
      kind: JoinConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          cloud-provider: aws
        name: '{{ ds.meta_data.local_hostname }}'

runcmd:
  - kubeadm join --config /tmp/kubeadm-join-config.yaml
```

```bash
kubectl --namespace=mycluster get secret mycluster-kubeconfig -o json | jq -r .data.value | base64 --decode > ${PWD}/kubeconfig/mycluster-kubeconfig

kubectl config get-contexts
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
*         kind-test   kind-test   kind-test

unset KUBECONFIG && for i in $(ls kubeconfig); do KUBECONFIG+=${PWD}/kubeconfig/$i:; done && export KUBECONFIG

kubectl config get-contexts
CURRENT   NAME                        CLUSTER     AUTHINFO          NAMESPACE
          kind-test                   kind-test   kind-test
*         mycluster-admin@mycluster   mycluster   mycluster-admin
```

```bash
kubectl --context=mycluster-admin@mycluster get nodes
NAME                                       STATUS     ROLES    AGE     VERSION
ip-10-0-0-193.eu-west-2.compute.internal   NotReady   <none>   33m     v1.18.0
ip-10-0-0-204.eu-west-2.compute.internal   NotReady   master   11m     v1.18.0
ip-10-0-0-35.eu-west-2.compute.internal    NotReady   <none>   3m53s   v1.18.0
ip-10-0-0-54.eu-west-2.compute.internal    NotReady   master   36m     v1.18.0
ip-10-0-0-74.eu-west-2.compute.internal    NotReady   master   15m     v1.18.0

# Nodes are NotReady as a CNI has not been installed
# Let us install the latest to date Antrea CNI

kubectl --context=mycluster-admin@mycluster apply -f https://github.com/vmware-tanzu/antrea/releases/download/v0.5.1/antrea.yml
customresourcedefinition.apiextensions.k8s.io/antreaagentinfos.clusterinformation.antrea.tanzu.vmware.com created
customresourcedefinition.apiextensions.k8s.io/antreacontrollerinfos.clusterinformation.antrea.tanzu.vmware.com created
serviceaccount/antctl created
serviceaccount/antrea-agent created
serviceaccount/antrea-controller created
clusterrole.rbac.authorization.k8s.io/antctl created
clusterrole.rbac.authorization.k8s.io/antrea-agent created
clusterrole.rbac.authorization.k8s.io/antrea-controller created
rolebinding.rbac.authorization.k8s.io/antrea-controller-authentication-reader created
clusterrolebinding.rbac.authorization.k8s.io/antctl created
clusterrolebinding.rbac.authorization.k8s.io/antrea-agent created
clusterrolebinding.rbac.authorization.k8s.io/antrea-controller created
configmap/antrea-config-b2b5bdkh8t created
service/antrea created
deployment.apps/antrea-controller created
apiservice.apiregistration.k8s.io/v1beta1.networking.antrea.tanzu.vmware.com created
apiservice.apiregistration.k8s.io/v1beta1.system.antrea.tanzu.vmware.com created
daemonset.apps/antrea-agent created

kubectl --context=mycluster-admin@mycluster get nodes
NAME                                       STATUS   ROLES    AGE    VERSION
ip-10-0-0-193.eu-west-2.compute.internal   Ready    <none>   36m    v1.18.0
ip-10-0-0-204.eu-west-2.compute.internal   Ready    master   13m    v1.18.0
ip-10-0-0-35.eu-west-2.compute.internal    Ready    <none>   6m9s   v1.18.0
ip-10-0-0-54.eu-west-2.compute.internal    Ready    master   38m    v1.18.0
ip-10-0-0-74.eu-west-2.compute.internal    Ready    master   18m    v1.18.0

kubectl --context=mycluster-admin@mycluster get pods -n kube-system
NAMESPACE     NAME                                                               READY   STATUS    RESTARTS   AGE
kube-system   antrea-agent-7rnk4                                                 2/2     Running   0          29s
kube-system   antrea-agent-j9ntb                                                 2/2     Running   0          29s
kube-system   antrea-agent-kml54                                                 2/2     Running   0          29s
kube-system   antrea-agent-m2dwq                                                 2/2     Running   0          29s
kube-system   antrea-agent-tkspl                                                 2/2     Running   0          29s
kube-system   antrea-controller-5659f95774-nlbxw                                 1/1     Running   0          29s
kube-system   coredns-66bff467f8-d482m                                           0/1     Running   0          38m
kube-system   coredns-66bff467f8-mfvxc                                           1/1     Running   0          38m
kube-system   etcd-ip-10-0-0-204.eu-west-2.compute.internal                      1/1     Running   0          13m
kube-system   etcd-ip-10-0-0-54.eu-west-2.compute.internal                       1/1     Running   0          38m
kube-system   etcd-ip-10-0-0-74.eu-west-2.compute.internal                       1/1     Running   0          16m
kube-system   kube-apiserver-ip-10-0-0-204.eu-west-2.compute.internal            1/1     Running   0          12m
kube-system   kube-apiserver-ip-10-0-0-54.eu-west-2.compute.internal             1/1     Running   0          38m
kube-system   kube-apiserver-ip-10-0-0-74.eu-west-2.compute.internal             1/1     Running   0          17m
kube-system   kube-controller-manager-ip-10-0-0-204.eu-west-2.compute.internal   1/1     Running   0          12m
kube-system   kube-controller-manager-ip-10-0-0-54.eu-west-2.compute.internal    1/1     Running   1          38m
kube-system   kube-controller-manager-ip-10-0-0-74.eu-west-2.compute.internal    1/1     Running   0          16m
kube-system   kube-proxy-6sxx6                                                   1/1     Running   0          13m
kube-system   kube-proxy-mnssp                                                   1/1     Running   0          38m
kube-system   kube-proxy-nf56k                                                   1/1     Running   0          36m
kube-system   kube-proxy-pqckz                                                   1/1     Running   0          6m11s
kube-system   kube-proxy-qc4sc                                                   1/1     Running   0          18m
kube-system   kube-scheduler-ip-10-0-0-204.eu-west-2.compute.internal            1/1     Running   0          12m
kube-system   kube-scheduler-ip-10-0-0-54.eu-west-2.compute.internal             1/1     Running   1          38m
kube-system   kube-scheduler-ip-10-0-0-74.eu-west-2.compute.internal             1/1     Running   0          16m

kubectl get deployment -A
NAMESPACE     NAME                READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   antrea-controller   1/1     1            1           8m23s
kube-system   coredns             2/2     2            2           46m

kubectl get services -A
NAMESPACE     NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
default       kubernetes   ClusterIP   10.20.0.1       <none>        443/TCP                  46m
kube-system   antrea       ClusterIP   10.20.244.209   <none>        443/TCP                  7m22s
kube-system   kube-dns     ClusterIP   10.20.0.10      <none>        53/UDP,53/TCP,9153/TCP   45m
```
