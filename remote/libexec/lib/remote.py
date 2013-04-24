from os import environ
import socket
import pwd
import grp

import pyutil

class Info:
    pass

def info():
    rv = Info()
    rv.hostname = socket.gethostname()

    rv.public_address = pyutil.capture_shell('hostname -I')

    rv.homedir = "/home/vagrant"
    rv.logdir = "/var/log/jfdi"
    rv.confdir = environ['_REMOTE_CONF']
    rv.username = 'vagrant'
    rv.groupname = 'vagrant'
    rv.userid = pwd.getpwnam(rv.username).pw_uid
    rv.groupid = grp.getgrnam(rv.groupname).gr_gid

    if rv.hostname == 'massive-dev':
        rv.is_devbox = True
    elif rv.hostname == 'massive':
        rv.is_devbox = False
    else:
        pyutil.exit("""
        This script is only meant to be run on remote 'massive-dev' or 'massive' hosts.
        Current host is '%s'.
        """ % rv['hostname'])

    return rv
