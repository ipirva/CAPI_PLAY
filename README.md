# ClusterAPI w/ AWS provider Play

A Git repository to play with ClusterAPI (CAPI) and ClusterAPI AWS provider (CAPA).

## Play

### CAPI management cluster

Start with customizing the variables inside .envrc file and then source that file.

```bash
source ${PWD}/.envrc
```

"kind" is being used to start a local one K8s control plane node.
"clusterawsadm" is being used to bootstrap the AWS environment using a CloudFormation stack. It will mainly create the IAM permissions for the Cluster API.
["clusterctl"](https://cluster-api.sigs.k8s.io/user/quick-start.html) is being used to transform the local K8s cluster into a management cluster. It will practically install all the needed CAPI, CAPA providers, controllers, CRDs, Roles, Cert Manager (e.g.: CAPI, Bootstrap kubeadm, AWS infrastructure components).

```bash
make kind_create
make clusterctl_init
make kubeconfig_export
```

### Workload cluster

The workload cluster bootstrap YAML file will be generated from a base cluster definition.

"clusterctl.yaml" file contains the parameters for a base cluster template we will use to bootstrap workload clusters.
Generate the base cluster template:

```bash
clusterctl config cluster base -n base --config clusterctl.yaml --infrastructure aws:${CAPA_VERSION} > ${PWD}/clusters/base/cluster-template.yaml
source ${PWD}/clusters/base/.envrc && cat ${PWD}/clusters/base/cluster-template-custom.yaml | envsubst > ${PWD}/clusters/base/cluster-template-custom_.yaml
```

There are some new options added to the default CAPA ["cluster-template.yaml"](https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/tag/v0.5.2) file.

- activate the Bastion host (AWSCluster.spec.bastion.enabled)
- add a customer AWS Security Group to the K8s control and worker nodes (AWSMachineTemplate.spec.template.spec.additionalSecurityGroups)

These are are defined in "cluster-template-custom.yaml" and previously sourced as "cluster-template-custom_.yaml".

- pods cidrBlocks
- services cidrBlocks
- additionalSecurityGroups:

Patch the default "cluster-template.yaml" file:

```bash
diff -u ${PWD}/clusters/base/cluster-template.yaml ${PWD}/clusters/base/cluster-template-custom_.yaml > ${PWD}/clusters/base/cluster-template.patch
patch ${PWD}/clusters/base/cluster-template.yaml ${PWD}/clusters/base/cluster-template.patch
```

The workload cluster to be deployed is called "mycluster". Define its specific variables in: "clusters/mycluster/.envrc"
Generate the kustomization file for the workload cluster:

```bash
source ${PWD}/clusters/mycluster/.envrc &&  cat ${PWD}/clusters/mycluster/kustomization-template.yaml | envsubst > ${PWD}/clusters/mycluster/kustomization.yaml
```

Generate the workload cluster deployment file and apply it to the AWS infrastructure:

```bash
kustomize build ${PWD}/clusters/mycluster | kubectl apply -f -
```

The previous command should show:

```bash
namespace/mycluster created
kubeadmconfigtemplate.bootstrap.cluster.x-k8s.io/mycluster-md-0 created
cluster.cluster.x-k8s.io/mycluster created
machinedeployment.cluster.x-k8s.io/mycluster-md-0 created
kubeadmcontrolplane.controlplane.cluster.x-k8s.io/mycluster-control-plane created
awscluster.infrastructure.cluster.x-k8s.io/mycluster created
awsmachinetemplate.infrastructure.cluster.x-k8s.io/mycluster-control-plane created
awsmachinetemplate.infrastructure.cluster.x-k8s.io/mycluster-md-0 created
```
