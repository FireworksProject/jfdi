import errno
import sys
from os import path, makedirs
import hashlib
import subprocess
import shutil
import textwrap


def sub_or_exit(cmd, errmsg):
    args = cmd.split()
    if subprocess.call(args) is not 0:
        exit(errmsg)

def shell(cmd):
    return subprocess.call(cmd, shell=True)

def capture_shell(cmd):
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
    return proc.stdout.read()

def exit(msg):
    sys.exit(textwrap.dedent(msg))

def file_md5(abspath):
    return hashlib.md5(open(abspath, 'rb').read()).hexdigest()

def files_equal(a, b):
    a_hash = file_md5(a)
    b_hash = file_md5(b)
    return (a_hash == b_hash)

def replace_dir(src, target):
    if path.isdir(target):
        shutil.rmtree(target)

    shutil.copytree(src, target)

def ensure_path(abspath):
    try:
        makedirs(abspath)
    except OSError as exc:
        if exc.errno == errno.EEXIST and path.isdir(abspath):
            pass
        else: raise exc
