#!/bin/sh

MY_DIR=`dirname $0`
SFBUILD_DIR=${MY_DIR}/..
SFBUILD_PY=${SFBUILD_DIR}/sfbuild.py

PYTHONPATH=${SFBUILD_DIR} pydoc -b