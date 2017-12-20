#!/bin/bash

function cond_redirect {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1" >&2
    fi
    return $status
}

java_webupd8() {
  echo -n "$(timestamp) [openHABian] Preparing and Installing Oracle Java 8 Web Upd8 repository... "
  cond_redirect apt -y install dirmngr
  cond_redirect apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
  if [ $? -ne 0 ]; then echo "FAILED (keyserver)"; exit 1; fi
  rm -f /etc/apt/sources.list.d/webupd8team-java.list
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
  if [ $? -ne 0 ]; then echo "FAILED (debconf)"; exit 1; fi
  cond_redirect apt update
  cond_redirect apt -y install oracle-java8-installer
  if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi
  cond_redirect apt -y install oracle-java8-set-default
  if [ $? -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 1; fi
}

echo "install Oracle JDK 8"
java_webupd8

