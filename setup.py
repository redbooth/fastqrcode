from distutils.core import setup
from distutils.extension import Extension


setup(
    name="fastqrcode",
    version="1.0",
    description="Fast and robust bindings for libqrencode",
    long_description=open('README.md', 'rt').read(),
    url="https://github.com/aerofs/fastqrcode",
    author="Gregory Schlomoff",
    author_email="greg@aerofs.com",
    ext_modules=[Extension("fastqrcode", ['fastqrcode.c'], libraries=["qrencode"])]
)
