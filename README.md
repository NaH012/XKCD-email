# XKCD-email
A script that will email either the newest XKCD comic or a random one

## Install ##
To install simply run 
```
sh install.sh
```
## Usage ##
The script takes the emails of the recipients as arguments ex.
```
sh emailXKCD.sh example@domain.com
```
There can be any number of emails.

### Dependencies ###
```wget```<br>
```mail``` from ```mailutils```<br>
```shuf``` which is in the default ubuntu installation
