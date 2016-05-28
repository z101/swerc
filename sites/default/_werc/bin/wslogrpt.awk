#!/usr/local/plan9/bin/awk -f

# lsz - log size in bytes

function alength(a,j) {
	for (i in a)
		if (i != "")
			j++
	return j
}

BEGIN {
	counters[""] = 0
	req[""] = 0
	ip[""] = 0
	ua[""] = 0
	errors[""] = 0
	freefmt[""] = 0
	sortcmd = "sort -nr"
}
/^\./ {
	counters["request"]++
	if (match($0, /^\. \[[^\]]+\] \[[^\]]+\] /)) {
		dtip = substr($0, RSTART, RLENGTH)
		req[substr($0, RSTART + RLENGTH)]++
		counters["get"]++
		if (match(dtip, /\[[^\]]+\]/))
			reqdt = substr($0, RSTART + 1, RLENGTH - 2)
		if (match(dtip, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/)) {
			client = substr(dtip, RSTART, RLENGTH)
			ip[client]++
			counters["ip hits"]++
		}
	}
	if (length(startdt) == 0)
		startdt = reqdt
	current=reqdt
	next
}
/^	->/ {
	if (match($0, /^	-> [uU][sS][eE][rR]-[aA][gG][eE][nN][tT]: +/)) {
		ua[substr($0, RSTART + RLENGTH)]++
		counters["user agents"]++
	}
	next
}
/^	<-/ {
	next
}
/^!/ {
	errors[NR] = substr($0, 3)
	next
}
/^\?/ {
	next
}
{
	if (length($0) > 0) {
		freefmt[NR] = $0
	}
	next
}
END {
	print "common"
	printf("    start date : %s\n", startdt)
	printf("    finish date: %s\n", current)
	printf("    file size  : %.2f MB\n", lsz/1024/1024)
	print ""
	print "counters"
	printf("    lines count    : %s\n", NR)
	printf("    requests count : %s\n", counters["request"])
	printf("    unique clients : %s\n", alength(ip))
	print  "    get", "(" counters["get"] ")"
	for(i in req) {
		if(i != "") {
			printf("    %8s %s\n", req[i], i) | sortcmd
		}
	}
	close(sortcmd)
	print  "    ip hits", "(" counters["ip hits"] ")"
	for(i in ip) {
		if(i != "") {
			printf("    %8s %-15s\n", ip[i], i) | sortcmd
		}
	}
	close(sortcmd)
	print  "    user agents", "(" counters["user agents"] ")"
	for(i in ua) {
		if(i != "") {
			printf("    %8s %-15s\n", ua[i], i) | sortcmd
		}
	}
	close(sortcmd)
	print ""
	print "errors", "(" alength(errors) ")"
	for(i in errors) {
		if(i != "") {
			printf("%8s %s\n", i, errors[i]) | sortcmd
		}
	}
	close(sortcmd)
	print ""
	print "free-format", "(" alength(freefmt) ")"
	for(i in freefmt) {
		if(i != "") {
			printf("%8s %s\n", i, freefmt[i]) | sortcmd
		}
	}
	close(sortcmd)
}
