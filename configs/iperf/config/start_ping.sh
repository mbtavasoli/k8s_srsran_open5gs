# Ping 10.41.0.2 to 10.41.0.100 using the following command:
# echo host1 host2 host3 ... | xargs -n1 -P0 ping -c 4

for ip in $(seq 2 6); do echo "10.41.0.$ip"; done | xargs -n1 -P0 ping