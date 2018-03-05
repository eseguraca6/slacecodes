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

#ifndef __log10_h
#define __log10_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_log10(void);
extern void TerminateModule_log10(void);
extern _mexLocalFunctionTable _local_function_table_log10;

extern mxArray * mlfLog10(mxArray * x);
extern void mlxLog10(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
