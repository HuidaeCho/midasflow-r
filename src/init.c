#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

extern SEXP call_mefa(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP call_meshed(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP,
                        SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP call_melfp(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP,
                       SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"call_mefa", (DL_FUNC) & call_mefa, 7},
    {"call_meshed", (DL_FUNC) & call_meshed, 14},
    {"call_melfp", (DL_FUNC) & call_meshed, 17},
    {NULL, NULL, 0}
};

void R_init_midasflow(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
