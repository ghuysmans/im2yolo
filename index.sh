#!/bin/sh
ls $1 |sed 's/.*/<img src="\0">/' >$1/index.html
