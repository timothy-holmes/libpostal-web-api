from os import environ

from flask import Flask, request, jsonify
from postal.expand import expand_address
from postal.parser import parse_address


# Get env vars
WEBSERVER_PORT = int(environ.get('WEBSERVER_PORT', 9999))
DEBUG = bool(environ.get('DEBUG', False))

# Print debug messages
debug = print if DEBUG else lambda *a, **k: None

# Init Flask
app = Flask(__name__)

# Endpoint for expand_address
@app.route('/expand', methods=['POST'])
def expand_address_endpoint():
    data = request.json
    address = data.get('address')
    if not address:
        return jsonify({'error': 'No address provided'}), 400
    expanded = expand_address(address)
    debug(f'input address: {address}, output address: {expanded}')
    return jsonify({'expanded': expanded})

# Endpoint for parse_address
@app.route('/parse', methods=['POST'])
def parse_address_endpoint():
    data = request.json
    address = data.get('address')
    if not address:
        return jsonify({'error': 'No address provided'}), 400
    parsed = parse_address(address)
    debug(f'input address: {address}, output address: {parsed}')
    return jsonify({'parsed': parsed})

if __name__ == '__main__':
    # Run parse test
    test_address = '123 Gisborne Rd Gisborne VIC 3431' # intentionally incorrect postcode
    parsed = parse_address(test_address)
    debug(f'input address: {test_address}, output address: {parsed}')

    # Run expand test
    expanded = expand_address(test_address)
    debug(f'input address: {test_address}, output address: {expanded}')
    print(expanded)

    # Run Flask app
    app.run(host='0.0.0.0', port=9999, debug=DEBUG)