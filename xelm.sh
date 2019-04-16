#!/bin/bash

xsltproc deploy.xsl values.xml | xmllint --format - | ./tojson.py
