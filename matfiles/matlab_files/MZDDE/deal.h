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

#ifndef __deal_h
#define __deal_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_deal(void);
extern void TerminateModule_deal(void);
extern _mexLocalFunctionTable _local_function_table_deal;

extern mxArray * mlfNDeal(int nargout, mlfVarargoutList * varargout, ...);
extern mxArray * mlfDeal(mlfVarargoutList * varargout, ...);
extern void mlfVDeal(mxArray * synthetic_varargin_argument, ...);
extern void mlxDeal(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
