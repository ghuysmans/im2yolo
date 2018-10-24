#!/bin/sh -e
[ -z "$1" ] && echo usage: $0 subreddit && exit 1
[ -z "$2" ] || after="&after=$2"
UA="linux:github.com/ghuysmans/im2yolo:0.1"
curl --user-agent "$UA" "https://www.reddit.com/r/$1.json?limit=100$after" |
jq -r '.data.after, (
       .data.children|
       map(.data)|
       map(select((.is_video=false) and (.is_self=false)))|
       map(.url|select(test(".jpg$")))
       [])' | (
read next
N=`cd /tmp; mkdir -p $1; cd $1; xargs wget --no-verbose --no-clobber; ls |wc -l`
echo N=$N $next
)
