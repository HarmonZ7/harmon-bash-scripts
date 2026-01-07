# Bash Script Collection

A collection of Bash scripts for administrative automation, file management, and package manageemnt.

## Overview

This repository contains a variety of reusable bash scripts to automate common tasks such as user creation/deletion, file manageemnt, backup creation, and system monitoring. Each script was designed to be easy to use, well documented, and safe to run on Linux or Mac operating systems.

## Requirements

- Bash 3.2 +
- Unix like operating system (Mac or Linux)

## Repository Structure
```
.
├── scripts/
│   ├── compressor.sh
│   ├── create_user.sh
│   ├── delete_user.sh
|   ├── disk_cleaner.sh
|   ├── package_updater.sh
|   └── vim_installer.sh
└── README.md
```

## Script Index

```
| Script | Description | Usage |
|------|------------|-------|
| `compressor.sh` | Creates a gzip and bzip backup of the user's etc directory and compares their sizes. | `./compressor.sh` |
| `create_user.sh` | Creates a new user within the dev_group with a temporary password to be changed on first login. | `sudo ./create_user <username> <password>` |
| `delete_user.sh` | Deletes a specified user. | `sudo ./delete_user.sh <username>` |
| `disk_cleaner.sh` | Cleans specified directories and compares pre and post cleaning disk size. | `./disk_cleaner.sh` |
| `package_updater.sh` | Linux and Mac versions. Updates all installed packages. | `./package_updater.sh` |
| `vim_installer.sh` | Installs Vim if not installed already. | `./vim_installer.sh` |
```
