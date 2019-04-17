#!/bin/bash

OUTPUT="xml"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|--help)
    HELP=true
    shift # past argument
    ;;
    -o|--output)
    OUTPUT="$2"
    shift # past argument
    shift # past value
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "$HELP" = true ] ; then
    echo "\
Usage: xelm [options] [--help]

Options are:
    -o, --output='xml': Output format. One of: xml, json\
"
    exit 0
fi

if [ "$OUTPUT" = "xml" ] ; then
  xsltproc ./templates/deploy.xsl values.xml | xmllint --format -;
elif [ "$OUTPUT" = "json" ] ; then
  xsltproc ./templates/deploy.xsl values.xml | xmllint --format - | python3 ./tojson.py;
fi
