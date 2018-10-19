#!/usr/bin/awk -E
BEGIN {
	#FIXME better argument passing mechanism?
	if (ENVIRON["W"] && ENVIRON["H"]) {
		W=ENVIRON["W"]+0
		H=ENVIRON["H"]+0
	}
	else {
		print "usage: W=n H=n resize.awk yolo.txt..." >"/dev/stderr"
		exit 1
	}
}
BEGINFILE {
	#FIXME escape?
	"dirname \"" FILENAME "\"" |getline DIR
	"basename \"" FILENAME "\" .txt"|getline BN
	PNG_I_E="\"" DIR "/" BN ".png\""
	OUT=BN ".txt"
	PNG_O_E="\"" BN ".png\""
	#extract and split dimensions
	FS=", "
	"file " PNG_I_E |getline
	FS=" x "
	$0=$2 #PNG..., W x H, ...
	#compute coefficients for then next rule
	X=W/$1
	Y=H/$2
	#resize the image
	#FIXME stretch!
	system("convert -resize " W "x" H " " PNG_I_E " " PNG_O_E)
	#input fields are separated by spaces or tabs
	FS=" "
	#output fields are separated by tabs
	OFS="\t"
}
/[0-9. ]+/ {
	print $1*X, $2*X, $3*Y, $4*Y >OUT
	next
}
{ #header
	print >OUT
}
