# CSE

CSE is a set of command line utilities designed to make interfacing with the UNSW Computer Science and Engineering's computer systems easier. 

## Curent Features

1) Autocomplete `give` commands on local (i.e. CSE owned) machines.
2) Run commands through `ssh` remotely, using the `cse` command.
3) Run those commands in the context of a local terminal (you don't need to keep a seperate terminal for connecting to cse)
    - Keep track of where on the CSE machine this "virtual SSH" is.
4) Automatically transfer files to cse by using the `^` character at the start of arguments
    - Files being replaced are backed up.

## Structure

Each module will eventually come in two parts:
1) Local: Runs on the CSE computers
2) Remote: Runs on any computer with an internet connection.

## Setup
Setting it up is possible in two ways. You can use a one-liner command, if you use bash; or add a few lines to your config file.
Currently, only `zsh` and `bash` are officially supported (though `zsh` is recommended).

## Automatic
If you use bash (the default on CSE machines), run this command:

```bash
> echo -n "zID [7 digits only]: z" && read zid && mkdir ~/.cse && cd ~/.cse && git clone https://github.com/tfpk/cse . && echo "export _CSE="z$zid@login.cse.unsw.edu.au"" >> ~/.bashrc && echo "source ~/.cse/cse_source.sh" >> ~/.bashrc && source ~/.bashrc && cd -
```
It will ask you for a zID. You should only enter numbers, you do not need to enter a `z`.

If you want to uninstall/retry, run this command (make sure to copy it exactly!):

```bash
> rm -rf ~/.cse/ && sed -i '/^export _CSE.*$/d' ~/.bashrc && sed -i '/source .*cse_source\.sh/d' ~/.bashrc
```

To update it, run:
```bash
cd ~/.cse && git stash && git pull && source ~/.bashrc && cd -
```

## Manual

First, pull this repository (`git clone https://github.com/tfpk/cse`).
Second, add the following to your `~/.bashrc` or `~/.zshrc` (the source file automatically decides if you are local or remote):
```bash
export _CSE="z5555555@login.cse.unsw.edu.au"
source ~/link/to/cse/cse_source.sh
```
Third, if you haven't already, configure ssh keys. [This tutorial is a good guide for CSE computers](https://github.com/CallumHoward/cli-tools/blob/master/ssh_guide.md)

# Usage
(On a local machine, the `cse` part of the command can be included or left out. It must be left out for autocompletion)

To give a program, with autocomplete:
```bash
$ give cs1[TAB]
cs1000 cs1001 ... cs1998
$ give cs1511 wk08_[TAB]
...
$ give cs1511 wk08_example [TAB]
file.c ... other_file.c
```

_DEPRECATED_: To give a program silently:
```bash
> gives cs1511 wk08_[TAB]
> gives cs1511 wk08_example
WARNING: ...
...
```
(This feature was removed by request of CSE).

To use the CSE machine simultaneously with yours:
```bash
> ls
local_file.c local_other_file.c ... home.c
> cse ls
[will pause while SSH connection establishes]
Documents Downloads ... MyHomeFolder
> cse ls ~/Documents
[using the same SSH connection]
remote_cse_file.txt ... another_remote_file.txt
> cse
$ echo "this is run remotely!"
...
$ exit
> echo "back to normal machine"
...
> cse exit
# Will close cse connection gracefully.
```

To transfer files while using `cse`, use the `^` (caret) directly before a filename as argument:
```bash
> ls
my_file.sh  another_file.sh
> cse cat my_file.sh
# error, since my_file.sh doesn't exist
> cse cat ^my_file.sh
# Contents of my_file.sh
> cse cat my_file.sh
# Contents of my_file.sh
```

To access backups in case of emergency (if you've accidentally overwritten a file):
```bash
> cse
$ cd ~/.cse_backup/
$ unzip backup.zip
$ ls backup
# List of all files
# Find the file that you lost (files are named by the time they were uploaded and their name).
$ mv ${my_file} ${new_location}
```

Backups are temporary! Old backups are deleted after 60 minutes of no files being transferred.

If you want to clear space by removing all backups, run `cse clean`
