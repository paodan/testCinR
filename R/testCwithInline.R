#' Return a sum of two numbers
#'
#'
#' Keywords in the C code: REALSXP, allocVector, PROTECT, SEXP, asReal,
#' UNPROTECT
#'
#' @param x description
#' @import inline
#' @export
#' @examples
#' \dontrun{
#' rc_add(1, 5)
#' }
#'
rc_add <- cfunction(sig = c(a = "integer", b = "integer"),
                 body =
                   "
  SEXP result = PROTECT(allocVector(REALSXP, 1));
  REAL(result)[0] = asReal(a) + asReal(b);
  UNPROTECT(1);

  return result;
",
)




#' create a random list of 3 elements
#'
#'
#' Keywords in the C code: REALSXP, LGLSXP, INTSXP, asInteger, PROTECT,
#' UNPROTECT, allocVector, SET_VECTOR_ELT, SEXP
#'
#' @examples
#' \dontrun{
#' rc_createList(4)
#' }
#'
#' @export
rc_createList <- cfunction(sig = c(x = "integer"), body = '
  SEXP dbls = PROTECT(allocVector(REALSXP, asInteger(x)));
  SEXP lgls = PROTECT(allocVector(LGLSXP, asInteger(x)));
  SEXP ints = PROTECT(allocVector(INTSXP, asInteger(x)));

  SEXP vec = PROTECT(allocVector(VECSXP, 3));
  SET_VECTOR_ELT(vec, 0, dbls);
  SET_VECTOR_ELT(vec, 1, lgls);
  SET_VECTOR_ELT(vec, 2, ints);

  UNPROTECT(4);
  return vec;
')



#' create a vector of zeros
#'
#' loop through each element in the vector and set it to a constant. The most efficient way to do that is to use memset()
#' // void \* memset ( void \* ptr, int value, size_t num );
#' Sets the first num bytes of the block of memory pointed by ptr to the specified value .
#' please not the character for new line is no longer `\n` but `\\n`.
#'
#' Keywords in the C code: INTSXP, asInteger, allocVector, PROTECT, memset,
#' UNPROTECT, for, printf, INTEGER
#'
#' @examples
#' \dontrun{
#' rc_zeroes(10)
#' }
#'
#' @export
rc_zeroes <- cfunction(sig = c(n_ = "integer"), body = '
  int n = asInteger(n_);

  SEXP out = PROTECT(allocVector(INTSXP, n));
  memset(INTEGER(out), 0, n * sizeof(int));
  UNPROTECT(1);
  for(int i = 0; i < 10; i++){
  printf("Hello World!\\n");
  printf("[%d] %d\\n", i, INTEGER(out)[i]);
  };

  return out;
', language = "C")



#' Are the elements in a vector a NA
#'
#'
#' Keywords in the C code: for, switch, TYPEOF, NA_LOGICAL, LOGICAL,
#' INTEGER, NA_INTEGER, ISNA, REAL, NA_STRING
#'
#' @examples
#' \dontrun{
#' rc_is_na(c(1, 2, 3, NA, 4))
#' rc_is_na(c(NA, "a"))
#' rc_is_na(c(NA, TRUE))
#' }
#'
#' @export
#'
rc_is_na <- cfunction(c(x = "ANY"), '
  int n = length(x);

  SEXP out = PROTECT(allocVector(LGLSXP, n));

  for (int i = 0; i < n; i++) {
    switch(TYPEOF(x)) {
      case LGLSXP:
        LOGICAL(out)[i] = (LOGICAL(x)[i] == NA_LOGICAL);
        break;
      case INTSXP:
        LOGICAL(out)[i] = (INTEGER(x)[i] == NA_INTEGER);
        break;
      case REALSXP:
        LOGICAL(out)[i] = ISNA(REAL(x)[i]);
        break;
      case STRSXP:
        LOGICAL(out)[i] = (STRING_ELT(x, i) == NA_STRING);
        break;
      default:
        LOGICAL(out)[i] = NA_LOGICAL;
    }
  }
  UNPROTECT(1);

  return out;
')





#' add 2 to a vector
#'
#' Keywords: length, double *, REALSXP, allocVector, PROTECT, SEXP, REAL,
#' UNPROTECT, for
#'
#' @examples
#' \dontrun{
#' (x = rnorm(5))
#' rc_add_two(x)
#' }
#'
#' @export

rc_add_two <- cfunction(c(x = "numeric"), "
  int n = length(x);
  double *px, *pout;

  SEXP out = PROTECT(allocVector(REALSXP, n));

  px = REAL(x);
  pout = REAL(out);
  for (int i = 0; i < n; i++) {
    pout[i] = px[i] + 2;
  }
  UNPROTECT(1);

  return out;
")


#' Create a vector of string using C
#'
#' Keywords: STRSXP, allocVector, PROTECT, SEXP, SET_STRING_ELT, mkChar, length,
#' STRING_ELT, CHAR, const char *, UNPROTECT, puts, type2char, TYPEOF, asChar
#'
#' puts function is to print a char array (or string).
#'
#' @examples
#' \dontrun{
#' rc_abc()
#' }
#'
#' @export

rc_abc <- cfunction(NULL, '
  SEXP out = PROTECT(allocVector(STRSXP, 3));

  char a[] = "a1";
  char b[] = "bb2";
  char c[] = "ccc3";
  SET_STRING_ELT(out, 0, mkChar(a));
  SET_STRING_ELT(out, 1, mkChar(b));
  SET_STRING_ELT(out, 2, mkChar(c));

  for(int i = 0; i < length(out); i++){
    SEXP tmp = PROTECT(STRING_ELT(out, i));
    const char *yc = CHAR(tmp);

    char t[] = "TYPEOF(asChar(tmp)): ";
    puts(t);
    puts(type2char(TYPEOF(asChar(tmp))));

    puts(yc);
    UNPROTECT(1);
  }
  UNPROTECT(1);
  return out;
')



#' add 4 to a number in place with duplicate function in C
#'
#' Keywords: duplicate, PROTECTSEXP, REAL, UNPROTECT
#'
#' @param x the value to be changed in place
#' @examples
#' \dontrun{
#' x <- 1
#' y <- x
#' rc_add_four(x)
#' y
#' x
#' }
#' @export
rc_add_four <- cfunction(c(x = "numeric"), '
  SEXP x_copy = PROTECT(duplicate(x));
  REAL(x_copy)[0] = REAL(x_copy)[0] + 4;
  UNPROTECT(1);
  return x_copy;
')



#' length of a vector
#'
#'
#' Keywords: XLENGTH, R_xlen_t, ScalarReal, (double), PROTECT, SEXP, UNPROTECT
#' if you use `int n = length(x)`, then this function cannot deal with a vector
#' of length 2^31 -1.
#'
#' @examples
#' \dontrun{
#' rc_length(1:5)
#' rc_length(1:2^32)
#' }
#'
#' @export
rc_length = cfunction(c(x = "numeric"), body = '
  R_xlen_t n = XLENGTH(x);
  SEXP res = PROTECT(ScalarReal((double)n));
  UNPROTECT(1);
  return res;
')



#' get data from pairlist
#'
#' Keywords: TAG, CAR, CAAR, CDR, CADR, SEXP, UNPROTECT
#' if you use `int n = length(x)`, then this function cannot deal with a vector
#' of length 2^31 -1.
#'
#' @examples
#' \dontrun{
#' x <- quote(f(a = 1, b = 2, c = 3, d = 4, e = 5, f = 6))
#' rc_tag(x)
#' rc_car(x)   # first
#' rc_caar(x)
#' rc_cdr(x)
#' rc_cadr(x)  # second
#' rc_cddr(x)
#' rc_cdddr(x)
#' rc_caddr(x) # third
#' rc_cadddr(x)# fourth
#' rc_cad4r(x) # fifth
#' rc_car(rc_cdr(rc_cdr(rc_cdr(rc_cdr(rc_cdr(x)))))) # sixth
#' rc_car(rc_cdr(rc_cdr(rc_cdr(rc_cdr(rc_cdr(rc_cdr(x))))))) # seventh
#' }
#'
#' @export

rc_tag <- cfunction(c(x = "ANY"), 'return TAG(x);')
#' @export
rc_car <- cfunction(c(x = "ANY"), 'return CAR(x);')
#' @export
rc_caar <- cfunction(c(x = "ANY"), 'return CAAR(x);')
#' @export
rc_cdr <- cfunction(c(x = "ANY"), 'return CDR(x);')
#' @export
rc_cadr <- cfunction(c(x = "ANY"), 'return CADR(x);')
#' @export
rc_cdar <- cfunction(c(x = "ANY"), 'return CDAR(x);')
#' @export
rc_cddr <- cfunction(c(x = "ANY"), 'return CDDR(x);')
#' @export
rc_cdddr <- cfunction(c(x = "ANY"), 'return CDDDR(x);')
#' @export
rc_caddr <- cfunction(c(x = "ANY"), 'return CADDR(x);')
#' @export
rc_cadddr <- cfunction(c(x = "ANY"), 'return CADDDR(x);')
#' @export
rc_cad4r <- cfunction(c(x = "ANY"), 'return CAD4R(x);')



#' make a call object `10+5`
#'
#' Keywords: ScalarReal, PROTECT, SEXP, install, LCONS, R_NilValue, UNPROTECT
#' Here install function is to create a symbol (the equivalent of as.symbol() in R).
#' @examples
#' \dontrun{
#' rc_new_call()
#' }
#'
#' @export
rc_new_call <- cfunction(NULL, '
  SEXP plusSym = PROTECT(install("+"));
  SEXP REALSXP_10 = PROTECT(ScalarReal(10));
  SEXP REALSXP_5 = PROTECT(ScalarReal(5));
  SEXP out = PROTECT(
  LCONS(plusSym,
    LCONS(REALSXP_10,
      LCONS(REALSXP_5, R_NilValue)
  )));
  UNPROTECT(4);
  return out;
')


#' set attribute for an object
#'
#' Keywords: asChar, CHAR, duplicate, setAttrib, install, SEXP
#' @examples
#' \dontrun{
#' x <- 1:10
#' rc_set_attr(x, "a", 1)
#' }
#'
#' @export
rc_set_attr <- cfunction(c(obj = "SEXP", attr = "SEXP", value = "SEXP"), '
  const char* attr_s = CHAR(asChar(attr));

  duplicate(obj);
  setAttrib(obj, install(attr_s), value);
  return obj;
')


#' get the dimension of a matrix
#'
#' Keywords: GET_DIM, duplicate, PROTECT, SEXP, UNPROTECT
#' @param obj a matrix
#' @examples
#' \dontrun{
#' rc_get_dim(matrix(1:10, nrow = 5))
#' rc_get_dim2(matrix(1:10, nrow = 5), attr = "dim") # here it is not R_DimSymbol
#' }
#'
#' @export
rc_get_dim <- cfunction(c(obj = "SEXP"), '
  duplicate(obj);
  SEXP dims = PROTECT(GET_DIM(obj));

  UNPROTECT(1);
  return dims;
')

#' @export
rc_get_dim2 <- cfunction(c(obj = "SEXP", attr = "SEXP"), '
  const char* attr_s = CHAR(asChar(attr));
  SEXP dims = PROTECT(getAttrib(obj, install(attr_s)));
  // SEXP dims = PROTECT(getAttrib(obj, R_DimSymbol));

  UNPROTECT(1);
  return dims;
')


#' make a matrix
#'
#'
#' Keywords: asInteger, allocMatrix, REALSXP, TYPEOF, if, else if, else, PROTECT, double*,
#' REAL, for, UNPROTECT, INTEGER, int*, UNPROTECT, error
#'
#' @param obj vector of integer or numeric
#' @param nrow number of rows
#' @param ncol number of columns
#' @examples
#' \dontrun{
#' x <- 1:10
#' (y = rc_make_matrix((x), nrow = 5, ncol = 2))
#' class(y[1])
#' (y = rc_make_matrix(as.numeric(x), nrow = 5, ncol = 2))
#' class(y[1])
#' }
#'
#' @export
rc_make_matrix <- cfunction(c(obj = "SEXP", nrow = "SEXP", ncol = "SEXP"), '
  int row = asInteger(nrow), col = asInteger(ncol);
// Check if the matrix is of type REALSXP (double)
  if (TYPEOF(obj) == REALSXP) {
        SEXP res = PROTECT(allocMatrix(REALSXP, row, col));
        double* data = REAL(res);
        double* pobj = REAL(obj);

        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                data[i + j * row] = pobj[i + j * row];
            }
        }
  UNPROTECT(1);
  return res;
  }
  else if (TYPEOF(obj) == INTSXP) {
        SEXP res = PROTECT(allocMatrix(INTSXP, row, col));
        int* data = INTEGER(res);
        int* pobj = INTEGER(obj);

        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                data[i + j * row] = pobj[i + j * row];
            }
        }
  UNPROTECT(1);
  return res;
  }
  else {
        error("Matrix is not of type REALSXP or INTSXP.");
  }
')



#' coaerce a vector to numeric
#'
#'
#' Keywords: ScalarLogical, PROTECT, TYPEOF, coerceVector, REALSXP, SEXP, UNPROTECT,
#' SET_STRING_ELT, const char *nm[], VECSXP, length,
#' allocVector, mkChar, install, setAttrib, SET_VECTOR_ELT
#'
#' @returns a list of two, which are the coaerced vector and a logical to tell
#' if the original vector is numeric (double).
#'
#' @param x a vector
#' @examples
#' \dontrun{
#' rc_coaerce(as.numeric(1:4))
#' rc_coaerce(1:4)
#' rc_coaerce(c(TRUE, FALSE))
#' }
#'
#' @export
rc_coaerce = cfunction(sig = c(x = "SEXP"), body = '
SEXP isNumeric = PROTECT(ScalarLogical(TYPEOF(x) == REALSXP));
SEXP y = PROTECT(coerceVector(x, REALSXP));

SEXP res = PROTECT(allocVector(VECSXP, 2));
const char *nm[] = {"y", "isNumeric"};


SEXP str = PROTECT(allocVector(STRSXP, 2));
int len = length(str);
for(int i =0; i < len; i ++){
  SET_STRING_ELT(str, i, mkChar(nm[i]));
}

SET_VECTOR_ELT(res, 0, y);
SET_VECTOR_ELT(res, 1, isNumeric);
setAttrib(res, install("names"), str);

printf("isNewList(res) = %d\\n", isNewList(res));
printf("isString(str) = %d\\n", isString(str));
printf("isNewList(str) = %d\\n", isNewList(str));

UNPROTECT(4);
return res;
')


