#include <Rinternals.h>                           // Include Rinternals.h
SEXP foo(SEXP x)                                  // Define function "foo"
{
  SEXP ab;                                        // Claim variable ab
  ab = PROTECT(allocVector(REALSXP, 2));          // Allocate ab with a vector of length 2 and protect from memory collection
  REAL(ab)[0] = LENGTH(x);                        // Use macro LENGTH to count the length of x and assign the length to the first element of ab
  REAL(ab)[1] = 67.89;                            // Assign 67.89 to the second element of ab
  UNPROTECT(1);                                   // Unprotect ab
  return ab;                                      // Return ab
}


void convolve(double *a, int *na, double *b, int *nb, double *ab);
void testPointerAddress(double *data);
void C_writeFile(char *fileName, double *num, int length);

// R-C Interface:
/* The following codes are not necessary, but including them will increase the
 * speed of running.
 * The code defines the cMethods array that maps the R function names to their
 * corresponding C functions, along with the number of arguments.
 *
 * foo and convolve are two defined functions, numbers 1 and 5 are numbers of
 * arguments in the functions.
 *
 * runCinR2 is the package name.
*/
static const R_CMethodDef cMethods[] = {
  {"foo", (DL_FUNC) &foo, 1},
  {"convolve", (DL_FUNC) &convolve, 5},
  {"testPointerAddress", (DL_FUNC) &testPointerAddress, 1},
  {"C_writeFile", (DL_FUNC) &C_writeFile, 3},
  {NULL, NULL, 0}
};

/* The R_init_runCinR2 function is an R-specific function that registers the C
 * functions with R's dynamic symbols, making them accessible from R.
 *
*/
void R_init_runCinR2(DllInfo *info)
{
  R_registerRoutines(info, cMethods, NULL, NULL, NULL);
  R_useDynamicSymbols(info, TRUE);
}
