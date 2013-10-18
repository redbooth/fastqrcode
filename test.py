import fastqrcode as qrcode

image = qrcode.encode("Hello World",
                      module_size=3,                    # Use 3x3 pixels for each 'dot' in the QR-code
                      version=20,                       # Make at least a version 20 QR-code
                      ec_level=qrcode.ERROR_CORRECT_H,  # High correction level (30% of codewords can be restored.)
                      border=5)                         # Keep a 5 'dots' (ie: 15 pixels) border around the code

image.save('qrcode.png')
