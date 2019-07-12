import sys
import socket

# Executed via `python n_free_ports.py` with the following arguments:
# 1. <number of ports to get>

# sys.argv[1:] is arguments
if (len(sys.argv[1:]) != 1):
    raise RuntimeError("Invalid number of arguments; expected input: `python3 n_free_ports.py <number of ports to get>`")

try:
    num_ports = int(sys.argv[1])
except ValueError:
    debug.error('Invalid argument type')
    raise

for i in range(num_ports):
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.bind(('localhost', 0))
	print(s.getsockname()[1])
	s.close()
