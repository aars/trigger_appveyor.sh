#!/bin/sh

_url="https://ci.appveyor.com/api/builds"
_usage() {
	if [ "$1" != "" ]; then
		echo Failed: $1
		echo
	fi
	echo "Usage: $(basename $0) project-slug branch [accountName] [url]"
	echo 
	echo "- project-slug: sluggified project name."
	echo "- branch:       branch to trigger build for."
	echo "- accountName:  read from APPVEYOR_API_ACCOUNTNAME in your env."
	echo "- url:          API url - default: $_url"
	exit 1
}

_trigger() {
	curl -H "Content-Type: application/json" -H "Authorization: Bearer $APPVEYOR_API_TOKEN" -X POST -d "{
		'accountName': '$3',
		'projectSlug': '$1',
		'branch': '$2'
	}" $4
}

if [ "$APPVEYOR_API_TOKEN" == "" ]; then
	_usage "APPVEYOR_API_TOKEN not found in your environment."
fi

if [ "$1" == "" ]; then _usage "Missing project slug"; fi
if [ "$2" == "" ]; then _usage "Missing branch"; fi
_account=$APPVEYOR_API_ACCOUNTNAME
if [ "$3" != "" ]; then _account=$3; fi
if [ "$4" != "" ]; then _url=$4; fi

_trigger $1 $2 $_account $_url

