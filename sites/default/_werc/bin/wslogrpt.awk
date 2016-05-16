#!/usr/local/plan9/bin/awk -f

# lsz - log size in bytes

END {
	printf("Log lines count: %s\n", NR)
	printf("Log file size  : %.2f KB\n", lsz/1024)
}
