#!/bin/sh
[ -z "$1" ] && echo usage: $0 subreddit && exit 1
#FIXME save the output, iterate using .data.after
curl https://www.reddit.com/r/$1.json?limit=100 |
jq -r '.data.children|
       map(.data)|
       map(select((.is_video=false) and (.is_self=false)))|
       map(.url|select(test(".jpg$")))
       []' |
#FIXME avoid duplicates...
(cd /tmp; mkdir $1; cd $1; xargs -P 20 wget)
