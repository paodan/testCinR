#include <R.h>
#include <Rinternals.h>

SEXP showArgs(SEXP args)
{
  args = CDR(args); /* skip ‘name’ */
  for(int i = 0; args != R_NilValue; i++, args = CDR(args)) {
    const char *name =
      isNull(TAG(args)) ? "" : CHAR(PRINTNAME(TAG(args)));
    SEXP el = CAR(args);
    if (length(el) == 0) {
      Rprintf("[%d] ‘%s’ R type, length 0\n", i+1, name);
      continue;
    }
    switch(TYPEOF(el)) {
    case REALSXP:
      Rprintf("[%d] ‘%s’ %f\n", i+1, name, REAL(el)[0]);
      break;
    case LGLSXP:
    case INTSXP:
      Rprintf("[%d] ‘%s’ %d\n", i+1, name, INTEGER(el)[0]);
      break;
    case CPLXSXP:
    {
      Rcomplex cpl = COMPLEX(el)[0];
      Rprintf("[%d] ‘%s’ %f + %fi\n", i+1, name, cpl.r, cpl.i);
    }
      break;
    case STRSXP:
      Rprintf("[%d] ‘%s’ %s\n", i+1, name,
              CHAR(STRING_ELT(el, 0)));
      break;
    default:
      Rprintf("[%d] ‘%s’ R type\n", i+1, name);
    }
  }
  return R_NilValue;
}



SEXP C_testCAR_CDR(SEXP args)
{
  SEXP args0 = args; /* skip ‘name’ */
  args = CDR(args); /* skip ‘name’ */
  int na, nb, nab;
  double *xa, *xb, *xab;
  SEXP a, b, ab;

  a = PROTECT(coerceVector(CAR(args), REALSXP));
  b = PROTECT(coerceVector(CAR(CDR(args)), REALSXP));

  na = length(a); nb = length(b); nab = na + nb - 1;

  ab = PROTECT(allocVector(REALSXP, nab));

  xa = REAL(a); xb = REAL(b); xab = REAL(ab);
  for(int i = 0; i < nab; i++) xab[i] = 0.0;
  for(int i = 0; i < na; i++)
    for(int j = 0; j < nb; j++) xab[i + j] += xa[i] * xb[j];
  UNPROTECT(3);
  showArgs(args0);
  printf("\n%f\n", asReal(ab));
  // printf("\n%c\n", *CHAR(STRING_ELT(TAG(args0), 0)));
  printf("---------- END----------\n");
  return ab;
}


SEXP C_testCAR_CDR_Call(SEXP a, SEXP b)
{
  int na, nb, nab;
  double *xa, *xb, *xab;
  SEXP ab;

  a = PROTECT(coerceVector(a, REALSXP));
  b = PROTECT(coerceVector(b, REALSXP));
  na = length(a); nb = length(b); nab = na + nb - 1;
  ab = PROTECT(allocVector(REALSXP, nab));
  xa = REAL(a); xb = REAL(b); xab = REAL(ab);
  for(int i = 0; i < nab; i++) xab[i] = 0.0;
  for(int i = 0; i < na; i++)
    for(int j = 0; j < nb; j++) xab[i + j] += xa[i] * xb[j];
  UNPROTECT(3);
  printf("%f, %f, %f\n", *xa, *xb, *xab);
  return ab;
}

