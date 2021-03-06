#!/usr/bin/python2

from BaseHTTPServer import BaseHTTPRequestHandler
import SocketServer
import json
import os
import getopt
import sys
import atexit

def shutdown():
    os.system('systemctl poweroff')

class S(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def _set_response_json(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def do_GET(self):
        if self.path.endswith('/info'):
            self._set_response()
            self.wfile.write('{"version": "1.0", "accessibility": "remote"}')

    def do_POST(self):
        if self.path.endswith('/shutdown'):
            self._set_response_json()
            self.wfile.write("OK")
            shutdown()
        elif self.path.endswith('/stop'):
            self._set_response_json()
            self.wfile.write("OK")
            exit()

server_port = 58879

try:
    opts, args = getopt.getopt(sys.argv[1:], 'p:')
except getopt.GetoptError as err:
    pass

output = None
verbose = False
for o, a in opts:
    if o == '-p':
        server_port = int(a)

server_address = ('', server_port)
httpd = SocketServer.TCPServer(server_address, S)

httpd.serve_forever()
