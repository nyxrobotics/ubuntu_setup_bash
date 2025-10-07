#! /usr/bin/env python2
# -*- coding: utf-8 -*-
# forked from egel/auto-remove-sublime-license-popup
# https://gist.github.com/egel/b7beba6f962110596660
# Reference URLs below
# https://gist.github.com/ruped24/a0fd0272a8ef56441cafb44c753310e0
# https://gist.github.com/SavageCore/2ef63039c95779ae8081

from commands import getoutput as cl
from threading import Event, Thread

from sublime_plugin import EventListener

sublimeMainWindowTitle = " - Sublime Text"


class LicenseWindowKiller(EventListener):
    def seek_n_close(self):
        sublimePid = int(
            cl(
                """wmctrl -lp \
                | grep "%s" \
                | awk '{print $3}'""" % 'Sublime Text'
            ).decode()
        )
        if sublimePid:
            sublimeMainWindowId = cl(
                """wmctrl -lp \
                | grep "%s" \
                | awk '{print $1}'""" % 'Sublime Text'
            ).decode()
            sublimeSecondWindowId = cl(
                """wmctrl -lp \
                | grep %s \
                | awk '{ids[$1]++}{for (id in ids){if (id != "%s"){printf id}}}'"""
                % (sublimePid, sublimeMainWindowId)
            ).decode()
            if sublimeSecondWindowId:
                sublimeSecondWindowTitle = cl(
                    """wmctrl -lp \
                    | grep %s \
                    | awk '{print $5}'""" % sublimeSecondWindowId
                ).decode()
                if not sublimeSecondWindowTitle:
                    cl("wmctrl -i -c %s" % sublimeSecondWindowId)
                    self._remove_popup.set()
        self._remove_popup.is_set()


class ListenerLoop(LicenseWindowKiller, Thread):
    def __init__(self):
        super(Thread, self).__init__()
        super(self.__class__, self).__init__()
        self._remove_popup = Event()
        self.remove_popup = Thread(target=self.on_pre_save_async)
        self.start()

    def on_pre_save_async(self):
        try:
            counter = 600
            while not self._remove_popup.is_set():
                self._remove_popup.wait(.01)
                counter -= 1
                if counter < 0:
                    seek = self._remove_popup.set()
                seek = self.seek_n_close()
        except ValueError:
            pass

    def run(self):
        self.remove_popup.start()


if __name__ == "__main__":
    ListenerLoop()
