# pm

The simple pass wrapper

## Usage

In the current iteration `pm` acts mostly as a [pass](https://www.passwordstore.org/)
wrapper, so usage is (mostly) identical to how you would use `pass`.

## Backups

`pm` has a backup feature, to use it one must first do two things, namely

* Setup a backup server(s).
* Create a backup queue.

The above mentioned are expanded below. Note to use this feature you __must__
have `ssh` and `sshpass` installed.

### Setup backup servers

A backup server is simply a machine that you can ssh to and has a working
`pass` installed (ie you can store and retrieve passwords).

### Creating a backup queue

Next in order to add a server to your 'backup' queue, do the following
```
$ pm add Backups/<user>@<ip>
```
And set the password to the one used when logging in to `<user>@<ip>` via ssh.

You can have multiple backup machines, simply add them like you did above.

### Creating the backup

Once you have at least one server in your backup queue (you can check this by
running `pm Backups`) you simply run:
```
pm backup
```
And pm will ssh to each machine in your backup queue and update its passwords
to mach your local passwords.

## Reason for own repo

Normally I keep helper scripts in my [bin](https://github.com/skiqqy/bin) but I
have plans one day to implement my own password manager, and hence will simply
adapt `pm`.
