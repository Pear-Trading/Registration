# Pear Trading Registration

This repo is for the Pear Trading Registration code and supporting API.
Eventual plan is to only have the Registration code in here, and have the API
in another repository, however, baby steps.

## Setup

To set this up, modify the following config files to contain the required data:

* config/con.php.example
* config/const.php.example

And save them without the `.example` suffix. The next step is to synchronise
these to the server, which you will need to know the IP or hostname, and target
folder for the app, and the ssh password and username.

```
rsync -v -e ssh --exclude '.git' --exclude 'pear.sql' --exclude '*.example' \
  --exclude 'migrations' -r --delete . username@hostname:/path/to/target
```

