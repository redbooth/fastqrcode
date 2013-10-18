from PIL.ImageOps import expand
from PIL.Image import frombytes

# Error-correction constants
ERROR_CORRECT_L = 0
ERROR_CORRECT_M = 1
ERROR_CORRECT_Q = 2
ERROR_CORRECT_H = 3

global errno

cdef extern from "errno.h":
    enum: ENOMEM
    enum: ERANGE

    int errno

cdef extern from "qrencode.h":

    ctypedef struct QRcode:
        int version
        int width
        unsigned char* data

    QRcode* QRcode_encodeData(int size, const unsigned char* data, int version, int level)
    void QRcode_free(QRcode* qrcode)


def encode(data, module_size=3, version=0, ec_level=ERROR_CORRECT_L, border=4):
    """
    Generate a QR code image

    @param data:        Python string with the data to be encoded.
    @param module_size: The size of each 'pixel' in the QR code.
    @param ec_level:    Error correction level.
    @param border:      Size of the border, in `module_size` units. Ie if border = 4 and module_size = 3, then the actual
                        border around the image will be 12 pixels wide. Default is 4 as recommended by the QR code spec.
    @param version:     The minimum QR code version to use. If 0, use the smallest version that fits all the data.
                        Note that the generated QR code may use a larger version if necessary.
    @return:            PIL image with the generated QR code
    """
    cdef QRcode* _qrcode
    try:
        # Generate the QR code
        _qrcode = QRcode_encodeData(len(data), data, int(version), int(ec_level))

        if _qrcode == NULL:
            if errno == ERANGE:
                raise ValueError("Couldn't generate QR code. Input data is too large.")
            elif errno == ENOMEM:
                raise MemoryError("Couldn't generate QR code. Out of memory.")
            else:
                raise RuntimeError("Couldn't generate QR code. Error %i." % errno)

        width = _qrcode.width

        # Generate the raw image data. Each pixel is represented by a byte. 0 for black, 255 for white.
        rawdata = ''
        for y in range(width):
            row = ''
            for x in range(width):
                module_color = _qrcode.data[y * width + x] % 2  # 1 for black, 0 for white
                row += module_size * chr(255 * (1 - module_color))
            rawdata += module_size * row

        # Create PIL image. Mode 'L' means grayscale, 1 byte per pixel.
        image = frombytes('L', (width * module_size, width * module_size), rawdata)

        # Add the border around the image
        return expand(image, border * module_size, 255)

    finally:
        QRcode_free(_qrcode)