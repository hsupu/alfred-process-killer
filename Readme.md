# Alfred Workflow - Process Killer

## Description

forked from [ngreenstein/alfred-process-killer](https://github.com/ngreenstein/alfred-process-killer)

Process Killer is an Alfred 2 workflow that makes it easy to kill misbehaving processes. It is, in essence, a way to easily find processes by name and kill them using command `kill`.

## Features && Changes

* Autocompletes process names
* *new* Supports send signal (use `-XXX`)
* *new* Supports filters (use `filter1 filter2 ..`)
* *new* Supports run as root (use `sudo kill -ppassword`)
* Learns and prioritizes processes you kill frequently
* Shows icons when possible
* *new* Shows PID, User with UID, CPU usage and MEM usage
* Shows process paths
* *new* Feedback notification about result
* Supports [Alleyoop updating](http://www.alfredforum.com/topic/1582-alleyoop-update-alfred-workflows/).

## Screenshots

![screenshot: `kill nginx`](example1.png)
![screenshot: `kill -USR1 nginx master`](example2.png)
![screenshot: `sudo kill`](example3.png)

## Usage

### just kill

1. Type `kill` into Alfred followed by a space.  
   Maybe you need `sudo kill` to kill other's process.
2. Begin typing the name of the process you want to kill.
3. When you see the process you want to kill, select it from the list as usual.
4. Press return to kill the selected process.

for example, see the [first screenshot](example1.png).

Only when use `sudo kill` can you see other's process. (see the [third screenshot](example3.png)).

### send a signal

see the [second screenshot](example2.png).

## Installation

Download the [release version](https://github.com/tridays/alfred-process-killer/releases). Open it and Alfred will walk you through the installation process.

No configuration is necessary.

## Making Changes

This script was written in Ruby. Edit it to suit your own habits.

### Alleyoop Support

If your updates are big enough to justify a new release, please update the Alleyoop support files for auto-updating.

1. Update `current-version.json` with the new version number (a float) and a short description of the changes.
2. Update `update.json` with the new version number.
3. **Copy the new `update.json` into the workflow's folder in Finder.**

## License

[WTFPL](http://www.wtfpl.net/about/), of course.
