# Use tcprewrite to edit pcap files to change src mac and dst ip
if [ -z "$1" ]; then
    echo "Usage: $0 <dst_ip>"
    exit 1
fi

src_mac=$(ifconfig n3 | grep ether | awk '{print $2}')
dst_ip=$1

tcpdump -r /mnt/pcaps/5g/ytdl.pcap -w /mnt/modified_pcaps/5g/temp.pcap 'ip dst 10.41.0.5' 
tcpprep --auto=bridge -i /mnt/modified_pcaps/5g/temp.pcap -o /mnt/modified_pcaps/5g/input.cache
tcprewrite --infile=/mnt/modified_pcaps/5g/temp.pcap --outfile=/mnt/modified_pcaps/5g/temp1.pcap --enet-smac=$src_mac --enet-dmac=0a:58:0a:0a:03:01
tcprewrite --infile=/mnt/modified_pcaps/5g/temp1.pcap --outfile=/mnt/modified_pcaps/5g/ytdl_$dst_ip.pcap --endpoints=$dst_ip:10.10.3.233 --cachefile=/mnt/modified_pcaps/5g/input.cache --fixcsum

# tcprewrite --infile=/mnt/modified_pcaps/5g/temp.pcap --outfile=/mnt/modified_pcaps/5g/ytdl_$dst_ip.pcap --endpoints=$dst_ip:10.10.3.233 --cachefile=/mnt/modified_pcaps/5g/input.cache --enet-smac=$src_mac --enet-dmac=0a:58:0a:0a:03:01 --fixcsum

#tcpdump -r /mnt/pcaps/5g/ytdl_upf.pcap -w /mnt/modified_pcaps/5g/temp.pcap 'ip src 10.10.3.1'
#tcprewrite --infile=/mnt/modified_pcaps/5g/temp.pcap --outfile=/mnt/modified_pcaps/5g/ytdl_$dst_ip.pcap --enet-smac=$src_mac --dstipmap=10.10.3.1:$dst_ip  --fixcsum
# tcprewrite --infile=/mnt/pcaps/5g/ytdl_upf.pcap --outfile=/mnt/modified_pcaps/5g/ytdl_$dst_ip.pcap --enet-smac=$src_mac --dstipmap=0.0.0.0/0:$dst_ip  --fixcsum
# tcprewrite --infile=/mnt/pcaps/5g/ytdl.pcap --outfile=/mnt/modified_pcaps/5g/ytdl_$dst_ip.pcap --enet-smac=$src_mac --dstipmap=10.41.0.2:$dst_ip --fixcsum 
# tcpprep --auto=bridge -i /mnt/pcaps/5g/ytdl_upf.pcap -o /mnt/modified_pcaps/5g/input.cache
# tcprewrite --infile=/mnt/pcaps/5g/ytdl_upf.pcap --outfile=/mnt/modified_pcaps/5g/ytdl_$dst_ip.pcap --enet-smac=$src_mac --endpoints=10.41.0.3:10.10.3.233  --fixcsum --cachefile=/mnt/modified_pcaps/5g/input.cache