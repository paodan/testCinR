# testCinR

This package has implemented some basic data processing using R API in C,
so, you can take the C code in this package as a reference when you write some C functions to do your work.

Currently it has contained the following technique:

1. Use `inline` package to write R functions that use C code.
2. Use `.External` function to call C code.
3. Use `.Call` function to call C code
4. Use `.C` function to call C code.
5. Convert SEXP into (array of) integer, double, string, etc.
6. Convert (array of) integer, double, string, etc. into SEXP.
7. ...

