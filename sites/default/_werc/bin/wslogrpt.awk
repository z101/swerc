#!/usr/local/plan9/bin/awk -f

# lsz - log size in bytes

function alength(a,j) {
	for(i in a)
		if(i != "")
			j++
	return j
}

BEGIN {
	# START - beginning of the file
	# BLOCK - log block
	# INFO - info block
	# REQUEST - request block
	# RESPONSE - response block
	# DATA - log data
	cursec="START"

	counters[""]=0
	malformed[""]=0
	errors[""]=0
	sortcmd="sort -n"
}
/^[A-Z][a-z][a-z], [0-9]+ [A-Z][a-z][a-z] [0-9]+ [0-9]+:[0-9]+:[0-9]+ GMT/ {
	counters["block"]++
	if(match($0, /^.*GMT	/)) {
		dt=substr($0,1,RLENGTH-1)
		msg=substr($0,RSTART+RLENGTH)
	} else {
		dt=$0
		msg=""
	}
	if(cursec == "START") {
		start=dt
	}
	cursec="BLOCK"
	current=dt
	if(match(msg, "error|failure")) {
		errors[NR]=msg
	}
	counters["processed"]++
	next
}
/^	>$/ {
	if(cursec == "START") {
		malformed[NR]="block expected, but request marker found"
		counters["processed"]++
		next
	}
}
/^	<$/	{
	if(cursec == "START") {
		malformed[NR]="block expected, but response marker found"
		counters["processed"]++
		next
	}
}
/^	[^:]+: / {
	if(cursec == "START") {
		malformed[NR]="block expected, but name:value pair found"
		counters["processed"]++
		next
	}
}
{
	if(cursec == "START") {
		malformed[NR]="block expected, but free-format data found"
		counters["processed"]++
		next
	}
}
END {
	print "COMMON"
	printf("    start date : %s\n", start)
	printf("    finish date: %s\n", current)
	printf("    file size  : %.2f MB\n", lsz/1024/1024)
	print ""
	print "COUNTERS"
	printf("    lines count    : %s\n", NR)
	printf("    lines processed: %s\n", counters["processed"])
	printf("    blocks count   : %s\n", counters["block"])
	hp=""
	for(i in malformed) {
		if(i != "") {
			if(hp == "") {
				print ""
				print "MALFORMED"
				hp="y"
			}
			printf("    %s, %s\n", i, malformed[i]) | sortcmd
		}
	}
	close(sortcmd)
	hp=""
	for(i in errors) {
		if(i != "") {
			if(hp == "") {
				print ""
				print "ERRORS", "(" alength(errors) ")"
				hp="y"
			}
			printf("    %s, %s\n", i, errors[i]) | sortcmd
		}
	}
	close(sortcmd)
}
