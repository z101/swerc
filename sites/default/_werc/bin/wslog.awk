#!/usr/local/plan9/bin/awk -f

END {
	printf("Log lines count: %s\n", NR)
}
