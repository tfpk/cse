# CSE

CSE is a set of command line utilities designed to make interfacing with the UNSW Computer Science and Engineering's computer systems easier. Each module will eventually come in two parts:
1) Local: Runs on the CSE computers
2) Remote: Runs on any computer with an internet connection.

## Setup
Setting it up is reasonably easy. 
First, pull this repository. 
Second, add the following to your `bashrc` or `zshrc`:
```bash
export CSE="z5555555@login.cse.unsw.edu.au"
source ~/link/to/cse/cse_source.sh
```
Third, if you haven't already, configure ssh keys.

# Usage
(On a local machine, the `cse` part of the command can be left out. It must be left out for autocompletion)

To give a program, with autocomplete:
```bash
$ give cs1[TAB]
cs1000 cs1001 ... cs1998
$ give cs1511 wk08_[TAB]
...
$ give cs1511 wk08_example [TAB]
file.c ... other_file.c
```

To use the CSE machine simultaneously with yours:
```bash
$ ls
local_file.c local_other_file.c ... home.c
$ cse ls
[will pause while SSH connection establishes]
Documents Downloads ... MyHomeFolder
$ cse ls ~/Documents
[using the same SSH connection]
remote_cse_file.txt ... another_remote_file.txt
$ cse
> echo "this is run remotely!"
...
> exit
$ echo "back to normal machine"
```
