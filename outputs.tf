output "k8sdbaccess_sgs" {
 value = {for k,v in aws_security_group.k8sdbaccess : k => v.id}
}

