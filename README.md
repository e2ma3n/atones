# atones - attack on esxi
## Introduction
Finding attack on vSphere web client and ssh in VMware ESXi

The project page is located at https://github.com/e2ma3n/atones

## Why we should use sshlog program ?

- Because i need to see ssh and vSphere web client attack in my esxi server
- Because i need to monitor users login in esxi server
- etc


## What esxi are supported ?
All new esxi version

| OS | Version |
| -------- |------ |
| ESXi     | 6.7u2 |
| ESXi     | 6.7u1 |
| ESXi     | 6.7   |
| ESXi     | 6.5   |
| ESXi     | 6.0   |
| ESXi     | 5.5   |


## Dependencies

| Dependency | Description |
| ---------- | ----------- |
| python-pandas   | pandas is an open source, BSD-licensed library providing high-performance, easy-to-use data structures and data analysis tools for the Python programming language. |
| python-tabulate | Pretty-print tabular data in Python, a library and a command-line utility. |
| rm              | remove files or directories. |
| mkdir           | make directories. |
| grep            | grep  searches  the  named  input FILEs for lines containing a match to the given PATTERN. |
| ls              | List information about the FILEs (the current directory by default). |
| cat             | concatenate files and print on the standard output. |
| paste           | Write lines consisting of the sequentially corresponding lines from each FILE, separated by TABs, to standard output. |
| cut             | Print selected parts of lines from each FILE to standard output. |
| tr              | Translate, squeeze, and/or delete characters from standard input, writing to standard output. |

## How to get source code ?
You can download and view source code from github : https://github.com/e2ma3n/atones

Also to get the latest source code, run following command:
```
# git clone https://github.com/e2ma3n/atones.git
```
This will create atones directory in your current directory and source files are stored there.

## How to install dependencies on debian ?
By using apt-get command; for example :
```
# apt-get install python-pandas
# apt-get install python-tabulate
```

## How to install atones ?

atones is a portable program and dont need to install

## How to uninstall ?

just remove atones script


## How to use atones ?

atones.sh [ESXi ip address]
Example: atones.sh 192.168.1.1

## License
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
