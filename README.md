fastqrcode
==========

Fast and robust Python bindings for libqrencode (http://fukuchi.org/works/qrencode/index.en.html) using Cython

There are already several Python bindings for libqrencode (qrencode, pyqrencode and qrkit to name a few), but as of this
writing (October 2013) they all suffer from one or more of the following issues:

  - Memory leaks (not freeing or improperly freeing the QRCode object returned by libqrencode
  - Crashing instead of throwing Python exceptions in case of problems
  - Inability to deal with binary data containing null characters

fastqrcode was written to solve those issues.

Usage
-----

    import fastqrcode as qrcode

    # Basic usage:
    image = qrcode.encode("Hello World")
    image.save('qrcode.png')

    # More options
    image = qrcode.encode("Hello World",
                          module_size=3,                    # Use 3x3 pixels for each 'dot' in the QR-code
                          version=20,                       # Make at least a version 20 QR-code
                          ec_level=qrcode.ERROR_CORRECT_H,  # High correction level (30% of codewords can be restored.)
                          border=5)                         # Keep a 5 'dots' (ie: 15 pixels) border around the code


Limitations
-----------

Currently, fastqrcode always encode in binary mode, which is less efficient if you are encoding only alphanumeric
characters.


Installation
------------

Please make sure you have the following dependencies:

  - libqrencode (OSX: `brew install libqrencode` - Ubuntu: `sudo apt-get install libqrencode-dev`)
  - Pillow (`pip install pillow`)

You should have libqrencode in your LD path (/usr/local/lib) and qrencode.h in your include path (/usr/local/include)

Then, install using pip:

    $ pip install fastqrcode

Alternatively, you can download the source code and install manually:

    $ python setup.py install


Development
-----------

If you'd like to make changes to fastqrcode.pyx, you will need to install Cython in order to compile the pyx file to c:

    $ pip install cython
    $ cython fastqrcode.pyx
    $ python setup.py install

If you're submitting a pull request, please make sure that your commit has the changes for both fastqrcode.pyx and
fastqrcode.c

