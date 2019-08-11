
create-cluster:
	cd k8_cluster;	\
	terraform apply -auto-approve;
create-helm-rbac: create-cluster
	cd helm_rbac; \
	terraform apply -auto-approve
create-helm-disks:	
	cd helm_tools/helm_tool_disks;\
	terraform apply
setup-tools: create-cluster create-helm-rbac
	cd helm_tools;\
	terraform apply -auto-approve
update-dns:
	./updateDns.sh anchore-anchore-engine-api anchore anchore-web.hopto.org
	./updateDns.sh jenkins-cd jenkins jenkins-web.hopto.org
	./updateDns.sh nexus-cd-sonatype-nexus nexus nexus-web.hopto.org
	./updateDns.sh prometheus-server monitoring prometheus-web.hopto.org
	./updateDns.sh grafana monitoring grafana-web.hopto.org
full-setup: setup-tools update-dns
	echo "http://jenkins-web.hopto.org:8080/"
	echo "http://nexus-web.hopto.org:8080/"
	echo "http://anchore-web.hopto.org:8228/"
	echo "http://prometheus-web.hopto.org/"
	echo "http://grafana-web.hopto.org/"

destroy-apps:
	cd helm_tools;\
	terraform destroy -auto-approve
destroy-helm-rbac:
	cd helm_rbac; \
	terraform destroy -auto-approve
# destroy-helm-disks:
# 	cd helm_tools/helm_tool_disks;\
# 	terraform destroy -auto-approve
destroy-cluster: destroy-apps destroy-helm-rbac
	cd k8_cluster; \
	terraform destroy -auto-approve
# destroy-all: destroy-apps destroy-helm-rbac destroy-helm-disks
# 	cd k8_cluster; \
# 	terraform destroy -auto-approve