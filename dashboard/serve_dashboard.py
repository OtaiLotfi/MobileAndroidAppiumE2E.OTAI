#!/usr/bin/env python3
"""
Serve the Mobile Android E2E dashboard over HTTP.

Usage: python serve_dashboard.py [port]
Default port: 8765

Then open: http://localhost:8765/index.html
"""

import http.server
import os
import sys


def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8765
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    handler = http.server.SimpleHTTPRequestHandler
    server = http.server.HTTPServer(('', port), handler)
    print(f'Dashboard server running on http://localhost:{port}/index.html')
    print('Press Ctrl+C to stop.')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print('\nStopped.')


if __name__ == '__main__':
    main()
