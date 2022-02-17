#!/usr/bin/python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import getopt
import subprocess
import sys

def shutdown():
    subprocess.call(['osascript', '-e', 'tell application "Finder" to shut down'])

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
            self.wfile.write(b'{"version": "2.2", "accessibility": "localOnly"}')

    def do_POST(self):
        if self.path.endswith('/shutdown'):
            self._set_response_json()
            self.wfile.write(b"OK")
            shutdown()
        elif self.path.endswith('/stop'):
            self._set_response_json()
            self.wfile.write(b"OK")
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

server_address = ('127.0.0.1', server_port)
httpd = HTTPServer(server_address, S)

httpd.serve_forever()
