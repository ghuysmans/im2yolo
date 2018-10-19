#!/usr/bin/awk -E
#precondition: areas must be on separate lines
#alternative: sed? then XSLT, but it's probably a bit longer
BEGINFILE {
	#FIXME escape?
	"basename \"" FILENAME "\" .map"|getline BN
	OUT=BN ".txt"
	#output coordinates are separated by tabs
	OFS="\t"
	#header
	print "x", "w", "y", "h" >OUT
}
/\s*<area / && / shape="rect"/  && / coords="([0-9,]+)"/ {
	#input shape coordinates are separated by commas
	FS=","
	$0=gensub(/.* coords="([0-9,]+)".*/, "\\1", 1)
	#real conversion work
	print $1, $3-$1, $2, $4-$2 >OUT
}
