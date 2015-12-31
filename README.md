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
folder for the app, and the ssh password and username. You will also need to do
this for the `htaccess.example` folder, modifying the `include_path` options to
include the root of the application folder.

```
rsync -v -e ssh --exclude '.git' --exclude 'pear.sql' --exclude '*.example' \
  --exclude 'composer.*' --exclude '*.swp' --exclude 'migrations' -r \
  --delete . username@hostname:/path/to/target
```

# Install deps to sync

Get composer:

```
curl -sS https://getcomposer.org/installer | php
```

then install the deps:

```
php composer.phar install
```

Note that composer.phar and the vendor folder are both ignored by git, and must
be downloaded before rsync-ing up. The composer.lock file locks all versions of
current libraries being used, so dont worry about that!
