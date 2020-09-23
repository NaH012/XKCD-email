# XKCD-email
A bash script that will email either the newest XKCD comic or a random one

## Usage ##
The script takes the emails of the recipients as arguments ex.
```
bash emailXKCD.sh example@domain.com
```
There can be any number of emails.

If you want and unsubscribe link provided to each recipient then you can add `-u` and follow their email with the link. All emails must have a link this way or the script will not message everyone.
```
bash emailXKCD.sh -u example@domain.com https://unsub.com secondemail@example.com ...
```

### Dependencies ###
```wget```<br>
```shuf``` which is in the default ubuntu installation <br>
```ssmtp```I know its no longer maintained, but it workes and I will look for something else eventually
## ##
I used Ssmtp on Ubuntu and had it send the message from a gmail account which can be set up like [this][ubuntu-email]




[ubuntu-email]: https://help.ubuntu.com/community/EmailAlerts
