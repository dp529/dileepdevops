#Perform this lab as part of Docker Swarm Traefik Ingress Controller Lab.
[docker_servers]
testserver01 ansible_port=22 ansible_host=${testserver01}
testserver02 ansible_port=22 ansible_host=${testserver02}
testserver03 ansible_port=22 ansible_host=${testserver03}
testserver04 ansible_port=22 ansible_host=${testserver04}
testserver05 ansible_port=22 ansible_host=${testserver05}
testserver06 ansible_port=22 ansible_host=${testserver06}


[docker_master]
testserver01 ansible_port=22 ansible_host=${testserver01}

[docker_managers]
testserver02 ansible_port=22 ansible_host=${testserver02}
testserver03 ansible_port=22 ansible_host=${testserver03}

[docker_workers]
testserver04 ansible_port=22 ansible_host=${testserver04}
testserver05 ansible_port=22 ansible_host=${testserver05}
testserver06 ansible_port=22 ansible_host=${testserver06}


