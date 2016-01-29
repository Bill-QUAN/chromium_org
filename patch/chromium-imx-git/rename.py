#!/usr/bin/env python

import os

lheader='arm-unknown-linux-gnueabi-'
sheader='arm-linux-'
path='/opt/arm-linux-20110812'

cmd='cd ' + path + '/bin; ' + 'ls'

for longname in os.popen(cmd):
  name=longname[len(lheader):-1]
  longname=longname[:-1]
  rename=sheader + name
  link='ln -s ' + longname + ' ' + path + '/bin/' + rename 
  #print link
  os.system(link)
