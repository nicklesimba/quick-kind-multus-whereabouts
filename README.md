# Before asking for help, read this, it might help!!!

## Easy Steps to Set Up a KinD Cluster With Multus and Whereabouts Installed

1. Follow KinD's quickstart guide online. Once you are comfortable with starting/deleting a cluster, return here. Also I assume you know what Multus and Whereabouts are if you are here. If you're new to either, check out these links first... [Multus](https://github.com/k8snetworkplumbingwg/multus-cni) and [Whereabouts](https://github.com/k8snetworkplumbingwg/whereabouts)

2. Run the `kind-multus-whereabouts.sh` to setup the cluster.
   
   - check your multus pods are healthy in kube-system namespace
	
   - to change namespaces use this
		
		`$ kubectl config set-context --current --namespace=kube-system`

3. Run multus quickstart steps to make sure multus is working.
   
   - if you get an error like... `error adding container to network "macvlan-conf": failed to find plugin "macvlan" in path"`

   - ...then try applying this file (it was taken from multus-cni upstream repo under /e2e)
	
		`$ kubectl apply -f cni-install.yml`


4. Install whereabouts by applying all 4 files in the whereabouts-yml directory.
   
	`$ kubectl apply -f <yml-file-here>` 

   - if you want to verify the installation, make the NetAttachDef from the "example configuration using a NetworkAttachmentDefinition" section in the whereabouts [`README.md`](https://github.com/k8snetworkplumbingwg/whereabouts#an-example-configuration-using-a-networkattachmentdefinition)
  
   - make a pod that uses the NetAttachDef you just made (same approach as in the multus quickstart) and see if the IP range for the pod is correct

5. You should be good to go!

## Other Tips/Debug Help

1. Edit multus-daemonset.yml if the one included here is not working

   - source of truth is on github at `k8snetworkplumbingwg/multus-cni/e2e`, can always find the file there.

   - take the file from there, and replace all instances of "localhost:5000/blahblah" with "ghcr.io/k8snetworkplumbingwg/multus-cni:snapshot" 
   
   - ...this will ensure the right version of multus is used.

2. If your multus pods are getting crashLoopBackOff errors:

   - do "$ kubectl logs <pod-name>" and see if the error is about too many open files.
  if so, edit sysctl.conf
	
		`$ sudo vi /etc/sysctl.conf`

   - to fix, add to the bottom of the file:
	
			fs.inotify.max_user_watches = 524288
			fs.inotify.max_user_instances = 512

3. If you want to access the root of any node, look at noderootpod.yml for steps on how to do it, credit to [this blog](https://raesene.github.io/blog/2019/04/01/The-most-pointless-kubernetes-command-ever/) :)

4. Additional credit to [this link](https://gist.github.com/s1061123/c0b857ec1a399c1e174531c0b826a81c), which basically explains how to set up a 3-node environment with KIND that has multus. i based my steps in this readme loosely on it, although it is out of date.