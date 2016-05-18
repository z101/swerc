#!/usr/local/plan9/bin/awk -f

# lsz - log size in bytes

END {
	printf("log file size  : %.2f MB\n", lsz/1024/1024)
	printf("log lines count: %s\n", NR)
}
