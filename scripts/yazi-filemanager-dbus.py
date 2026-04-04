#!/usr/bin/env python3
"""D-Bus service implementing org.freedesktop.FileManager1.

Replaces nautilus for "Show in Folder" actions by launching ghostty+yazi.
"""

import subprocess
from urllib.parse import unquote, urlparse

import dbus
import dbus.mainloop.glib
import dbus.service
from gi.repository import GLib

BUS_NAME = "org.freedesktop.FileManager1"
OBJ_PATH = "/org/freedesktop/FileManager1"
TERMINAL = ["ghostty", "--title=FileManager", "-e"]


def uri_to_path(uri):
    return unquote(urlparse(uri).path)


def open_yazi(path):
    subprocess.Popen(
        [*TERMINAL, "yazi", path],
        start_new_session=True,
    )


class FileManager1(dbus.service.Object):
    @dbus.service.method(BUS_NAME, in_signature="ass")
    def ShowFolders(self, uris, startup_id):
        for uri in uris:
            open_yazi(uri_to_path(uri))

    @dbus.service.method(BUS_NAME, in_signature="ass")
    def ShowItems(self, uris, startup_id):
        for uri in uris:
            open_yazi(uri_to_path(uri))

    @dbus.service.method(BUS_NAME, in_signature="ass")
    def ShowItemProperties(self, uris, startup_id):
        for uri in uris:
            open_yazi(uri_to_path(uri))


if __name__ == "__main__":
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()
    dbus.service.BusName(BUS_NAME, bus, replace_existing=True, allow_replacement=True)
    FileManager1(bus, OBJ_PATH)
    GLib.MainLoop().run()
