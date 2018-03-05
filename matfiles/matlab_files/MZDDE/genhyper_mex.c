/*
 * MATLAB Compiler: 3.0
 * Date: Sun Jul 10 15:25:31 2005
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "genHyper.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "libmatlb.h"
#include "genhyper.h"
#include "deal.h"
#include "log10.h"

extern _mex_information _mex_info;

mxArray * eps = NULL;

mxArray * half = NULL;

mxArray * nout = NULL;

mxArray * one = NULL;

mxArray * ten = NULL;

mxArray * two = NULL;

mxArray * zero = NULL;

static mexGlobalTableEntry global_table[7]
  = { { "eps", &eps }, { "half", &half }, { "nout", &nout }, { "one", &one },
      { "ten", &ten }, { "two", &two }, { "zero", &zero } };

static mexFunctionTableEntry function_table[1]
  = { { "genhyper", mlxGenhyper, 6, 1, &_local_function_table_genhyper } };

static _mexInitTermTableEntry init_term_table[1]
  = { { InitializeModule_genhyper, TerminateModule_genhyper } };

/*
 * The function "Mlog10" is the MATLAB callback version of the "log10" function
 * from file "c:\matlab6p5\toolbox\matlab\elfun\log10.m". It performs a
 * callback to MATLAB to run the "log10" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * Mlog10(int nargout_, mxArray * x) {
    mxArray * y = NULL;
    mclFevalCallMATLAB(mclNVarargout(nargout_, 0, &y, NULL), "log10", x, NULL);
    return y;
}

/*
 * The function "Mdeal" is the MATLAB callback version of the "deal" function
 * from file "c:\matlab6p5\toolbox\matlab\datatypes\deal.m". It performs a
 * callback to MATLAB to run the "deal" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * Mdeal(int nargout_, mxArray * varargin) {
    mxArray * varargout = NULL;
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 1, &varargout, NULL),
      "deal",
      mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL);
    return varargout;
}

/*
 * The function "mexLibrary" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxGenhyper". Finally, it clears the feval table and exits.
 */
mex_information mexLibrary(void) {
    mclMexLibraryInit();
    return &_mex_info;
}

_mex_information _mex_info
  = { 1, 1, function_table, 7, global_table, 0, NULL, 1, init_term_table };

/*
 * The function "mlfLog10" contains the normal interface for the "log10"
 * M-function from file "c:\matlab6p5\toolbox\matlab\elfun\log10.m" (lines
 * 0-0). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfLog10(mxArray * x) {
    int nargout = 1;
    mxArray * y = NULL;
    mlfEnterNewContext(0, 1, x);
    y = Mlog10(nargout, x);
    mlfRestorePreviousContext(0, 1, x);
    return mlfReturnValue(y);
}

/*
 * The function "mlxLog10" contains the feval interface for the "log10"
 * M-function from file "c:\matlab6p5\toolbox\matlab\elfun\log10.m" (lines
 * 0-0). The feval function calls the implementation version of log10 through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
void mlxLog10(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: log10 Line: 1 Column: 1 The function \"log10"
            "\" was called with more than the declared number of outputs (1)."),
          NULL);
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: log10 Line: 1 Column: 1 The function \"log10"
            "\" was called with more than the declared number of inputs (1)."),
          NULL);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    mplhs[0] = Mlog10(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfNDeal" contains the nargout interface for the "deal"
 * M-function from file "c:\matlab6p5\toolbox\matlab\datatypes\deal.m" (lines
 * 0-0). This interface is only produced if the M-function uses the special
 * variable "nargout". The nargout interface allows the number of requested
 * outputs to be specified via the nargout argument, as opposed to the normal
 * interface which dynamically calculates the number of outputs based on the
 * number of non-NULL inputs it receives. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
mxArray * mlfNDeal(int nargout, mlfVarargoutList * varargout, ...) {
    mxArray * varargin = NULL;
    mlfVarargin(&varargin, varargout, 0);
    mlfEnterNewContext(0, -1, varargin);
    nargout += mclNargout(varargout);
    *mlfGetVarargoutCellPtr(varargout) = Mdeal(nargout, varargin);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(varargin);
    return mlfAssignOutputs(varargout);
}

/*
 * The function "mlfDeal" contains the normal interface for the "deal"
 * M-function from file "c:\matlab6p5\toolbox\matlab\datatypes\deal.m" (lines
 * 0-0). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfDeal(mlfVarargoutList * varargout, ...) {
    mxArray * varargin = NULL;
    int nargout = 0;
    mlfVarargin(&varargin, varargout, 0);
    mlfEnterNewContext(0, -1, varargin);
    nargout += mclNargout(varargout);
    *mlfGetVarargoutCellPtr(varargout) = Mdeal(nargout, varargin);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(varargin);
    return mlfAssignOutputs(varargout);
}

/*
 * The function "mlfVDeal" contains the void interface for the "deal"
 * M-function from file "c:\matlab6p5\toolbox\matlab\datatypes\deal.m" (lines
 * 0-0). The void interface is only produced if the M-function uses the special
 * variable "nargout", and has at least one output. The void interface function
 * specifies zero output arguments to the implementation version of the
 * function, and in the event that the implementation version still returns an
 * output (which, in MATLAB, would be assigned to the "ans" variable), it
 * deallocates the output. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlfVDeal(mxArray * synthetic_varargin_argument, ...) {
    mxArray * varargin = NULL;
    mxArray * varargout = NULL;
    mlfVarargin(&varargin, synthetic_varargin_argument, 1);
    mlfEnterNewContext(0, -1, varargin);
    varargout = Mdeal(0, synthetic_varargin_argument);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(varargin);
}

/*
 * The function "mlxDeal" contains the feval interface for the "deal"
 * M-function from file "c:\matlab6p5\toolbox\matlab\datatypes\deal.m" (lines
 * 0-0). The feval function calls the implementation version of deal through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
void mlxDeal(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    mlfEnterNewContext(0, 0);
    mprhs[0] = NULL;
    mlfAssign(&mprhs[0], mclCreateVararginCell(nrhs, prhs));
    mplhs[0] = Mdeal(nlhs, mprhs[0]);
    mclAssignVarargoutCell(0, nlhs, plhs, mplhs[0]);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(mprhs[0]);
}
