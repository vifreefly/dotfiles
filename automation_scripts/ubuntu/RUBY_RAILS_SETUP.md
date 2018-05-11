# Ruby/Rails setup readme

## Basic ubuntu 16.04 setup

First, you need to do a basic setup: [_Ubuntu server setup readme_](https://github.com/vfreefly/dotfiles/blob/master/automation_scripts/ubuntu/README.md).

## Ruby setup

After when you done a basic setup, we are going to install ruby.

Here is a script: [languages_install.sh](https://github.com/vfreefly/dotfiles/blob/master/automation_scripts/ubuntu/languages_install.sh).

Script contains setup for python, go, nodejs and ruby programming languages. You can install only one language, for this just provide a name of the function to execute, in our case (ruby) it will be: `$ languages_install.sh ruby_install`.

For ruby setup script doing next things:
1. Install ruby compilation dependencies
2. Install rbenv
3. Install latest ruby version (2.5.1) and makes it default
4. Install bundler gem.

To install:
```bash
curl -L https://github.com/vfreefly/dotfiles/raw/master/automation_scripts/ubuntu/languages_install.sh > languages_install.sh && bash languages_install.sh ruby_install
```

After, update enviroment variables of your bash session (to have a just installed ruby command avaiable in terminal): `$ exec $SHELL`.
