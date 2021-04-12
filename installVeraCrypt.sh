#!/bin/bash

baseURL="https://launchpad.net"
versionsURL="/veracrypt/trunk"
downloadURLsuffix="/veracrypt/trunk/:VER/+download/veracrypt-:VER-setup.tar.bz2"
binVER="veracrypt-:VER"

if [[ "$(which veracrypt | wc -c)" -eq "0" ]]
then

  curDir="$(pwd)"
  # This will determine the latest stable version
  version=$(curl -s ${baseURL}${versionsURL} | egrep 'VeraCrypt\s*[1-9]' | egrep -v 'update|hotfix' | sort | tail -n 2 | sort -r | tail -n 1 | cut -d \" -f 2 | cut -d / -f 4)

  echo "OK:Latest stable version is: ${version}"

  downloadURL="${baseURL}$(echo ${downloadURLsuffix} | sed 's/:VER/'${version}'/g')"
  setupVer="$(echo ${binVER} | sed 's/:VER/'${version}'/g')"
  downloadDir="/tmp/${setupVer}.$$"

  mkdir ${downloadDir}
  cd ${downloadDir}
  echo "OK:Downloading ${downloadURL} to ${downloadDir}"
  wget ${downloadURL}

  if [[ -e "${downloadDir}/${setupVer}-setup.tar.bz2" ]]
  then
    echo "OK:Download successful, proceeding with extraction"
    tar -xvjf "${setupVer}-setup.tar.bz2"
    if [[ -e "${downloadDir}/${setupVer}-setup-console-x64" ]]
    then
      echo "OK:Extraction successful, proceeding with install"
      sudo sh "./${setupVer}-setup-console-x64"
      if [[ "$(which veracrypt | wc -c)" -gt "0" ]]
      then
        echo "OK:Instalation successful, proceeding with cleanup"
        cd ${curDir} 
        rm -rf ${downloadDir} 
      else
        echo "ERROR:Failed to install, aborting"
      fi
    else
      echo "ERROR:Failed to extract the installer, aborting"
    fi 
  else
    echo "ERROR:Failed to download the installer, aborting"
    cd ${curDir} 
    rm -rf ${downloadDir} 
  fi
else
  echo "WARN:Veracrypt is already installed, aborting"
fi

