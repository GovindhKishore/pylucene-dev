#!/bin/bash
set -e

# Dependencies
sudo apt-get update
sudo apt-get install -y \
  ant \
  build-essential \
  python3-dev \
  wget

# Download PyLucene (check https://lucene.apache.org/pylucene/ for latest)
PYLUCENE_VERSION="9.8.0"
wget https://downloads.apache.org/lucene/pylucene/pylucene-${PYLUCENE_VERSION}-src.tar.gz
tar -xzf pylucene-${PYLUCENE_VERSION}-src.tar.gz
cd pylucene-${PYLUCENE_VERSION}

# Build JCC first
cd jcc
JCC_JDK=$(dirname $(dirname $(readlink -f $(which java)))) python setup.py build
JCC_JDK=$(dirname $(dirname $(readlink -f $(which java)))) python setup.py install
cd ..

# Edit Makefile for your environment
PREFIX_PYTHON=/usr
ANT=ant
PYTHON=$(which python3)
JCC=$(python3 -c "import jcc, os; print(os.path.dirname(jcc.__file__))")
NUM_FILES=8

# Build PyLucene
make all PYTHON=${PYTHON} JCC="${PYTHON} -m jcc" ANT=${ANT} PREFIX_PYTHON=${PREFIX_PYTHON} NUM_FILES=${NUM_FILES}
make install PYTHON=${PYTHON} JCC="${PYTHON} -m jcc" ANT=${ANT} PREFIX_PYTHON=${PREFIX_PYTHON} NUM_FILES=${NUM_FILES}

echo "PyLucene installed successfully"
