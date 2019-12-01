#!/bin/bash
filename='apt-packageinstall.txt'
while read line;
do
  sudo apt-get install $line
done < "filename"
