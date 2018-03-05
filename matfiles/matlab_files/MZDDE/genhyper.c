/*
 * MATLAB Compiler: 3.0
 * Date: Sun Jul 10 15:25:31 2005
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "genHyper.m" 
 */
#include "genhyper.h"
#include "mwservices.h"
#include "deal.h"
#include "libmatlbm.h"
#include "log10.h"

extern mxArray * eps;
extern mxArray * half;
extern mxArray * nout;
extern mxArray * one;
extern mxArray * ten;
extern mxArray * two;
extern mxArray * zero;
static mxArray * _mxarray0_;
static mxArray * _mxarray1_;
static mxArray * _mxarray2_;
static mxArray * _mxarray3_;
static mxArray * _mxarray4_;
static mxArray * _mxarray5_;
static mxArray * _mxarray6_;

static mxChar _array8_[42] = { ' ', 'e', 'r', 'r', 'o', 'r', ' ', 'i', 'n',
                               ' ', 'i', 'n', 'p', 'u', 't', ' ', 'a', 'r',
                               'g', 'u', 'm', 'e', 'n', 't', 's', ':', ' ',
                               'l', 'n', 'p', 'f', 'q', ' ', '~', '=', ' ',
                               '0', ' ', 'o', 'r', ' ', '1' };
static mxArray * _mxarray7_;

static mxChar _array10_[41] = { 's', 't', 'o', 'p', ' ', 'e', 'n', 'c', 'o',
                                'u', 'n', 't', 'e', 'r', 'e', 'd', ' ', 'i',
                                'n', ' ', 'o', 'r', 'i', 'g', 'i', 'n', 'a',
                                'l', ' ', 'f', 'o', 'r', 't', 'r', 'a', 'n',
                                ' ', 'c', 'o', 'd', 'e' };
static mxArray * _mxarray9_;
static mxArray * _mxarray11_;
static mxArray * _mxarray12_;
static mxArray * _mxarray13_;
static mxArray * _mxarray14_;
static mxArray * _mxarray15_;
static mxArray * _mxarray16_;

static mxChar _array18_[41] = { ' ', 'w', 'a', 'r', 'n', 'i', 'n', 'g', ' ',
                                '-', ' ', 'r', 'e', 'a', 'l', ' ', 'p', 'a',
                                'r', 't', ' ', 'o', 'f', ' ', 'z', ' ', 'w',
                                'a', 's', ' ', 's', 'e', 't', ' ', 't', 'o',
                                ' ', 'z', 'e', 'r', 'o' };
static mxArray * _mxarray17_;

static mxChar _array20_[41] = { ' ', 'w', 'a', 'r', 'n', 'i', 'n', 'g', ' ',
                                '-', ' ', 'i', 'm', 'a', 'g', ' ', 'p', 'a',
                                'r', 't', ' ', 'o', 'f', ' ', 'z', ' ', 'w',
                                'a', 's', ' ', 's', 'e', 't', ' ', 't', 'o',
                                ' ', 'z', 'e', 'r', 'o' };
static mxArray * _mxarray19_;
static mxArray * _mxarray21_;
static mxArray * _mxarray22_;
static mxArray * _mxarray23_;
static mxArray * _mxarray24_;
static mxArray * _mxarray25_;

static mxChar _array27_[48] = { ' ', 'e', 'r', 'r', 'o', 'r', ' ', 'i',
                                'n', ' ', 'i', 'p', 'r', 'e', 'm', 'a',
                                'x', '-', '-', 'd', 'i', 'd', ' ', 'n',
                                'o', 't', ' ', 'f', 'i', 'n', 'd', ' ',
                                'm', 'a', 'x', 'i', 'm', 'u', 'm', ' ',
                                'e', 'x', 'p', 'o', 'n', 'e', 'n', 't' };
static mxArray * _mxarray26_;
static mxArray * _mxarray28_;
static mxArray * _mxarray29_;
static mxArray * _mxarray30_;

static double _array32_[7] = { 1.0, -1.0, 1.0, -1.0, 5.0, -691.0, 7.0 };
static mxArray * _mxarray31_;

static double _array34_[7] = { 6.0, 30.0, 42.0, 30.0, 66.0, 2730.0, 6.0 };
static mxArray * _mxarray33_;
static mxArray * _mxarray35_;

void InitializeModule_genhyper(void) {
    _mxarray0_ = mclInitializeDouble(10.0);
    _mxarray1_ = mclInitializeDouble(0.0);
    _mxarray2_ = mclInitializeDouble(.5);
    _mxarray3_ = mclInitializeDouble(1.0);
    _mxarray4_ = mclInitializeDouble(2.0);
    _mxarray5_ = mclInitializeDouble(1e-10);
    _mxarray6_ = mclInitializeDouble(6.0);
    _mxarray7_ = mclInitializeString(42, _array8_);
    _mxarray9_ = mclInitializeString(41, _array10_);
    _mxarray11_ = mclInitializeDouble(.9);
    _mxarray12_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
    _mxarray13_ = mclInitializeDouble(3.0);
    _mxarray14_ = mclInitializeDouble(4.0);
    _mxarray15_ = mclInitializeDouble(5.0);
    _mxarray16_ = mclInitializeDouble(777.0);
    _mxarray17_ = mclInitializeString(41, _array18_);
    _mxarray19_ = mclInitializeString(41, _array20_);
    _mxarray21_ = mclInitializeDouble(-1.0);
    _mxarray22_ = mclInitializeDouble(320.0);
    _mxarray23_ = mclInitializeDouble(.1);
    _mxarray24_ = mclInitializeDouble(36.0);
    _mxarray25_ = mclInitializeDouble(-36.0);
    _mxarray26_ = mclInitializeString(48, _array27_);
    _mxarray28_ = mclInitializeDouble(12.0);
    _mxarray29_ = mclInitializeDouble(30.0);
    _mxarray30_ = mclInitializeDouble(7.0);
    _mxarray31_ = mclInitializeDoubleVector(1, 7, _array32_);
    _mxarray33_ = mclInitializeDoubleVector(1, 7, _array34_);
    _mxarray35_ = mclInitializeDouble(-2.0);
}

void TerminateModule_genhyper(void) {
    mxDestroyArray(_mxarray35_);
    mxDestroyArray(_mxarray33_);
    mxDestroyArray(_mxarray31_);
    mxDestroyArray(_mxarray30_);
    mxDestroyArray(_mxarray29_);
    mxDestroyArray(_mxarray28_);
    mxDestroyArray(_mxarray26_);
    mxDestroyArray(_mxarray25_);
    mxDestroyArray(_mxarray24_);
    mxDestroyArray(_mxarray23_);
    mxDestroyArray(_mxarray22_);
    mxDestroyArray(_mxarray21_);
    mxDestroyArray(_mxarray19_);
    mxDestroyArray(_mxarray17_);
    mxDestroyArray(_mxarray16_);
    mxDestroyArray(_mxarray15_);
    mxDestroyArray(_mxarray14_);
    mxDestroyArray(_mxarray13_);
    mxDestroyArray(_mxarray12_);
    mxDestroyArray(_mxarray11_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray7_);
    mxDestroyArray(_mxarray6_);
    mxDestroyArray(_mxarray5_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray3_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray1_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * mlfGenhyper_bits(void);
static void mlxGenhyper_bits(int nlhs,
                             mxArray * plhs[],
                             int nrhs,
                             mxArray * prhs[]);
static mxArray * mlfGenhyper_hyper(mxArray * a,
                                   mxArray * b,
                                   mxArray * ip,
                                   mxArray * iq,
                                   mxArray * z,
                                   mxArray * lnpfq,
                                   mxArray * ix,
                                   mxArray * nsigfig);
static void mlxGenhyper_hyper(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]);
static mxArray * mlfGenhyper_aradd(mxArray * * b,
                                   mxArray * * c,
                                   mxArray * * z,
                                   mxArray * * l,
                                   mxArray * * rmax,
                                   mxArray * a_in,
                                   mxArray * b_in,
                                   mxArray * c_in,
                                   mxArray * z_in,
                                   mxArray * l_in,
                                   mxArray * rmax_in);
static void mlxGenhyper_aradd(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]);
static mxArray * mlfGenhyper_arsub(mxArray * * b,
                                   mxArray * * c,
                                   mxArray * * wk1,
                                   mxArray * * wk2,
                                   mxArray * * l,
                                   mxArray * * rmax,
                                   mxArray * a_in,
                                   mxArray * b_in,
                                   mxArray * c_in,
                                   mxArray * wk1_in,
                                   mxArray * wk2_in,
                                   mxArray * l_in,
                                   mxArray * rmax_in);
static void mlxGenhyper_arsub(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]);
static mxArray * mlfGenhyper_armult(mxArray * * b,
                                    mxArray * * c,
                                    mxArray * * z,
                                    mxArray * * l,
                                    mxArray * * rmax,
                                    mxArray * a_in,
                                    mxArray * b_in,
                                    mxArray * c_in,
                                    mxArray * z_in,
                                    mxArray * l_in,
                                    mxArray * rmax_in);
static void mlxGenhyper_armult(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_cmpadd(mxArray * * ai,
                                    mxArray * * br,
                                    mxArray * * bi,
                                    mxArray * * cr,
                                    mxArray * * ci,
                                    mxArray * * wk1,
                                    mxArray * * l,
                                    mxArray * * rmax,
                                    mxArray * ar_in,
                                    mxArray * ai_in,
                                    mxArray * br_in,
                                    mxArray * bi_in,
                                    mxArray * cr_in,
                                    mxArray * ci_in,
                                    mxArray * wk1_in,
                                    mxArray * l_in,
                                    mxArray * rmax_in);
static void mlxGenhyper_cmpadd(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_cmpsub(mxArray * * ai,
                                    mxArray * * br,
                                    mxArray * * bi,
                                    mxArray * * cr,
                                    mxArray * * ci,
                                    mxArray * * wk1,
                                    mxArray * * wk2,
                                    mxArray * * l,
                                    mxArray * * rmax,
                                    mxArray * ar_in,
                                    mxArray * ai_in,
                                    mxArray * br_in,
                                    mxArray * bi_in,
                                    mxArray * cr_in,
                                    mxArray * ci_in,
                                    mxArray * wk1_in,
                                    mxArray * wk2_in,
                                    mxArray * l_in,
                                    mxArray * rmax_in);
static void mlxGenhyper_cmpsub(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_cmpmul(mxArray * * ai,
                                    mxArray * * br,
                                    mxArray * * bi,
                                    mxArray * * cr,
                                    mxArray * * ci,
                                    mxArray * * wk1,
                                    mxArray * * wk2,
                                    mxArray * * cr2,
                                    mxArray * * d1,
                                    mxArray * * d2,
                                    mxArray * * wk6,
                                    mxArray * * l,
                                    mxArray * * rmax,
                                    mxArray * ar_in,
                                    mxArray * ai_in,
                                    mxArray * br_in,
                                    mxArray * bi_in,
                                    mxArray * cr_in,
                                    mxArray * ci_in,
                                    mxArray * wk1_in,
                                    mxArray * wk2_in,
                                    mxArray * cr2_in,
                                    mxArray * d1_in,
                                    mxArray * d2_in,
                                    mxArray * wk6_in,
                                    mxArray * l_in,
                                    mxArray * rmax_in);
static void mlxGenhyper_cmpmul(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_arydiv(mxArray * * ai,
                                    mxArray * * br,
                                    mxArray * * bi,
                                    mxArray * * c,
                                    mxArray * * l,
                                    mxArray * * lnpfq,
                                    mxArray * * rmax,
                                    mxArray * * ibit,
                                    mxArray * ar_in,
                                    mxArray * ai_in,
                                    mxArray * br_in,
                                    mxArray * bi_in,
                                    mxArray * c_in,
                                    mxArray * l_in,
                                    mxArray * lnpfq_in,
                                    mxArray * rmax_in,
                                    mxArray * ibit_in);
static void mlxGenhyper_arydiv(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_emult(mxArray * * e1,
                                   mxArray * * n2,
                                   mxArray * * e2,
                                   mxArray * * nf,
                                   mxArray * * ef,
                                   mxArray * n1_in,
                                   mxArray * e1_in,
                                   mxArray * n2_in,
                                   mxArray * e2_in,
                                   mxArray * nf_in,
                                   mxArray * ef_in);
static void mlxGenhyper_emult(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]);
static mxArray * mlfGenhyper_ediv(mxArray * * e1,
                                  mxArray * * n2,
                                  mxArray * * e2,
                                  mxArray * * nf,
                                  mxArray * * ef,
                                  mxArray * n1_in,
                                  mxArray * e1_in,
                                  mxArray * n2_in,
                                  mxArray * e2_in,
                                  mxArray * nf_in,
                                  mxArray * ef_in);
static void mlxGenhyper_ediv(int nlhs,
                             mxArray * plhs[],
                             int nrhs,
                             mxArray * prhs[]);
static mxArray * mlfGenhyper_eadd(mxArray * * e1,
                                  mxArray * * n2,
                                  mxArray * * e2,
                                  mxArray * * nf,
                                  mxArray * * ef,
                                  mxArray * n1_in,
                                  mxArray * e1_in,
                                  mxArray * n2_in,
                                  mxArray * e2_in,
                                  mxArray * nf_in,
                                  mxArray * ef_in);
static void mlxGenhyper_eadd(int nlhs,
                             mxArray * plhs[],
                             int nrhs,
                             mxArray * prhs[]);
static mxArray * mlfGenhyper_esub(mxArray * * e1,
                                  mxArray * * n2,
                                  mxArray * * e2,
                                  mxArray * * nf,
                                  mxArray * * ef,
                                  mxArray * n1_in,
                                  mxArray * e1_in,
                                  mxArray * n2_in,
                                  mxArray * e2_in,
                                  mxArray * nf_in,
                                  mxArray * ef_in);
static void mlxGenhyper_esub(int nlhs,
                             mxArray * plhs[],
                             int nrhs,
                             mxArray * prhs[]);
static mxArray * mlfGenhyper_conv12(mxArray * * cae,
                                    mxArray * cn_in,
                                    mxArray * cae_in);
static void mlxGenhyper_conv12(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_conv21(mxArray * * cn,
                                    mxArray * cae_in,
                                    mxArray * cn_in);
static void mlxGenhyper_conv21(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_ecpmul(mxArray * * b,
                                    mxArray * * c,
                                    mxArray * a_in,
                                    mxArray * b_in,
                                    mxArray * c_in);
static void mlxGenhyper_ecpmul(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_ecpdiv(mxArray * * b,
                                    mxArray * * c,
                                    mxArray * a_in,
                                    mxArray * b_in,
                                    mxArray * c_in);
static void mlxGenhyper_ecpdiv(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_ipremax(mxArray * a,
                                     mxArray * b,
                                     mxArray * ip,
                                     mxArray * iq,
                                     mxArray * z);
static void mlxGenhyper_ipremax(int nlhs,
                                mxArray * plhs[],
                                int nrhs,
                                mxArray * prhs[]);
static mxArray * mlfGenhyper_factor(mxArray * z);
static void mlxGenhyper_factor(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * mlfGenhyper_cgamma(mxArray * arg, mxArray * lnpfq);
static void mlxGenhyper_cgamma(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * Mgenhyper(int nargout_,
                           mxArray * a,
                           mxArray * b,
                           mxArray * z,
                           mxArray * lnpfq,
                           mxArray * ix,
                           mxArray * nsigfig);
static mxArray * Mgenhyper_bits(int nargout_);
static mxArray * Mgenhyper_hyper(int nargout_,
                                 mxArray * a,
                                 mxArray * b,
                                 mxArray * ip,
                                 mxArray * iq,
                                 mxArray * z,
                                 mxArray * lnpfq,
                                 mxArray * ix,
                                 mxArray * nsigfig);
static mxArray * Mgenhyper_aradd(mxArray * * b,
                                 mxArray * * c,
                                 mxArray * * z,
                                 mxArray * * l,
                                 mxArray * * rmax,
                                 int nargout_,
                                 mxArray * a_in,
                                 mxArray * b_in,
                                 mxArray * c_in,
                                 mxArray * z_in,
                                 mxArray * l_in,
                                 mxArray * rmax_in);
static mxArray * Mgenhyper_arsub(mxArray * * b,
                                 mxArray * * c,
                                 mxArray * * wk1,
                                 mxArray * * wk2,
                                 mxArray * * l,
                                 mxArray * * rmax,
                                 int nargout_,
                                 mxArray * a_in,
                                 mxArray * b_in,
                                 mxArray * c_in,
                                 mxArray * wk1_in,
                                 mxArray * wk2_in,
                                 mxArray * l_in,
                                 mxArray * rmax_in);
static mxArray * Mgenhyper_armult(mxArray * * b,
                                  mxArray * * c,
                                  mxArray * * z,
                                  mxArray * * l,
                                  mxArray * * rmax,
                                  int nargout_,
                                  mxArray * a_in,
                                  mxArray * b_in,
                                  mxArray * c_in,
                                  mxArray * z_in,
                                  mxArray * l_in,
                                  mxArray * rmax_in);
static mxArray * Mgenhyper_cmpadd(mxArray * * ai,
                                  mxArray * * br,
                                  mxArray * * bi,
                                  mxArray * * cr,
                                  mxArray * * ci,
                                  mxArray * * wk1,
                                  mxArray * * l,
                                  mxArray * * rmax,
                                  int nargout_,
                                  mxArray * ar_in,
                                  mxArray * ai_in,
                                  mxArray * br_in,
                                  mxArray * bi_in,
                                  mxArray * cr_in,
                                  mxArray * ci_in,
                                  mxArray * wk1_in,
                                  mxArray * l_in,
                                  mxArray * rmax_in);
static mxArray * Mgenhyper_cmpsub(mxArray * * ai,
                                  mxArray * * br,
                                  mxArray * * bi,
                                  mxArray * * cr,
                                  mxArray * * ci,
                                  mxArray * * wk1,
                                  mxArray * * wk2,
                                  mxArray * * l,
                                  mxArray * * rmax,
                                  int nargout_,
                                  mxArray * ar_in,
                                  mxArray * ai_in,
                                  mxArray * br_in,
                                  mxArray * bi_in,
                                  mxArray * cr_in,
                                  mxArray * ci_in,
                                  mxArray * wk1_in,
                                  mxArray * wk2_in,
                                  mxArray * l_in,
                                  mxArray * rmax_in);
static mxArray * Mgenhyper_cmpmul(mxArray * * ai,
                                  mxArray * * br,
                                  mxArray * * bi,
                                  mxArray * * cr,
                                  mxArray * * ci,
                                  mxArray * * wk1,
                                  mxArray * * wk2,
                                  mxArray * * cr2,
                                  mxArray * * d1,
                                  mxArray * * d2,
                                  mxArray * * wk6,
                                  mxArray * * l,
                                  mxArray * * rmax,
                                  int nargout_,
                                  mxArray * ar_in,
                                  mxArray * ai_in,
                                  mxArray * br_in,
                                  mxArray * bi_in,
                                  mxArray * cr_in,
                                  mxArray * ci_in,
                                  mxArray * wk1_in,
                                  mxArray * wk2_in,
                                  mxArray * cr2_in,
                                  mxArray * d1_in,
                                  mxArray * d2_in,
                                  mxArray * wk6_in,
                                  mxArray * l_in,
                                  mxArray * rmax_in);
static mxArray * Mgenhyper_arydiv(mxArray * * ai,
                                  mxArray * * br,
                                  mxArray * * bi,
                                  mxArray * * c,
                                  mxArray * * l,
                                  mxArray * * lnpfq,
                                  mxArray * * rmax,
                                  mxArray * * ibit,
                                  int nargout_,
                                  mxArray * ar_in,
                                  mxArray * ai_in,
                                  mxArray * br_in,
                                  mxArray * bi_in,
                                  mxArray * c_in,
                                  mxArray * l_in,
                                  mxArray * lnpfq_in,
                                  mxArray * rmax_in,
                                  mxArray * ibit_in);
static mxArray * Mgenhyper_emult(mxArray * * e1,
                                 mxArray * * n2,
                                 mxArray * * e2,
                                 mxArray * * nf,
                                 mxArray * * ef,
                                 int nargout_,
                                 mxArray * n1_in,
                                 mxArray * e1_in,
                                 mxArray * n2_in,
                                 mxArray * e2_in,
                                 mxArray * nf_in,
                                 mxArray * ef_in);
static mxArray * Mgenhyper_ediv(mxArray * * e1,
                                mxArray * * n2,
                                mxArray * * e2,
                                mxArray * * nf,
                                mxArray * * ef,
                                int nargout_,
                                mxArray * n1_in,
                                mxArray * e1_in,
                                mxArray * n2_in,
                                mxArray * e2_in,
                                mxArray * nf_in,
                                mxArray * ef_in);
static mxArray * Mgenhyper_eadd(mxArray * * e1,
                                mxArray * * n2,
                                mxArray * * e2,
                                mxArray * * nf,
                                mxArray * * ef,
                                int nargout_,
                                mxArray * n1_in,
                                mxArray * e1_in,
                                mxArray * n2_in,
                                mxArray * e2_in,
                                mxArray * nf_in,
                                mxArray * ef_in);
static mxArray * Mgenhyper_esub(mxArray * * e1,
                                mxArray * * n2,
                                mxArray * * e2,
                                mxArray * * nf,
                                mxArray * * ef,
                                int nargout_,
                                mxArray * n1_in,
                                mxArray * e1_in,
                                mxArray * n2_in,
                                mxArray * e2_in,
                                mxArray * nf_in,
                                mxArray * ef_in);
static mxArray * Mgenhyper_conv12(mxArray * * cae,
                                  int nargout_,
                                  mxArray * cn_in,
                                  mxArray * cae_in);
static mxArray * Mgenhyper_conv21(mxArray * * cn,
                                  int nargout_,
                                  mxArray * cae_in,
                                  mxArray * cn_in);
static mxArray * Mgenhyper_ecpmul(mxArray * * b,
                                  mxArray * * c,
                                  int nargout_,
                                  mxArray * a_in,
                                  mxArray * b_in,
                                  mxArray * c_in);
static mxArray * Mgenhyper_ecpdiv(mxArray * * b,
                                  mxArray * * c,
                                  int nargout_,
                                  mxArray * a_in,
                                  mxArray * b_in,
                                  mxArray * c_in);
static mxArray * Mgenhyper_ipremax(int nargout_,
                                   mxArray * a,
                                   mxArray * b,
                                   mxArray * ip,
                                   mxArray * iq,
                                   mxArray * z);
static mxArray * Mgenhyper_factor(int nargout_, mxArray * z);
static mxArray * Mgenhyper_cgamma(int nargout_, mxArray * arg, mxArray * lnpfq);

static mexFunctionTableEntry local_function_table_[20]
  = { { "bits", mlxGenhyper_bits, 0, 1, NULL },
      { "hyper", mlxGenhyper_hyper, 8, 1, NULL },
      { "aradd", mlxGenhyper_aradd, 6, 6, NULL },
      { "arsub", mlxGenhyper_arsub, 7, 7, NULL },
      { "armult", mlxGenhyper_armult, 6, 6, NULL },
      { "cmpadd", mlxGenhyper_cmpadd, 9, 9, NULL },
      { "cmpsub", mlxGenhyper_cmpsub, 10, 10, NULL },
      { "cmpmul", mlxGenhyper_cmpmul, 14, 14, NULL },
      { "arydiv", mlxGenhyper_arydiv, 9, 9, NULL },
      { "emult", mlxGenhyper_emult, 6, 6, NULL },
      { "ediv", mlxGenhyper_ediv, 6, 6, NULL },
      { "eadd", mlxGenhyper_eadd, 6, 6, NULL },
      { "esub", mlxGenhyper_esub, 6, 6, NULL },
      { "conv12", mlxGenhyper_conv12, 2, 2, NULL },
      { "conv21", mlxGenhyper_conv21, 2, 2, NULL },
      { "ecpmul", mlxGenhyper_ecpmul, 3, 3, NULL },
      { "ecpdiv", mlxGenhyper_ecpdiv, 3, 3, NULL },
      { "ipremax", mlxGenhyper_ipremax, 5, 1, NULL },
      { "factor", mlxGenhyper_factor, 1, 1, NULL },
      { "cgamma", mlxGenhyper_cgamma, 2, 1, NULL } };

_mexLocalFunctionTable _local_function_table_genhyper
  = { 20, local_function_table_ };

/*
 * The function "mlfGenhyper" contains the normal interface for the "genhyper"
 * M-function from file "c:\projects\mzdde\genhyper.m" (lines 1-269). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfGenhyper(mxArray * a,
                      mxArray * b,
                      mxArray * z,
                      mxArray * lnpfq,
                      mxArray * ix,
                      mxArray * nsigfig) {
    int nargout = 1;
    mxArray * pfq = NULL;
    mlfEnterNewContext(0, 6, a, b, z, lnpfq, ix, nsigfig);
    pfq = Mgenhyper(nargout, a, b, z, lnpfq, ix, nsigfig);
    mlfRestorePreviousContext(0, 6, a, b, z, lnpfq, ix, nsigfig);
    return mlfReturnValue(pfq);
}

/*
 * The function "mlxGenhyper" contains the feval interface for the "genhyper"
 * M-function from file "c:\projects\mzdde\genhyper.m" (lines 1-269). The feval
 * function calls the implementation version of genhyper through this function.
 * This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxGenhyper(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper Line: 1 Column:"
            " 1 The function \"genhyper\" was called with m"
            "ore than the declared number of outputs (1)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper Line: 1 Column:"
            " 1 The function \"genhyper\" was called with m"
            "ore than the declared number of inputs (6)."),
          NULL);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mgenhyper(
          nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfGenhyper_bits" contains the normal interface for the
 * "genhyper/bits" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 269-300). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_bits(void) {
    int nargout = 1;
    mxArray * bits = NULL;
    mlfEnterNewContext(0, 0);
    bits = Mgenhyper_bits(nargout);
    mlfRestorePreviousContext(0, 0);
    return mlfReturnValue(bits);
}

/*
 * The function "mlxGenhyper_bits" contains the feval interface for the
 * "genhyper/bits" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 269-300). The feval function calls the implementation version of
 * genhyper/bits through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_bits(int nlhs,
                             mxArray * plhs[],
                             int nrhs,
                             mxArray * prhs[]) {
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/bits Line: 269 Colu"
            "mn: 1 The function \"genhyper/bits\" was called wi"
            "th more than the declared number of outputs (1)."),
          NULL);
    }
    if (nrhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/bits Line: 269 Colu"
            "mn: 1 The function \"genhyper/bits\" was called wi"
            "th more than the declared number of inputs (0)."),
          NULL);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    mlfEnterNewContext(0, 0);
    mplhs[0] = Mgenhyper_bits(nlhs);
    mlfRestorePreviousContext(0, 0);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfGenhyper_hyper" contains the normal interface for the
 * "genhyper/hyper" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 300-759). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_hyper(mxArray * a,
                                   mxArray * b,
                                   mxArray * ip,
                                   mxArray * iq,
                                   mxArray * z,
                                   mxArray * lnpfq,
                                   mxArray * ix,
                                   mxArray * nsigfig) {
    int nargout = 1;
    mxArray * hyper = NULL;
    mlfEnterNewContext(0, 8, a, b, ip, iq, z, lnpfq, ix, nsigfig);
    hyper = Mgenhyper_hyper(nargout, a, b, ip, iq, z, lnpfq, ix, nsigfig);
    mlfRestorePreviousContext(0, 8, a, b, ip, iq, z, lnpfq, ix, nsigfig);
    return mlfReturnValue(hyper);
}

/*
 * The function "mlxGenhyper_hyper" contains the feval interface for the
 * "genhyper/hyper" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 300-759). The feval function calls the implementation version of
 * genhyper/hyper through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_hyper(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]) {
    mxArray * mprhs[8];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/hyper Line: 300 Colu"
            "mn: 1 The function \"genhyper/hyper\" was called wi"
            "th more than the declared number of outputs (1)."),
          NULL);
    }
    if (nrhs > 8) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/hyper Line: 300 Colu"
            "mn: 1 The function \"genhyper/hyper\" was called wi"
            "th more than the declared number of inputs (8)."),
          NULL);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 8 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 8; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0,
      8,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7]);
    mplhs[0]
      = Mgenhyper_hyper(
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5],
          mprhs[6],
          mprhs[7]);
    mlfRestorePreviousContext(
      0,
      8,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfGenhyper_aradd" contains the normal interface for the
 * "genhyper/aradd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 759-1071). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_aradd(mxArray * * b,
                                   mxArray * * c,
                                   mxArray * * z,
                                   mxArray * * l,
                                   mxArray * * rmax,
                                   mxArray * a_in,
                                   mxArray * b_in,
                                   mxArray * c_in,
                                   mxArray * z_in,
                                   mxArray * l_in,
                                   mxArray * rmax_in) {
    int nargout = 1;
    mxArray * a = NULL;
    mxArray * b__ = NULL;
    mxArray * c__ = NULL;
    mxArray * z__ = NULL;
    mxArray * l__ = NULL;
    mxArray * rmax__ = NULL;
    mlfEnterNewContext(
      5, 6, b, c, z, l, rmax, a_in, b_in, c_in, z_in, l_in, rmax_in);
    if (b != NULL) {
        ++nargout;
    }
    if (c != NULL) {
        ++nargout;
    }
    if (z != NULL) {
        ++nargout;
    }
    if (l != NULL) {
        ++nargout;
    }
    if (rmax != NULL) {
        ++nargout;
    }
    a
      = Mgenhyper_aradd(
          &b__,
          &c__,
          &z__,
          &l__,
          &rmax__,
          nargout,
          a_in,
          b_in,
          c_in,
          z_in,
          l_in,
          rmax_in);
    mlfRestorePreviousContext(
      5, 6, b, c, z, l, rmax, a_in, b_in, c_in, z_in, l_in, rmax_in);
    if (b != NULL) {
        mclCopyOutputArg(b, b__);
    } else {
        mxDestroyArray(b__);
    }
    if (c != NULL) {
        mclCopyOutputArg(c, c__);
    } else {
        mxDestroyArray(c__);
    }
    if (z != NULL) {
        mclCopyOutputArg(z, z__);
    } else {
        mxDestroyArray(z__);
    }
    if (l != NULL) {
        mclCopyOutputArg(l, l__);
    } else {
        mxDestroyArray(l__);
    }
    if (rmax != NULL) {
        mclCopyOutputArg(rmax, rmax__);
    } else {
        mxDestroyArray(rmax__);
    }
    return mlfReturnValue(a);
}

/*
 * The function "mlxGenhyper_aradd" contains the feval interface for the
 * "genhyper/aradd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 759-1071). The feval function calls the implementation version of
 * genhyper/aradd through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_aradd(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[6];
    int i;
    if (nlhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/aradd Line: 759 Colu"
            "mn: 1 The function \"genhyper/aradd\" was called wi"
            "th more than the declared number of outputs (6)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/aradd Line: 759 Colu"
            "mn: 1 The function \"genhyper/aradd\" was called wi"
            "th more than the declared number of inputs (6)."),
          NULL);
    }
    for (i = 0; i < 6; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mgenhyper_aradd(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 6 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 6; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_arsub" contains the normal interface for the
 * "genhyper/arsub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1071-1104). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_arsub(mxArray * * b,
                                   mxArray * * c,
                                   mxArray * * wk1,
                                   mxArray * * wk2,
                                   mxArray * * l,
                                   mxArray * * rmax,
                                   mxArray * a_in,
                                   mxArray * b_in,
                                   mxArray * c_in,
                                   mxArray * wk1_in,
                                   mxArray * wk2_in,
                                   mxArray * l_in,
                                   mxArray * rmax_in) {
    int nargout = 1;
    mxArray * a = NULL;
    mxArray * b__ = NULL;
    mxArray * c__ = NULL;
    mxArray * wk1__ = NULL;
    mxArray * wk2__ = NULL;
    mxArray * l__ = NULL;
    mxArray * rmax__ = NULL;
    mlfEnterNewContext(
      6,
      7,
      b,
      c,
      wk1,
      wk2,
      l,
      rmax,
      a_in,
      b_in,
      c_in,
      wk1_in,
      wk2_in,
      l_in,
      rmax_in);
    if (b != NULL) {
        ++nargout;
    }
    if (c != NULL) {
        ++nargout;
    }
    if (wk1 != NULL) {
        ++nargout;
    }
    if (wk2 != NULL) {
        ++nargout;
    }
    if (l != NULL) {
        ++nargout;
    }
    if (rmax != NULL) {
        ++nargout;
    }
    a
      = Mgenhyper_arsub(
          &b__,
          &c__,
          &wk1__,
          &wk2__,
          &l__,
          &rmax__,
          nargout,
          a_in,
          b_in,
          c_in,
          wk1_in,
          wk2_in,
          l_in,
          rmax_in);
    mlfRestorePreviousContext(
      6,
      7,
      b,
      c,
      wk1,
      wk2,
      l,
      rmax,
      a_in,
      b_in,
      c_in,
      wk1_in,
      wk2_in,
      l_in,
      rmax_in);
    if (b != NULL) {
        mclCopyOutputArg(b, b__);
    } else {
        mxDestroyArray(b__);
    }
    if (c != NULL) {
        mclCopyOutputArg(c, c__);
    } else {
        mxDestroyArray(c__);
    }
    if (wk1 != NULL) {
        mclCopyOutputArg(wk1, wk1__);
    } else {
        mxDestroyArray(wk1__);
    }
    if (wk2 != NULL) {
        mclCopyOutputArg(wk2, wk2__);
    } else {
        mxDestroyArray(wk2__);
    }
    if (l != NULL) {
        mclCopyOutputArg(l, l__);
    } else {
        mxDestroyArray(l__);
    }
    if (rmax != NULL) {
        mclCopyOutputArg(rmax, rmax__);
    } else {
        mxDestroyArray(rmax__);
    }
    return mlfReturnValue(a);
}

/*
 * The function "mlxGenhyper_arsub" contains the feval interface for the
 * "genhyper/arsub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1071-1104). The feval function calls the implementation version of
 * genhyper/arsub through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_arsub(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]) {
    mxArray * mprhs[7];
    mxArray * mplhs[7];
    int i;
    if (nlhs > 7) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/arsub Line: 1071 Col"
            "umn: 1 The function \"genhyper/arsub\" was called w"
            "ith more than the declared number of outputs (7)."),
          NULL);
    }
    if (nrhs > 7) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/arsub Line: 1071 Col"
            "umn: 1 The function \"genhyper/arsub\" was called w"
            "ith more than the declared number of inputs (7)."),
          NULL);
    }
    for (i = 0; i < 7; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 7 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 7; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0,
      7,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6]);
    mplhs[0]
      = Mgenhyper_arsub(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          &mplhs[6],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5],
          mprhs[6]);
    mlfRestorePreviousContext(
      0,
      7,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 7 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 7; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_armult" contains the normal interface for the
 * "genhyper/armult" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1104-1175). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_armult(mxArray * * b,
                                    mxArray * * c,
                                    mxArray * * z,
                                    mxArray * * l,
                                    mxArray * * rmax,
                                    mxArray * a_in,
                                    mxArray * b_in,
                                    mxArray * c_in,
                                    mxArray * z_in,
                                    mxArray * l_in,
                                    mxArray * rmax_in) {
    int nargout = 1;
    mxArray * a = NULL;
    mxArray * b__ = NULL;
    mxArray * c__ = NULL;
    mxArray * z__ = NULL;
    mxArray * l__ = NULL;
    mxArray * rmax__ = NULL;
    mlfEnterNewContext(
      5, 6, b, c, z, l, rmax, a_in, b_in, c_in, z_in, l_in, rmax_in);
    if (b != NULL) {
        ++nargout;
    }
    if (c != NULL) {
        ++nargout;
    }
    if (z != NULL) {
        ++nargout;
    }
    if (l != NULL) {
        ++nargout;
    }
    if (rmax != NULL) {
        ++nargout;
    }
    a
      = Mgenhyper_armult(
          &b__,
          &c__,
          &z__,
          &l__,
          &rmax__,
          nargout,
          a_in,
          b_in,
          c_in,
          z_in,
          l_in,
          rmax_in);
    mlfRestorePreviousContext(
      5, 6, b, c, z, l, rmax, a_in, b_in, c_in, z_in, l_in, rmax_in);
    if (b != NULL) {
        mclCopyOutputArg(b, b__);
    } else {
        mxDestroyArray(b__);
    }
    if (c != NULL) {
        mclCopyOutputArg(c, c__);
    } else {
        mxDestroyArray(c__);
    }
    if (z != NULL) {
        mclCopyOutputArg(z, z__);
    } else {
        mxDestroyArray(z__);
    }
    if (l != NULL) {
        mclCopyOutputArg(l, l__);
    } else {
        mxDestroyArray(l__);
    }
    if (rmax != NULL) {
        mclCopyOutputArg(rmax, rmax__);
    } else {
        mxDestroyArray(rmax__);
    }
    return mlfReturnValue(a);
}

/*
 * The function "mlxGenhyper_armult" contains the feval interface for the
 * "genhyper/armult" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1104-1175). The feval function calls the implementation version of
 * genhyper/armult through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_armult(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[6];
    int i;
    if (nlhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/armult Line: 1104 Col"
            "umn: 1 The function \"genhyper/armult\" was called w"
            "ith more than the declared number of outputs (6)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/armult Line: 1104 Col"
            "umn: 1 The function \"genhyper/armult\" was called w"
            "ith more than the declared number of inputs (6)."),
          NULL);
    }
    for (i = 0; i < 6; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mgenhyper_armult(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 6 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 6; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_cmpadd" contains the normal interface for the
 * "genhyper/cmpadd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1175-1203). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_cmpadd(mxArray * * ai,
                                    mxArray * * br,
                                    mxArray * * bi,
                                    mxArray * * cr,
                                    mxArray * * ci,
                                    mxArray * * wk1,
                                    mxArray * * l,
                                    mxArray * * rmax,
                                    mxArray * ar_in,
                                    mxArray * ai_in,
                                    mxArray * br_in,
                                    mxArray * bi_in,
                                    mxArray * cr_in,
                                    mxArray * ci_in,
                                    mxArray * wk1_in,
                                    mxArray * l_in,
                                    mxArray * rmax_in) {
    int nargout = 1;
    mxArray * ar = NULL;
    mxArray * ai__ = NULL;
    mxArray * br__ = NULL;
    mxArray * bi__ = NULL;
    mxArray * cr__ = NULL;
    mxArray * ci__ = NULL;
    mxArray * wk1__ = NULL;
    mxArray * l__ = NULL;
    mxArray * rmax__ = NULL;
    mlfEnterNewContext(
      8,
      9,
      ai,
      br,
      bi,
      cr,
      ci,
      wk1,
      l,
      rmax,
      ar_in,
      ai_in,
      br_in,
      bi_in,
      cr_in,
      ci_in,
      wk1_in,
      l_in,
      rmax_in);
    if (ai != NULL) {
        ++nargout;
    }
    if (br != NULL) {
        ++nargout;
    }
    if (bi != NULL) {
        ++nargout;
    }
    if (cr != NULL) {
        ++nargout;
    }
    if (ci != NULL) {
        ++nargout;
    }
    if (wk1 != NULL) {
        ++nargout;
    }
    if (l != NULL) {
        ++nargout;
    }
    if (rmax != NULL) {
        ++nargout;
    }
    ar
      = Mgenhyper_cmpadd(
          &ai__,
          &br__,
          &bi__,
          &cr__,
          &ci__,
          &wk1__,
          &l__,
          &rmax__,
          nargout,
          ar_in,
          ai_in,
          br_in,
          bi_in,
          cr_in,
          ci_in,
          wk1_in,
          l_in,
          rmax_in);
    mlfRestorePreviousContext(
      8,
      9,
      ai,
      br,
      bi,
      cr,
      ci,
      wk1,
      l,
      rmax,
      ar_in,
      ai_in,
      br_in,
      bi_in,
      cr_in,
      ci_in,
      wk1_in,
      l_in,
      rmax_in);
    if (ai != NULL) {
        mclCopyOutputArg(ai, ai__);
    } else {
        mxDestroyArray(ai__);
    }
    if (br != NULL) {
        mclCopyOutputArg(br, br__);
    } else {
        mxDestroyArray(br__);
    }
    if (bi != NULL) {
        mclCopyOutputArg(bi, bi__);
    } else {
        mxDestroyArray(bi__);
    }
    if (cr != NULL) {
        mclCopyOutputArg(cr, cr__);
    } else {
        mxDestroyArray(cr__);
    }
    if (ci != NULL) {
        mclCopyOutputArg(ci, ci__);
    } else {
        mxDestroyArray(ci__);
    }
    if (wk1 != NULL) {
        mclCopyOutputArg(wk1, wk1__);
    } else {
        mxDestroyArray(wk1__);
    }
    if (l != NULL) {
        mclCopyOutputArg(l, l__);
    } else {
        mxDestroyArray(l__);
    }
    if (rmax != NULL) {
        mclCopyOutputArg(rmax, rmax__);
    } else {
        mxDestroyArray(rmax__);
    }
    return mlfReturnValue(ar);
}

/*
 * The function "mlxGenhyper_cmpadd" contains the feval interface for the
 * "genhyper/cmpadd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1175-1203). The feval function calls the implementation version of
 * genhyper/cmpadd through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_cmpadd(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[9];
    mxArray * mplhs[9];
    int i;
    if (nlhs > 9) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/cmpadd Line: 1175 Col"
            "umn: 1 The function \"genhyper/cmpadd\" was called w"
            "ith more than the declared number of outputs (9)."),
          NULL);
    }
    if (nrhs > 9) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/cmpadd Line: 1175 Col"
            "umn: 1 The function \"genhyper/cmpadd\" was called w"
            "ith more than the declared number of inputs (9)."),
          NULL);
    }
    for (i = 0; i < 9; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 9 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 9; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0,
      9,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7],
      mprhs[8]);
    mplhs[0]
      = Mgenhyper_cmpadd(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          &mplhs[6],
          &mplhs[7],
          &mplhs[8],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5],
          mprhs[6],
          mprhs[7],
          mprhs[8]);
    mlfRestorePreviousContext(
      0,
      9,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7],
      mprhs[8]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 9 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 9; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_cmpsub" contains the normal interface for the
 * "genhyper/cmpsub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1203-1230). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_cmpsub(mxArray * * ai,
                                    mxArray * * br,
                                    mxArray * * bi,
                                    mxArray * * cr,
                                    mxArray * * ci,
                                    mxArray * * wk1,
                                    mxArray * * wk2,
                                    mxArray * * l,
                                    mxArray * * rmax,
                                    mxArray * ar_in,
                                    mxArray * ai_in,
                                    mxArray * br_in,
                                    mxArray * bi_in,
                                    mxArray * cr_in,
                                    mxArray * ci_in,
                                    mxArray * wk1_in,
                                    mxArray * wk2_in,
                                    mxArray * l_in,
                                    mxArray * rmax_in) {
    int nargout = 1;
    mxArray * ar = NULL;
    mxArray * ai__ = NULL;
    mxArray * br__ = NULL;
    mxArray * bi__ = NULL;
    mxArray * cr__ = NULL;
    mxArray * ci__ = NULL;
    mxArray * wk1__ = NULL;
    mxArray * wk2__ = NULL;
    mxArray * l__ = NULL;
    mxArray * rmax__ = NULL;
    mlfEnterNewContext(
      9,
      10,
      ai,
      br,
      bi,
      cr,
      ci,
      wk1,
      wk2,
      l,
      rmax,
      ar_in,
      ai_in,
      br_in,
      bi_in,
      cr_in,
      ci_in,
      wk1_in,
      wk2_in,
      l_in,
      rmax_in);
    if (ai != NULL) {
        ++nargout;
    }
    if (br != NULL) {
        ++nargout;
    }
    if (bi != NULL) {
        ++nargout;
    }
    if (cr != NULL) {
        ++nargout;
    }
    if (ci != NULL) {
        ++nargout;
    }
    if (wk1 != NULL) {
        ++nargout;
    }
    if (wk2 != NULL) {
        ++nargout;
    }
    if (l != NULL) {
        ++nargout;
    }
    if (rmax != NULL) {
        ++nargout;
    }
    ar
      = Mgenhyper_cmpsub(
          &ai__,
          &br__,
          &bi__,
          &cr__,
          &ci__,
          &wk1__,
          &wk2__,
          &l__,
          &rmax__,
          nargout,
          ar_in,
          ai_in,
          br_in,
          bi_in,
          cr_in,
          ci_in,
          wk1_in,
          wk2_in,
          l_in,
          rmax_in);
    mlfRestorePreviousContext(
      9,
      10,
      ai,
      br,
      bi,
      cr,
      ci,
      wk1,
      wk2,
      l,
      rmax,
      ar_in,
      ai_in,
      br_in,
      bi_in,
      cr_in,
      ci_in,
      wk1_in,
      wk2_in,
      l_in,
      rmax_in);
    if (ai != NULL) {
        mclCopyOutputArg(ai, ai__);
    } else {
        mxDestroyArray(ai__);
    }
    if (br != NULL) {
        mclCopyOutputArg(br, br__);
    } else {
        mxDestroyArray(br__);
    }
    if (bi != NULL) {
        mclCopyOutputArg(bi, bi__);
    } else {
        mxDestroyArray(bi__);
    }
    if (cr != NULL) {
        mclCopyOutputArg(cr, cr__);
    } else {
        mxDestroyArray(cr__);
    }
    if (ci != NULL) {
        mclCopyOutputArg(ci, ci__);
    } else {
        mxDestroyArray(ci__);
    }
    if (wk1 != NULL) {
        mclCopyOutputArg(wk1, wk1__);
    } else {
        mxDestroyArray(wk1__);
    }
    if (wk2 != NULL) {
        mclCopyOutputArg(wk2, wk2__);
    } else {
        mxDestroyArray(wk2__);
    }
    if (l != NULL) {
        mclCopyOutputArg(l, l__);
    } else {
        mxDestroyArray(l__);
    }
    if (rmax != NULL) {
        mclCopyOutputArg(rmax, rmax__);
    } else {
        mxDestroyArray(rmax__);
    }
    return mlfReturnValue(ar);
}

/*
 * The function "mlxGenhyper_cmpsub" contains the feval interface for the
 * "genhyper/cmpsub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1203-1230). The feval function calls the implementation version of
 * genhyper/cmpsub through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_cmpsub(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[10];
    mxArray * mplhs[10];
    int i;
    if (nlhs > 10) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/cmpsub Line: 1203 Col"
            "umn: 1 The function \"genhyper/cmpsub\" was called w"
            "ith more than the declared number of outputs (10)."),
          NULL);
    }
    if (nrhs > 10) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/cmpsub Line: 1203 Col"
            "umn: 1 The function \"genhyper/cmpsub\" was called w"
            "ith more than the declared number of inputs (10)."),
          NULL);
    }
    for (i = 0; i < 10; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 10 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 10; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0,
      10,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7],
      mprhs[8],
      mprhs[9]);
    mplhs[0]
      = Mgenhyper_cmpsub(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          &mplhs[6],
          &mplhs[7],
          &mplhs[8],
          &mplhs[9],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5],
          mprhs[6],
          mprhs[7],
          mprhs[8],
          mprhs[9]);
    mlfRestorePreviousContext(
      0,
      10,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7],
      mprhs[8],
      mprhs[9]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 10 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 10; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_cmpmul" contains the normal interface for the
 * "genhyper/cmpmul" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1230-1266). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_cmpmul(mxArray * * ai,
                                    mxArray * * br,
                                    mxArray * * bi,
                                    mxArray * * cr,
                                    mxArray * * ci,
                                    mxArray * * wk1,
                                    mxArray * * wk2,
                                    mxArray * * cr2,
                                    mxArray * * d1,
                                    mxArray * * d2,
                                    mxArray * * wk6,
                                    mxArray * * l,
                                    mxArray * * rmax,
                                    mxArray * ar_in,
                                    mxArray * ai_in,
                                    mxArray * br_in,
                                    mxArray * bi_in,
                                    mxArray * cr_in,
                                    mxArray * ci_in,
                                    mxArray * wk1_in,
                                    mxArray * wk2_in,
                                    mxArray * cr2_in,
                                    mxArray * d1_in,
                                    mxArray * d2_in,
                                    mxArray * wk6_in,
                                    mxArray * l_in,
                                    mxArray * rmax_in) {
    int nargout = 1;
    mxArray * ar = NULL;
    mxArray * ai__ = NULL;
    mxArray * br__ = NULL;
    mxArray * bi__ = NULL;
    mxArray * cr__ = NULL;
    mxArray * ci__ = NULL;
    mxArray * wk1__ = NULL;
    mxArray * wk2__ = NULL;
    mxArray * cr2__ = NULL;
    mxArray * d1__ = NULL;
    mxArray * d2__ = NULL;
    mxArray * wk6__ = NULL;
    mxArray * l__ = NULL;
    mxArray * rmax__ = NULL;
    mlfEnterNewContext(
      13,
      14,
      ai,
      br,
      bi,
      cr,
      ci,
      wk1,
      wk2,
      cr2,
      d1,
      d2,
      wk6,
      l,
      rmax,
      ar_in,
      ai_in,
      br_in,
      bi_in,
      cr_in,
      ci_in,
      wk1_in,
      wk2_in,
      cr2_in,
      d1_in,
      d2_in,
      wk6_in,
      l_in,
      rmax_in);
    if (ai != NULL) {
        ++nargout;
    }
    if (br != NULL) {
        ++nargout;
    }
    if (bi != NULL) {
        ++nargout;
    }
    if (cr != NULL) {
        ++nargout;
    }
    if (ci != NULL) {
        ++nargout;
    }
    if (wk1 != NULL) {
        ++nargout;
    }
    if (wk2 != NULL) {
        ++nargout;
    }
    if (cr2 != NULL) {
        ++nargout;
    }
    if (d1 != NULL) {
        ++nargout;
    }
    if (d2 != NULL) {
        ++nargout;
    }
    if (wk6 != NULL) {
        ++nargout;
    }
    if (l != NULL) {
        ++nargout;
    }
    if (rmax != NULL) {
        ++nargout;
    }
    ar
      = Mgenhyper_cmpmul(
          &ai__,
          &br__,
          &bi__,
          &cr__,
          &ci__,
          &wk1__,
          &wk2__,
          &cr2__,
          &d1__,
          &d2__,
          &wk6__,
          &l__,
          &rmax__,
          nargout,
          ar_in,
          ai_in,
          br_in,
          bi_in,
          cr_in,
          ci_in,
          wk1_in,
          wk2_in,
          cr2_in,
          d1_in,
          d2_in,
          wk6_in,
          l_in,
          rmax_in);
    mlfRestorePreviousContext(
      13,
      14,
      ai,
      br,
      bi,
      cr,
      ci,
      wk1,
      wk2,
      cr2,
      d1,
      d2,
      wk6,
      l,
      rmax,
      ar_in,
      ai_in,
      br_in,
      bi_in,
      cr_in,
      ci_in,
      wk1_in,
      wk2_in,
      cr2_in,
      d1_in,
      d2_in,
      wk6_in,
      l_in,
      rmax_in);
    if (ai != NULL) {
        mclCopyOutputArg(ai, ai__);
    } else {
        mxDestroyArray(ai__);
    }
    if (br != NULL) {
        mclCopyOutputArg(br, br__);
    } else {
        mxDestroyArray(br__);
    }
    if (bi != NULL) {
        mclCopyOutputArg(bi, bi__);
    } else {
        mxDestroyArray(bi__);
    }
    if (cr != NULL) {
        mclCopyOutputArg(cr, cr__);
    } else {
        mxDestroyArray(cr__);
    }
    if (ci != NULL) {
        mclCopyOutputArg(ci, ci__);
    } else {
        mxDestroyArray(ci__);
    }
    if (wk1 != NULL) {
        mclCopyOutputArg(wk1, wk1__);
    } else {
        mxDestroyArray(wk1__);
    }
    if (wk2 != NULL) {
        mclCopyOutputArg(wk2, wk2__);
    } else {
        mxDestroyArray(wk2__);
    }
    if (cr2 != NULL) {
        mclCopyOutputArg(cr2, cr2__);
    } else {
        mxDestroyArray(cr2__);
    }
    if (d1 != NULL) {
        mclCopyOutputArg(d1, d1__);
    } else {
        mxDestroyArray(d1__);
    }
    if (d2 != NULL) {
        mclCopyOutputArg(d2, d2__);
    } else {
        mxDestroyArray(d2__);
    }
    if (wk6 != NULL) {
        mclCopyOutputArg(wk6, wk6__);
    } else {
        mxDestroyArray(wk6__);
    }
    if (l != NULL) {
        mclCopyOutputArg(l, l__);
    } else {
        mxDestroyArray(l__);
    }
    if (rmax != NULL) {
        mclCopyOutputArg(rmax, rmax__);
    } else {
        mxDestroyArray(rmax__);
    }
    return mlfReturnValue(ar);
}

/*
 * The function "mlxGenhyper_cmpmul" contains the feval interface for the
 * "genhyper/cmpmul" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1230-1266). The feval function calls the implementation version of
 * genhyper/cmpmul through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_cmpmul(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[14];
    mxArray * mplhs[14];
    int i;
    if (nlhs > 14) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/cmpmul Line: 1230 Col"
            "umn: 1 The function \"genhyper/cmpmul\" was called w"
            "ith more than the declared number of outputs (14)."),
          NULL);
    }
    if (nrhs > 14) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/cmpmul Line: 1230 Col"
            "umn: 1 The function \"genhyper/cmpmul\" was called w"
            "ith more than the declared number of inputs (14)."),
          NULL);
    }
    for (i = 0; i < 14; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 14 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 14; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0,
      14,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7],
      mprhs[8],
      mprhs[9],
      mprhs[10],
      mprhs[11],
      mprhs[12],
      mprhs[13]);
    mplhs[0]
      = Mgenhyper_cmpmul(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          &mplhs[6],
          &mplhs[7],
          &mplhs[8],
          &mplhs[9],
          &mplhs[10],
          &mplhs[11],
          &mplhs[12],
          &mplhs[13],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5],
          mprhs[6],
          mprhs[7],
          mprhs[8],
          mprhs[9],
          mprhs[10],
          mprhs[11],
          mprhs[12],
          mprhs[13]);
    mlfRestorePreviousContext(
      0,
      14,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7],
      mprhs[8],
      mprhs[9],
      mprhs[10],
      mprhs[11],
      mprhs[12],
      mprhs[13]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 14 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 14; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_arydiv" contains the normal interface for the
 * "genhyper/arydiv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1266-1380). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_arydiv(mxArray * * ai,
                                    mxArray * * br,
                                    mxArray * * bi,
                                    mxArray * * c,
                                    mxArray * * l,
                                    mxArray * * lnpfq,
                                    mxArray * * rmax,
                                    mxArray * * ibit,
                                    mxArray * ar_in,
                                    mxArray * ai_in,
                                    mxArray * br_in,
                                    mxArray * bi_in,
                                    mxArray * c_in,
                                    mxArray * l_in,
                                    mxArray * lnpfq_in,
                                    mxArray * rmax_in,
                                    mxArray * ibit_in) {
    int nargout = 1;
    mxArray * ar = NULL;
    mxArray * ai__ = NULL;
    mxArray * br__ = NULL;
    mxArray * bi__ = NULL;
    mxArray * c__ = NULL;
    mxArray * l__ = NULL;
    mxArray * lnpfq__ = NULL;
    mxArray * rmax__ = NULL;
    mxArray * ibit__ = NULL;
    mlfEnterNewContext(
      8,
      9,
      ai,
      br,
      bi,
      c,
      l,
      lnpfq,
      rmax,
      ibit,
      ar_in,
      ai_in,
      br_in,
      bi_in,
      c_in,
      l_in,
      lnpfq_in,
      rmax_in,
      ibit_in);
    if (ai != NULL) {
        ++nargout;
    }
    if (br != NULL) {
        ++nargout;
    }
    if (bi != NULL) {
        ++nargout;
    }
    if (c != NULL) {
        ++nargout;
    }
    if (l != NULL) {
        ++nargout;
    }
    if (lnpfq != NULL) {
        ++nargout;
    }
    if (rmax != NULL) {
        ++nargout;
    }
    if (ibit != NULL) {
        ++nargout;
    }
    ar
      = Mgenhyper_arydiv(
          &ai__,
          &br__,
          &bi__,
          &c__,
          &l__,
          &lnpfq__,
          &rmax__,
          &ibit__,
          nargout,
          ar_in,
          ai_in,
          br_in,
          bi_in,
          c_in,
          l_in,
          lnpfq_in,
          rmax_in,
          ibit_in);
    mlfRestorePreviousContext(
      8,
      9,
      ai,
      br,
      bi,
      c,
      l,
      lnpfq,
      rmax,
      ibit,
      ar_in,
      ai_in,
      br_in,
      bi_in,
      c_in,
      l_in,
      lnpfq_in,
      rmax_in,
      ibit_in);
    if (ai != NULL) {
        mclCopyOutputArg(ai, ai__);
    } else {
        mxDestroyArray(ai__);
    }
    if (br != NULL) {
        mclCopyOutputArg(br, br__);
    } else {
        mxDestroyArray(br__);
    }
    if (bi != NULL) {
        mclCopyOutputArg(bi, bi__);
    } else {
        mxDestroyArray(bi__);
    }
    if (c != NULL) {
        mclCopyOutputArg(c, c__);
    } else {
        mxDestroyArray(c__);
    }
    if (l != NULL) {
        mclCopyOutputArg(l, l__);
    } else {
        mxDestroyArray(l__);
    }
    if (lnpfq != NULL) {
        mclCopyOutputArg(lnpfq, lnpfq__);
    } else {
        mxDestroyArray(lnpfq__);
    }
    if (rmax != NULL) {
        mclCopyOutputArg(rmax, rmax__);
    } else {
        mxDestroyArray(rmax__);
    }
    if (ibit != NULL) {
        mclCopyOutputArg(ibit, ibit__);
    } else {
        mxDestroyArray(ibit__);
    }
    return mlfReturnValue(ar);
}

/*
 * The function "mlxGenhyper_arydiv" contains the feval interface for the
 * "genhyper/arydiv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1266-1380). The feval function calls the implementation version of
 * genhyper/arydiv through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_arydiv(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[9];
    mxArray * mplhs[9];
    int i;
    if (nlhs > 9) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/arydiv Line: 1266 Col"
            "umn: 1 The function \"genhyper/arydiv\" was called w"
            "ith more than the declared number of outputs (9)."),
          NULL);
    }
    if (nrhs > 9) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/arydiv Line: 1266 Col"
            "umn: 1 The function \"genhyper/arydiv\" was called w"
            "ith more than the declared number of inputs (9)."),
          NULL);
    }
    for (i = 0; i < 9; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 9 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 9; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0,
      9,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7],
      mprhs[8]);
    mplhs[0]
      = Mgenhyper_arydiv(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          &mplhs[6],
          &mplhs[7],
          &mplhs[8],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5],
          mprhs[6],
          mprhs[7],
          mprhs[8]);
    mlfRestorePreviousContext(
      0,
      9,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6],
      mprhs[7],
      mprhs[8]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 9 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 9; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_emult" contains the normal interface for the
 * "genhyper/emult" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1380-1409). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_emult(mxArray * * e1,
                                   mxArray * * n2,
                                   mxArray * * e2,
                                   mxArray * * nf,
                                   mxArray * * ef,
                                   mxArray * n1_in,
                                   mxArray * e1_in,
                                   mxArray * n2_in,
                                   mxArray * e2_in,
                                   mxArray * nf_in,
                                   mxArray * ef_in) {
    int nargout = 1;
    mxArray * n1 = NULL;
    mxArray * e1__ = NULL;
    mxArray * n2__ = NULL;
    mxArray * e2__ = NULL;
    mxArray * nf__ = NULL;
    mxArray * ef__ = NULL;
    mlfEnterNewContext(
      5, 6, e1, n2, e2, nf, ef, n1_in, e1_in, n2_in, e2_in, nf_in, ef_in);
    if (e1 != NULL) {
        ++nargout;
    }
    if (n2 != NULL) {
        ++nargout;
    }
    if (e2 != NULL) {
        ++nargout;
    }
    if (nf != NULL) {
        ++nargout;
    }
    if (ef != NULL) {
        ++nargout;
    }
    n1
      = Mgenhyper_emult(
          &e1__,
          &n2__,
          &e2__,
          &nf__,
          &ef__,
          nargout,
          n1_in,
          e1_in,
          n2_in,
          e2_in,
          nf_in,
          ef_in);
    mlfRestorePreviousContext(
      5, 6, e1, n2, e2, nf, ef, n1_in, e1_in, n2_in, e2_in, nf_in, ef_in);
    if (e1 != NULL) {
        mclCopyOutputArg(e1, e1__);
    } else {
        mxDestroyArray(e1__);
    }
    if (n2 != NULL) {
        mclCopyOutputArg(n2, n2__);
    } else {
        mxDestroyArray(n2__);
    }
    if (e2 != NULL) {
        mclCopyOutputArg(e2, e2__);
    } else {
        mxDestroyArray(e2__);
    }
    if (nf != NULL) {
        mclCopyOutputArg(nf, nf__);
    } else {
        mxDestroyArray(nf__);
    }
    if (ef != NULL) {
        mclCopyOutputArg(ef, ef__);
    } else {
        mxDestroyArray(ef__);
    }
    return mlfReturnValue(n1);
}

/*
 * The function "mlxGenhyper_emult" contains the feval interface for the
 * "genhyper/emult" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1380-1409). The feval function calls the implementation version of
 * genhyper/emult through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_emult(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[6];
    int i;
    if (nlhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/emult Line: 1380 Col"
            "umn: 1 The function \"genhyper/emult\" was called w"
            "ith more than the declared number of outputs (6)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/emult Line: 1380 Col"
            "umn: 1 The function \"genhyper/emult\" was called w"
            "ith more than the declared number of inputs (6)."),
          NULL);
    }
    for (i = 0; i < 6; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mgenhyper_emult(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 6 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 6; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_ediv" contains the normal interface for the
 * "genhyper/ediv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1409-1438). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_ediv(mxArray * * e1,
                                  mxArray * * n2,
                                  mxArray * * e2,
                                  mxArray * * nf,
                                  mxArray * * ef,
                                  mxArray * n1_in,
                                  mxArray * e1_in,
                                  mxArray * n2_in,
                                  mxArray * e2_in,
                                  mxArray * nf_in,
                                  mxArray * ef_in) {
    int nargout = 1;
    mxArray * n1 = NULL;
    mxArray * e1__ = NULL;
    mxArray * n2__ = NULL;
    mxArray * e2__ = NULL;
    mxArray * nf__ = NULL;
    mxArray * ef__ = NULL;
    mlfEnterNewContext(
      5, 6, e1, n2, e2, nf, ef, n1_in, e1_in, n2_in, e2_in, nf_in, ef_in);
    if (e1 != NULL) {
        ++nargout;
    }
    if (n2 != NULL) {
        ++nargout;
    }
    if (e2 != NULL) {
        ++nargout;
    }
    if (nf != NULL) {
        ++nargout;
    }
    if (ef != NULL) {
        ++nargout;
    }
    n1
      = Mgenhyper_ediv(
          &e1__,
          &n2__,
          &e2__,
          &nf__,
          &ef__,
          nargout,
          n1_in,
          e1_in,
          n2_in,
          e2_in,
          nf_in,
          ef_in);
    mlfRestorePreviousContext(
      5, 6, e1, n2, e2, nf, ef, n1_in, e1_in, n2_in, e2_in, nf_in, ef_in);
    if (e1 != NULL) {
        mclCopyOutputArg(e1, e1__);
    } else {
        mxDestroyArray(e1__);
    }
    if (n2 != NULL) {
        mclCopyOutputArg(n2, n2__);
    } else {
        mxDestroyArray(n2__);
    }
    if (e2 != NULL) {
        mclCopyOutputArg(e2, e2__);
    } else {
        mxDestroyArray(e2__);
    }
    if (nf != NULL) {
        mclCopyOutputArg(nf, nf__);
    } else {
        mxDestroyArray(nf__);
    }
    if (ef != NULL) {
        mclCopyOutputArg(ef, ef__);
    } else {
        mxDestroyArray(ef__);
    }
    return mlfReturnValue(n1);
}

/*
 * The function "mlxGenhyper_ediv" contains the feval interface for the
 * "genhyper/ediv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1409-1438). The feval function calls the implementation version of
 * genhyper/ediv through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_ediv(int nlhs,
                             mxArray * plhs[],
                             int nrhs,
                             mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[6];
    int i;
    if (nlhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/ediv Line: 1409 Colu"
            "mn: 1 The function \"genhyper/ediv\" was called wit"
            "h more than the declared number of outputs (6)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/ediv Line: 1409 Col"
            "umn: 1 The function \"genhyper/ediv\" was called w"
            "ith more than the declared number of inputs (6)."),
          NULL);
    }
    for (i = 0; i < 6; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mgenhyper_ediv(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 6 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 6; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_eadd" contains the normal interface for the
 * "genhyper/eadd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1438-1484). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_eadd(mxArray * * e1,
                                  mxArray * * n2,
                                  mxArray * * e2,
                                  mxArray * * nf,
                                  mxArray * * ef,
                                  mxArray * n1_in,
                                  mxArray * e1_in,
                                  mxArray * n2_in,
                                  mxArray * e2_in,
                                  mxArray * nf_in,
                                  mxArray * ef_in) {
    int nargout = 1;
    mxArray * n1 = NULL;
    mxArray * e1__ = NULL;
    mxArray * n2__ = NULL;
    mxArray * e2__ = NULL;
    mxArray * nf__ = NULL;
    mxArray * ef__ = NULL;
    mlfEnterNewContext(
      5, 6, e1, n2, e2, nf, ef, n1_in, e1_in, n2_in, e2_in, nf_in, ef_in);
    if (e1 != NULL) {
        ++nargout;
    }
    if (n2 != NULL) {
        ++nargout;
    }
    if (e2 != NULL) {
        ++nargout;
    }
    if (nf != NULL) {
        ++nargout;
    }
    if (ef != NULL) {
        ++nargout;
    }
    n1
      = Mgenhyper_eadd(
          &e1__,
          &n2__,
          &e2__,
          &nf__,
          &ef__,
          nargout,
          n1_in,
          e1_in,
          n2_in,
          e2_in,
          nf_in,
          ef_in);
    mlfRestorePreviousContext(
      5, 6, e1, n2, e2, nf, ef, n1_in, e1_in, n2_in, e2_in, nf_in, ef_in);
    if (e1 != NULL) {
        mclCopyOutputArg(e1, e1__);
    } else {
        mxDestroyArray(e1__);
    }
    if (n2 != NULL) {
        mclCopyOutputArg(n2, n2__);
    } else {
        mxDestroyArray(n2__);
    }
    if (e2 != NULL) {
        mclCopyOutputArg(e2, e2__);
    } else {
        mxDestroyArray(e2__);
    }
    if (nf != NULL) {
        mclCopyOutputArg(nf, nf__);
    } else {
        mxDestroyArray(nf__);
    }
    if (ef != NULL) {
        mclCopyOutputArg(ef, ef__);
    } else {
        mxDestroyArray(ef__);
    }
    return mlfReturnValue(n1);
}

/*
 * The function "mlxGenhyper_eadd" contains the feval interface for the
 * "genhyper/eadd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1438-1484). The feval function calls the implementation version of
 * genhyper/eadd through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_eadd(int nlhs,
                             mxArray * plhs[],
                             int nrhs,
                             mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[6];
    int i;
    if (nlhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/eadd Line: 1438 Colu"
            "mn: 1 The function \"genhyper/eadd\" was called wit"
            "h more than the declared number of outputs (6)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/eadd Line: 1438 Col"
            "umn: 1 The function \"genhyper/eadd\" was called w"
            "ith more than the declared number of inputs (6)."),
          NULL);
    }
    for (i = 0; i < 6; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mgenhyper_eadd(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 6 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 6; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_esub" contains the normal interface for the
 * "genhyper/esub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1484-1508). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_esub(mxArray * * e1,
                                  mxArray * * n2,
                                  mxArray * * e2,
                                  mxArray * * nf,
                                  mxArray * * ef,
                                  mxArray * n1_in,
                                  mxArray * e1_in,
                                  mxArray * n2_in,
                                  mxArray * e2_in,
                                  mxArray * nf_in,
                                  mxArray * ef_in) {
    int nargout = 1;
    mxArray * n1 = NULL;
    mxArray * e1__ = NULL;
    mxArray * n2__ = NULL;
    mxArray * e2__ = NULL;
    mxArray * nf__ = NULL;
    mxArray * ef__ = NULL;
    mlfEnterNewContext(
      5, 6, e1, n2, e2, nf, ef, n1_in, e1_in, n2_in, e2_in, nf_in, ef_in);
    if (e1 != NULL) {
        ++nargout;
    }
    if (n2 != NULL) {
        ++nargout;
    }
    if (e2 != NULL) {
        ++nargout;
    }
    if (nf != NULL) {
        ++nargout;
    }
    if (ef != NULL) {
        ++nargout;
    }
    n1
      = Mgenhyper_esub(
          &e1__,
          &n2__,
          &e2__,
          &nf__,
          &ef__,
          nargout,
          n1_in,
          e1_in,
          n2_in,
          e2_in,
          nf_in,
          ef_in);
    mlfRestorePreviousContext(
      5, 6, e1, n2, e2, nf, ef, n1_in, e1_in, n2_in, e2_in, nf_in, ef_in);
    if (e1 != NULL) {
        mclCopyOutputArg(e1, e1__);
    } else {
        mxDestroyArray(e1__);
    }
    if (n2 != NULL) {
        mclCopyOutputArg(n2, n2__);
    } else {
        mxDestroyArray(n2__);
    }
    if (e2 != NULL) {
        mclCopyOutputArg(e2, e2__);
    } else {
        mxDestroyArray(e2__);
    }
    if (nf != NULL) {
        mclCopyOutputArg(nf, nf__);
    } else {
        mxDestroyArray(nf__);
    }
    if (ef != NULL) {
        mclCopyOutputArg(ef, ef__);
    } else {
        mxDestroyArray(ef__);
    }
    return mlfReturnValue(n1);
}

/*
 * The function "mlxGenhyper_esub" contains the feval interface for the
 * "genhyper/esub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1484-1508). The feval function calls the implementation version of
 * genhyper/esub through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_esub(int nlhs,
                             mxArray * plhs[],
                             int nrhs,
                             mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[6];
    int i;
    if (nlhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/esub Line: 1484 Colu"
            "mn: 1 The function \"genhyper/esub\" was called wit"
            "h more than the declared number of outputs (6)."),
          NULL);
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/esub Line: 1484 Col"
            "umn: 1 The function \"genhyper/esub\" was called w"
            "ith more than the declared number of inputs (6)."),
          NULL);
    }
    for (i = 0; i < 6; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = Mgenhyper_esub(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 6 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 6; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_conv12" contains the normal interface for the
 * "genhyper/conv12" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1508-1564). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_conv12(mxArray * * cae,
                                    mxArray * cn_in,
                                    mxArray * cae_in) {
    int nargout = 1;
    mxArray * cn = NULL;
    mxArray * cae__ = NULL;
    mlfEnterNewContext(1, 2, cae, cn_in, cae_in);
    if (cae != NULL) {
        ++nargout;
    }
    cn = Mgenhyper_conv12(&cae__, nargout, cn_in, cae_in);
    mlfRestorePreviousContext(1, 2, cae, cn_in, cae_in);
    if (cae != NULL) {
        mclCopyOutputArg(cae, cae__);
    } else {
        mxDestroyArray(cae__);
    }
    return mlfReturnValue(cn);
}

/*
 * The function "mlxGenhyper_conv12" contains the feval interface for the
 * "genhyper/conv12" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1508-1564). The feval function calls the implementation version of
 * genhyper/conv12 through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_conv12(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/conv12 Line: 1508 Col"
            "umn: 1 The function \"genhyper/conv12\" was called w"
            "ith more than the declared number of outputs (2)."),
          NULL);
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/conv12 Line: 1508 Col"
            "umn: 1 The function \"genhyper/conv12\" was called w"
            "ith more than the declared number of inputs (2)."),
          NULL);
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mgenhyper_conv12(&mplhs[1], nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_conv21" contains the normal interface for the
 * "genhyper/conv21" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1564-1619). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_conv21(mxArray * * cn,
                                    mxArray * cae_in,
                                    mxArray * cn_in) {
    int nargout = 1;
    mxArray * cae = NULL;
    mxArray * cn__ = NULL;
    mlfEnterNewContext(1, 2, cn, cae_in, cn_in);
    if (cn != NULL) {
        ++nargout;
    }
    cae = Mgenhyper_conv21(&cn__, nargout, cae_in, cn_in);
    mlfRestorePreviousContext(1, 2, cn, cae_in, cn_in);
    if (cn != NULL) {
        mclCopyOutputArg(cn, cn__);
    } else {
        mxDestroyArray(cn__);
    }
    return mlfReturnValue(cae);
}

/*
 * The function "mlxGenhyper_conv21" contains the feval interface for the
 * "genhyper/conv21" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1564-1619). The feval function calls the implementation version of
 * genhyper/conv21 through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_conv21(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/conv21 Line: 1564 Col"
            "umn: 1 The function \"genhyper/conv21\" was called w"
            "ith more than the declared number of outputs (2)."),
          NULL);
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/conv21 Line: 1564 Col"
            "umn: 1 The function \"genhyper/conv21\" was called w"
            "ith more than the declared number of inputs (2)."),
          NULL);
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mgenhyper_conv21(&mplhs[1], nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_ecpmul" contains the normal interface for the
 * "genhyper/ecpmul" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1619-1650). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_ecpmul(mxArray * * b,
                                    mxArray * * c,
                                    mxArray * a_in,
                                    mxArray * b_in,
                                    mxArray * c_in) {
    int nargout = 1;
    mxArray * a = NULL;
    mxArray * b__ = NULL;
    mxArray * c__ = NULL;
    mlfEnterNewContext(2, 3, b, c, a_in, b_in, c_in);
    if (b != NULL) {
        ++nargout;
    }
    if (c != NULL) {
        ++nargout;
    }
    a = Mgenhyper_ecpmul(&b__, &c__, nargout, a_in, b_in, c_in);
    mlfRestorePreviousContext(2, 3, b, c, a_in, b_in, c_in);
    if (b != NULL) {
        mclCopyOutputArg(b, b__);
    } else {
        mxDestroyArray(b__);
    }
    if (c != NULL) {
        mclCopyOutputArg(c, c__);
    } else {
        mxDestroyArray(c__);
    }
    return mlfReturnValue(a);
}

/*
 * The function "mlxGenhyper_ecpmul" contains the feval interface for the
 * "genhyper/ecpmul" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1619-1650). The feval function calls the implementation version of
 * genhyper/ecpmul through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_ecpmul(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/ecpmul Line: 1619 Col"
            "umn: 1 The function \"genhyper/ecpmul\" was called w"
            "ith more than the declared number of outputs (3)."),
          NULL);
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/ecpmul Line: 1619 Col"
            "umn: 1 The function \"genhyper/ecpmul\" was called w"
            "ith more than the declared number of inputs (3)."),
          NULL);
    }
    for (i = 0; i < 3; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0]
      = Mgenhyper_ecpmul(
          &mplhs[1], &mplhs[2], nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 3 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 3; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_ecpdiv" contains the normal interface for the
 * "genhyper/ecpdiv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1650-1683). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_ecpdiv(mxArray * * b,
                                    mxArray * * c,
                                    mxArray * a_in,
                                    mxArray * b_in,
                                    mxArray * c_in) {
    int nargout = 1;
    mxArray * a = NULL;
    mxArray * b__ = NULL;
    mxArray * c__ = NULL;
    mlfEnterNewContext(2, 3, b, c, a_in, b_in, c_in);
    if (b != NULL) {
        ++nargout;
    }
    if (c != NULL) {
        ++nargout;
    }
    a = Mgenhyper_ecpdiv(&b__, &c__, nargout, a_in, b_in, c_in);
    mlfRestorePreviousContext(2, 3, b, c, a_in, b_in, c_in);
    if (b != NULL) {
        mclCopyOutputArg(b, b__);
    } else {
        mxDestroyArray(b__);
    }
    if (c != NULL) {
        mclCopyOutputArg(c, c__);
    } else {
        mxDestroyArray(c__);
    }
    return mlfReturnValue(a);
}

/*
 * The function "mlxGenhyper_ecpdiv" contains the feval interface for the
 * "genhyper/ecpdiv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1650-1683). The feval function calls the implementation version of
 * genhyper/ecpdiv through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_ecpdiv(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/ecpdiv Line: 1650 Col"
            "umn: 1 The function \"genhyper/ecpdiv\" was called w"
            "ith more than the declared number of outputs (3)."),
          NULL);
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/ecpdiv Line: 1650 Col"
            "umn: 1 The function \"genhyper/ecpdiv\" was called w"
            "ith more than the declared number of inputs (3)."),
          NULL);
    }
    for (i = 0; i < 3; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0]
      = Mgenhyper_ecpdiv(
          &mplhs[1], &mplhs[2], nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 3 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 3; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfGenhyper_ipremax" contains the normal interface for the
 * "genhyper/ipremax" M-function from file "c:\projects\mzdde\genhyper.m"
 * (lines 1683-1735). This function processes any input arguments and passes
 * them to the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_ipremax(mxArray * a,
                                     mxArray * b,
                                     mxArray * ip,
                                     mxArray * iq,
                                     mxArray * z) {
    int nargout = 1;
    mxArray * ipremax = NULL;
    mlfEnterNewContext(0, 5, a, b, ip, iq, z);
    ipremax = Mgenhyper_ipremax(nargout, a, b, ip, iq, z);
    mlfRestorePreviousContext(0, 5, a, b, ip, iq, z);
    return mlfReturnValue(ipremax);
}

/*
 * The function "mlxGenhyper_ipremax" contains the feval interface for the
 * "genhyper/ipremax" M-function from file "c:\projects\mzdde\genhyper.m"
 * (lines 1683-1735). The feval function calls the implementation version of
 * genhyper/ipremax through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_ipremax(int nlhs,
                                mxArray * plhs[],
                                int nrhs,
                                mxArray * prhs[]) {
    mxArray * mprhs[5];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/ipremax Line: 1683 Col"
            "umn: 1 The function \"genhyper/ipremax\" was called w"
            "ith more than the declared number of outputs (1)."),
          NULL);
    }
    if (nrhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/ipremax Line: 1683 Co"
            "lumn: 1 The function \"genhyper/ipremax\" was called"
            " with more than the declared number of inputs (5)."),
          NULL);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 5 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 5; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mplhs[0]
      = Mgenhyper_ipremax(
          nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mlfRestorePreviousContext(
      0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfGenhyper_factor" contains the normal interface for the
 * "genhyper/factor" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1735-1766). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_factor(mxArray * z) {
    int nargout = 1;
    mxArray * factor = NULL;
    mlfEnterNewContext(0, 1, z);
    factor = Mgenhyper_factor(nargout, z);
    mlfRestorePreviousContext(0, 1, z);
    return mlfReturnValue(factor);
}

/*
 * The function "mlxGenhyper_factor" contains the feval interface for the
 * "genhyper/factor" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1735-1766). The feval function calls the implementation version of
 * genhyper/factor through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_factor(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/factor Line: 1735 Col"
            "umn: 1 The function \"genhyper/factor\" was called w"
            "ith more than the declared number of outputs (1)."),
          NULL);
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/factor Line: 1735 Col"
            "umn: 1 The function \"genhyper/factor\" was called w"
            "ith more than the declared number of inputs (1)."),
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
    mplhs[0] = Mgenhyper_factor(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfGenhyper_cgamma" contains the normal interface for the
 * "genhyper/cgamma" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1766-2019). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
static mxArray * mlfGenhyper_cgamma(mxArray * arg, mxArray * lnpfq) {
    int nargout = 1;
    mxArray * cgamma = NULL;
    mlfEnterNewContext(0, 2, arg, lnpfq);
    cgamma = Mgenhyper_cgamma(nargout, arg, lnpfq);
    mlfRestorePreviousContext(0, 2, arg, lnpfq);
    return mlfReturnValue(cgamma);
}

/*
 * The function "mlxGenhyper_cgamma" contains the feval interface for the
 * "genhyper/cgamma" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1766-2019). The feval function calls the implementation version of
 * genhyper/cgamma through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
static void mlxGenhyper_cgamma(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/cgamma Line: 1766 Col"
            "umn: 1 The function \"genhyper/cgamma\" was called w"
            "ith more than the declared number of outputs (1)."),
          NULL);
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: genhyper/cgamma Line: 1766 Col"
            "umn: 1 The function \"genhyper/cgamma\" was called w"
            "ith more than the declared number of inputs (2)."),
          NULL);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mgenhyper_cgamma(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}

/*
 * The function "Mgenhyper" is the implementation version of the "genhyper"
 * M-function from file "c:\projects\mzdde\genhyper.m" (lines 1-269). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [pfq]=genHyper(a,b,z,lnpfq,ix,nsigfig);
 */
static mxArray * Mgenhyper(int nargout_,
                           mxArray * a,
                           mxArray * b,
                           mxArray * z,
                           mxArray * lnpfq,
                           mxArray * ix,
                           mxArray * nsigfig) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    int nargin_ = mclNargin(6, a, b, z, lnpfq, ix, nsigfig, NULL);
    mxArray * pfq = NULL;
    mxArray * i = NULL;
    mxArray * precis = NULL;
    mxArray * dnum = NULL;
    mxArray * diff = NULL;
    mxArray * argr = NULL;
    mxArray * argi = NULL;
    mxArray * z1 = NULL;
    mxArray * hyper2 = NULL;
    mxArray * hyper1 = NULL;
    mxArray * gam7 = NULL;
    mxArray * gam6 = NULL;
    mxArray * gam5 = NULL;
    mxArray * gam4 = NULL;
    mxArray * gam3 = NULL;
    mxArray * gam2 = NULL;
    mxArray * gam1 = NULL;
    mxArray * b1 = NULL;
    mxArray * a1 = NULL;
    mxArray * ans = NULL;
    mxArray * iq = NULL;
    mxArray * ip = NULL;
    mclCopyArray(&a);
    mclCopyArray(&b);
    mclCopyArray(&z);
    mclCopyArray(&lnpfq);
    mclCopyArray(&ix);
    mclCopyArray(&nsigfig);
    /*
     * % function [pfq]=genHyper(a,b,z,lnpfq,ix,nsigfig)
     * % Description : A numerical evaluator for the generalized hypergeometric
     * %               function for complex arguments with large magnitudes
     * %               using a direct summation of the Gauss series.
     * %               pFq isdefined by (borrowed from Maple):
     * %   pFq = sum(z^k / k! * product(pochhammer(n[i], k), i=1..p) /
     * %         product(pochhammer(d[j], k), j=1..q), k=0..infinity )
     * %
     * % INPUTS:       a => array containing numerator parameters
     * %               b => array containing denominator parameters
     * %               z => complex argument (scalar)
     * %           lnpfq => (optional) set to 1 if desired result is the natural
     * %                    log of pfq (default is 0)
     * %              ix => (optional) maximum number of terms in a,b (see below)
     * %         nsigfig => number of desired significant figures (default=10)
     * %
     * % OUPUT:      pfq => result
     * %
     * % EXAMPLES:     a=[1+i,1]; b=[2-i,3,3]; z=1.5;
     * %               >> genHyper(a,b,z)
     * %               ans =
     * %                          1.02992154295955 +     0.106416425916656i
     * %               or with more precision,
     * %               >> genHyper(a,b,z,0,0,15)
     * %               ans =
     * %                          1.02992154295896 +     0.106416425915575i
     * %               using the log option,
     * %               >> genHyper(a,b,z,1,0,15)
     * %               ans =
     * %                        0.0347923403326305 +     0.102959427435454i
     * %               >> exp(ans)
     * %               ans =
     * %                          1.02992154295896 +     0.106416425915575i
     * %
     * %
     * % Translated from the original fortran using f2matlab.m
     * %  by Ben E. Barrowes - barrowes@alum.mit.edu, 7/04.
     * %  
     * 
     * %% Original fortran documentation
     * %     ACPAPFQ.  A NUMERICAL EVALUATOR FOR THE GENERALIZED HYPERGEOMETRIC
     * %
     * %     1  SERIES.  W.F. PERGER, A. BHALLA, M. NARDIN.
     * %
     * %     REF. IN COMP. PHYS. COMMUN. 77 (1993) 249
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *    SOLUTION TO THE GENERALIZED HYPERGEOMETRIC FUNCTION       *
     * %     *                                                              *
     * %     *                           by                                 *
     * %     *                                                              *
     * %     *                      W. F. PERGER,                           *
     * %     *                                                              *
     * %     *              MARK NARDIN  and ATUL BHALLA                    *
     * %     *                                                              *
     * %     *                                                              *
     * %     *            Electrical Engineering Department                 *
     * %     *            Michigan Technological University                 *
     * %     *                  1400 Townsend Drive                         *
     * %     *                Houghton, MI  49931-1295   USA                *
     * %     *                     Copyright 1993                           *
     * %     *                                                              *
     * %     *               e-mail address: wfp@mtu.edu                    *
     * %     *                                                              *
     * %     *  Description : A numerical evaluator for the generalized     *
     * %     *    hypergeometric function for complex arguments with large  *
     * %     *    magnitudes using a direct summation of the Gauss series.  *
     * %     *    The method used allows an accuracy of up to thirteen      *
     * %     *    decimal places through the use of large integer arrays    *
     * %     *    and a single final division.                              *
     * %     *    (original subroutines for the confluent hypergeometric    *
     * %     *    written by Mark Nardin, 1989; modifications made to cal-  *
     * %     *    culate the generalized hypergeometric function were       *
     * %     *    written by W.F. Perger and A. Bhalla, June, 1990)         *
     * %     *                                                              *
     * %     *  The evaluation of the pFq series is accomplished by a func- *
     * %     *  ion call to PFQ, which is a double precision complex func-  *
     * %     *  tion.  The required input is:                               *
     * %     *  1. Double precision complex arrays A and B.  These are the  *
     * %     *     arrays containing the parameters in the numerator and de-*
     * %     *     nominator, respectively.                                 *
     * %     *  2. Integers IP and IQ.  These integers indicate the number  *
     * %     *     of numerator and denominator terms, respectively (these  *
     * %     *     are p and q in the pFq function).                        *
     * %     *  3. Double precision complex argument Z.                     *
     * %     *  4. Integer LNPFQ.  This integer should be set to '1' if the *
     * %     *     result from PFQ is to be returned as the natural logaritm*
     * %     *     of the series, or '0' if not.  The user can generally set*
     * %     *     LNPFQ = '0' and change it if required.                   *
     * %     *  5. Integer IX.  This integer should be set to '0' if the    *
     * %     *     user desires the program PFQ to estimate the number of   *
     * %     *     array terms (in A and B) to be used, or an integer       *
     * %     *     greater than zero specifying the number of integer pos-  *
     * %     *     itions to be used.  This input parameter is escpecially  *
     * %     *     useful as a means to check the results of a given run.   *
     * %     *     Specificially, if the user obtains a result for a given  *
     * %     *     set of parameters, then changes IX and re-runs the eval- *
     * %     *     uator, and if the number of array positions was insuffi- *
     * %     *     cient, then the two results will likely differ.  The rec-*
     * %     *     commended would be to generally set IX = '0' and then set*
     * %     *     it to 100 or so for a second run.  Note that the LENGTH  *
     * %     *     parameter currently sets the upper limit on IX to 777,   *
     * %     *     but that can easily be changed (it is a single PARAMETER *
     * %     *     statement) and the program recompiled.                   *
     * %     *  6. Integer NSIGFIG.  This integer specifies the requested   *
     * %     *     number of significant figures in the final result.  If   *
     * %     *     the user attempts to request more than the number of bits*
     * %     *     in the mantissa allows, the program will abort with an   *
     * %     *     appropriate error message.  The recommended value is 10. *
     * %     *                                                              *
     * %     *     Note: The variable NOUT is the file to which error mess- *
     * %     *           ages are written (default is 6).  This can be      *
     * %     *           changed in the FUNCTION PFQ to accomodate re-      *
     * %     *           of output to another file                          *
     * %     *                                                              *
     * %     *  Subprograms called: HYPER.                                  *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     * %
     * %
     * %
     * 
     * if nargin<6
     */
    if (nargin_ < 6) {
        /*
         * nsigfig=10;
         */
        mlfAssign(&nsigfig, _mxarray0_);
    /*
     * elseif isempty(nsigfig)
     */
    } else if (mlfTobool(mlfIsempty(mclVa(nsigfig, "nsigfig")))) {
        /*
         * nsigfig=10;
         */
        mlfAssign(&nsigfig, _mxarray0_);
    /*
     * end
     */
    }
    /*
     * if nargin<5
     */
    if (nargin_ < 5) {
        /*
         * ix=0;
         */
        mlfAssign(&ix, _mxarray1_);
    /*
     * elseif isempty(ix)
     */
    } else if (mlfTobool(mlfIsempty(mclVa(ix, "ix")))) {
        /*
         * ix=0;
         */
        mlfAssign(&ix, _mxarray1_);
    /*
     * end
     */
    }
    /*
     * if nargin<4
     */
    if (nargin_ < 4) {
        /*
         * lnpfq=0;
         */
        mlfAssign(&lnpfq, _mxarray1_);
    /*
     * elseif isempty(lnpfq)
     */
    } else if (mlfTobool(mlfIsempty(mclVa(lnpfq, "lnpfq")))) {
        /*
         * lnpfq=0;
         */
        mlfAssign(&lnpfq, _mxarray1_);
    /*
     * end
     */
    }
    /*
     * ip=length(a);
     */
    mlfAssign(&ip, mlfScalar(mclLengthInt(mclVa(a, "a"))));
    /*
     * iq=length(b);
     */
    mlfAssign(&iq, mlfScalar(mclLengthInt(mclVa(b, "b"))));
    /*
     * 
     * global  zero   half   one   two   ten   eps;
     * [zero , half , one , two , ten , eps]=deal(0.0d0,0.5d0,1.0d0,2.0d0,10.0d0,1.0d-10);
     */
    mlfNDeal(
      0,
      mlfVarargout(
        mclPrepareGlobal(&zero),
        mclPrepareGlobal(&half),
        mclPrepareGlobal(&one),
        mclPrepareGlobal(&two),
        mclPrepareGlobal(&ten),
        mclPrepareGlobal(&eps),
        NULL),
      _mxarray1_,
      _mxarray2_,
      _mxarray3_,
      _mxarray4_,
      _mxarray0_,
      _mxarray5_,
      NULL);
    /*
     * global  nout;
     * %
     * %
     * %
     * %
     * a1=zeros(2,1);b1=zeros(1,1);gam1=0;gam2=0;gam3=0;gam4=0;gam5=0;gam6=0;gam7=0;hyper1=0;hyper2=0;z1=0;
     */
    mlfAssign(&a1, mlfZeros(_mxarray4_, _mxarray3_, NULL));
    mlfAssign(&b1, mlfZeros(_mxarray3_, _mxarray3_, NULL));
    mlfAssign(&gam1, _mxarray1_);
    mlfAssign(&gam2, _mxarray1_);
    mlfAssign(&gam3, _mxarray1_);
    mlfAssign(&gam4, _mxarray1_);
    mlfAssign(&gam5, _mxarray1_);
    mlfAssign(&gam6, _mxarray1_);
    mlfAssign(&gam7, _mxarray1_);
    mlfAssign(&hyper1, _mxarray1_);
    mlfAssign(&hyper2, _mxarray1_);
    mlfAssign(&z1, _mxarray1_);
    /*
     * argi=0;argr=0;diff=0;dnum=0;precis=0;
     */
    mlfAssign(&argi, _mxarray1_);
    mlfAssign(&argr, _mxarray1_);
    mlfAssign(&diff, _mxarray1_);
    mlfAssign(&dnum, _mxarray1_);
    mlfAssign(&precis, _mxarray1_);
    /*
     * %
     * %
     * i=0;
     */
    mlfAssign(&i, _mxarray1_);
    /*
     * %
     * %
     * %
     * nout=6;
     */
    mlfAssign(mclPrepareGlobal(&nout), _mxarray6_);
    /*
     * if ((lnpfq~=0) & (lnpfq~=1)) ;
     */
    {
        mxArray * a_ = mclInitialize(mclNe(mclVa(lnpfq, "lnpfq"), _mxarray1_));
        if (mlfTobool(a_)
            && mlfTobool(
                 mclAnd(a_, mclNe(mclVa(lnpfq, "lnpfq"), _mxarray3_)))) {
            mxDestroyArray(a_);
            /*
             * ' error in input arguments: lnpfq ~= 0 or 1',
             */
            mclPrintAns(&ans, _mxarray7_);
            /*
             * error('stop encountered in original fortran code');
             */
            mlfError(_mxarray9_, NULL);
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * if ((ip>iq) & (abs(z)>one)) ;
     */
    {
        mxArray * a_ = mclInitialize(mclGt(mclVv(ip, "ip"), mclVv(iq, "iq")));
        if (mlfTobool(a_)
            && mlfTobool(
                 mclAnd(
                   a_, mclGt(mlfAbs(mclVa(z, "z")), mclVg(&one, "one"))))) {
            mxDestroyArray(a_);
            /*
             * ip , iq , abs(z),
             */
            mclPrintArray(mclVv(ip, "ip"), "ip");
            mclPrintArray(mclVv(iq, "iq"), "iq");
            mclPrintAns(&ans, mlfAbs(mclVa(z, "z")));
            /*
             * %format [,1x,'ip=',1i2,3x,'iq=',1i2,3x,'and abs(z)=',1e12.5,2x,./,' which is greater than one--series does',' not converge');
             * error('stop encountered in original fortran code');
             */
            mlfError(_mxarray9_, NULL);
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * if (ip==2 & iq==1 & abs(z)>0.9) ;
     */
    {
        mxArray * a_ = mclInitialize(mclEq(mclVv(ip, "ip"), _mxarray4_));
        if (mlfTobool(a_)) {
            mlfAssign(&a_, mclAnd(a_, mclEq(mclVv(iq, "iq"), _mxarray3_)));
        } else {
            mlfAssign(&a_, mlfScalar(0));
        }
        if (mlfTobool(a_)
            && mlfTobool(
                 mclAnd(a_, mclGt(mlfAbs(mclVa(z, "z")), _mxarray11_)))) {
            mxDestroyArray(a_);
            /*
             * if (lnpfq~=1) ;
             */
            if (mclNeBool(mclVa(lnpfq, "lnpfq"), _mxarray3_)) {
                /*
                 * %
                 * %      Check to see if the Gamma function arguments are o.k.; if not,
                 * %
                 * %      then the series will have to be used.
                 * %
                 * %
                 * %
                 * %      PRECIS - MACHINE PRECISION
                 * %
                 * %
                 * precis=one;
                 */
                mlfAssign(&precis, mclVg(&one, "one"));
                /*
                 * precis=precis./two;
                 */
                mlfAssign(
                  &precis,
                  mclRdivide(mclVv(precis, "precis"), mclVg(&two, "two")));
                /*
                 * dnum=precis+one;
                 */
                mlfAssign(
                  &dnum, mclPlus(mclVv(precis, "precis"), mclVg(&one, "one")));
                /*
                 * while (dnum>one);
                 */
                while (mclGtBool(mclVv(dnum, "dnum"), mclVg(&one, "one"))) {
                    /*
                     * precis=precis./two;
                     */
                    mlfAssign(
                      &precis,
                      mclRdivide(mclVv(precis, "precis"), mclVg(&two, "two")));
                    /*
                     * dnum=precis+one;
                     */
                    mlfAssign(
                      &dnum,
                      mclPlus(mclVv(precis, "precis"), mclVg(&one, "one")));
                /*
                 * end;
                 */
                }
                /*
                 * precis=two.*precis;
                 */
                mlfAssign(
                  &precis,
                  mclTimes(mclVg(&two, "two"), mclVv(precis, "precis")));
                /*
                 * for i=1 : 6;
                 */
                {
                    int v_ = mclForIntStart(1);
                    int e_ = 6;
                    if (v_ > e_) {
                        mlfAssign(&i, _mxarray12_);
                    } else {
                        /*
                         * if (i==1) ;
                         * argi=imag(b(1));
                         * argr=real(b(1));
                         * elseif (i==2);
                         * argi=imag(b(1)-a(1)-a(2));
                         * argr=real(b(1)-a(1)-a(2));
                         * elseif (i==3);
                         * argi=imag(b(1)-a(1));
                         * argr=real(b(1)-a(1));
                         * elseif (i==4);
                         * argi=imag(a(1)+a(2)-b(1));
                         * argr=real(a(1)+a(2)-b(1));
                         * elseif (i==5);
                         * argi=imag(a(1));
                         * argr=real(a(1));
                         * elseif (i==6);
                         * argi=imag(a(2));
                         * argr=real(a(2));
                         * end;
                         * %
                         * %       CASES WHERE THE ARGUMENT IS REAL
                         * %
                         * %
                         * if (argi==0.0) ;
                         * %
                         * %        CASES WHERE THE ARGUMENT IS REAL AND NEGATIVE
                         * %
                         * %
                         * if (argr<=0.0) ;
                         * %
                         * %         USE THE SERIES EXPANSION IF THE ARGUMENT IS TOO NEAR A POLE
                         * %
                         * %
                         * diff=abs(real(round(argr))-argr);
                         * if (diff<=two.*precis) ;
                         * pfq=hyper(a,b,ip,iq,z,lnpfq,ix,nsigfig);
                         * return;
                         * end;
                         * end;
                         * end;
                         * end;
                         */
                        for (; ; ) {
                            if (mclEqBool(mlfScalar(v_), _mxarray3_)) {
                                mlfAssign(
                                  &argi,
                                  mlfImag(mclIntArrayRef1(mclVa(b, "b"), 1)));
                                mlfAssign(
                                  &argr,
                                  mlfReal(mclIntArrayRef1(mclVa(b, "b"), 1)));
                            } else if (mclEqBool(mlfScalar(v_), _mxarray4_)) {
                                mlfAssign(
                                  &argi,
                                  mlfImag(
                                    mclMinus(
                                      mclMinus(
                                        mclIntArrayRef1(mclVa(b, "b"), 1),
                                        mclIntArrayRef1(mclVa(a, "a"), 1)),
                                      mclIntArrayRef1(mclVa(a, "a"), 2))));
                                mlfAssign(
                                  &argr,
                                  mlfReal(
                                    mclMinus(
                                      mclMinus(
                                        mclIntArrayRef1(mclVa(b, "b"), 1),
                                        mclIntArrayRef1(mclVa(a, "a"), 1)),
                                      mclIntArrayRef1(mclVa(a, "a"), 2))));
                            } else if (mclEqBool(mlfScalar(v_), _mxarray13_)) {
                                mlfAssign(
                                  &argi,
                                  mlfImag(
                                    mclMinus(
                                      mclIntArrayRef1(mclVa(b, "b"), 1),
                                      mclIntArrayRef1(mclVa(a, "a"), 1))));
                                mlfAssign(
                                  &argr,
                                  mlfReal(
                                    mclMinus(
                                      mclIntArrayRef1(mclVa(b, "b"), 1),
                                      mclIntArrayRef1(mclVa(a, "a"), 1))));
                            } else if (mclEqBool(mlfScalar(v_), _mxarray14_)) {
                                mlfAssign(
                                  &argi,
                                  mlfImag(
                                    mclMinus(
                                      mclPlus(
                                        mclIntArrayRef1(mclVa(a, "a"), 1),
                                        mclIntArrayRef1(mclVa(a, "a"), 2)),
                                      mclIntArrayRef1(mclVa(b, "b"), 1))));
                                mlfAssign(
                                  &argr,
                                  mlfReal(
                                    mclMinus(
                                      mclPlus(
                                        mclIntArrayRef1(mclVa(a, "a"), 1),
                                        mclIntArrayRef1(mclVa(a, "a"), 2)),
                                      mclIntArrayRef1(mclVa(b, "b"), 1))));
                            } else if (mclEqBool(mlfScalar(v_), _mxarray15_)) {
                                mlfAssign(
                                  &argi,
                                  mlfImag(mclIntArrayRef1(mclVa(a, "a"), 1)));
                                mlfAssign(
                                  &argr,
                                  mlfReal(mclIntArrayRef1(mclVa(a, "a"), 1)));
                            } else if (mclEqBool(mlfScalar(v_), _mxarray6_)) {
                                mlfAssign(
                                  &argi,
                                  mlfImag(mclIntArrayRef1(mclVa(a, "a"), 2)));
                                mlfAssign(
                                  &argr,
                                  mlfReal(mclIntArrayRef1(mclVa(a, "a"), 2)));
                            }
                            if (mclEqBool(mclVv(argi, "argi"), _mxarray1_)) {
                                if (mclLeBool(
                                      mclVv(argr, "argr"), _mxarray1_)) {
                                    mlfAssign(
                                      &diff,
                                      mlfAbs(
                                        mclMinus(
                                          mlfReal(
                                            mlfRound(mclVv(argr, "argr"))),
                                          mclVv(argr, "argr"))));
                                    if (mclLeBool(
                                          mclVv(diff, "diff"),
                                          mclTimes(
                                            mclVg(&two, "two"),
                                            mclVv(precis, "precis")))) {
                                        mlfAssign(
                                          &pfq,
                                          mlfGenhyper_hyper(
                                            mclVa(a, "a"),
                                            mclVa(b, "b"),
                                            mclVv(ip, "ip"),
                                            mclVv(iq, "iq"),
                                            mclVa(z, "z"),
                                            mclVa(lnpfq, "lnpfq"),
                                            mclVa(ix, "ix"),
                                            mclVa(nsigfig, "nsigfig")));
                                        goto return_;
                                    }
                                }
                            }
                            if (v_ == e_) {
                                break;
                            }
                            ++v_;
                        }
                        mlfAssign(&i, mlfScalar(v_));
                    }
                }
                /*
                 * gam1=cgamma(b(1),lnpfq);
                 */
                mlfAssign(
                  &gam1,
                  mlfGenhyper_cgamma(
                    mclIntArrayRef1(mclVa(b, "b"), 1), mclVa(lnpfq, "lnpfq")));
                /*
                 * gam2=cgamma(b(1)-a(1)-a(2),lnpfq);
                 */
                mlfAssign(
                  &gam2,
                  mlfGenhyper_cgamma(
                    mclMinus(
                      mclMinus(
                        mclIntArrayRef1(mclVa(b, "b"), 1),
                        mclIntArrayRef1(mclVa(a, "a"), 1)),
                      mclIntArrayRef1(mclVa(a, "a"), 2)),
                    mclVa(lnpfq, "lnpfq")));
                /*
                 * gam3=cgamma(b(1)-a(1),lnpfq);
                 */
                mlfAssign(
                  &gam3,
                  mlfGenhyper_cgamma(
                    mclMinus(
                      mclIntArrayRef1(mclVa(b, "b"), 1),
                      mclIntArrayRef1(mclVa(a, "a"), 1)),
                    mclVa(lnpfq, "lnpfq")));
                /*
                 * gam4=cgamma(b(1)-a(2),lnpfq);
                 */
                mlfAssign(
                  &gam4,
                  mlfGenhyper_cgamma(
                    mclMinus(
                      mclIntArrayRef1(mclVa(b, "b"), 1),
                      mclIntArrayRef1(mclVa(a, "a"), 2)),
                    mclVa(lnpfq, "lnpfq")));
                /*
                 * gam5=cgamma(a(1)+a(2)-b(1),lnpfq);
                 */
                mlfAssign(
                  &gam5,
                  mlfGenhyper_cgamma(
                    mclMinus(
                      mclPlus(
                        mclIntArrayRef1(mclVa(a, "a"), 1),
                        mclIntArrayRef1(mclVa(a, "a"), 2)),
                      mclIntArrayRef1(mclVa(b, "b"), 1)),
                    mclVa(lnpfq, "lnpfq")));
                /*
                 * gam6=cgamma(a(1),lnpfq);
                 */
                mlfAssign(
                  &gam6,
                  mlfGenhyper_cgamma(
                    mclIntArrayRef1(mclVa(a, "a"), 1), mclVa(lnpfq, "lnpfq")));
                /*
                 * gam7=cgamma(a(2),lnpfq);
                 */
                mlfAssign(
                  &gam7,
                  mlfGenhyper_cgamma(
                    mclIntArrayRef1(mclVa(a, "a"), 2), mclVa(lnpfq, "lnpfq")));
                /*
                 * a1(1)=a(1);
                 */
                mclIntArrayAssign1(&a1, mclIntArrayRef1(mclVa(a, "a"), 1), 1);
                /*
                 * a1(2)=a(2);
                 */
                mclIntArrayAssign1(&a1, mclIntArrayRef1(mclVa(a, "a"), 2), 2);
                /*
                 * b1(1)=a(1)+a(2)-b(1)+one;
                 */
                mclIntArrayAssign1(
                  &b1,
                  mclPlus(
                    mclMinus(
                      mclPlus(
                        mclIntArrayRef1(mclVa(a, "a"), 1),
                        mclIntArrayRef1(mclVa(a, "a"), 2)),
                      mclIntArrayRef1(mclVa(b, "b"), 1)),
                    mclVg(&one, "one")),
                  1);
                /*
                 * z1=one-z;
                 */
                mlfAssign(&z1, mclMinus(mclVg(&one, "one"), mclVa(z, "z")));
                /*
                 * hyper1=hyper(a1,b1,ip,iq,z1,lnpfq,ix,nsigfig);
                 */
                mlfAssign(
                  &hyper1,
                  mlfGenhyper_hyper(
                    mclVv(a1, "a1"),
                    mclVv(b1, "b1"),
                    mclVv(ip, "ip"),
                    mclVv(iq, "iq"),
                    mclVv(z1, "z1"),
                    mclVa(lnpfq, "lnpfq"),
                    mclVa(ix, "ix"),
                    mclVa(nsigfig, "nsigfig")));
                /*
                 * a1(1)=b(1)-a(1);
                 */
                mclIntArrayAssign1(
                  &a1,
                  mclMinus(
                    mclIntArrayRef1(mclVa(b, "b"), 1),
                    mclIntArrayRef1(mclVa(a, "a"), 1)),
                  1);
                /*
                 * a1(2)=b(1)-a(2);
                 */
                mclIntArrayAssign1(
                  &a1,
                  mclMinus(
                    mclIntArrayRef1(mclVa(b, "b"), 1),
                    mclIntArrayRef1(mclVa(a, "a"), 2)),
                  2);
                /*
                 * b1(1)=b(1)-a(1)-a(2)+one;
                 */
                mclIntArrayAssign1(
                  &b1,
                  mclPlus(
                    mclMinus(
                      mclMinus(
                        mclIntArrayRef1(mclVa(b, "b"), 1),
                        mclIntArrayRef1(mclVa(a, "a"), 1)),
                      mclIntArrayRef1(mclVa(a, "a"), 2)),
                    mclVg(&one, "one")),
                  1);
                /*
                 * hyper2=hyper(a1,b1,ip,iq,z1,lnpfq,ix,nsigfig);
                 */
                mlfAssign(
                  &hyper2,
                  mlfGenhyper_hyper(
                    mclVv(a1, "a1"),
                    mclVv(b1, "b1"),
                    mclVv(ip, "ip"),
                    mclVv(iq, "iq"),
                    mclVv(z1, "z1"),
                    mclVa(lnpfq, "lnpfq"),
                    mclVa(ix, "ix"),
                    mclVa(nsigfig, "nsigfig")));
                /*
                 * pfq=gam1.*gam2.*hyper1./(gam3.*gam4)+(one-z).^(b(1)-a(1)-a(2)).*gam1.*gam5.*hyper2./(gam6.*gam7);
                 */
                mlfAssign(
                  &pfq,
                  mclPlus(
                    mclRdivide(
                      mclTimes(
                        mclTimes(mclVv(gam1, "gam1"), mclVv(gam2, "gam2")),
                        mclVv(hyper1, "hyper1")),
                      mclTimes(mclVv(gam3, "gam3"), mclVv(gam4, "gam4"))),
                    mclRdivide(
                      mclTimes(
                        mclTimes(
                          mclTimes(
                            mlfPower(
                              mclMinus(mclVg(&one, "one"), mclVa(z, "z")),
                              mclMinus(
                                mclMinus(
                                  mclIntArrayRef1(mclVa(b, "b"), 1),
                                  mclIntArrayRef1(mclVa(a, "a"), 1)),
                                mclIntArrayRef1(mclVa(a, "a"), 2))),
                            mclVv(gam1, "gam1")),
                          mclVv(gam5, "gam5")),
                        mclVv(hyper2, "hyper2")),
                      mclTimes(mclVv(gam6, "gam6"), mclVv(gam7, "gam7")))));
                /*
                 * return;
                 */
                goto return_;
            /*
             * end;
             */
            }
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * pfq=hyper(a,b,ip,iq,z,lnpfq,ix,nsigfig);
     */
    mlfAssign(
      &pfq,
      mlfGenhyper_hyper(
        mclVa(a, "a"),
        mclVa(b, "b"),
        mclVv(ip, "ip"),
        mclVv(iq, "iq"),
        mclVa(z, "z"),
        mclVa(lnpfq, "lnpfq"),
        mclVa(ix, "ix"),
        mclVa(nsigfig, "nsigfig")));
    /*
     * return;
     * 
     * 
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                   FUNCTION BITS                              *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Determines the number of significant figures  *
     * %     *    of machine precision to arrive at the size of the array   *
     * %     *    the numbers must be stored in to get the accuracy of the  *
     * %     *    solution.                                                 *
     * %     *                                                              *
     * %     *  Subprograms called: none                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
    return_:
    mclValidateOutput(pfq, 1, nargout_, "pfq", "genhyper");
    mxDestroyArray(ip);
    mxDestroyArray(iq);
    mxDestroyArray(ans);
    mxDestroyArray(a1);
    mxDestroyArray(b1);
    mxDestroyArray(gam1);
    mxDestroyArray(gam2);
    mxDestroyArray(gam3);
    mxDestroyArray(gam4);
    mxDestroyArray(gam5);
    mxDestroyArray(gam6);
    mxDestroyArray(gam7);
    mxDestroyArray(hyper1);
    mxDestroyArray(hyper2);
    mxDestroyArray(z1);
    mxDestroyArray(argi);
    mxDestroyArray(argr);
    mxDestroyArray(diff);
    mxDestroyArray(dnum);
    mxDestroyArray(precis);
    mxDestroyArray(i);
    mxDestroyArray(nsigfig);
    mxDestroyArray(ix);
    mxDestroyArray(lnpfq);
    mxDestroyArray(z);
    mxDestroyArray(b);
    mxDestroyArray(a);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return pfq;
}

/*
 * The function "Mgenhyper_bits" is the implementation version of the
 * "genhyper/bits" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 269-300). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [bits]=bits;
 */
static mxArray * Mgenhyper_bits(int nargout_) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * bits = NULL;
    mxArray * nnz = NULL;
    mxArray * bit = NULL;
    mxArray * bit2 = NULL;
    /*
     * %
     * bit2=0;
     */
    mlfAssign(&bit2, _mxarray1_);
    /*
     * %
     * %
     * %
     * bit=1.0;
     */
    mlfAssign(&bit, _mxarray3_);
    /*
     * nnz=0;
     */
    mlfAssign(&nnz, _mxarray1_);
    /*
     * nnz=nnz+1;
     */
    mlfAssign(&nnz, mclPlus(mclVv(nnz, "nnz"), _mxarray3_));
    /*
     * bit2=bit.*2.0;
     */
    mlfAssign(&bit2, mclTimes(mclVv(bit, "bit"), _mxarray4_));
    /*
     * bit=bit2+1.0;
     */
    mlfAssign(&bit, mclPlus(mclVv(bit2, "bit2"), _mxarray3_));
    /*
     * while ((bit-bit2)~=0.0);
     */
    while (mclNeBool(
             mclMinus(mclVv(bit, "bit"), mclVv(bit2, "bit2")), _mxarray1_)) {
        /*
         * nnz=nnz+1;
         */
        mlfAssign(&nnz, mclPlus(mclVv(nnz, "nnz"), _mxarray3_));
        /*
         * bit2=bit.*2.0;
         */
        mlfAssign(&bit2, mclTimes(mclVv(bit, "bit"), _mxarray4_));
        /*
         * bit=bit2+1.0;
         */
        mlfAssign(&bit, mclPlus(mclVv(bit2, "bit2"), _mxarray3_));
    /*
     * end;
     */
    }
    /*
     * bits=nnz-3;
     */
    mlfAssign(&bits, mclMinus(mclVv(nnz, "nnz"), _mxarray13_));
    mclValidateOutput(bits, 1, nargout_, "bits", "genhyper/bits");
    mxDestroyArray(bit2);
    mxDestroyArray(bit);
    mxDestroyArray(nnz);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return bits;
    /*
     * 
     * 
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                   FUNCTION HYPER                             *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Function that sums the Gauss series.          *
     * %     *                                                              *
     * %     *  Subprograms called: ARMULT, ARYDIV, BITS, CMPADD, CMPMUL,   *
     * %     *                      IPREMAX.                                *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_hyper" is the implementation version of the
 * "genhyper/hyper" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 300-759). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [hyper]=hyper(a,b,ip,iq,z,lnpfq,ix,nsigfig);
 */
static mxArray * Mgenhyper_hyper(int nargout_,
                                 mxArray * a,
                                 mxArray * b,
                                 mxArray * ip,
                                 mxArray * iq,
                                 mxArray * z,
                                 mxArray * lnpfq,
                                 mxArray * ix,
                                 mxArray * nsigfig) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * hyper = NULL;
    mxArray * goon1 = NULL;
    mxArray * rexp = NULL;
    mxArray * nmach = NULL;
    mxArray * lmax = NULL;
    mxArray * ixcnt = NULL;
    mxArray * ir10 = NULL;
    mxArray * ii10 = NULL;
    mxArray * icount = NULL;
    mxArray * i = NULL;
    mxArray * temp1 = NULL;
    mxArray * oldtemp = NULL;
    mxArray * cdum2 = NULL;
    mxArray * cdum1 = NULL;
    mxArray * xl = NULL;
    mxArray * x = NULL;
    mxArray * rr10 = NULL;
    mxArray * ri10 = NULL;
    mxArray * mx2 = NULL;
    mxArray * mx1 = NULL;
    mxArray * log2 = NULL;
    mxArray * expon = NULL;
    mxArray * dum2 = NULL;
    mxArray * dum1 = NULL;
    mxArray * creal = NULL;
    mxArray * accy = NULL;
    mxArray * ans = NULL;
    mxArray * length = NULL;
    mxArray * bar2 = NULL;
    mxArray * bar1 = NULL;
    mxArray * xi2 = NULL;
    mxArray * xr2 = NULL;
    mxArray * xi = NULL;
    mxArray * xr = NULL;
    mxArray * ai2 = NULL;
    mxArray * ar2 = NULL;
    mxArray * ai = NULL;
    mxArray * ar = NULL;
    mxArray * numi = NULL;
    mxArray * numr = NULL;
    mxArray * sigfig = NULL;
    mxArray * foo2 = NULL;
    mxArray * cnt = NULL;
    mxArray * foo1 = NULL;
    mxArray * qi2 = NULL;
    mxArray * qr2 = NULL;
    mxArray * ci2 = NULL;
    mxArray * cr2 = NULL;
    mxArray * wk6 = NULL;
    mxArray * wk5 = NULL;
    mxArray * wk4 = NULL;
    mxArray * wk3 = NULL;
    mxArray * wk2 = NULL;
    mxArray * wk1 = NULL;
    mxArray * qi1 = NULL;
    mxArray * qr1 = NULL;
    mxArray * ci = NULL;
    mxArray * i1 = NULL;
    mxArray * cr = NULL;
    mxArray * temp = NULL;
    mxArray * ibit = NULL;
    mxArray * rmax = NULL;
    mxArray * l = NULL;
    mxArray * final = NULL;
    mxArray * denomi = NULL;
    mxArray * denomr = NULL;
    mxArray * sumi = NULL;
    mxArray * sumr = NULL;
    mclCopyArray(&a);
    mclCopyArray(&b);
    mclCopyArray(&ip);
    mclCopyArray(&iq);
    mclCopyArray(&z);
    mclCopyArray(&lnpfq);
    mclCopyArray(&ix);
    mclCopyArray(&nsigfig);
    /*
     * %
     * %
     * % PARAMETER definitions
     * %
     * sumr=[];sumi=[];denomr=[];denomi=[];final=[];l=[];rmax=[];ibit=[];temp=[];cr=[];i1=[];ci=[];qr1=[];qi1=[];wk1=[];wk2=[];wk3=[];wk4=[];wk5=[];wk6=[];cr2=[];ci2=[];qr2=[];qi2=[];foo1=[];cnt=[];foo2=[];sigfig=[];numr=[];numi=[];ar=[];ai=[];ar2=[];ai2=[];xr=[];xi=[];xr2=[];xi2=[];bar1=[];bar2=[];
     */
    mlfAssign(&sumr, _mxarray12_);
    mlfAssign(&sumi, _mxarray12_);
    mlfAssign(&denomr, _mxarray12_);
    mlfAssign(&denomi, _mxarray12_);
    mlfAssign(&final, _mxarray12_);
    mlfAssign(&l, _mxarray12_);
    mlfAssign(&rmax, _mxarray12_);
    mlfAssign(&ibit, _mxarray12_);
    mlfAssign(&temp, _mxarray12_);
    mlfAssign(&cr, _mxarray12_);
    mlfAssign(&i1, _mxarray12_);
    mlfAssign(&ci, _mxarray12_);
    mlfAssign(&qr1, _mxarray12_);
    mlfAssign(&qi1, _mxarray12_);
    mlfAssign(&wk1, _mxarray12_);
    mlfAssign(&wk2, _mxarray12_);
    mlfAssign(&wk3, _mxarray12_);
    mlfAssign(&wk4, _mxarray12_);
    mlfAssign(&wk5, _mxarray12_);
    mlfAssign(&wk6, _mxarray12_);
    mlfAssign(&cr2, _mxarray12_);
    mlfAssign(&ci2, _mxarray12_);
    mlfAssign(&qr2, _mxarray12_);
    mlfAssign(&qi2, _mxarray12_);
    mlfAssign(&foo1, _mxarray12_);
    mlfAssign(&cnt, _mxarray12_);
    mlfAssign(&foo2, _mxarray12_);
    mlfAssign(&sigfig, _mxarray12_);
    mlfAssign(&numr, _mxarray12_);
    mlfAssign(&numi, _mxarray12_);
    mlfAssign(&ar, _mxarray12_);
    mlfAssign(&ai, _mxarray12_);
    mlfAssign(&ar2, _mxarray12_);
    mlfAssign(&ai2, _mxarray12_);
    mlfAssign(&xr, _mxarray12_);
    mlfAssign(&xi, _mxarray12_);
    mlfAssign(&xr2, _mxarray12_);
    mlfAssign(&xi2, _mxarray12_);
    mlfAssign(&bar1, _mxarray12_);
    mlfAssign(&bar2, _mxarray12_);
    /*
     * length=0;
     */
    mlfAssign(&length, _mxarray1_);
    /*
     * length=777;
     */
    mlfAssign(&length, _mxarray16_);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * global  nout;
     * %
     * %
     * %
     * %
     * accy=0;ai=zeros(10,1);ai2=zeros(10,1);ar=zeros(10,1);ar2=zeros(10,1);ci=zeros(10,1);ci2=zeros(10,1);cnt=0;cr=zeros(10,1);cr2=zeros(10,1);creal=0;denomi=zeros(length+2,1);denomr=zeros(length+2,1);dum1=0;dum2=0;expon=0;log2=0;mx1=0;mx2=0;numi=zeros(length+2,1);numr=zeros(length+2,1);qi1=zeros(length+2,1);qi2=zeros(length+2,1);qr1=zeros(length+2,1);qr2=zeros(length+2,1);ri10=0;rmax=0;rr10=0;sigfig=0;sumi=zeros(length+2,1);sumr=zeros(length+2,1);wk1=zeros(length+2,1);wk2=zeros(length+2,1);wk3=zeros(length+2,1);wk4=zeros(length+2,1);wk5=zeros(length+2,1);wk6=zeros(length+2,1);x=0;xi=0;xi2=0;xl=0;xr=0;xr2=0;
     */
    mlfAssign(&accy, _mxarray1_);
    mlfAssign(&ai, mlfZeros(_mxarray0_, _mxarray3_, NULL));
    mlfAssign(&ai2, mlfZeros(_mxarray0_, _mxarray3_, NULL));
    mlfAssign(&ar, mlfZeros(_mxarray0_, _mxarray3_, NULL));
    mlfAssign(&ar2, mlfZeros(_mxarray0_, _mxarray3_, NULL));
    mlfAssign(&ci, mlfZeros(_mxarray0_, _mxarray3_, NULL));
    mlfAssign(&ci2, mlfZeros(_mxarray0_, _mxarray3_, NULL));
    mlfAssign(&cnt, _mxarray1_);
    mlfAssign(&cr, mlfZeros(_mxarray0_, _mxarray3_, NULL));
    mlfAssign(&cr2, mlfZeros(_mxarray0_, _mxarray3_, NULL));
    mlfAssign(&creal, _mxarray1_);
    mlfAssign(
      &denomi,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &denomr,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(&dum1, _mxarray1_);
    mlfAssign(&dum2, _mxarray1_);
    mlfAssign(&expon, _mxarray1_);
    mlfAssign(&log2, _mxarray1_);
    mlfAssign(&mx1, _mxarray1_);
    mlfAssign(&mx2, _mxarray1_);
    mlfAssign(
      &numi,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &numr,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &qi1,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &qi2,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &qr1,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &qr2,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(&ri10, _mxarray1_);
    mlfAssign(&rmax, _mxarray1_);
    mlfAssign(&rr10, _mxarray1_);
    mlfAssign(&sigfig, _mxarray1_);
    mlfAssign(
      &sumi,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &sumr,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &wk1,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &wk2,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &wk3,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &wk4,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &wk5,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &wk6,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(&x, _mxarray1_);
    mlfAssign(&xi, _mxarray1_);
    mlfAssign(&xi2, _mxarray1_);
    mlfAssign(&xl, _mxarray1_);
    mlfAssign(&xr, _mxarray1_);
    mlfAssign(&xr2, _mxarray1_);
    /*
     * %
     * cdum1=0;cdum2=0;final=0;oldtemp=0;temp=0;temp1=0;
     */
    mlfAssign(&cdum1, _mxarray1_);
    mlfAssign(&cdum2, _mxarray1_);
    mlfAssign(&final, _mxarray1_);
    mlfAssign(&oldtemp, _mxarray1_);
    mlfAssign(&temp, _mxarray1_);
    mlfAssign(&temp1, _mxarray1_);
    /*
     * %
     * %
     * %
     * i=0;i1=0;ibit=0;icount=0;ii10=0;ir10=0;ixcnt=0;l=0;lmax=0;nmach=0;rexp=0;
     */
    mlfAssign(&i, _mxarray1_);
    mlfAssign(&i1, _mxarray1_);
    mlfAssign(&ibit, _mxarray1_);
    mlfAssign(&icount, _mxarray1_);
    mlfAssign(&ii10, _mxarray1_);
    mlfAssign(&ir10, _mxarray1_);
    mlfAssign(&ixcnt, _mxarray1_);
    mlfAssign(&l, _mxarray1_);
    mlfAssign(&lmax, _mxarray1_);
    mlfAssign(&nmach, _mxarray1_);
    mlfAssign(&rexp, _mxarray1_);
    /*
     * %
     * %
     * %
     * goon1=0;
     */
    mlfAssign(&goon1, _mxarray1_);
    /*
     * foo1=zeros(length+2,1);foo2=zeros(length+2,1);bar1=zeros(length+2,1);bar2=zeros(length+2,1);
     */
    mlfAssign(
      &foo1,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &foo2,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &bar1,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    mlfAssign(
      &bar2,
      mlfZeros(mclPlus(mclVv(length, "length"), _mxarray4_), _mxarray3_, NULL));
    /*
     * %
     * %
     * zero=0.0d0;
     */
    mlfAssign(mclPrepareGlobal(&zero), _mxarray1_);
    /*
     * log2=log10(two);
     */
    mlfAssign(&log2, mlfLog10(mclVg(&two, "two")));
    /*
     * ibit=fix(bits);
     */
    mlfAssign(&ibit, mlfFix(mlfGenhyper_bits()));
    /*
     * rmax=two.^(fix(ibit./2));
     */
    mlfAssign(
      &rmax,
      mlfPower(
        mclVg(&two, "two"),
        mlfFix(mclRdivide(mclVv(ibit, "ibit"), _mxarray4_))));
    /*
     * sigfig=two.^(fix(ibit./4));
     */
    mlfAssign(
      &sigfig,
      mlfPower(
        mclVg(&two, "two"),
        mlfFix(mclRdivide(mclVv(ibit, "ibit"), _mxarray14_))));
    /*
     * %
     * for i1=1 : ip;
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVa(ip, "ip"));
        if (v_ > e_) {
            mlfAssign(&i1, _mxarray12_);
        } else {
            /*
             * ar2(i1)=real(a(i1)).*sigfig;
             * ar(i1)=fix(ar2(i1));
             * ar2(i1)=round((ar2(i1)-ar(i1)).*rmax);
             * ai2(i1)=imag(a(i1)).*sigfig;
             * ai(i1)=fix(ai2(i1));
             * ai2(i1)=round((ai2(i1)-ai(i1)).*rmax);
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(
                  &ar2,
                  mclTimes(
                    mlfReal(mclIntArrayRef1(mclVa(a, "a"), v_)),
                    mclVv(sigfig, "sigfig")),
                  v_);
                mclIntArrayAssign1(
                  &ar, mlfFix(mclIntArrayRef1(mclVv(ar2, "ar2"), v_)), v_);
                mclIntArrayAssign1(
                  &ar2,
                  mlfRound(
                    mclTimes(
                      mclMinus(
                        mclIntArrayRef1(mclVv(ar2, "ar2"), v_),
                        mclIntArrayRef1(mclVv(ar, "ar"), v_)),
                      mclVv(rmax, "rmax"))),
                  v_);
                mclIntArrayAssign1(
                  &ai2,
                  mclTimes(
                    mlfImag(mclIntArrayRef1(mclVa(a, "a"), v_)),
                    mclVv(sigfig, "sigfig")),
                  v_);
                mclIntArrayAssign1(
                  &ai, mlfFix(mclIntArrayRef1(mclVv(ai2, "ai2"), v_)), v_);
                mclIntArrayAssign1(
                  &ai2,
                  mlfRound(
                    mclTimes(
                      mclMinus(
                        mclIntArrayRef1(mclVv(ai2, "ai2"), v_),
                        mclIntArrayRef1(mclVv(ai, "ai"), v_)),
                      mclVv(rmax, "rmax"))),
                  v_);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i1, mlfScalar(v_));
        }
    }
    /*
     * for i1=1 : iq;
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVa(iq, "iq"));
        if (v_ > e_) {
            mlfAssign(&i1, _mxarray12_);
        } else {
            /*
             * cr2(i1)=real(b(i1)).*sigfig;
             * cr(i1)=fix(cr2(i1));
             * cr2(i1)=round((cr2(i1)-cr(i1)).*rmax);
             * ci2(i1)=imag(b(i1)).*sigfig;
             * ci(i1)=fix(ci2(i1));
             * ci2(i1)=round((ci2(i1)-ci(i1)).*rmax);
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(
                  &cr2,
                  mclTimes(
                    mlfReal(mclIntArrayRef1(mclVa(b, "b"), v_)),
                    mclVv(sigfig, "sigfig")),
                  v_);
                mclIntArrayAssign1(
                  &cr, mlfFix(mclIntArrayRef1(mclVv(cr2, "cr2"), v_)), v_);
                mclIntArrayAssign1(
                  &cr2,
                  mlfRound(
                    mclTimes(
                      mclMinus(
                        mclIntArrayRef1(mclVv(cr2, "cr2"), v_),
                        mclIntArrayRef1(mclVv(cr, "cr"), v_)),
                      mclVv(rmax, "rmax"))),
                  v_);
                mclIntArrayAssign1(
                  &ci2,
                  mclTimes(
                    mlfImag(mclIntArrayRef1(mclVa(b, "b"), v_)),
                    mclVv(sigfig, "sigfig")),
                  v_);
                mclIntArrayAssign1(
                  &ci, mlfFix(mclIntArrayRef1(mclVv(ci2, "ci2"), v_)), v_);
                mclIntArrayAssign1(
                  &ci2,
                  mlfRound(
                    mclTimes(
                      mclMinus(
                        mclIntArrayRef1(mclVv(ci2, "ci2"), v_),
                        mclIntArrayRef1(mclVv(ci, "ci"), v_)),
                      mclVv(rmax, "rmax"))),
                  v_);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i1, mlfScalar(v_));
        }
    }
    /*
     * xr2=real(z).*sigfig;
     */
    mlfAssign(&xr2, mclTimes(mlfReal(mclVa(z, "z")), mclVv(sigfig, "sigfig")));
    /*
     * xr=fix(xr2);
     */
    mlfAssign(&xr, mlfFix(mclVv(xr2, "xr2")));
    /*
     * xr2=round((xr2-xr).*rmax);
     */
    mlfAssign(
      &xr2,
      mlfRound(
        mclTimes(
          mclMinus(mclVv(xr2, "xr2"), mclVv(xr, "xr")), mclVv(rmax, "rmax"))));
    /*
     * xi2=imag(z).*sigfig;
     */
    mlfAssign(&xi2, mclTimes(mlfImag(mclVa(z, "z")), mclVv(sigfig, "sigfig")));
    /*
     * xi=fix(xi2);
     */
    mlfAssign(&xi, mlfFix(mclVv(xi2, "xi2")));
    /*
     * xi2=round((xi2-xi).*rmax);
     */
    mlfAssign(
      &xi2,
      mlfRound(
        mclTimes(
          mclMinus(mclVv(xi2, "xi2"), mclVv(xi, "xi")), mclVv(rmax, "rmax"))));
    /*
     * %
     * %     WARN THE USER THAT THE INPUT VALUE WAS SO CLOSE TO ZERO THAT IT
     * %     WAS SET EQUAL TO ZERO.
     * %
     * for i1=1 : ip;
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVa(ip, "ip"));
        if (v_ > e_) {
            mlfAssign(&i1, _mxarray12_);
        } else {
            /*
             * if ((real(a(i1))~=0.0) & (ar(i1)==0.0) & (ar2(i1)==0.0));
             * i1,
             * end;
             * %format (1x,'warning - real part of a(',1i2,') was set to zero');
             * if ((imag(a(i1))~=0.0) & (ai(i1)==0.0) & (ai2(i1)==0.0));
             * i1,
             * end;
             * %format (1x,'warning - imag part of a(',1i2,') was set to zero');
             * end;
             */
            for (; ; ) {
                mxArray * a_
                  = mclInitialize(
                      mclNe(
                        mlfReal(mclIntArrayRef1(mclVa(a, "a"), v_)),
                        _mxarray1_));
                if (mlfTobool(a_)) {
                    mlfAssign(
                      &a_,
                      mclAnd(
                        a_,
                        mclEq(
                          mclIntArrayRef1(mclVv(ar, "ar"), v_), _mxarray1_)));
                } else {
                    mlfAssign(&a_, mlfScalar(0));
                }
                if (mlfTobool(a_)
                    && mlfTobool(
                         mclAnd(
                           a_,
                           mclEq(
                             mclIntArrayRef1(mclVv(ar2, "ar2"), v_),
                             _mxarray1_)))) {
                    mxDestroyArray(a_);
                    mclPrintArray(mlfScalar(v_), "i1");
                } else {
                    mxDestroyArray(a_);
                }
                {
                    mxArray * a_
                      = mclInitialize(
                          mclNe(
                            mlfImag(mclIntArrayRef1(mclVa(a, "a"), v_)),
                            _mxarray1_));
                    if (mlfTobool(a_)) {
                        mlfAssign(
                          &a_,
                          mclAnd(
                            a_,
                            mclEq(
                              mclIntArrayRef1(mclVv(ai, "ai"), v_),
                              _mxarray1_)));
                    } else {
                        mlfAssign(&a_, mlfScalar(0));
                    }
                    if (mlfTobool(a_)
                        && mlfTobool(
                             mclAnd(
                               a_,
                               mclEq(
                                 mclIntArrayRef1(mclVv(ai2, "ai2"), v_),
                                 _mxarray1_)))) {
                        mxDestroyArray(a_);
                        mclPrintArray(mlfScalar(v_), "i1");
                    } else {
                        mxDestroyArray(a_);
                    }
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i1, mlfScalar(v_));
        }
    }
    /*
     * for i1=1 : iq;
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVa(iq, "iq"));
        if (v_ > e_) {
            mlfAssign(&i1, _mxarray12_);
        } else {
            /*
             * if ((real(b(i1))~=0.0) & (cr(i1)==0.0) & (cr2(i1)==0.0));
             * i1,
             * end;
             * %format (1x,'warning - real part of b(',1i2,') was set to zero');
             * if ((imag(b(i1))~=0.0) & (ci(i1)==0.0) & (ci2(i1)==0.0));
             * i1,
             * end;
             * %format (1x,'warning - imag part of b(',1i2,') was set to zero');
             * end;
             */
            for (; ; ) {
                mxArray * a_
                  = mclInitialize(
                      mclNe(
                        mlfReal(mclIntArrayRef1(mclVa(b, "b"), v_)),
                        _mxarray1_));
                if (mlfTobool(a_)) {
                    mlfAssign(
                      &a_,
                      mclAnd(
                        a_,
                        mclEq(
                          mclIntArrayRef1(mclVv(cr, "cr"), v_), _mxarray1_)));
                } else {
                    mlfAssign(&a_, mlfScalar(0));
                }
                if (mlfTobool(a_)
                    && mlfTobool(
                         mclAnd(
                           a_,
                           mclEq(
                             mclIntArrayRef1(mclVv(cr2, "cr2"), v_),
                             _mxarray1_)))) {
                    mxDestroyArray(a_);
                    mclPrintArray(mlfScalar(v_), "i1");
                } else {
                    mxDestroyArray(a_);
                }
                {
                    mxArray * a_
                      = mclInitialize(
                          mclNe(
                            mlfImag(mclIntArrayRef1(mclVa(b, "b"), v_)),
                            _mxarray1_));
                    if (mlfTobool(a_)) {
                        mlfAssign(
                          &a_,
                          mclAnd(
                            a_,
                            mclEq(
                              mclIntArrayRef1(mclVv(ci, "ci"), v_),
                              _mxarray1_)));
                    } else {
                        mlfAssign(&a_, mlfScalar(0));
                    }
                    if (mlfTobool(a_)
                        && mlfTobool(
                             mclAnd(
                               a_,
                               mclEq(
                                 mclIntArrayRef1(mclVv(ci2, "ci2"), v_),
                                 _mxarray1_)))) {
                        mxDestroyArray(a_);
                        mclPrintArray(mlfScalar(v_), "i1");
                    } else {
                        mxDestroyArray(a_);
                    }
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i1, mlfScalar(v_));
        }
    }
    /*
     * if ((real(z)~=0.0) & (xr==0.0) & (xr2==0.0)) ;
     */
    {
        mxArray * a_ = mclInitialize(mclNe(mlfReal(mclVa(z, "z")), _mxarray1_));
        if (mlfTobool(a_)) {
            mlfAssign(&a_, mclAnd(a_, mclEq(mclVv(xr, "xr"), _mxarray1_)));
        } else {
            mlfAssign(&a_, mlfScalar(0));
        }
        if (mlfTobool(a_)
            && mlfTobool(mclAnd(a_, mclEq(mclVv(xr2, "xr2"), _mxarray1_)))) {
            mxDestroyArray(a_);
            /*
             * ' warning - real part of z was set to zero',
             */
            mclPrintAns(&ans, _mxarray17_);
            /*
             * z=complex(0.0,imag(z));
             */
            mlfAssign(&z, mlfComplex(_mxarray1_, mlfImag(mclVa(z, "z"))));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * if ((imag(z)~=0.0) & (xi==0.0) & (xi2==0.0)) ;
     */
    {
        mxArray * a_ = mclInitialize(mclNe(mlfImag(mclVa(z, "z")), _mxarray1_));
        if (mlfTobool(a_)) {
            mlfAssign(&a_, mclAnd(a_, mclEq(mclVv(xi, "xi"), _mxarray1_)));
        } else {
            mlfAssign(&a_, mlfScalar(0));
        }
        if (mlfTobool(a_)
            && mlfTobool(mclAnd(a_, mclEq(mclVv(xi2, "xi2"), _mxarray1_)))) {
            mxDestroyArray(a_);
            /*
             * ' warning - imag part of z was set to zero',
             */
            mclPrintAns(&ans, _mxarray19_);
            /*
             * z=complex(real(z),0.0);
             */
            mlfAssign(&z, mlfComplex(mlfReal(mclVa(z, "z")), _mxarray1_));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * %
     * %
     * %     SCREENING OF NUMERATOR ARGUMENTS FOR NEGATIVE INTEGERS OR ZERO.
     * %     ICOUNT WILL FORCE THE SERIES TO TERMINATE CORRECTLY.
     * %
     * nmach=fix(log10(two.^fix(bits)));
     */
    mlfAssign(
      &nmach,
      mlfFix(
        mlfLog10(mlfPower(mclVg(&two, "two"), mlfFix(mlfGenhyper_bits())))));
    /*
     * icount=-1;
     */
    mlfAssign(&icount, _mxarray21_);
    /*
     * for i1=1 : ip;
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVa(ip, "ip"));
        if (v_ > e_) {
            mlfAssign(&i1, _mxarray12_);
        } else {
            /*
             * if ((ar2(i1)==0.0) & (ar(i1)==0.0) & (ai2(i1)==0.0) &(ai(i1)==0.0)) ;
             * hyper=complex(one,0.0);
             * return;
             * end;
             * if ((ai(i1)==0.0) & (ai2(i1)==0.0) & (real(a(i1))<0.0));
             * if (abs(real(a(i1))-real(round(real(a(i1)))))<ten.^(-nmach)) ;
             * if (icount~=-1) ;
             * icount=min([icount,-round(real(a(i1)))]);
             * else;
             * icount=-round(real(a(i1)));
             * end;
             * end;
             * end;
             * end;
             */
            for (; ; ) {
                mxArray * a_
                  = mclInitialize(
                      mclEq(
                        mclIntArrayRef1(mclVv(ar2, "ar2"), v_), _mxarray1_));
                if (mlfTobool(a_)) {
                    mlfAssign(
                      &a_,
                      mclAnd(
                        a_,
                        mclEq(
                          mclIntArrayRef1(mclVv(ar, "ar"), v_), _mxarray1_)));
                } else {
                    mlfAssign(&a_, mlfScalar(0));
                }
                if (mlfTobool(a_)) {
                    mlfAssign(
                      &a_,
                      mclAnd(
                        a_,
                        mclEq(
                          mclIntArrayRef1(mclVv(ai2, "ai2"), v_), _mxarray1_)));
                } else {
                    mlfAssign(&a_, mlfScalar(0));
                }
                if (mlfTobool(a_)
                    && mlfTobool(
                         mclAnd(
                           a_,
                           mclEq(
                             mclIntArrayRef1(mclVv(ai, "ai"), v_),
                             _mxarray1_)))) {
                    mxDestroyArray(a_);
                    mlfAssign(
                      &hyper, mlfComplex(mclVg(&one, "one"), _mxarray1_));
                    goto return_;
                } else {
                    mxDestroyArray(a_);
                }
                {
                    mxArray * a_
                      = mclInitialize(
                          mclEq(
                            mclIntArrayRef1(mclVv(ai, "ai"), v_), _mxarray1_));
                    if (mlfTobool(a_)) {
                        mlfAssign(
                          &a_,
                          mclAnd(
                            a_,
                            mclEq(
                              mclIntArrayRef1(mclVv(ai2, "ai2"), v_),
                              _mxarray1_)));
                    } else {
                        mlfAssign(&a_, mlfScalar(0));
                    }
                    if (mlfTobool(a_)
                        && mlfTobool(
                             mclAnd(
                               a_,
                               mclLt(
                                 mlfReal(mclIntArrayRef1(mclVa(a, "a"), v_)),
                                 _mxarray1_)))) {
                        mxDestroyArray(a_);
                        if (mclLtBool(
                              mlfAbs(
                                mclMinus(
                                  mlfReal(mclIntArrayRef1(mclVa(a, "a"), v_)),
                                  mlfReal(
                                    mlfRound(
                                      mlfReal(
                                        mclIntArrayRef1(mclVa(a, "a"), v_)))))),
                              mlfPower(
                                mclVg(&ten, "ten"),
                                mclUminus(mclVv(nmach, "nmach"))))) {
                            if (mclNeBool(
                                  mclVv(icount, "icount"), _mxarray21_)) {
                                mlfAssign(
                                  &icount,
                                  mlfMin(
                                    NULL,
                                    mlfHorzcat(
                                      mclVv(icount, "icount"),
                                      mclUminus(
                                        mlfRound(
                                          mlfReal(
                                            mclIntArrayRef1(
                                              mclVa(a, "a"), v_)))),
                                      NULL),
                                    NULL,
                                    NULL));
                            } else {
                                mlfAssign(
                                  &icount,
                                  mclUminus(
                                    mlfRound(
                                      mlfReal(
                                        mclIntArrayRef1(mclVa(a, "a"), v_)))));
                            }
                        }
                    } else {
                        mxDestroyArray(a_);
                    }
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i1, mlfScalar(v_));
        }
    }
    /*
     * %
     * %     SCREENING OF DENOMINATOR ARGUMENTS FOR ZEROES OR NEGATIVE INTEGERS
     * %     .
     * %
     * for i1=1 : iq;
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVa(iq, "iq"));
        if (v_ > e_) {
            mlfAssign(&i1, _mxarray12_);
        } else {
            /*
             * if ((cr(i1)==0.0) & (cr2(i1)==0.0) & (ci(i1)==0.0) &(ci2(i1)==0.0)) ;
             * i1,
             * %format (1x,'error - argument b(',1i2,') was equal to zero');
             * error('stop encountered in original fortran code');
             * end;
             * if ((ci(i1)==0.0) & (ci2(i1)==0.0) & (real(b(i1))<0.0));
             * if ((abs(real(b(i1))-real(round(real(b(i1)))))<ten.^(-nmach)) &(icount>=-round(real(b(i1))) | icount==-1)) ;
             * i1,
             * %format (1x,'error - argument b(',1i2,') was a negative',' integer');
             * error('stop encountered in original fortran code');
             * end;
             * end;
             * end;
             */
            for (; ; ) {
                mxArray * a_
                  = mclInitialize(
                      mclEq(mclIntArrayRef1(mclVv(cr, "cr"), v_), _mxarray1_));
                if (mlfTobool(a_)) {
                    mlfAssign(
                      &a_,
                      mclAnd(
                        a_,
                        mclEq(
                          mclIntArrayRef1(mclVv(cr2, "cr2"), v_), _mxarray1_)));
                } else {
                    mlfAssign(&a_, mlfScalar(0));
                }
                if (mlfTobool(a_)) {
                    mlfAssign(
                      &a_,
                      mclAnd(
                        a_,
                        mclEq(
                          mclIntArrayRef1(mclVv(ci, "ci"), v_), _mxarray1_)));
                } else {
                    mlfAssign(&a_, mlfScalar(0));
                }
                if (mlfTobool(a_)
                    && mlfTobool(
                         mclAnd(
                           a_,
                           mclEq(
                             mclIntArrayRef1(mclVv(ci2, "ci2"), v_),
                             _mxarray1_)))) {
                    mxDestroyArray(a_);
                    mclPrintArray(mlfScalar(v_), "i1");
                    mlfError(_mxarray9_, NULL);
                } else {
                    mxDestroyArray(a_);
                }
                {
                    mxArray * a_
                      = mclInitialize(
                          mclEq(
                            mclIntArrayRef1(mclVv(ci, "ci"), v_), _mxarray1_));
                    if (mlfTobool(a_)) {
                        mlfAssign(
                          &a_,
                          mclAnd(
                            a_,
                            mclEq(
                              mclIntArrayRef1(mclVv(ci2, "ci2"), v_),
                              _mxarray1_)));
                    } else {
                        mlfAssign(&a_, mlfScalar(0));
                    }
                    if (mlfTobool(a_)
                        && mlfTobool(
                             mclAnd(
                               a_,
                               mclLt(
                                 mlfReal(mclIntArrayRef1(mclVa(b, "b"), v_)),
                                 _mxarray1_)))) {
                        mxDestroyArray(a_);
                        {
                            mxArray * a_0
                              = mclInitialize(
                                  mclLt(
                                    mlfAbs(
                                      mclMinus(
                                        mlfReal(
                                          mclIntArrayRef1(mclVa(b, "b"), v_)),
                                        mlfReal(
                                          mlfRound(
                                            mlfReal(
                                              mclIntArrayRef1(
                                                mclVa(b, "b"), v_)))))),
                                    mlfPower(
                                      mclVg(&ten, "ten"),
                                      mclUminus(mclVv(nmach, "nmach")))));
                            if (mlfTobool(a_0)) {
                                mxArray * b_
                                  = mclInitialize(
                                      mclGe(
                                        mclVv(icount, "icount"),
                                        mclUminus(
                                          mlfRound(
                                            mlfReal(
                                              mclIntArrayRef1(
                                                mclVa(b, "b"), v_))))));
                                if (mlfTobool(b_)) {
                                    mlfAssign(&b_, mlfScalar(1));
                                } else {
                                    mlfAssign(
                                      &b_,
                                      mclOr(
                                        b_,
                                        mclEq(
                                          mclVv(icount, "icount"),
                                          _mxarray21_)));
                                }
                                {
                                    mxLogical c_0 = mlfTobool(mclAnd(a_0, b_));
                                    mxDestroyArray(b_);
                                    mxDestroyArray(a_0);
                                    if (c_0) {
                                        mclPrintArray(mlfScalar(v_), "i1");
                                        mlfError(_mxarray9_, NULL);
                                    }
                                }
                            } else {
                                mxDestroyArray(a_0);
                            }
                        }
                    } else {
                        mxDestroyArray(a_);
                    }
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i1, mlfScalar(v_));
        }
    }
    /*
     * %
     * nmach=fix(log10(two.^ibit));
     */
    mlfAssign(
      &nmach,
      mlfFix(mlfLog10(mlfPower(mclVg(&two, "two"), mclVv(ibit, "ibit")))));
    /*
     * nsigfig=min([nsigfig,fix(log10(two.^ibit))]);
     */
    mlfAssign(
      &nsigfig,
      mlfMin(
        NULL,
        mlfHorzcat(
          mclVa(nsigfig, "nsigfig"),
          mlfFix(mlfLog10(mlfPower(mclVg(&two, "two"), mclVv(ibit, "ibit")))),
          NULL),
        NULL,
        NULL));
    /*
     * accy=ten.^(-nsigfig);
     */
    mlfAssign(
      &accy,
      mlfPower(mclVg(&ten, "ten"), mclUminus(mclVa(nsigfig, "nsigfig"))));
    /*
     * l=ipremax(a,b,ip,iq,z);
     */
    mlfAssign(
      &l,
      mlfGenhyper_ipremax(
        mclVa(a, "a"),
        mclVa(b, "b"),
        mclVa(ip, "ip"),
        mclVa(iq, "iq"),
        mclVa(z, "z")));
    /*
     * if (l~=1) ;
     */
    if (mclNeBool(mclVv(l, "l"), _mxarray3_)) {
        /*
         * %
         * %     First, estimate the exponent of the maximum term in the pFq series
         * %     .
         * %
         * expon=0.0;
         */
        mlfAssign(&expon, _mxarray1_);
        /*
         * xl=real(l);
         */
        mlfAssign(&xl, mlfReal(mclVv(l, "l")));
        /*
         * for i=1 : ip;
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVa(ip, "ip"));
            if (v_ > e_) {
                mlfAssign(&i, _mxarray12_);
            } else {
                /*
                 * expon=expon+real(factor(a(i)+xl-one))-real(factor(a(i)-one));
                 * end;
                 */
                for (; ; ) {
                    mlfAssign(
                      &expon,
                      mclMinus(
                        mclPlus(
                          mclVv(expon, "expon"),
                          mlfReal(
                            mlfGenhyper_factor(
                              mclMinus(
                                mclPlus(
                                  mclIntArrayRef1(mclVa(a, "a"), v_),
                                  mclVv(xl, "xl")),
                                mclVg(&one, "one"))))),
                        mlfReal(
                          mlfGenhyper_factor(
                            mclMinus(
                              mclIntArrayRef1(mclVa(a, "a"), v_),
                              mclVg(&one, "one"))))));
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i, mlfScalar(v_));
            }
        }
        /*
         * for i=1 : iq;
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVa(iq, "iq"));
            if (v_ > e_) {
                mlfAssign(&i, _mxarray12_);
            } else {
                /*
                 * expon=expon-real(factor(b(i)+xl-one))+real(factor(b(i)-one));
                 * end;
                 */
                for (; ; ) {
                    mlfAssign(
                      &expon,
                      mclPlus(
                        mclMinus(
                          mclVv(expon, "expon"),
                          mlfReal(
                            mlfGenhyper_factor(
                              mclMinus(
                                mclPlus(
                                  mclIntArrayRef1(mclVa(b, "b"), v_),
                                  mclVv(xl, "xl")),
                                mclVg(&one, "one"))))),
                        mlfReal(
                          mlfGenhyper_factor(
                            mclMinus(
                              mclIntArrayRef1(mclVa(b, "b"), v_),
                              mclVg(&one, "one"))))));
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i, mlfScalar(v_));
            }
        }
        /*
         * expon=expon+xl.*real(log(z))-real(factor(complex(xl,0.0)));
         */
        mlfAssign(
          &expon,
          mclMinus(
            mclPlus(
              mclVv(expon, "expon"),
              mclTimes(mclVv(xl, "xl"), mlfReal(mlfLog(mclVa(z, "z"))))),
            mlfReal(
              mlfGenhyper_factor(mlfComplex(mclVv(xl, "xl"), _mxarray1_)))));
        /*
         * lmax=fix(log10(exp(one)).*expon);
         */
        mlfAssign(
          &lmax,
          mlfFix(
            mclTimes(
              mlfLog10(mlfExp(mclVg(&one, "one"))), mclVv(expon, "expon"))));
        /*
         * l=lmax;
         */
        mlfAssign(&l, mclVv(lmax, "lmax"));
        /*
         * %
         * %     Now, estimate the exponent of where the pFq series will terminate.
         * %
         * temp1=complex(one,0.0);
         */
        mlfAssign(&temp1, mlfComplex(mclVg(&one, "one"), _mxarray1_));
        /*
         * creal=one;
         */
        mlfAssign(&creal, mclVg(&one, "one"));
        /*
         * for i1=1 : ip;
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVa(ip, "ip"));
            if (v_ > e_) {
                mlfAssign(&i1, _mxarray12_);
            } else {
                /*
                 * temp1=temp1.*complex(ar(i1),ai(i1))./sigfig;
                 * end;
                 */
                for (; ; ) {
                    mlfAssign(
                      &temp1,
                      mclRdivide(
                        mclTimes(
                          mclVv(temp1, "temp1"),
                          mlfComplex(
                            mclIntArrayRef1(mclVv(ar, "ar"), v_),
                            mclIntArrayRef1(mclVv(ai, "ai"), v_))),
                        mclVv(sigfig, "sigfig")));
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i1, mlfScalar(v_));
            }
        }
        /*
         * for i1=1 : iq;
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVa(iq, "iq"));
            if (v_ > e_) {
                mlfAssign(&i1, _mxarray12_);
            } else {
                /*
                 * temp1=temp1./(complex(cr(i1),ci(i1))./sigfig);
                 * creal=creal.*cr(i1);
                 * end;
                 */
                for (; ; ) {
                    mlfAssign(
                      &temp1,
                      mclRdivide(
                        mclVv(temp1, "temp1"),
                        mclRdivide(
                          mlfComplex(
                            mclIntArrayRef1(mclVv(cr, "cr"), v_),
                            mclIntArrayRef1(mclVv(ci, "ci"), v_)),
                          mclVv(sigfig, "sigfig"))));
                    mlfAssign(
                      &creal,
                      mclTimes(
                        mclVv(creal, "creal"),
                        mclIntArrayRef1(mclVv(cr, "cr"), v_)));
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i1, mlfScalar(v_));
            }
        }
        /*
         * temp1=temp1.*complex(xr,xi);
         */
        mlfAssign(
          &temp1,
          mclTimes(
            mclVv(temp1, "temp1"),
            mlfComplex(mclVv(xr, "xr"), mclVv(xi, "xi"))));
        /*
         * %
         * %     Triple it to make sure.
         * %
         * l=3.*l;
         */
        mlfAssign(&l, mclTimes(_mxarray13_, mclVv(l, "l")));
        /*
         * %
         * %     Divide the number of significant figures necessary by the number
         * %     of
         * %     digits available per array position.
         * %
         * %
         * l=fix((2.*l+nsigfig)./nmach)+2;
         */
        mlfAssign(
          &l,
          mclPlus(
            mlfFix(
              mclRdivide(
                mclPlus(
                  mclTimes(_mxarray4_, mclVv(l, "l")),
                  mclVa(nsigfig, "nsigfig")),
                mclVv(nmach, "nmach"))),
            _mxarray4_));
    /*
     * end;
     */
    }
    /*
     * %
     * %     Make sure there are at least 5 array positions used.
     * %
     * l=max([l,5]);
     */
    mlfAssign(
      &l,
      mlfMax(NULL, mlfHorzcat(mclVv(l, "l"), _mxarray15_, NULL), NULL, NULL));
    /*
     * l=max([l,ix]);
     */
    mlfAssign(
      &l,
      mlfMax(
        NULL, mlfHorzcat(mclVv(l, "l"), mclVa(ix, "ix"), NULL), NULL, NULL));
    /*
     * %     write (6,*) ' Estimated value of L=',L
     * if ((l<0) | (l>length)) ;
     */
    {
        mxArray * a_ = mclInitialize(mclLt(mclVv(l, "l"), _mxarray1_));
        if (mlfTobool(a_)
            || mlfTobool(
                 mclOr(a_, mclGt(mclVv(l, "l"), mclVv(length, "length"))))) {
            mxDestroyArray(a_);
            /*
             * length,
             */
            mclPrintArray(mclVv(length, "length"), "length");
            /*
             * %format (1x,['error in fn hyper: l must be < '],1i4);
             * error('stop encountered in original fortran code');
             */
            mlfError(_mxarray9_, NULL);
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * if (nsigfig>nmach) ;
     */
    if (mclGtBool(mclVa(nsigfig, "nsigfig"), mclVv(nmach, "nmach"))) {
        /*
         * nmach,
         */
        mclPrintArray(mclVv(nmach, "nmach"), "nmach");
    /*
     * %format (1x,' warning--the number of significant figures requ','ested',./,'is greater than the machine precision--','final answer',./,'will be accurate to only',i3,' digits');
     * end;
     */
    }
    /*
     * %
     * sumr(-1+2)=one;
     */
    mclIntArrayAssign1(&sumr, mclVg(&one, "one"), 1);
    /*
     * sumi(-1+2)=one;
     */
    mclIntArrayAssign1(&sumi, mclVg(&one, "one"), 1);
    /*
     * numr(-1+2)=one;
     */
    mclIntArrayAssign1(&numr, mclVg(&one, "one"), 1);
    /*
     * numi(-1+2)=one;
     */
    mclIntArrayAssign1(&numi, mclVg(&one, "one"), 1);
    /*
     * denomr(-1+2)=one;
     */
    mclIntArrayAssign1(&denomr, mclVg(&one, "one"), 1);
    /*
     * denomi(-1+2)=one;
     */
    mclIntArrayAssign1(&denomi, mclVg(&one, "one"), 1);
    /*
     * for i=0 : l+1;
     */
    {
        int v_ = mclForIntStart(0);
        int e_ = mclForIntEnd(mclPlus(mclVv(l, "l"), _mxarray3_));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray12_);
        } else {
            /*
             * sumr(i+2)=0.0;
             * sumi(i+2)=0.0;
             * numr(i+2)=0.0;
             * numi(i+2)=0.0;
             * denomr(i+2)=0.0;
             * denomi(i+2)=0.0;
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(&sumr, _mxarray1_, v_ + 2);
                mclIntArrayAssign1(&sumi, _mxarray1_, v_ + 2);
                mclIntArrayAssign1(&numr, _mxarray1_, v_ + 2);
                mclIntArrayAssign1(&numi, _mxarray1_, v_ + 2);
                mclIntArrayAssign1(&denomr, _mxarray1_, v_ + 2);
                mclIntArrayAssign1(&denomi, _mxarray1_, v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * sumr(1+2)=one;
     */
    mclIntArrayAssign1(&sumr, mclVg(&one, "one"), 3);
    /*
     * numr(1+2)=one;
     */
    mclIntArrayAssign1(&numr, mclVg(&one, "one"), 3);
    /*
     * denomr(1+2)=one;
     */
    mclIntArrayAssign1(&denomr, mclVg(&one, "one"), 3);
    /*
     * cnt=sigfig;
     */
    mlfAssign(&cnt, mclVv(sigfig, "sigfig"));
    /*
     * temp=complex(0.0,0.0);
     */
    mlfAssign(&temp, mlfComplex(_mxarray1_, _mxarray1_));
    /*
     * oldtemp=temp;
     */
    mlfAssign(&oldtemp, mclVv(temp, "temp"));
    /*
     * ixcnt=0;
     */
    mlfAssign(&ixcnt, _mxarray1_);
    /*
     * rexp=fix(ibit./2);
     */
    mlfAssign(&rexp, mlfFix(mclRdivide(mclVv(ibit, "ibit"), _mxarray4_)));
    /*
     * x=rexp.*(sumr(l+1+2)-2);
     */
    mlfAssign(
      &x,
      mclTimes(
        mclVv(rexp, "rexp"),
        mclMinus(
          mclArrayRef1(
            mclVv(sumr, "sumr"),
            mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
          _mxarray4_)));
    /*
     * rr10=x.*log2;
     */
    mlfAssign(&rr10, mclTimes(mclVv(x, "x"), mclVv(log2, "log2")));
    /*
     * ir10=fix(rr10);
     */
    mlfAssign(&ir10, mlfFix(mclVv(rr10, "rr10")));
    /*
     * rr10=rr10-ir10;
     */
    mlfAssign(&rr10, mclMinus(mclVv(rr10, "rr10"), mclVv(ir10, "ir10")));
    /*
     * x=rexp.*(sumi(l+1+2)-2);
     */
    mlfAssign(
      &x,
      mclTimes(
        mclVv(rexp, "rexp"),
        mclMinus(
          mclArrayRef1(
            mclVv(sumi, "sumi"),
            mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
          _mxarray4_)));
    /*
     * ri10=x.*log2;
     */
    mlfAssign(&ri10, mclTimes(mclVv(x, "x"), mclVv(log2, "log2")));
    /*
     * ii10=fix(ri10);
     */
    mlfAssign(&ii10, mlfFix(mclVv(ri10, "ri10")));
    /*
     * ri10=ri10-ii10;
     */
    mlfAssign(&ri10, mclMinus(mclVv(ri10, "ri10"), mclVv(ii10, "ii10")));
    /*
     * dum1=(abs(sumr(1+2).*rmax.*rmax+sumr(2+2).*rmax+sumr(3+2)).*sign(sumr(-1+2)));
     */
    mlfAssign(
      &dum1,
      mclTimes(
        mlfAbs(
          mclPlus(
            mclPlus(
              mclTimes(
                mclTimes(
                  mclIntArrayRef1(mclVv(sumr, "sumr"), 3), mclVv(rmax, "rmax")),
                mclVv(rmax, "rmax")),
              mclTimes(
                mclIntArrayRef1(mclVv(sumr, "sumr"), 4), mclVv(rmax, "rmax"))),
            mclIntArrayRef1(mclVv(sumr, "sumr"), 5))),
        mlfSign(mclIntArrayRef1(mclVv(sumr, "sumr"), 1))));
    /*
     * dum2=(abs(sumi(1+2).*rmax.*rmax+sumi(2+2).*rmax+sumi(3+2)).*sign(sumi(-1+2)));
     */
    mlfAssign(
      &dum2,
      mclTimes(
        mlfAbs(
          mclPlus(
            mclPlus(
              mclTimes(
                mclTimes(
                  mclIntArrayRef1(mclVv(sumi, "sumi"), 3), mclVv(rmax, "rmax")),
                mclVv(rmax, "rmax")),
              mclTimes(
                mclIntArrayRef1(mclVv(sumi, "sumi"), 4), mclVv(rmax, "rmax"))),
            mclIntArrayRef1(mclVv(sumi, "sumi"), 5))),
        mlfSign(mclIntArrayRef1(mclVv(sumi, "sumi"), 1))));
    /*
     * dum1=dum1.*10.^rr10;
     */
    mlfAssign(
      &dum1,
      mclTimes(mclVv(dum1, "dum1"), mlfPower(_mxarray0_, mclVv(rr10, "rr10"))));
    /*
     * dum2=dum2.*10.^ri10;
     */
    mlfAssign(
      &dum2,
      mclTimes(mclVv(dum2, "dum2"), mlfPower(_mxarray0_, mclVv(ri10, "ri10"))));
    /*
     * cdum1=complex(dum1,dum2);
     */
    mlfAssign(&cdum1, mlfComplex(mclVv(dum1, "dum1"), mclVv(dum2, "dum2")));
    /*
     * x=rexp.*(denomr(l+1+2)-2);
     */
    mlfAssign(
      &x,
      mclTimes(
        mclVv(rexp, "rexp"),
        mclMinus(
          mclArrayRef1(
            mclVv(denomr, "denomr"),
            mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
          _mxarray4_)));
    /*
     * rr10=x.*log2;
     */
    mlfAssign(&rr10, mclTimes(mclVv(x, "x"), mclVv(log2, "log2")));
    /*
     * ir10=fix(rr10);
     */
    mlfAssign(&ir10, mlfFix(mclVv(rr10, "rr10")));
    /*
     * rr10=rr10-ir10;
     */
    mlfAssign(&rr10, mclMinus(mclVv(rr10, "rr10"), mclVv(ir10, "ir10")));
    /*
     * x=rexp.*(denomi(l+1+2)-2);
     */
    mlfAssign(
      &x,
      mclTimes(
        mclVv(rexp, "rexp"),
        mclMinus(
          mclArrayRef1(
            mclVv(denomi, "denomi"),
            mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
          _mxarray4_)));
    /*
     * ri10=x.*log2;
     */
    mlfAssign(&ri10, mclTimes(mclVv(x, "x"), mclVv(log2, "log2")));
    /*
     * ii10=fix(ri10);
     */
    mlfAssign(&ii10, mlfFix(mclVv(ri10, "ri10")));
    /*
     * ri10=ri10-ii10;
     */
    mlfAssign(&ri10, mclMinus(mclVv(ri10, "ri10"), mclVv(ii10, "ii10")));
    /*
     * dum1=(abs(denomr(1+2).*rmax.*rmax+denomr(2+2).*rmax+denomr(3+2)).*sign(denomr(-1+2)));
     */
    mlfAssign(
      &dum1,
      mclTimes(
        mlfAbs(
          mclPlus(
            mclPlus(
              mclTimes(
                mclTimes(
                  mclIntArrayRef1(mclVv(denomr, "denomr"), 3),
                  mclVv(rmax, "rmax")),
                mclVv(rmax, "rmax")),
              mclTimes(
                mclIntArrayRef1(mclVv(denomr, "denomr"), 4),
                mclVv(rmax, "rmax"))),
            mclIntArrayRef1(mclVv(denomr, "denomr"), 5))),
        mlfSign(mclIntArrayRef1(mclVv(denomr, "denomr"), 1))));
    /*
     * dum2=(abs(denomi(1+2).*rmax.*rmax+denomi(2+2).*rmax+denomi(3+2)).*sign(denomi(-1+2)));
     */
    mlfAssign(
      &dum2,
      mclTimes(
        mlfAbs(
          mclPlus(
            mclPlus(
              mclTimes(
                mclTimes(
                  mclIntArrayRef1(mclVv(denomi, "denomi"), 3),
                  mclVv(rmax, "rmax")),
                mclVv(rmax, "rmax")),
              mclTimes(
                mclIntArrayRef1(mclVv(denomi, "denomi"), 4),
                mclVv(rmax, "rmax"))),
            mclIntArrayRef1(mclVv(denomi, "denomi"), 5))),
        mlfSign(mclIntArrayRef1(mclVv(denomi, "denomi"), 1))));
    /*
     * dum1=dum1.*10.^rr10;
     */
    mlfAssign(
      &dum1,
      mclTimes(mclVv(dum1, "dum1"), mlfPower(_mxarray0_, mclVv(rr10, "rr10"))));
    /*
     * dum2=dum2.*10.^ri10;
     */
    mlfAssign(
      &dum2,
      mclTimes(mclVv(dum2, "dum2"), mlfPower(_mxarray0_, mclVv(ri10, "ri10"))));
    /*
     * cdum2=complex(dum1,dum2);
     */
    mlfAssign(&cdum2, mlfComplex(mclVv(dum1, "dum1"), mclVv(dum2, "dum2")));
    /*
     * temp=cdum1./cdum2;
     */
    mlfAssign(&temp, mclRdivide(mclVv(cdum1, "cdum1"), mclVv(cdum2, "cdum2")));
    /*
     * %
     * %     130 IF (IP .GT. 0) THEN
     * goon1=1;
     */
    mlfAssign(&goon1, _mxarray3_);
    /*
     * while (goon1==1);
     */
    while (mclEqBool(mclVv(goon1, "goon1"), _mxarray3_)) {
        /*
         * goon1=0;
         */
        mlfAssign(&goon1, _mxarray1_);
        /*
         * if (ip<0) ;
         */
        if (mclLtBool(mclVa(ip, "ip"), _mxarray1_)) {
            /*
             * if (sumr(1+2)<half) ;
             */
            if (mclLtBool(
                  mclIntArrayRef1(mclVv(sumr, "sumr"), 3),
                  mclVg(&half, "half"))) {
                /*
                 * mx1=sumi(l+1+2);
                 */
                mlfAssign(
                  &mx1,
                  mclArrayRef1(
                    mclVv(sumi, "sumi"),
                    mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)));
            /*
             * elseif (sumi(1+2)<half);
             */
            } else if (mclLtBool(
                         mclIntArrayRef1(mclVv(sumi, "sumi"), 3),
                         mclVg(&half, "half"))) {
                /*
                 * mx1=sumr(l+1+2);
                 */
                mlfAssign(
                  &mx1,
                  mclArrayRef1(
                    mclVv(sumr, "sumr"),
                    mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)));
            /*
             * else;
             */
            } else {
                /*
                 * mx1=max([sumr(l+1+2),sumi(l+1+2)]);
                 */
                mlfAssign(
                  &mx1,
                  mlfMax(
                    NULL,
                    mlfHorzcat(
                      mclArrayRef1(
                        mclVv(sumr, "sumr"),
                        mclPlus(
                          mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
                      mclArrayRef1(
                        mclVv(sumi, "sumi"),
                        mclPlus(
                          mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
                      NULL),
                    NULL,
                    NULL));
            /*
             * end;
             */
            }
            /*
             * if (numr(1+2)<half) ;
             */
            if (mclLtBool(
                  mclIntArrayRef1(mclVv(numr, "numr"), 3),
                  mclVg(&half, "half"))) {
                /*
                 * mx2=numi(l+1+2);
                 */
                mlfAssign(
                  &mx2,
                  mclArrayRef1(
                    mclVv(numi, "numi"),
                    mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)));
            /*
             * elseif (numi(1+2)<half);
             */
            } else if (mclLtBool(
                         mclIntArrayRef1(mclVv(numi, "numi"), 3),
                         mclVg(&half, "half"))) {
                /*
                 * mx2=numr(l+1+2);
                 */
                mlfAssign(
                  &mx2,
                  mclArrayRef1(
                    mclVv(numr, "numr"),
                    mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)));
            /*
             * else;
             */
            } else {
                /*
                 * mx2=max([numr(l+1+2),numi(l+1+2)]);
                 */
                mlfAssign(
                  &mx2,
                  mlfMax(
                    NULL,
                    mlfHorzcat(
                      mclArrayRef1(
                        mclVv(numr, "numr"),
                        mclPlus(
                          mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
                      mclArrayRef1(
                        mclVv(numi, "numi"),
                        mclPlus(
                          mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
                      NULL),
                    NULL,
                    NULL));
            /*
             * end;
             */
            }
            /*
             * if (mx1-mx2>2.0) ;
             */
            if (mclGtBool(
                  mclMinus(mclVv(mx1, "mx1"), mclVv(mx2, "mx2")), _mxarray4_)) {
                /*
                 * if (creal>=0.0) ;
                 */
                if (mclGeBool(mclVv(creal, "creal"), _mxarray1_)) {
                    /*
                     * %        write (6,*) ' cdabs(temp1/cnt)=',cdabs(temp1/cnt)
                     * %
                     * if (abs(temp1./cnt)<=one) ;
                     */
                    if (mclLeBool(
                          mlfAbs(
                            mclRdivide(
                              mclVv(temp1, "temp1"), mclVv(cnt, "cnt"))),
                          mclVg(&one, "one"))) {
                        /*
                         * [sumr,sumi,denomr,denomi,final,l,lnpfq,rmax,ibit]=arydiv(sumr,sumi,denomr,denomi,final,l,lnpfq,rmax,ibit);
                         */
                        mlfAssign(
                          &sumr,
                          mlfGenhyper_arydiv(
                            &sumi,
                            &denomr,
                            &denomi,
                            &final,
                            &l,
                            &lnpfq,
                            &rmax,
                            &ibit,
                            mclVv(sumr, "sumr"),
                            mclVv(sumi, "sumi"),
                            mclVv(denomr, "denomr"),
                            mclVv(denomi, "denomi"),
                            mclVv(final, "final"),
                            mclVv(l, "l"),
                            mclVa(lnpfq, "lnpfq"),
                            mclVv(rmax, "rmax"),
                            mclVv(ibit, "ibit")));
                        /*
                         * hyper=final;
                         */
                        mlfAssign(&hyper, mclVv(final, "final"));
                        /*
                         * return;
                         */
                        goto return_;
                    /*
                     * end;
                     */
                    }
                /*
                 * end;
                 */
                }
            /*
             * end;
             */
            }
        /*
         * else;
         */
        } else {
            /*
             * [sumr,sumi,denomr,denomi,temp,l,lnpfq,rmax,ibit]=arydiv(sumr,sumi,denomr,denomi,temp,l,lnpfq,rmax,ibit);
             */
            mlfAssign(
              &sumr,
              mlfGenhyper_arydiv(
                &sumi,
                &denomr,
                &denomi,
                &temp,
                &l,
                &lnpfq,
                &rmax,
                &ibit,
                mclVv(sumr, "sumr"),
                mclVv(sumi, "sumi"),
                mclVv(denomr, "denomr"),
                mclVv(denomi, "denomi"),
                mclVv(temp, "temp"),
                mclVv(l, "l"),
                mclVa(lnpfq, "lnpfq"),
                mclVv(rmax, "rmax"),
                mclVv(ibit, "ibit")));
            /*
             * %
             * %      First, estimate the exponent of the maximum term in the pFq
             * %      series.
             * %
             * expon=0.0;
             */
            mlfAssign(&expon, _mxarray1_);
            /*
             * xl=real(ixcnt);
             */
            mlfAssign(&xl, mlfReal(mclVv(ixcnt, "ixcnt")));
            /*
             * for i=1 : ip;
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVa(ip, "ip"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray12_);
                } else {
                    /*
                     * expon=expon+real(factor(a(i)+xl-one))-real(factor(a(i)-one));
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(
                          &expon,
                          mclMinus(
                            mclPlus(
                              mclVv(expon, "expon"),
                              mlfReal(
                                mlfGenhyper_factor(
                                  mclMinus(
                                    mclPlus(
                                      mclIntArrayRef1(mclVa(a, "a"), v_),
                                      mclVv(xl, "xl")),
                                    mclVg(&one, "one"))))),
                            mlfReal(
                              mlfGenhyper_factor(
                                mclMinus(
                                  mclIntArrayRef1(mclVa(a, "a"), v_),
                                  mclVg(&one, "one"))))));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i, mlfScalar(v_));
                }
            }
            /*
             * for i=1 : iq;
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVa(iq, "iq"));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray12_);
                } else {
                    /*
                     * expon=expon-real(factor(b(i)+xl-one))+real(factor(b(i)-one));
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(
                          &expon,
                          mclPlus(
                            mclMinus(
                              mclVv(expon, "expon"),
                              mlfReal(
                                mlfGenhyper_factor(
                                  mclMinus(
                                    mclPlus(
                                      mclIntArrayRef1(mclVa(b, "b"), v_),
                                      mclVv(xl, "xl")),
                                    mclVg(&one, "one"))))),
                            mlfReal(
                              mlfGenhyper_factor(
                                mclMinus(
                                  mclIntArrayRef1(mclVa(b, "b"), v_),
                                  mclVg(&one, "one"))))));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i, mlfScalar(v_));
                }
            }
            /*
             * expon=expon+xl.*real(log(z))-real(factor(complex(xl,0.0)));
             */
            mlfAssign(
              &expon,
              mclMinus(
                mclPlus(
                  mclVv(expon, "expon"),
                  mclTimes(mclVv(xl, "xl"), mlfReal(mlfLog(mclVa(z, "z"))))),
                mlfReal(
                  mlfGenhyper_factor(
                    mlfComplex(mclVv(xl, "xl"), _mxarray1_)))));
            /*
             * lmax=fix(log10(exp(one)).*expon);
             */
            mlfAssign(
              &lmax,
              mlfFix(
                mclTimes(
                  mlfLog10(mlfExp(mclVg(&one, "one"))),
                  mclVv(expon, "expon"))));
            /*
             * if (abs(oldtemp-temp)<abs(temp.*accy)) ;
             */
            if (mclLtBool(
                  mlfAbs(
                    mclMinus(mclVv(oldtemp, "oldtemp"), mclVv(temp, "temp"))),
                  mlfAbs(mclTimes(mclVv(temp, "temp"), mclVv(accy, "accy"))))) {
                /*
                 * [sumr,sumi,denomr,denomi,final,l,lnpfq,rmax,ibit]=arydiv(sumr,sumi,denomr,denomi,final,l,lnpfq,rmax,ibit);
                 */
                mlfAssign(
                  &sumr,
                  mlfGenhyper_arydiv(
                    &sumi,
                    &denomr,
                    &denomi,
                    &final,
                    &l,
                    &lnpfq,
                    &rmax,
                    &ibit,
                    mclVv(sumr, "sumr"),
                    mclVv(sumi, "sumi"),
                    mclVv(denomr, "denomr"),
                    mclVv(denomi, "denomi"),
                    mclVv(final, "final"),
                    mclVv(l, "l"),
                    mclVa(lnpfq, "lnpfq"),
                    mclVv(rmax, "rmax"),
                    mclVv(ibit, "ibit")));
                /*
                 * hyper=final;
                 */
                mlfAssign(&hyper, mclVv(final, "final"));
                /*
                 * return;
                 */
                goto return_;
            /*
             * end;
             */
            }
            /*
             * oldtemp=temp;
             */
            mlfAssign(&oldtemp, mclVv(temp, "temp"));
        /*
         * end;
         */
        }
        /*
         * if (ixcnt~=icount) ;
         */
        if (mclNeBool(mclVv(ixcnt, "ixcnt"), mclVv(icount, "icount"))) {
            /*
             * ixcnt=ixcnt+1;
             */
            mlfAssign(&ixcnt, mclPlus(mclVv(ixcnt, "ixcnt"), _mxarray3_));
            /*
             * for i1=1 : iq;
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVa(iq, "iq"));
                if (v_ > e_) {
                    mlfAssign(&i1, _mxarray12_);
                } else {
                    /*
                     * %
                     * %      TAKE THE CURRENT SUM AND MULTIPLY BY THE DENOMINATOR OF THE NEXT
                     * %
                     * %      TERM, FOR BOTH THE MOST SIGNIFICANT HALF (CR,CI) AND THE LEAST
                     * %
                     * %      SIGNIFICANT HALF (CR2,CI2).
                     * %
                     * %
                     * [sumr,sumi,cr(i1),ci(i1),qr1,qi1,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax]=cmpmul(sumr,sumi,cr(i1),ci(i1),qr1,qi1,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax);
                     * [sumr,sumi,cr2(i1),ci2(i1),qr2,qi2,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax]=cmpmul(sumr,sumi,cr2(i1),ci2(i1),qr2,qi2,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax);
                     * qr2(l+1+2)=qr2(l+1+2)-1;
                     * qi2(l+1+2)=qi2(l+1+2)-1;
                     * %
                     * %      STORE THIS TEMPORARILY IN THE SUM ARRAYS.
                     * %
                     * %
                     * [qr1,qi1,qr2,qi2,sumr,sumi,wk1,l,rmax]=cmpadd(qr1,qi1,qr2,qi2,sumr,sumi,wk1,l,rmax);
                     * end;
                     */
                    for (; ; ) {
                        mclFeval(
                          mlfIndexVarargout(
                            &sumr, "",
                            &sumi, "",
                            &cr, "(?)", mlfScalar(v_),
                            &ci, "(?)", mlfScalar(v_),
                            &qr1, "",
                            &qi1, "",
                            &wk1, "",
                            &wk2, "",
                            &wk3, "",
                            &wk4, "",
                            &wk5, "",
                            &wk6, "",
                            &l, "",
                            &rmax, "",
                            NULL),
                          mlxGenhyper_cmpmul,
                          mclVv(sumr, "sumr"),
                          mclVv(sumi, "sumi"),
                          mclIntArrayRef1(mclVv(cr, "cr"), v_),
                          mclIntArrayRef1(mclVv(ci, "ci"), v_),
                          mclVv(qr1, "qr1"),
                          mclVv(qi1, "qi1"),
                          mclVv(wk1, "wk1"),
                          mclVv(wk2, "wk2"),
                          mclVv(wk3, "wk3"),
                          mclVv(wk4, "wk4"),
                          mclVv(wk5, "wk5"),
                          mclVv(wk6, "wk6"),
                          mclVv(l, "l"),
                          mclVv(rmax, "rmax"),
                          NULL);
                        mclFeval(
                          mlfIndexVarargout(
                            &sumr, "",
                            &sumi, "",
                            &cr2, "(?)", mlfScalar(v_),
                            &ci2, "(?)", mlfScalar(v_),
                            &qr2, "",
                            &qi2, "",
                            &wk1, "",
                            &wk2, "",
                            &wk3, "",
                            &wk4, "",
                            &wk5, "",
                            &wk6, "",
                            &l, "",
                            &rmax, "",
                            NULL),
                          mlxGenhyper_cmpmul,
                          mclVv(sumr, "sumr"),
                          mclVv(sumi, "sumi"),
                          mclIntArrayRef1(mclVv(cr2, "cr2"), v_),
                          mclIntArrayRef1(mclVv(ci2, "ci2"), v_),
                          mclVv(qr2, "qr2"),
                          mclVv(qi2, "qi2"),
                          mclVv(wk1, "wk1"),
                          mclVv(wk2, "wk2"),
                          mclVv(wk3, "wk3"),
                          mclVv(wk4, "wk4"),
                          mclVv(wk5, "wk5"),
                          mclVv(wk6, "wk6"),
                          mclVv(l, "l"),
                          mclVv(rmax, "rmax"),
                          NULL);
                        mclArrayAssign1(
                          &qr2,
                          mclMinus(
                            mclArrayRef1(
                              mclVv(qr2, "qr2"),
                              mclPlus(
                                mclPlus(mclVv(l, "l"), _mxarray3_),
                                _mxarray4_)),
                            _mxarray3_),
                          mclPlus(
                            mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_));
                        mclArrayAssign1(
                          &qi2,
                          mclMinus(
                            mclArrayRef1(
                              mclVv(qi2, "qi2"),
                              mclPlus(
                                mclPlus(mclVv(l, "l"), _mxarray3_),
                                _mxarray4_)),
                            _mxarray3_),
                          mclPlus(
                            mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_));
                        mlfAssign(
                          &qr1,
                          mlfGenhyper_cmpadd(
                            &qi1,
                            &qr2,
                            &qi2,
                            &sumr,
                            &sumi,
                            &wk1,
                            &l,
                            &rmax,
                            mclVv(qr1, "qr1"),
                            mclVv(qi1, "qi1"),
                            mclVv(qr2, "qr2"),
                            mclVv(qi2, "qi2"),
                            mclVv(sumr, "sumr"),
                            mclVv(sumi, "sumi"),
                            mclVv(wk1, "wk1"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i1, mlfScalar(v_));
                }
            }
            /*
             * %
             * %
             * %     MULTIPLY BY THE FACTORIAL TERM.
             * %
             * foo1=sumr;
             */
            mlfAssign(&foo1, mclVv(sumr, "sumr"));
            /*
             * foo2=sumr;
             */
            mlfAssign(&foo2, mclVv(sumr, "sumr"));
            /*
             * [foo1,cnt,foo2,wk6,l,rmax]=armult(foo1,cnt,foo2,wk6,l,rmax);
             */
            mlfAssign(
              &foo1,
              mlfGenhyper_armult(
                &cnt,
                &foo2,
                &wk6,
                &l,
                &rmax,
                mclVv(foo1, "foo1"),
                mclVv(cnt, "cnt"),
                mclVv(foo2, "foo2"),
                mclVv(wk6, "wk6"),
                mclVv(l, "l"),
                mclVv(rmax, "rmax")));
            /*
             * sumr=foo2;
             */
            mlfAssign(&sumr, mclVv(foo2, "foo2"));
            /*
             * foo1=sumi;
             */
            mlfAssign(&foo1, mclVv(sumi, "sumi"));
            /*
             * foo2=sumi;
             */
            mlfAssign(&foo2, mclVv(sumi, "sumi"));
            /*
             * [foo1,cnt,foo2,wk6,l,rmax]=armult(foo1,cnt,foo2,wk6,l,rmax);
             */
            mlfAssign(
              &foo1,
              mlfGenhyper_armult(
                &cnt,
                &foo2,
                &wk6,
                &l,
                &rmax,
                mclVv(foo1, "foo1"),
                mclVv(cnt, "cnt"),
                mclVv(foo2, "foo2"),
                mclVv(wk6, "wk6"),
                mclVv(l, "l"),
                mclVv(rmax, "rmax")));
            /*
             * sumi=foo2;
             */
            mlfAssign(&sumi, mclVv(foo2, "foo2"));
            /*
             * %
             * %     MULTIPLY BY THE SCALING FACTOR, SIGFIG, TO KEEP THE SCALE CORRECT.
             * %
             * for i1=1 : ip-iq;
             */
            {
                int v_ = mclForIntStart(1);
                int e_
                  = mclForIntEnd(mclMinus(mclVa(ip, "ip"), mclVa(iq, "iq")));
                if (v_ > e_) {
                    mlfAssign(&i1, _mxarray12_);
                } else {
                    /*
                     * foo1=sumr;
                     * foo2=sumr;
                     * [foo1,sigfig,foo2,wk6,l,rmax]=armult(foo1,sigfig,foo2,wk6,l,rmax);
                     * sumr=foo2;
                     * foo1=sumi;
                     * foo2=sumi;
                     * [foo1,sigfig,foo2,wk6,l,rmax]=armult(foo1,sigfig,foo2,wk6,l,rmax);
                     * sumi=foo2;
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(&foo1, mclVv(sumr, "sumr"));
                        mlfAssign(&foo2, mclVv(sumr, "sumr"));
                        mlfAssign(
                          &foo1,
                          mlfGenhyper_armult(
                            &sigfig,
                            &foo2,
                            &wk6,
                            &l,
                            &rmax,
                            mclVv(foo1, "foo1"),
                            mclVv(sigfig, "sigfig"),
                            mclVv(foo2, "foo2"),
                            mclVv(wk6, "wk6"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        mlfAssign(&sumr, mclVv(foo2, "foo2"));
                        mlfAssign(&foo1, mclVv(sumi, "sumi"));
                        mlfAssign(&foo2, mclVv(sumi, "sumi"));
                        mlfAssign(
                          &foo1,
                          mlfGenhyper_armult(
                            &sigfig,
                            &foo2,
                            &wk6,
                            &l,
                            &rmax,
                            mclVv(foo1, "foo1"),
                            mclVv(sigfig, "sigfig"),
                            mclVv(foo2, "foo2"),
                            mclVv(wk6, "wk6"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        mlfAssign(&sumi, mclVv(foo2, "foo2"));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i1, mlfScalar(v_));
                }
            }
            /*
             * for i1=1 : iq;
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVa(iq, "iq"));
                if (v_ > e_) {
                    mlfAssign(&i1, _mxarray12_);
                } else {
                    /*
                     * %
                     * %      UPDATE THE DENOMINATOR.
                     * %
                     * %
                     * [denomr,denomi,cr(i1),ci(i1),qr1,qi1,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax]=cmpmul(denomr,denomi,cr(i1),ci(i1),qr1,qi1,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax);
                     * [denomr,denomi,cr2(i1),ci2(i1),qr2,qi2,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax]=cmpmul(denomr,denomi,cr2(i1),ci2(i1),qr2,qi2,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax);
                     * qr2(l+1+2)=qr2(l+1+2)-1;
                     * qi2(l+1+2)=qi2(l+1+2)-1;
                     * [qr1,qi1,qr2,qi2,denomr,denomi,wk1,l,rmax]=cmpadd(qr1,qi1,qr2,qi2,denomr,denomi,wk1,l,rmax);
                     * end;
                     */
                    for (; ; ) {
                        mclFeval(
                          mlfIndexVarargout(
                            &denomr, "",
                            &denomi, "",
                            &cr, "(?)", mlfScalar(v_),
                            &ci, "(?)", mlfScalar(v_),
                            &qr1, "",
                            &qi1, "",
                            &wk1, "",
                            &wk2, "",
                            &wk3, "",
                            &wk4, "",
                            &wk5, "",
                            &wk6, "",
                            &l, "",
                            &rmax, "",
                            NULL),
                          mlxGenhyper_cmpmul,
                          mclVv(denomr, "denomr"),
                          mclVv(denomi, "denomi"),
                          mclIntArrayRef1(mclVv(cr, "cr"), v_),
                          mclIntArrayRef1(mclVv(ci, "ci"), v_),
                          mclVv(qr1, "qr1"),
                          mclVv(qi1, "qi1"),
                          mclVv(wk1, "wk1"),
                          mclVv(wk2, "wk2"),
                          mclVv(wk3, "wk3"),
                          mclVv(wk4, "wk4"),
                          mclVv(wk5, "wk5"),
                          mclVv(wk6, "wk6"),
                          mclVv(l, "l"),
                          mclVv(rmax, "rmax"),
                          NULL);
                        mclFeval(
                          mlfIndexVarargout(
                            &denomr, "",
                            &denomi, "",
                            &cr2, "(?)", mlfScalar(v_),
                            &ci2, "(?)", mlfScalar(v_),
                            &qr2, "",
                            &qi2, "",
                            &wk1, "",
                            &wk2, "",
                            &wk3, "",
                            &wk4, "",
                            &wk5, "",
                            &wk6, "",
                            &l, "",
                            &rmax, "",
                            NULL),
                          mlxGenhyper_cmpmul,
                          mclVv(denomr, "denomr"),
                          mclVv(denomi, "denomi"),
                          mclIntArrayRef1(mclVv(cr2, "cr2"), v_),
                          mclIntArrayRef1(mclVv(ci2, "ci2"), v_),
                          mclVv(qr2, "qr2"),
                          mclVv(qi2, "qi2"),
                          mclVv(wk1, "wk1"),
                          mclVv(wk2, "wk2"),
                          mclVv(wk3, "wk3"),
                          mclVv(wk4, "wk4"),
                          mclVv(wk5, "wk5"),
                          mclVv(wk6, "wk6"),
                          mclVv(l, "l"),
                          mclVv(rmax, "rmax"),
                          NULL);
                        mclArrayAssign1(
                          &qr2,
                          mclMinus(
                            mclArrayRef1(
                              mclVv(qr2, "qr2"),
                              mclPlus(
                                mclPlus(mclVv(l, "l"), _mxarray3_),
                                _mxarray4_)),
                            _mxarray3_),
                          mclPlus(
                            mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_));
                        mclArrayAssign1(
                          &qi2,
                          mclMinus(
                            mclArrayRef1(
                              mclVv(qi2, "qi2"),
                              mclPlus(
                                mclPlus(mclVv(l, "l"), _mxarray3_),
                                _mxarray4_)),
                            _mxarray3_),
                          mclPlus(
                            mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_));
                        mlfAssign(
                          &qr1,
                          mlfGenhyper_cmpadd(
                            &qi1,
                            &qr2,
                            &qi2,
                            &denomr,
                            &denomi,
                            &wk1,
                            &l,
                            &rmax,
                            mclVv(qr1, "qr1"),
                            mclVv(qi1, "qi1"),
                            mclVv(qr2, "qr2"),
                            mclVv(qi2, "qi2"),
                            mclVv(denomr, "denomr"),
                            mclVv(denomi, "denomi"),
                            mclVv(wk1, "wk1"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i1, mlfScalar(v_));
                }
            }
            /*
             * %
             * %
             * %     MULTIPLY BY THE FACTORIAL TERM.
             * %
             * foo1=denomr;
             */
            mlfAssign(&foo1, mclVv(denomr, "denomr"));
            /*
             * foo2=denomr;
             */
            mlfAssign(&foo2, mclVv(denomr, "denomr"));
            /*
             * [foo1,cnt,foo2,wk6,l,rmax]=armult(foo1,cnt,foo2,wk6,l,rmax);
             */
            mlfAssign(
              &foo1,
              mlfGenhyper_armult(
                &cnt,
                &foo2,
                &wk6,
                &l,
                &rmax,
                mclVv(foo1, "foo1"),
                mclVv(cnt, "cnt"),
                mclVv(foo2, "foo2"),
                mclVv(wk6, "wk6"),
                mclVv(l, "l"),
                mclVv(rmax, "rmax")));
            /*
             * denomr=foo2;
             */
            mlfAssign(&denomr, mclVv(foo2, "foo2"));
            /*
             * foo1=denomi;
             */
            mlfAssign(&foo1, mclVv(denomi, "denomi"));
            /*
             * foo2=denomi;
             */
            mlfAssign(&foo2, mclVv(denomi, "denomi"));
            /*
             * [foo1,cnt,foo2,wk6,l,rmax]=armult(foo1,cnt,foo2,wk6,l,rmax);
             */
            mlfAssign(
              &foo1,
              mlfGenhyper_armult(
                &cnt,
                &foo2,
                &wk6,
                &l,
                &rmax,
                mclVv(foo1, "foo1"),
                mclVv(cnt, "cnt"),
                mclVv(foo2, "foo2"),
                mclVv(wk6, "wk6"),
                mclVv(l, "l"),
                mclVv(rmax, "rmax")));
            /*
             * denomi=foo2;
             */
            mlfAssign(&denomi, mclVv(foo2, "foo2"));
            /*
             * %
             * %     MULTIPLY BY THE SCALING FACTOR, SIGFIG, TO KEEP THE SCALE CORRECT.
             * %
             * for i1=1 : ip-iq;
             */
            {
                int v_ = mclForIntStart(1);
                int e_
                  = mclForIntEnd(mclMinus(mclVa(ip, "ip"), mclVa(iq, "iq")));
                if (v_ > e_) {
                    mlfAssign(&i1, _mxarray12_);
                } else {
                    /*
                     * foo1=denomr;
                     * foo2=denomr;
                     * [foo1,sigfig,foo2,wk6,l,rmax]=armult(foo1,sigfig,foo2,wk6,l,rmax);
                     * denomr=foo2;
                     * foo1=denomi;
                     * foo2=denomi;
                     * [foo1,sigfig,foo2,wk6,l,rmax]=armult(foo1,sigfig,foo2,wk6,l,rmax);
                     * denomi=foo2;
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(&foo1, mclVv(denomr, "denomr"));
                        mlfAssign(&foo2, mclVv(denomr, "denomr"));
                        mlfAssign(
                          &foo1,
                          mlfGenhyper_armult(
                            &sigfig,
                            &foo2,
                            &wk6,
                            &l,
                            &rmax,
                            mclVv(foo1, "foo1"),
                            mclVv(sigfig, "sigfig"),
                            mclVv(foo2, "foo2"),
                            mclVv(wk6, "wk6"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        mlfAssign(&denomr, mclVv(foo2, "foo2"));
                        mlfAssign(&foo1, mclVv(denomi, "denomi"));
                        mlfAssign(&foo2, mclVv(denomi, "denomi"));
                        mlfAssign(
                          &foo1,
                          mlfGenhyper_armult(
                            &sigfig,
                            &foo2,
                            &wk6,
                            &l,
                            &rmax,
                            mclVv(foo1, "foo1"),
                            mclVv(sigfig, "sigfig"),
                            mclVv(foo2, "foo2"),
                            mclVv(wk6, "wk6"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        mlfAssign(&denomi, mclVv(foo2, "foo2"));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i1, mlfScalar(v_));
                }
            }
            /*
             * %
             * %     FORM THE NEXT NUMERATOR TERM BY MULTIPLYING THE CURRENT
             * %     NUMERATOR TERM (AN ARRAY) WITH THE A ARGUMENT (A SCALAR).
             * %
             * for i1=1 : ip;
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVa(ip, "ip"));
                if (v_ > e_) {
                    mlfAssign(&i1, _mxarray12_);
                } else {
                    /*
                     * [numr,numi,ar(i1),ai(i1),qr1,qi1,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax]=cmpmul(numr,numi,ar(i1),ai(i1),qr1,qi1,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax);
                     * [numr,numi,ar2(i1),ai2(i1),qr2,qi2,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax]=cmpmul(numr,numi,ar2(i1),ai2(i1),qr2,qi2,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax);
                     * qr2(l+1+2)=qr2(l+1+2)-1;
                     * qi2(l+1+2)=qi2(l+1+2)-1;
                     * [qr1,qi1,qr2,qi2,numr,numi,wk1,l,rmax]=cmpadd(qr1,qi1,qr2,qi2,numr,numi,wk1,l,rmax);
                     * end;
                     */
                    for (; ; ) {
                        mclFeval(
                          mlfIndexVarargout(
                            &numr, "",
                            &numi, "",
                            &ar, "(?)", mlfScalar(v_),
                            &ai, "(?)", mlfScalar(v_),
                            &qr1, "",
                            &qi1, "",
                            &wk1, "",
                            &wk2, "",
                            &wk3, "",
                            &wk4, "",
                            &wk5, "",
                            &wk6, "",
                            &l, "",
                            &rmax, "",
                            NULL),
                          mlxGenhyper_cmpmul,
                          mclVv(numr, "numr"),
                          mclVv(numi, "numi"),
                          mclIntArrayRef1(mclVv(ar, "ar"), v_),
                          mclIntArrayRef1(mclVv(ai, "ai"), v_),
                          mclVv(qr1, "qr1"),
                          mclVv(qi1, "qi1"),
                          mclVv(wk1, "wk1"),
                          mclVv(wk2, "wk2"),
                          mclVv(wk3, "wk3"),
                          mclVv(wk4, "wk4"),
                          mclVv(wk5, "wk5"),
                          mclVv(wk6, "wk6"),
                          mclVv(l, "l"),
                          mclVv(rmax, "rmax"),
                          NULL);
                        mclFeval(
                          mlfIndexVarargout(
                            &numr, "",
                            &numi, "",
                            &ar2, "(?)", mlfScalar(v_),
                            &ai2, "(?)", mlfScalar(v_),
                            &qr2, "",
                            &qi2, "",
                            &wk1, "",
                            &wk2, "",
                            &wk3, "",
                            &wk4, "",
                            &wk5, "",
                            &wk6, "",
                            &l, "",
                            &rmax, "",
                            NULL),
                          mlxGenhyper_cmpmul,
                          mclVv(numr, "numr"),
                          mclVv(numi, "numi"),
                          mclIntArrayRef1(mclVv(ar2, "ar2"), v_),
                          mclIntArrayRef1(mclVv(ai2, "ai2"), v_),
                          mclVv(qr2, "qr2"),
                          mclVv(qi2, "qi2"),
                          mclVv(wk1, "wk1"),
                          mclVv(wk2, "wk2"),
                          mclVv(wk3, "wk3"),
                          mclVv(wk4, "wk4"),
                          mclVv(wk5, "wk5"),
                          mclVv(wk6, "wk6"),
                          mclVv(l, "l"),
                          mclVv(rmax, "rmax"),
                          NULL);
                        mclArrayAssign1(
                          &qr2,
                          mclMinus(
                            mclArrayRef1(
                              mclVv(qr2, "qr2"),
                              mclPlus(
                                mclPlus(mclVv(l, "l"), _mxarray3_),
                                _mxarray4_)),
                            _mxarray3_),
                          mclPlus(
                            mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_));
                        mclArrayAssign1(
                          &qi2,
                          mclMinus(
                            mclArrayRef1(
                              mclVv(qi2, "qi2"),
                              mclPlus(
                                mclPlus(mclVv(l, "l"), _mxarray3_),
                                _mxarray4_)),
                            _mxarray3_),
                          mclPlus(
                            mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_));
                        mlfAssign(
                          &qr1,
                          mlfGenhyper_cmpadd(
                            &qi1,
                            &qr2,
                            &qi2,
                            &numr,
                            &numi,
                            &wk1,
                            &l,
                            &rmax,
                            mclVv(qr1, "qr1"),
                            mclVv(qi1, "qi1"),
                            mclVv(qr2, "qr2"),
                            mclVv(qi2, "qi2"),
                            mclVv(numr, "numr"),
                            mclVv(numi, "numi"),
                            mclVv(wk1, "wk1"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i1, mlfScalar(v_));
                }
            }
            /*
             * %
             * %     FINISH THE NEW NUMERATOR TERM BY MULTIPLYING BY THE Z ARGUMENT.
             * %
             * [numr,numi,xr,xi,qr1,qi1,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax]=cmpmul(numr,numi,xr,xi,qr1,qi1,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax);
             */
            mlfAssign(
              &numr,
              mlfGenhyper_cmpmul(
                &numi,
                &xr,
                &xi,
                &qr1,
                &qi1,
                &wk1,
                &wk2,
                &wk3,
                &wk4,
                &wk5,
                &wk6,
                &l,
                &rmax,
                mclVv(numr, "numr"),
                mclVv(numi, "numi"),
                mclVv(xr, "xr"),
                mclVv(xi, "xi"),
                mclVv(qr1, "qr1"),
                mclVv(qi1, "qi1"),
                mclVv(wk1, "wk1"),
                mclVv(wk2, "wk2"),
                mclVv(wk3, "wk3"),
                mclVv(wk4, "wk4"),
                mclVv(wk5, "wk5"),
                mclVv(wk6, "wk6"),
                mclVv(l, "l"),
                mclVv(rmax, "rmax")));
            /*
             * [numr,numi,xr2,xi2,qr2,qi2,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax]=cmpmul(numr,numi,xr2,xi2,qr2,qi2,wk1,wk2,wk3,wk4,wk5,wk6,l,rmax);
             */
            mlfAssign(
              &numr,
              mlfGenhyper_cmpmul(
                &numi,
                &xr2,
                &xi2,
                &qr2,
                &qi2,
                &wk1,
                &wk2,
                &wk3,
                &wk4,
                &wk5,
                &wk6,
                &l,
                &rmax,
                mclVv(numr, "numr"),
                mclVv(numi, "numi"),
                mclVv(xr2, "xr2"),
                mclVv(xi2, "xi2"),
                mclVv(qr2, "qr2"),
                mclVv(qi2, "qi2"),
                mclVv(wk1, "wk1"),
                mclVv(wk2, "wk2"),
                mclVv(wk3, "wk3"),
                mclVv(wk4, "wk4"),
                mclVv(wk5, "wk5"),
                mclVv(wk6, "wk6"),
                mclVv(l, "l"),
                mclVv(rmax, "rmax")));
            /*
             * qr2(l+1+2)=qr2(l+1+2)-1;
             */
            mclArrayAssign1(
              &qr2,
              mclMinus(
                mclArrayRef1(
                  mclVv(qr2, "qr2"),
                  mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
                _mxarray3_),
              mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_));
            /*
             * qi2(l+1+2)=qi2(l+1+2)-1;
             */
            mclArrayAssign1(
              &qi2,
              mclMinus(
                mclArrayRef1(
                  mclVv(qi2, "qi2"),
                  mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_)),
                _mxarray3_),
              mclPlus(mclPlus(mclVv(l, "l"), _mxarray3_), _mxarray4_));
            /*
             * [qr1,qi1,qr2,qi2,numr,numi,wk1,l,rmax]=cmpadd(qr1,qi1,qr2,qi2,numr,numi,wk1,l,rmax);
             */
            mlfAssign(
              &qr1,
              mlfGenhyper_cmpadd(
                &qi1,
                &qr2,
                &qi2,
                &numr,
                &numi,
                &wk1,
                &l,
                &rmax,
                mclVv(qr1, "qr1"),
                mclVv(qi1, "qi1"),
                mclVv(qr2, "qr2"),
                mclVv(qi2, "qi2"),
                mclVv(numr, "numr"),
                mclVv(numi, "numi"),
                mclVv(wk1, "wk1"),
                mclVv(l, "l"),
                mclVv(rmax, "rmax")));
            /*
             * %
             * %     MULTIPLY BY THE SCALING FACTOR, SIGFIG, TO KEEP THE SCALE CORRECT.
             * %
             * for i1=1 : iq-ip;
             */
            {
                int v_ = mclForIntStart(1);
                int e_
                  = mclForIntEnd(mclMinus(mclVa(iq, "iq"), mclVa(ip, "ip")));
                if (v_ > e_) {
                    mlfAssign(&i1, _mxarray12_);
                } else {
                    /*
                     * foo1=numr;
                     * foo2=numr;
                     * [foo1,sigfig,foo2,wk6,l,rmax]=armult(foo1,sigfig,foo2,wk6,l,rmax);
                     * numr=foo2;
                     * foo1=numi;
                     * foo2=numi;
                     * [foo1,sigfig,foo2,wk6,l,rmax]=armult(foo1,sigfig,foo2,wk6,l,rmax);
                     * numi=foo2;
                     * end;
                     */
                    for (; ; ) {
                        mlfAssign(&foo1, mclVv(numr, "numr"));
                        mlfAssign(&foo2, mclVv(numr, "numr"));
                        mlfAssign(
                          &foo1,
                          mlfGenhyper_armult(
                            &sigfig,
                            &foo2,
                            &wk6,
                            &l,
                            &rmax,
                            mclVv(foo1, "foo1"),
                            mclVv(sigfig, "sigfig"),
                            mclVv(foo2, "foo2"),
                            mclVv(wk6, "wk6"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        mlfAssign(&numr, mclVv(foo2, "foo2"));
                        mlfAssign(&foo1, mclVv(numi, "numi"));
                        mlfAssign(&foo2, mclVv(numi, "numi"));
                        mlfAssign(
                          &foo1,
                          mlfGenhyper_armult(
                            &sigfig,
                            &foo2,
                            &wk6,
                            &l,
                            &rmax,
                            mclVv(foo1, "foo1"),
                            mclVv(sigfig, "sigfig"),
                            mclVv(foo2, "foo2"),
                            mclVv(wk6, "wk6"),
                            mclVv(l, "l"),
                            mclVv(rmax, "rmax")));
                        mlfAssign(&numi, mclVv(foo2, "foo2"));
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i1, mlfScalar(v_));
                }
            }
            /*
             * %
             * %     FINALLY, ADD THE NEW NUMERATOR TERM WITH THE CURRENT RUNNING
             * %     SUM OF THE NUMERATOR AND STORE THE NEW RUNNING SUM IN SUMR, SUMI.
             * %
             * foo1=sumr;
             */
            mlfAssign(&foo1, mclVv(sumr, "sumr"));
            /*
             * foo2=sumr;
             */
            mlfAssign(&foo2, mclVv(sumr, "sumr"));
            /*
             * bar1=sumi;
             */
            mlfAssign(&bar1, mclVv(sumi, "sumi"));
            /*
             * bar2=sumi;
             */
            mlfAssign(&bar2, mclVv(sumi, "sumi"));
            /*
             * [foo1,bar1,numr,numi,foo2,bar2,wk1,l,rmax]=cmpadd(foo1,bar1,numr,numi,foo2,bar2,wk1,l,rmax);
             */
            mlfAssign(
              &foo1,
              mlfGenhyper_cmpadd(
                &bar1,
                &numr,
                &numi,
                &foo2,
                &bar2,
                &wk1,
                &l,
                &rmax,
                mclVv(foo1, "foo1"),
                mclVv(bar1, "bar1"),
                mclVv(numr, "numr"),
                mclVv(numi, "numi"),
                mclVv(foo2, "foo2"),
                mclVv(bar2, "bar2"),
                mclVv(wk1, "wk1"),
                mclVv(l, "l"),
                mclVv(rmax, "rmax")));
            /*
             * sumi=bar2;
             */
            mlfAssign(&sumi, mclVv(bar2, "bar2"));
            /*
             * sumr=foo2;
             */
            mlfAssign(&sumr, mclVv(foo2, "foo2"));
            /*
             * 
             * %
             * %     BECAUSE SIGFIG REPRESENTS "ONE" ON THE NEW SCALE, ADD SIGFIG
             * %     TO THE CURRENT COUNT AND, CONSEQUENTLY, TO THE IP ARGUMENTS
             * %     IN THE NUMERATOR AND THE IQ ARGUMENTS IN THE DENOMINATOR.
             * %
             * cnt=cnt+sigfig;
             */
            mlfAssign(
              &cnt, mclPlus(mclVv(cnt, "cnt"), mclVv(sigfig, "sigfig")));
            /*
             * for i1=1 : ip;
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVa(ip, "ip"));
                if (v_ > e_) {
                    mlfAssign(&i1, _mxarray12_);
                } else {
                    /*
                     * ar(i1)=ar(i1)+sigfig;
                     * end;
                     */
                    for (; ; ) {
                        mclIntArrayAssign1(
                          &ar,
                          mclPlus(
                            mclIntArrayRef1(mclVv(ar, "ar"), v_),
                            mclVv(sigfig, "sigfig")),
                          v_);
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i1, mlfScalar(v_));
                }
            }
            /*
             * for i1=1 : iq;
             */
            {
                int v_ = mclForIntStart(1);
                int e_ = mclForIntEnd(mclVa(iq, "iq"));
                if (v_ > e_) {
                    mlfAssign(&i1, _mxarray12_);
                } else {
                    /*
                     * cr(i1)=cr(i1)+sigfig;
                     * end;
                     */
                    for (; ; ) {
                        mclIntArrayAssign1(
                          &cr,
                          mclPlus(
                            mclIntArrayRef1(mclVv(cr, "cr"), v_),
                            mclVv(sigfig, "sigfig")),
                          v_);
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i1, mlfScalar(v_));
                }
            }
            /*
             * goon1=1;
             */
            mlfAssign(&goon1, _mxarray3_);
        /*
         * end;
         */
        }
    /*
     * end;
     */
    }
    /*
     * [sumr,sumi,denomr,denomi,final,l,lnpfq,rmax,ibit]=arydiv(sumr,sumi,denomr,denomi,final,l,lnpfq,rmax,ibit);
     */
    mlfAssign(
      &sumr,
      mlfGenhyper_arydiv(
        &sumi,
        &denomr,
        &denomi,
        &final,
        &l,
        &lnpfq,
        &rmax,
        &ibit,
        mclVv(sumr, "sumr"),
        mclVv(sumi, "sumi"),
        mclVv(denomr, "denomr"),
        mclVv(denomi, "denomi"),
        mclVv(final, "final"),
        mclVv(l, "l"),
        mclVa(lnpfq, "lnpfq"),
        mclVv(rmax, "rmax"),
        mclVv(ibit, "ibit")));
    /*
     * %     write (6,*) 'Number of terms=',ixcnt
     * hyper=final;
     */
    mlfAssign(&hyper, mclVv(final, "final"));
    /*
     * return;
     * 
     * 
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE ARADD                             *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Accepts two arrays of numbers and returns     *
     * %     *    the sum of the array.  Each array is holding the value    *
     * %     *    of one number in the series.  The parameter L is the      *
     * %     *    size of the array representing the number and RMAX is     *
     * %     *    the actual number of digits needed to give the numbers    *
     * %     *    the desired accuracy.                                     *
     * %     *                                                              *
     * %     *  Subprograms called: none                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
    return_:
    mclValidateOutput(hyper, 1, nargout_, "hyper", "genhyper/hyper");
    mxDestroyArray(sumr);
    mxDestroyArray(sumi);
    mxDestroyArray(denomr);
    mxDestroyArray(denomi);
    mxDestroyArray(final);
    mxDestroyArray(l);
    mxDestroyArray(rmax);
    mxDestroyArray(ibit);
    mxDestroyArray(temp);
    mxDestroyArray(cr);
    mxDestroyArray(i1);
    mxDestroyArray(ci);
    mxDestroyArray(qr1);
    mxDestroyArray(qi1);
    mxDestroyArray(wk1);
    mxDestroyArray(wk2);
    mxDestroyArray(wk3);
    mxDestroyArray(wk4);
    mxDestroyArray(wk5);
    mxDestroyArray(wk6);
    mxDestroyArray(cr2);
    mxDestroyArray(ci2);
    mxDestroyArray(qr2);
    mxDestroyArray(qi2);
    mxDestroyArray(foo1);
    mxDestroyArray(cnt);
    mxDestroyArray(foo2);
    mxDestroyArray(sigfig);
    mxDestroyArray(numr);
    mxDestroyArray(numi);
    mxDestroyArray(ar);
    mxDestroyArray(ai);
    mxDestroyArray(ar2);
    mxDestroyArray(ai2);
    mxDestroyArray(xr);
    mxDestroyArray(xi);
    mxDestroyArray(xr2);
    mxDestroyArray(xi2);
    mxDestroyArray(bar1);
    mxDestroyArray(bar2);
    mxDestroyArray(length);
    mxDestroyArray(ans);
    mxDestroyArray(accy);
    mxDestroyArray(creal);
    mxDestroyArray(dum1);
    mxDestroyArray(dum2);
    mxDestroyArray(expon);
    mxDestroyArray(log2);
    mxDestroyArray(mx1);
    mxDestroyArray(mx2);
    mxDestroyArray(ri10);
    mxDestroyArray(rr10);
    mxDestroyArray(x);
    mxDestroyArray(xl);
    mxDestroyArray(cdum1);
    mxDestroyArray(cdum2);
    mxDestroyArray(oldtemp);
    mxDestroyArray(temp1);
    mxDestroyArray(i);
    mxDestroyArray(icount);
    mxDestroyArray(ii10);
    mxDestroyArray(ir10);
    mxDestroyArray(ixcnt);
    mxDestroyArray(lmax);
    mxDestroyArray(nmach);
    mxDestroyArray(rexp);
    mxDestroyArray(goon1);
    mxDestroyArray(nsigfig);
    mxDestroyArray(ix);
    mxDestroyArray(lnpfq);
    mxDestroyArray(z);
    mxDestroyArray(iq);
    mxDestroyArray(ip);
    mxDestroyArray(b);
    mxDestroyArray(a);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return hyper;
}

/*
 * The function "Mgenhyper_aradd" is the implementation version of the
 * "genhyper/aradd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 759-1071). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [a,b,c,z,l,rmax]=aradd(a,b,c,z,l,rmax);
 */
static mxArray * Mgenhyper_aradd(mxArray * * b,
                                 mxArray * * c,
                                 mxArray * * z,
                                 mxArray * * l,
                                 mxArray * * rmax,
                                 int nargout_,
                                 mxArray * a_in,
                                 mxArray * b_in,
                                 mxArray * c_in,
                                 mxArray * z_in,
                                 mxArray * l_in,
                                 mxArray * rmax_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * a = NULL;
    mxArray * goon190 = NULL;
    mxArray * goon300 = NULL;
    mxArray * j = NULL;
    mxArray * i = NULL;
    mxArray * ediff = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&a, a_in);
    mclCopyInputArg(b, b_in);
    mclCopyInputArg(c, c_in);
    mclCopyInputArg(z, z_in);
    mclCopyInputArg(l, l_in);
    mclCopyInputArg(rmax, rmax_in);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * ediff=0;i=0;j=0;
     */
    mlfAssign(&ediff, _mxarray1_);
    mlfAssign(&i, _mxarray1_);
    mlfAssign(&j, _mxarray1_);
    /*
     * %
     * %
     * for i=0 : l+1;
     */
    {
        int v_ = mclForIntStart(0);
        int e_ = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray12_);
        } else {
            /*
             * z(i+2)=0.0;
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(z, _mxarray1_, v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * ediff=round(a(l+1+2)-b(l+1+2));
     */
    mlfAssign(
      &ediff,
      mlfRound(
        mclMinus(
          mclArrayRef1(
            mclVa(a, "a"),
            mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
          mclArrayRef1(
            mclVa(*b, "b"),
            mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)))));
    /*
     * if (abs(a(1+2))<half | ediff<=-l) ;
     */
    {
        mxArray * a_
          = mclInitialize(
              mclLt(
                mlfAbs(mclIntArrayRef1(mclVa(a, "a"), 3)),
                mclVg(&half, "half")));
        if (mlfTobool(a_)
            || mlfTobool(
                 mclOr(
                   a_,
                   mclLe(mclVv(ediff, "ediff"), mclUminus(mclVa(*l, "l")))))) {
            mxDestroyArray(a_);
            /*
             * for i=-1 : l+1;
             */
            {
                int v_ = mclForIntStart(-1);
                int e_ = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
                if (v_ > e_) {
                    mlfAssign(&i, _mxarray12_);
                } else {
                    /*
                     * c(i+2)=b(i+2);
                     * end;
                     */
                    for (; ; ) {
                        mclIntArrayAssign1(
                          c, mclIntArrayRef1(mclVa(*b, "b"), v_ + 2), v_ + 2);
                        if (v_ == e_) {
                            break;
                        }
                        ++v_;
                    }
                    mlfAssign(&i, mlfScalar(v_));
                }
            }
            /*
             * if (c(1+2)<half) ;
             */
            if (mclLtBool(
                  mclIntArrayRef1(mclVa(*c, "c"), 3), mclVg(&half, "half"))) {
                /*
                 * c(-1+2)=one;
                 */
                mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
                /*
                 * c(l+1+2)=0.0;
                 */
                mclArrayAssign1(
                  c,
                  _mxarray1_,
                  mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
            /*
             * end;
             */
            }
            /*
             * return;
             */
            goto return_;
        /*
         * else;
         */
        } else {
            mxDestroyArray(a_);
            /*
             * if (abs(b(1+2))<half | ediff>=l) ;
             */
            {
                mxArray * a_1
                  = mclInitialize(
                      mclLt(
                        mlfAbs(mclIntArrayRef1(mclVa(*b, "b"), 3)),
                        mclVg(&half, "half")));
                if (mlfTobool(a_1)
                    || mlfTobool(
                         mclOr(
                           a_1,
                           mclGe(mclVv(ediff, "ediff"), mclVa(*l, "l"))))) {
                    mxDestroyArray(a_1);
                    /*
                     * for i=-1 : l+1;
                     */
                    {
                        int v_ = mclForIntStart(-1);
                        int e_
                          = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
                        if (v_ > e_) {
                            mlfAssign(&i, _mxarray12_);
                        } else {
                            /*
                             * c(i+2)=a(i+2);
                             * end;
                             */
                            for (; ; ) {
                                mclIntArrayAssign1(
                                  c,
                                  mclIntArrayRef1(mclVa(a, "a"), v_ + 2),
                                  v_ + 2);
                                if (v_ == e_) {
                                    break;
                                }
                                ++v_;
                            }
                            mlfAssign(&i, mlfScalar(v_));
                        }
                    }
                    /*
                     * if (c(1+2)<half) ;
                     */
                    if (mclLtBool(
                          mclIntArrayRef1(mclVa(*c, "c"), 3),
                          mclVg(&half, "half"))) {
                        /*
                         * c(-1+2)=one;
                         */
                        mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
                        /*
                         * c(l+1+2)=0.0;
                         */
                        mclArrayAssign1(
                          c,
                          _mxarray1_,
                          mclPlus(
                            mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
                    /*
                     * end;
                     */
                    }
                    /*
                     * return;
                     */
                    goto return_;
                /*
                 * else;
                 */
                } else {
                    mxDestroyArray(a_1);
                    /*
                     * z(-1+2)=a(-1+2);
                     */
                    mclIntArrayAssign1(z, mclIntArrayRef1(mclVa(a, "a"), 1), 1);
                    /*
                     * goon300=1;
                     */
                    mlfAssign(&goon300, _mxarray3_);
                    /*
                     * goon190=1;
                     */
                    mlfAssign(&goon190, _mxarray3_);
                    /*
                     * if (abs(a(-1+2)-b(-1+2))>=half) ;
                     */
                    if (mclGeBool(
                          mlfAbs(
                            mclMinus(
                              mclIntArrayRef1(mclVa(a, "a"), 1),
                              mclIntArrayRef1(mclVa(*b, "b"), 1))),
                          mclVg(&half, "half"))) {
                        /*
                         * goon300=0;
                         */
                        mlfAssign(&goon300, _mxarray1_);
                        /*
                         * if (ediff>0) ;
                         */
                        if (mclGtBool(mclVv(ediff, "ediff"), _mxarray1_)) {
                            /*
                             * z(l+1+2)=a(l+1+2);
                             */
                            mclArrayAssign1(
                              z,
                              mclArrayRef1(
                                mclVa(a, "a"),
                                mclPlus(
                                  mclPlus(mclVa(*l, "l"), _mxarray3_),
                                  _mxarray4_)),
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                        /*
                         * elseif (ediff<0);
                         */
                        } else if (mclLtBool(
                                     mclVv(ediff, "ediff"), _mxarray1_)) {
                            /*
                             * z(l+1+2)=b(l+1+2);
                             */
                            mclArrayAssign1(
                              z,
                              mclArrayRef1(
                                mclVa(*b, "b"),
                                mclPlus(
                                  mclPlus(mclVa(*l, "l"), _mxarray3_),
                                  _mxarray4_)),
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                            /*
                             * z(-1+2)=b(-1+2);
                             */
                            mclIntArrayAssign1(
                              z, mclIntArrayRef1(mclVa(*b, "b"), 1), 1);
                            /*
                             * goon190=0;
                             */
                            mlfAssign(&goon190, _mxarray1_);
                        /*
                         * else;
                         */
                        } else {
                            /*
                             * for i=1 : l;
                             */
                            int v_ = mclForIntStart(1);
                            int e_ = mclForIntEnd(mclVa(*l, "l"));
                            if (v_ > e_) {
                                mlfAssign(&i, _mxarray12_);
                            } else {
                                /*
                                 * if (a(i+2)>b(i+2)) ;
                                 * z(l+1+2)=a(l+1+2);
                                 * break;
                                 * end;
                                 * if (a(i+2)<b(i+2)) ;
                                 * z(l+1+2)=b(l+1+2);
                                 * z(-1+2)=b(-1+2);
                                 * goon190=0;
                                 * end;
                                 * end;
                                 */
                                for (; ; ) {
                                    if (mclGtBool(
                                          mclIntArrayRef1(
                                            mclVa(a, "a"), v_ + 2),
                                          mclIntArrayRef1(
                                            mclVa(*b, "b"), v_ + 2))) {
                                        mclArrayAssign1(
                                          z,
                                          mclArrayRef1(
                                            mclVa(a, "a"),
                                            mclPlus(
                                              mclPlus(
                                                mclVa(*l, "l"), _mxarray3_),
                                              _mxarray4_)),
                                          mclPlus(
                                            mclPlus(mclVa(*l, "l"), _mxarray3_),
                                            _mxarray4_));
                                        break;
                                    }
                                    if (mclLtBool(
                                          mclIntArrayRef1(
                                            mclVa(a, "a"), v_ + 2),
                                          mclIntArrayRef1(
                                            mclVa(*b, "b"), v_ + 2))) {
                                        mclArrayAssign1(
                                          z,
                                          mclArrayRef1(
                                            mclVa(*b, "b"),
                                            mclPlus(
                                              mclPlus(
                                                mclVa(*l, "l"), _mxarray3_),
                                              _mxarray4_)),
                                          mclPlus(
                                            mclPlus(mclVa(*l, "l"), _mxarray3_),
                                            _mxarray4_));
                                        mclIntArrayAssign1(
                                          z,
                                          mclIntArrayRef1(mclVa(*b, "b"), 1),
                                          1);
                                        mlfAssign(&goon190, _mxarray1_);
                                    }
                                    if (v_ == e_) {
                                        break;
                                    }
                                    ++v_;
                                }
                                mlfAssign(&i, mlfScalar(v_));
                            }
                        /*
                         * end;
                         */
                        }
                    /*
                     * %
                     * elseif (ediff>0);
                     */
                    } else if (mclGtBool(mclVv(ediff, "ediff"), _mxarray1_)) {
                        /*
                         * z(l+1+2)=a(l+1+2);
                         */
                        mclArrayAssign1(
                          z,
                          mclArrayRef1(
                            mclVa(a, "a"),
                            mclPlus(
                              mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
                          mclPlus(
                            mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
                        /*
                         * for i=l : -1: 1+ediff ;
                         */
                        {
                            mclForLoopIterator viter__;
                            for (mclForStart(
                                   &viter__,
                                   mclVa(*l, "l"),
                                   _mxarray21_,
                                   mclPlus(_mxarray3_, mclVv(ediff, "ediff")));
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=a(i+2)+b(i-ediff+2)+z(i+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclPlus(
                                    mclPlus(
                                      mclArrayRef1(
                                        mclVa(a, "a"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclArrayRef1(
                                        mclVa(*b, "b"),
                                        mclPlus(
                                          mclMinus(
                                            mclVv(i, "i"),
                                            mclVv(ediff, "ediff")),
                                          _mxarray4_))),
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_))),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                                /*
                                 * if (z(i+2)>=rmax) ;
                                 */
                                if (mclGeBool(
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclVa(*rmax, "rmax"))) {
                                    /*
                                     * z(i+2)=z(i+2)-rmax;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclMinus(
                                        mclArrayRef1(
                                          mclVa(*z, "z"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_)),
                                        mclVa(*rmax, "rmax")),
                                      mclPlus(mclVv(i, "i"), _mxarray4_));
                                    /*
                                     * z(i-1+2)=one;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclVg(&one, "one"),
                                      mclPlus(
                                        mclMinus(mclVv(i, "i"), _mxarray3_),
                                        _mxarray4_));
                                /*
                                 * end;
                                 */
                                }
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                        }
                        /*
                         * for i=ediff : -1: 1 ;
                         */
                        {
                            mclForLoopIterator viter__;
                            for (mclForStart(
                                   &viter__,
                                   mclVv(ediff, "ediff"),
                                   _mxarray21_,
                                   _mxarray3_);
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=a(i+2)+z(i+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclPlus(
                                    mclArrayRef1(
                                      mclVa(a, "a"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_)),
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_))),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                                /*
                                 * if (z(i+2)>=rmax) ;
                                 */
                                if (mclGeBool(
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclVa(*rmax, "rmax"))) {
                                    /*
                                     * z(i+2)=z(i+2)-rmax;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclMinus(
                                        mclArrayRef1(
                                          mclVa(*z, "z"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_)),
                                        mclVa(*rmax, "rmax")),
                                      mclPlus(mclVv(i, "i"), _mxarray4_));
                                    /*
                                     * z(i-1+2)=one;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclVg(&one, "one"),
                                      mclPlus(
                                        mclMinus(mclVv(i, "i"), _mxarray3_),
                                        _mxarray4_));
                                /*
                                 * end;
                                 */
                                }
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                        }
                        /*
                         * if (z(0+2)>half) ;
                         */
                        if (mclGtBool(
                              mclIntArrayRef1(mclVa(*z, "z"), 2),
                              mclVg(&half, "half"))) {
                            mclForLoopIterator viter__;
                            /*
                             * for i=l : -1: 1 ;
                             */
                            for (mclForStart(
                                   &viter__,
                                   mclVa(*l, "l"),
                                   _mxarray21_,
                                   _mxarray3_);
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=z(i-1+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclArrayRef1(
                                    mclVa(*z, "z"),
                                    mclPlus(
                                      mclMinus(mclVv(i, "i"), _mxarray3_),
                                      _mxarray4_)),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                            /*
                             * z(l+1+2)=z(l+1+2)+1;
                             */
                            mclArrayAssign1(
                              z,
                              mclPlus(
                                mclArrayRef1(
                                  mclVa(*z, "z"),
                                  mclPlus(
                                    mclPlus(mclVa(*l, "l"), _mxarray3_),
                                    _mxarray4_)),
                                _mxarray3_),
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                            /*
                             * z(0+2)=0.0;
                             */
                            mclIntArrayAssign1(z, _mxarray1_, 2);
                        /*
                         * end;
                         */
                        }
                    /*
                     * elseif (ediff<0);
                     */
                    } else if (mclLtBool(mclVv(ediff, "ediff"), _mxarray1_)) {
                        /*
                         * z(l+1+2)=b(l+1+2);
                         */
                        mclArrayAssign1(
                          z,
                          mclArrayRef1(
                            mclVa(*b, "b"),
                            mclPlus(
                              mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
                          mclPlus(
                            mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
                        /*
                         * for i=l : -1: 1-ediff ;
                         */
                        {
                            mclForLoopIterator viter__;
                            for (mclForStart(
                                   &viter__,
                                   mclVa(*l, "l"),
                                   _mxarray21_,
                                   mclMinus(_mxarray3_, mclVv(ediff, "ediff")));
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=a(i+ediff+2)+b(i+2)+z(i+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclPlus(
                                    mclPlus(
                                      mclArrayRef1(
                                        mclVa(a, "a"),
                                        mclPlus(
                                          mclPlus(
                                            mclVv(i, "i"),
                                            mclVv(ediff, "ediff")),
                                          _mxarray4_)),
                                      mclArrayRef1(
                                        mclVa(*b, "b"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_))),
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_))),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                                /*
                                 * if (z(i+2)>=rmax) ;
                                 */
                                if (mclGeBool(
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclVa(*rmax, "rmax"))) {
                                    /*
                                     * z(i+2)=z(i+2)-rmax;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclMinus(
                                        mclArrayRef1(
                                          mclVa(*z, "z"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_)),
                                        mclVa(*rmax, "rmax")),
                                      mclPlus(mclVv(i, "i"), _mxarray4_));
                                    /*
                                     * z(i-1+2)=one;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclVg(&one, "one"),
                                      mclPlus(
                                        mclMinus(mclVv(i, "i"), _mxarray3_),
                                        _mxarray4_));
                                /*
                                 * end;
                                 */
                                }
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                        }
                        /*
                         * for i=0-ediff : -1: 1 ;
                         */
                        {
                            mclForLoopIterator viter__;
                            for (mclForStart(
                                   &viter__,
                                   mclMinus(_mxarray1_, mclVv(ediff, "ediff")),
                                   _mxarray21_,
                                   _mxarray3_);
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=b(i+2)+z(i+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclPlus(
                                    mclArrayRef1(
                                      mclVa(*b, "b"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_)),
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_))),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                                /*
                                 * if (z(i+2)>=rmax) ;
                                 */
                                if (mclGeBool(
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclVa(*rmax, "rmax"))) {
                                    /*
                                     * z(i+2)=z(i+2)-rmax;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclMinus(
                                        mclArrayRef1(
                                          mclVa(*z, "z"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_)),
                                        mclVa(*rmax, "rmax")),
                                      mclPlus(mclVv(i, "i"), _mxarray4_));
                                    /*
                                     * z(i-1+2)=one;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclVg(&one, "one"),
                                      mclPlus(
                                        mclMinus(mclVv(i, "i"), _mxarray3_),
                                        _mxarray4_));
                                /*
                                 * end;
                                 */
                                }
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                        }
                        /*
                         * if (z(0+2)>half) ;
                         */
                        if (mclGtBool(
                              mclIntArrayRef1(mclVa(*z, "z"), 2),
                              mclVg(&half, "half"))) {
                            mclForLoopIterator viter__;
                            /*
                             * for i=l : -1: 1 ;
                             */
                            for (mclForStart(
                                   &viter__,
                                   mclVa(*l, "l"),
                                   _mxarray21_,
                                   _mxarray3_);
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=z(i-1+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclArrayRef1(
                                    mclVa(*z, "z"),
                                    mclPlus(
                                      mclMinus(mclVv(i, "i"), _mxarray3_),
                                      _mxarray4_)),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                            /*
                             * z(l+1+2)=z(l+1+2)+one;
                             */
                            mclArrayAssign1(
                              z,
                              mclPlus(
                                mclArrayRef1(
                                  mclVa(*z, "z"),
                                  mclPlus(
                                    mclPlus(mclVa(*l, "l"), _mxarray3_),
                                    _mxarray4_)),
                                mclVg(&one, "one")),
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                            /*
                             * z(0+2)=0.0;
                             */
                            mclIntArrayAssign1(z, _mxarray1_, 2);
                        /*
                         * end;
                         */
                        }
                    /*
                     * else;
                     */
                    } else {
                        /*
                         * z(l+1+2)=a(l+1+2);
                         */
                        mclArrayAssign1(
                          z,
                          mclArrayRef1(
                            mclVa(a, "a"),
                            mclPlus(
                              mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
                          mclPlus(
                            mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
                        /*
                         * for i=l : -1: 1 ;
                         */
                        {
                            mclForLoopIterator viter__;
                            for (mclForStart(
                                   &viter__,
                                   mclVa(*l, "l"),
                                   _mxarray21_,
                                   _mxarray3_);
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=a(i+2)+b(i+2)+z(i+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclPlus(
                                    mclPlus(
                                      mclArrayRef1(
                                        mclVa(a, "a"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclArrayRef1(
                                        mclVa(*b, "b"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_))),
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_))),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                                /*
                                 * if (z(i+2)>=rmax) ;
                                 */
                                if (mclGeBool(
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclVa(*rmax, "rmax"))) {
                                    /*
                                     * z(i+2)=z(i+2)-rmax;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclMinus(
                                        mclArrayRef1(
                                          mclVa(*z, "z"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_)),
                                        mclVa(*rmax, "rmax")),
                                      mclPlus(mclVv(i, "i"), _mxarray4_));
                                    /*
                                     * z(i-1+2)=one;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclVg(&one, "one"),
                                      mclPlus(
                                        mclMinus(mclVv(i, "i"), _mxarray3_),
                                        _mxarray4_));
                                /*
                                 * end;
                                 */
                                }
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                        }
                        /*
                         * if (z(0+2)>half) ;
                         */
                        if (mclGtBool(
                              mclIntArrayRef1(mclVa(*z, "z"), 2),
                              mclVg(&half, "half"))) {
                            mclForLoopIterator viter__;
                            /*
                             * for i=l : -1: 1 ;
                             */
                            for (mclForStart(
                                   &viter__,
                                   mclVa(*l, "l"),
                                   _mxarray21_,
                                   _mxarray3_);
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=z(i-1+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclArrayRef1(
                                    mclVa(*z, "z"),
                                    mclPlus(
                                      mclMinus(mclVv(i, "i"), _mxarray3_),
                                      _mxarray4_)),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                            /*
                             * z(l+1+2)=z(l+1+2)+one;
                             */
                            mclArrayAssign1(
                              z,
                              mclPlus(
                                mclArrayRef1(
                                  mclVa(*z, "z"),
                                  mclPlus(
                                    mclPlus(mclVa(*l, "l"), _mxarray3_),
                                    _mxarray4_)),
                                mclVg(&one, "one")),
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                            /*
                             * z(0+2)=0.0;
                             */
                            mclIntArrayAssign1(z, _mxarray1_, 2);
                        /*
                         * end;
                         */
                        }
                    /*
                     * end;
                     */
                    }
                    /*
                     * if (goon300==1) ;
                     */
                    if (mclEqBool(mclVv(goon300, "goon300"), _mxarray3_)) {
                        /*
                         * i=i; %here is the line that had a +1 taken from it.
                         */
                        mlfAssign(&i, mclVv(i, "i"));
                        /*
                         * while (z(i+2)<half & i<l+1);
                         */
                        for (;;) {
                            mxArray * a_2
                              = mclInitialize(
                                  mclLt(
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_)),
                                    mclVg(&half, "half")));
                            if (mlfTobool(a_2)
                                && mlfTobool(
                                     mclAnd(
                                       a_2,
                                       mclLt(
                                         mclVv(i, "i"),
                                         mclPlus(
                                           mclVa(*l, "l"), _mxarray3_))))) {
                                mxDestroyArray(a_2);
                            } else {
                                mxDestroyArray(a_2);
                                break;
                            }
                            /*
                             * i=i+1;
                             */
                            mlfAssign(&i, mclPlus(mclVv(i, "i"), _mxarray3_));
                        /*
                         * end;
                         */
                        }
                        /*
                         * if (i==l+1) ;
                         */
                        if (mclEqBool(
                              mclVv(i, "i"),
                              mclPlus(mclVa(*l, "l"), _mxarray3_))) {
                            /*
                             * z(-1+2)=one;
                             */
                            mclIntArrayAssign1(z, mclVg(&one, "one"), 1);
                            /*
                             * z(l+1+2)=0.0;
                             */
                            mclArrayAssign1(
                              z,
                              _mxarray1_,
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                            /*
                             * for i=-1 : l+1;
                             */
                            {
                                int v_ = mclForIntStart(-1);
                                int e_
                                  = mclForIntEnd(
                                      mclPlus(mclVa(*l, "l"), _mxarray3_));
                                if (v_ > e_) {
                                    mlfAssign(&i, _mxarray12_);
                                } else {
                                    /*
                                     * c(i+2)=z(i+2);
                                     * end;
                                     */
                                    for (; ; ) {
                                        mclIntArrayAssign1(
                                          c,
                                          mclIntArrayRef1(
                                            mclVa(*z, "z"), v_ + 2),
                                          v_ + 2);
                                        if (v_ == e_) {
                                            break;
                                        }
                                        ++v_;
                                    }
                                    mlfAssign(&i, mlfScalar(v_));
                                }
                            }
                            /*
                             * if (c(1+2)<half) ;
                             */
                            if (mclLtBool(
                                  mclIntArrayRef1(mclVa(*c, "c"), 3),
                                  mclVg(&half, "half"))) {
                                /*
                                 * c(-1+2)=one;
                                 */
                                mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
                                /*
                                 * c(l+1+2)=0.0;
                                 */
                                mclArrayAssign1(
                                  c,
                                  _mxarray1_,
                                  mclPlus(
                                    mclPlus(mclVa(*l, "l"), _mxarray3_),
                                    _mxarray4_));
                            /*
                             * end;
                             */
                            }
                            /*
                             * return;
                             */
                            goto return_;
                        /*
                         * end;
                         */
                        }
                        /*
                         * for j=1 : l+1-i;
                         */
                        {
                            int v_ = mclForIntStart(1);
                            int e_
                              = mclForIntEnd(
                                  mclMinus(
                                    mclPlus(mclVa(*l, "l"), _mxarray3_),
                                    mclVv(i, "i")));
                            if (v_ > e_) {
                                mlfAssign(&j, _mxarray12_);
                            } else {
                                /*
                                 * z(j+2)=z(j+i-1+2);
                                 * end;
                                 */
                                for (; ; ) {
                                    mclIntArrayAssign1(
                                      z,
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(
                                          mclMinus(
                                            mclPlus(
                                              mlfScalar(v_), mclVv(i, "i")),
                                            _mxarray3_),
                                          _mxarray4_)),
                                      v_ + 2);
                                    if (v_ == e_) {
                                        break;
                                    }
                                    ++v_;
                                }
                                mlfAssign(&j, mlfScalar(v_));
                            }
                        }
                        /*
                         * for j=l+2-i : l;
                         */
                        {
                            mclForLoopIterator viter__;
                            for (mclForStart(
                                   &viter__,
                                   mclMinus(
                                     mclPlus(mclVa(*l, "l"), _mxarray4_),
                                     mclVv(i, "i")),
                                   mclVa(*l, "l"),
                                   NULL);
                                 mclForNext(&viter__, &j);
                                 ) {
                                /*
                                 * z(j+2)=0.0;
                                 */
                                mclArrayAssign1(
                                  z,
                                  _mxarray1_,
                                  mclPlus(mclVv(j, "j"), _mxarray4_));
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                        }
                        /*
                         * z(l+1+2)=z(l+1+2)-i+1;
                         */
                        mclArrayAssign1(
                          z,
                          mclPlus(
                            mclMinus(
                              mclArrayRef1(
                                mclVa(*z, "z"),
                                mclPlus(
                                  mclPlus(mclVa(*l, "l"), _mxarray3_),
                                  _mxarray4_)),
                              mclVv(i, "i")),
                            _mxarray3_),
                          mclPlus(
                            mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
                        /*
                         * for i=-1 : l+1;
                         */
                        {
                            int v_ = mclForIntStart(-1);
                            int e_
                              = mclForIntEnd(
                                  mclPlus(mclVa(*l, "l"), _mxarray3_));
                            if (v_ > e_) {
                                mlfAssign(&i, _mxarray12_);
                            } else {
                                /*
                                 * c(i+2)=z(i+2);
                                 * end;
                                 */
                                for (; ; ) {
                                    mclIntArrayAssign1(
                                      c,
                                      mclIntArrayRef1(mclVa(*z, "z"), v_ + 2),
                                      v_ + 2);
                                    if (v_ == e_) {
                                        break;
                                    }
                                    ++v_;
                                }
                                mlfAssign(&i, mlfScalar(v_));
                            }
                        }
                        /*
                         * if (c(1+2)<half) ;
                         */
                        if (mclLtBool(
                              mclIntArrayRef1(mclVa(*c, "c"), 3),
                              mclVg(&half, "half"))) {
                            /*
                             * c(-1+2)=one;
                             */
                            mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
                            /*
                             * c(l+1+2)=0.0;
                             */
                            mclArrayAssign1(
                              c,
                              _mxarray1_,
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                        /*
                         * end;
                         */
                        }
                        /*
                         * return;
                         */
                        goto return_;
                    /*
                     * end;
                     */
                    }
                    /*
                     * %
                     * if (goon190==1) ;
                     */
                    if (mclEqBool(mclVv(goon190, "goon190"), _mxarray3_)) {
                        /*
                         * if (ediff>0) ;
                         */
                        if (mclGtBool(mclVv(ediff, "ediff"), _mxarray1_)) {
                            mclForLoopIterator viter__;
                            /*
                             * for i=l : -1: 1+ediff ;
                             */
                            for (mclForStart(
                                   &viter__,
                                   mclVa(*l, "l"),
                                   _mxarray21_,
                                   mclPlus(_mxarray3_, mclVv(ediff, "ediff")));
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=a(i+2)-b(i-ediff+2)+z(i+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclPlus(
                                    mclMinus(
                                      mclArrayRef1(
                                        mclVa(a, "a"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclArrayRef1(
                                        mclVa(*b, "b"),
                                        mclPlus(
                                          mclMinus(
                                            mclVv(i, "i"),
                                            mclVv(ediff, "ediff")),
                                          _mxarray4_))),
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_))),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                                /*
                                 * if (z(i+2)<0.0) ;
                                 */
                                if (mclLtBool(
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      _mxarray1_)) {
                                    /*
                                     * z(i+2)=z(i+2)+rmax;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclPlus(
                                        mclArrayRef1(
                                          mclVa(*z, "z"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_)),
                                        mclVa(*rmax, "rmax")),
                                      mclPlus(mclVv(i, "i"), _mxarray4_));
                                    /*
                                     * z(i-1+2)=-one;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclUminus(mclVg(&one, "one")),
                                      mclPlus(
                                        mclMinus(mclVv(i, "i"), _mxarray3_),
                                        _mxarray4_));
                                /*
                                 * end;
                                 */
                                }
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                            /*
                             * for i=ediff : -1: 1 ;
                             */
                            {
                                mclForLoopIterator viter__;
                                for (mclForStart(
                                       &viter__,
                                       mclVv(ediff, "ediff"),
                                       _mxarray21_,
                                       _mxarray3_);
                                     mclForNext(&viter__, &i);
                                     ) {
                                    /*
                                     * z(i+2)=a(i+2)+z(i+2);
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclPlus(
                                        mclArrayRef1(
                                          mclVa(a, "a"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_)),
                                        mclArrayRef1(
                                          mclVa(*z, "z"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_))),
                                      mclPlus(mclVv(i, "i"), _mxarray4_));
                                    /*
                                     * if (z(i+2)<0.0) ;
                                     */
                                    if (mclLtBool(
                                          mclArrayRef1(
                                            mclVa(*z, "z"),
                                            mclPlus(mclVv(i, "i"), _mxarray4_)),
                                          _mxarray1_)) {
                                        /*
                                         * z(i+2)=z(i+2)+rmax;
                                         */
                                        mclArrayAssign1(
                                          z,
                                          mclPlus(
                                            mclArrayRef1(
                                              mclVa(*z, "z"),
                                              mclPlus(
                                                mclVv(i, "i"), _mxarray4_)),
                                            mclVa(*rmax, "rmax")),
                                          mclPlus(mclVv(i, "i"), _mxarray4_));
                                        /*
                                         * z(i-1+2)=-one;
                                         */
                                        mclArrayAssign1(
                                          z,
                                          mclUminus(mclVg(&one, "one")),
                                          mclPlus(
                                            mclMinus(mclVv(i, "i"), _mxarray3_),
                                            _mxarray4_));
                                    /*
                                     * end;
                                     */
                                    }
                                /*
                                 * end;
                                 */
                                }
                                mclDestroyForLoopIterator(viter__);
                            }
                        /*
                         * else;
                         */
                        } else {
                            mclForLoopIterator viter__;
                            /*
                             * for i=l : -1: 1 ;
                             */
                            for (mclForStart(
                                   &viter__,
                                   mclVa(*l, "l"),
                                   _mxarray21_,
                                   _mxarray3_);
                                 mclForNext(&viter__, &i);
                                 ) {
                                /*
                                 * z(i+2)=a(i+2)-b(i+2)+z(i+2);
                                 */
                                mclArrayAssign1(
                                  z,
                                  mclPlus(
                                    mclMinus(
                                      mclArrayRef1(
                                        mclVa(a, "a"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      mclArrayRef1(
                                        mclVa(*b, "b"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_))),
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_))),
                                  mclPlus(mclVv(i, "i"), _mxarray4_));
                                /*
                                 * if (z(i+2)<0.0) ;
                                 */
                                if (mclLtBool(
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(mclVv(i, "i"), _mxarray4_)),
                                      _mxarray1_)) {
                                    /*
                                     * z(i+2)=z(i+2)+rmax;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclPlus(
                                        mclArrayRef1(
                                          mclVa(*z, "z"),
                                          mclPlus(mclVv(i, "i"), _mxarray4_)),
                                        mclVa(*rmax, "rmax")),
                                      mclPlus(mclVv(i, "i"), _mxarray4_));
                                    /*
                                     * z(i-1+2)=-one;
                                     */
                                    mclArrayAssign1(
                                      z,
                                      mclUminus(mclVg(&one, "one")),
                                      mclPlus(
                                        mclMinus(mclVv(i, "i"), _mxarray3_),
                                        _mxarray4_));
                                /*
                                 * end;
                                 */
                                }
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                        /*
                         * end;
                         */
                        }
                        /*
                         * if (z(1+2)>half) ;
                         */
                        if (mclGtBool(
                              mclIntArrayRef1(mclVa(*z, "z"), 3),
                              mclVg(&half, "half"))) {
                            /*
                             * for i=-1 : l+1;
                             */
                            int v_ = mclForIntStart(-1);
                            int e_
                              = mclForIntEnd(
                                  mclPlus(mclVa(*l, "l"), _mxarray3_));
                            if (v_ > e_) {
                                mlfAssign(&i, _mxarray12_);
                            } else {
                                /*
                                 * c(i+2)=z(i+2);
                                 * end;
                                 */
                                for (; ; ) {
                                    mclIntArrayAssign1(
                                      c,
                                      mclIntArrayRef1(mclVa(*z, "z"), v_ + 2),
                                      v_ + 2);
                                    if (v_ == e_) {
                                        break;
                                    }
                                    ++v_;
                                }
                                mlfAssign(&i, mlfScalar(v_));
                            }
                            /*
                             * if (c(1+2)<half) ;
                             */
                            if (mclLtBool(
                                  mclIntArrayRef1(mclVa(*c, "c"), 3),
                                  mclVg(&half, "half"))) {
                                /*
                                 * c(-1+2)=one;
                                 */
                                mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
                                /*
                                 * c(l+1+2)=0.0;
                                 */
                                mclArrayAssign1(
                                  c,
                                  _mxarray1_,
                                  mclPlus(
                                    mclPlus(mclVa(*l, "l"), _mxarray3_),
                                    _mxarray4_));
                            /*
                             * end;
                             */
                            }
                            /*
                             * return;
                             */
                            goto return_;
                        /*
                         * end;
                         */
                        }
                        /*
                         * i=1;
                         */
                        mlfAssign(&i, _mxarray3_);
                        /*
                         * i=i+1;
                         */
                        mlfAssign(&i, mclPlus(mclVv(i, "i"), _mxarray3_));
                        /*
                         * while (z(i+2)<half & i<l+1);
                         */
                        for (;;) {
                            mxArray * a_3
                              = mclInitialize(
                                  mclLt(
                                    mclArrayRef1(
                                      mclVa(*z, "z"),
                                      mclPlus(mclVv(i, "i"), _mxarray4_)),
                                    mclVg(&half, "half")));
                            if (mlfTobool(a_3)
                                && mlfTobool(
                                     mclAnd(
                                       a_3,
                                       mclLt(
                                         mclVv(i, "i"),
                                         mclPlus(
                                           mclVa(*l, "l"), _mxarray3_))))) {
                                mxDestroyArray(a_3);
                            } else {
                                mxDestroyArray(a_3);
                                break;
                            }
                            /*
                             * i=i+1;
                             */
                            mlfAssign(&i, mclPlus(mclVv(i, "i"), _mxarray3_));
                        /*
                         * end;
                         */
                        }
                        /*
                         * if (i==l+1) ;
                         */
                        if (mclEqBool(
                              mclVv(i, "i"),
                              mclPlus(mclVa(*l, "l"), _mxarray3_))) {
                            /*
                             * z(-1+2)=one;
                             */
                            mclIntArrayAssign1(z, mclVg(&one, "one"), 1);
                            /*
                             * z(l+1+2)=0.0;
                             */
                            mclArrayAssign1(
                              z,
                              _mxarray1_,
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                            /*
                             * for i=-1 : l+1;
                             */
                            {
                                int v_ = mclForIntStart(-1);
                                int e_
                                  = mclForIntEnd(
                                      mclPlus(mclVa(*l, "l"), _mxarray3_));
                                if (v_ > e_) {
                                    mlfAssign(&i, _mxarray12_);
                                } else {
                                    /*
                                     * c(i+2)=z(i+2);
                                     * end;
                                     */
                                    for (; ; ) {
                                        mclIntArrayAssign1(
                                          c,
                                          mclIntArrayRef1(
                                            mclVa(*z, "z"), v_ + 2),
                                          v_ + 2);
                                        if (v_ == e_) {
                                            break;
                                        }
                                        ++v_;
                                    }
                                    mlfAssign(&i, mlfScalar(v_));
                                }
                            }
                            /*
                             * if (c(1+2)<half) ;
                             */
                            if (mclLtBool(
                                  mclIntArrayRef1(mclVa(*c, "c"), 3),
                                  mclVg(&half, "half"))) {
                                /*
                                 * c(-1+2)=one;
                                 */
                                mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
                                /*
                                 * c(l+1+2)=0.0;
                                 */
                                mclArrayAssign1(
                                  c,
                                  _mxarray1_,
                                  mclPlus(
                                    mclPlus(mclVa(*l, "l"), _mxarray3_),
                                    _mxarray4_));
                            /*
                             * end;
                             */
                            }
                            /*
                             * return;
                             */
                            goto return_;
                        /*
                         * end;
                         */
                        }
                        /*
                         * for j=1 : l+1-i;
                         */
                        {
                            int v_ = mclForIntStart(1);
                            int e_
                              = mclForIntEnd(
                                  mclMinus(
                                    mclPlus(mclVa(*l, "l"), _mxarray3_),
                                    mclVv(i, "i")));
                            if (v_ > e_) {
                                mlfAssign(&j, _mxarray12_);
                            } else {
                                /*
                                 * z(j+2)=z(j+i-1+2);
                                 * end;
                                 */
                                for (; ; ) {
                                    mclIntArrayAssign1(
                                      z,
                                      mclArrayRef1(
                                        mclVa(*z, "z"),
                                        mclPlus(
                                          mclMinus(
                                            mclPlus(
                                              mlfScalar(v_), mclVv(i, "i")),
                                            _mxarray3_),
                                          _mxarray4_)),
                                      v_ + 2);
                                    if (v_ == e_) {
                                        break;
                                    }
                                    ++v_;
                                }
                                mlfAssign(&j, mlfScalar(v_));
                            }
                        }
                        /*
                         * for j=l+2-i : l;
                         */
                        {
                            mclForLoopIterator viter__;
                            for (mclForStart(
                                   &viter__,
                                   mclMinus(
                                     mclPlus(mclVa(*l, "l"), _mxarray4_),
                                     mclVv(i, "i")),
                                   mclVa(*l, "l"),
                                   NULL);
                                 mclForNext(&viter__, &j);
                                 ) {
                                /*
                                 * z(j+2)=0.0;
                                 */
                                mclArrayAssign1(
                                  z,
                                  _mxarray1_,
                                  mclPlus(mclVv(j, "j"), _mxarray4_));
                            /*
                             * end;
                             */
                            }
                            mclDestroyForLoopIterator(viter__);
                        }
                        /*
                         * z(l+1+2)=z(l+1+2)-i+1;
                         */
                        mclArrayAssign1(
                          z,
                          mclPlus(
                            mclMinus(
                              mclArrayRef1(
                                mclVa(*z, "z"),
                                mclPlus(
                                  mclPlus(mclVa(*l, "l"), _mxarray3_),
                                  _mxarray4_)),
                              mclVv(i, "i")),
                            _mxarray3_),
                          mclPlus(
                            mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
                        /*
                         * for i=-1 : l+1;
                         */
                        {
                            int v_ = mclForIntStart(-1);
                            int e_
                              = mclForIntEnd(
                                  mclPlus(mclVa(*l, "l"), _mxarray3_));
                            if (v_ > e_) {
                                mlfAssign(&i, _mxarray12_);
                            } else {
                                /*
                                 * c(i+2)=z(i+2);
                                 * end;
                                 */
                                for (; ; ) {
                                    mclIntArrayAssign1(
                                      c,
                                      mclIntArrayRef1(mclVa(*z, "z"), v_ + 2),
                                      v_ + 2);
                                    if (v_ == e_) {
                                        break;
                                    }
                                    ++v_;
                                }
                                mlfAssign(&i, mlfScalar(v_));
                            }
                        }
                        /*
                         * if (c(1+2)<half) ;
                         */
                        if (mclLtBool(
                              mclIntArrayRef1(mclVa(*c, "c"), 3),
                              mclVg(&half, "half"))) {
                            /*
                             * c(-1+2)=one;
                             */
                            mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
                            /*
                             * c(l+1+2)=0.0;
                             */
                            mclArrayAssign1(
                              c,
                              _mxarray1_,
                              mclPlus(
                                mclPlus(mclVa(*l, "l"), _mxarray3_),
                                _mxarray4_));
                        /*
                         * end;
                         */
                        }
                        /*
                         * return;
                         */
                        goto return_;
                    /*
                     * end;
                     */
                    }
                }
            /*
             * end;
             */
            }
            /*
             * %
             * if (ediff<0) ;
             */
            if (mclLtBool(mclVv(ediff, "ediff"), _mxarray1_)) {
                mclForLoopIterator viter__;
                /*
                 * for i=l : -1: 1-ediff ;
                 */
                for (mclForStart(
                       &viter__,
                       mclVa(*l, "l"),
                       _mxarray21_,
                       mclMinus(_mxarray3_, mclVv(ediff, "ediff")));
                     mclForNext(&viter__, &i);
                     ) {
                    /*
                     * z(i+2)=b(i+2)-a(i+ediff+2)+z(i+2);
                     */
                    mclArrayAssign1(
                      z,
                      mclPlus(
                        mclMinus(
                          mclArrayRef1(
                            mclVa(*b, "b"), mclPlus(mclVv(i, "i"), _mxarray4_)),
                          mclArrayRef1(
                            mclVa(a, "a"),
                            mclPlus(
                              mclPlus(mclVv(i, "i"), mclVv(ediff, "ediff")),
                              _mxarray4_))),
                        mclArrayRef1(
                          mclVa(*z, "z"), mclPlus(mclVv(i, "i"), _mxarray4_))),
                      mclPlus(mclVv(i, "i"), _mxarray4_));
                    /*
                     * if (z(i+2)<0.0) ;
                     */
                    if (mclLtBool(
                          mclArrayRef1(
                            mclVa(*z, "z"), mclPlus(mclVv(i, "i"), _mxarray4_)),
                          _mxarray1_)) {
                        /*
                         * z(i+2)=z(i+2)+rmax;
                         */
                        mclArrayAssign1(
                          z,
                          mclPlus(
                            mclArrayRef1(
                              mclVa(*z, "z"),
                              mclPlus(mclVv(i, "i"), _mxarray4_)),
                            mclVa(*rmax, "rmax")),
                          mclPlus(mclVv(i, "i"), _mxarray4_));
                        /*
                         * z(i-1+2)=-one;
                         */
                        mclArrayAssign1(
                          z,
                          mclUminus(mclVg(&one, "one")),
                          mclPlus(
                            mclMinus(mclVv(i, "i"), _mxarray3_), _mxarray4_));
                    /*
                     * end;
                     */
                    }
                /*
                 * end;
                 */
                }
                mclDestroyForLoopIterator(viter__);
                /*
                 * for i=0-ediff : -1: 1 ;
                 */
                {
                    mclForLoopIterator viter__;
                    for (mclForStart(
                           &viter__,
                           mclMinus(_mxarray1_, mclVv(ediff, "ediff")),
                           _mxarray21_,
                           _mxarray3_);
                         mclForNext(&viter__, &i);
                         ) {
                        /*
                         * z(i+2)=b(i+2)+z(i+2);
                         */
                        mclArrayAssign1(
                          z,
                          mclPlus(
                            mclArrayRef1(
                              mclVa(*b, "b"),
                              mclPlus(mclVv(i, "i"), _mxarray4_)),
                            mclArrayRef1(
                              mclVa(*z, "z"),
                              mclPlus(mclVv(i, "i"), _mxarray4_))),
                          mclPlus(mclVv(i, "i"), _mxarray4_));
                        /*
                         * if (z(i+2)<0.0) ;
                         */
                        if (mclLtBool(
                              mclArrayRef1(
                                mclVa(*z, "z"),
                                mclPlus(mclVv(i, "i"), _mxarray4_)),
                              _mxarray1_)) {
                            /*
                             * z(i+2)=z(i+2)+rmax;
                             */
                            mclArrayAssign1(
                              z,
                              mclPlus(
                                mclArrayRef1(
                                  mclVa(*z, "z"),
                                  mclPlus(mclVv(i, "i"), _mxarray4_)),
                                mclVa(*rmax, "rmax")),
                              mclPlus(mclVv(i, "i"), _mxarray4_));
                            /*
                             * z(i-1+2)=-one;
                             */
                            mclArrayAssign1(
                              z,
                              mclUminus(mclVg(&one, "one")),
                              mclPlus(
                                mclMinus(mclVv(i, "i"), _mxarray3_),
                                _mxarray4_));
                        /*
                         * end;
                         */
                        }
                    /*
                     * end;
                     */
                    }
                    mclDestroyForLoopIterator(viter__);
                }
            /*
             * else;
             */
            } else {
                mclForLoopIterator viter__;
                /*
                 * for i=l : -1: 1 ;
                 */
                for (mclForStart(
                       &viter__, mclVa(*l, "l"), _mxarray21_, _mxarray3_);
                     mclForNext(&viter__, &i);
                     ) {
                    /*
                     * z(i+2)=b(i+2)-a(i+2)+z(i+2);
                     */
                    mclArrayAssign1(
                      z,
                      mclPlus(
                        mclMinus(
                          mclArrayRef1(
                            mclVa(*b, "b"), mclPlus(mclVv(i, "i"), _mxarray4_)),
                          mclArrayRef1(
                            mclVa(a, "a"), mclPlus(mclVv(i, "i"), _mxarray4_))),
                        mclArrayRef1(
                          mclVa(*z, "z"), mclPlus(mclVv(i, "i"), _mxarray4_))),
                      mclPlus(mclVv(i, "i"), _mxarray4_));
                    /*
                     * if (z(i+2)<0.0) ;
                     */
                    if (mclLtBool(
                          mclArrayRef1(
                            mclVa(*z, "z"), mclPlus(mclVv(i, "i"), _mxarray4_)),
                          _mxarray1_)) {
                        /*
                         * z(i+2)=z(i+2)+rmax;
                         */
                        mclArrayAssign1(
                          z,
                          mclPlus(
                            mclArrayRef1(
                              mclVa(*z, "z"),
                              mclPlus(mclVv(i, "i"), _mxarray4_)),
                            mclVa(*rmax, "rmax")),
                          mclPlus(mclVv(i, "i"), _mxarray4_));
                        /*
                         * z(i-1+2)=-one;
                         */
                        mclArrayAssign1(
                          z,
                          mclUminus(mclVg(&one, "one")),
                          mclPlus(
                            mclMinus(mclVv(i, "i"), _mxarray3_), _mxarray4_));
                    /*
                     * end;
                     */
                    }
                /*
                 * end;
                 */
                }
                mclDestroyForLoopIterator(viter__);
            /*
             * end;
             */
            }
        }
    /*
     * end;
     */
    }
    /*
     * %
     * if (z(1+2)>half) ;
     */
    if (mclGtBool(mclIntArrayRef1(mclVa(*z, "z"), 3), mclVg(&half, "half"))) {
        /*
         * for i=-1 : l+1;
         */
        int v_ = mclForIntStart(-1);
        int e_ = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray12_);
        } else {
            /*
             * c(i+2)=z(i+2);
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(
                  c, mclIntArrayRef1(mclVa(*z, "z"), v_ + 2), v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
        /*
         * if (c(1+2)<half) ;
         */
        if (mclLtBool(
              mclIntArrayRef1(mclVa(*c, "c"), 3), mclVg(&half, "half"))) {
            /*
             * c(-1+2)=one;
             */
            mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
            /*
             * c(l+1+2)=0.0;
             */
            mclArrayAssign1(
              c,
              _mxarray1_,
              mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
        /*
         * end;
         */
        }
        /*
         * return;
         */
        goto return_;
    /*
     * end;
     */
    }
    /*
     * i=1;
     */
    mlfAssign(&i, _mxarray3_);
    /*
     * i=i+1;
     */
    mlfAssign(&i, mclPlus(mclVv(i, "i"), _mxarray3_));
    /*
     * while (z(i+2)<half & i<l+1);
     */
    for (;;) {
        mxArray * a_
          = mclInitialize(
              mclLt(
                mclArrayRef1(
                  mclVa(*z, "z"), mclPlus(mclVv(i, "i"), _mxarray4_)),
                mclVg(&half, "half")));
        if (mlfTobool(a_)
            && mlfTobool(
                 mclAnd(
                   a_,
                   mclLt(
                     mclVv(i, "i"), mclPlus(mclVa(*l, "l"), _mxarray3_))))) {
            mxDestroyArray(a_);
        } else {
            mxDestroyArray(a_);
            break;
        }
        /*
         * i=i+1;
         */
        mlfAssign(&i, mclPlus(mclVv(i, "i"), _mxarray3_));
    /*
     * end;
     */
    }
    /*
     * if (i==l+1) ;
     */
    if (mclEqBool(mclVv(i, "i"), mclPlus(mclVa(*l, "l"), _mxarray3_))) {
        /*
         * z(-1+2)=one;
         */
        mclIntArrayAssign1(z, mclVg(&one, "one"), 1);
        /*
         * z(l+1+2)=0.0;
         */
        mclArrayAssign1(
          z,
          _mxarray1_,
          mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
        /*
         * for i=-1 : l+1;
         */
        {
            int v_ = mclForIntStart(-1);
            int e_ = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
            if (v_ > e_) {
                mlfAssign(&i, _mxarray12_);
            } else {
                /*
                 * c(i+2)=z(i+2);
                 * end;
                 */
                for (; ; ) {
                    mclIntArrayAssign1(
                      c, mclIntArrayRef1(mclVa(*z, "z"), v_ + 2), v_ + 2);
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i, mlfScalar(v_));
            }
        }
        /*
         * if (c(1+2)<half) ;
         */
        if (mclLtBool(
              mclIntArrayRef1(mclVa(*c, "c"), 3), mclVg(&half, "half"))) {
            /*
             * c(-1+2)=one;
             */
            mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
            /*
             * c(l+1+2)=0.0;
             */
            mclArrayAssign1(
              c,
              _mxarray1_,
              mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
        /*
         * end;
         */
        }
        /*
         * return;
         */
        goto return_;
    /*
     * end;
     */
    }
    /*
     * for j=1 : l+1-i;
     */
    {
        int v_ = mclForIntStart(1);
        int e_
          = mclForIntEnd(
              mclMinus(mclPlus(mclVa(*l, "l"), _mxarray3_), mclVv(i, "i")));
        if (v_ > e_) {
            mlfAssign(&j, _mxarray12_);
        } else {
            /*
             * z(j+2)=z(j+i-1+2);
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(
                  z,
                  mclArrayRef1(
                    mclVa(*z, "z"),
                    mclPlus(
                      mclMinus(
                        mclPlus(mlfScalar(v_), mclVv(i, "i")), _mxarray3_),
                      _mxarray4_)),
                  v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&j, mlfScalar(v_));
        }
    }
    /*
     * for j=l+2-i : l;
     */
    {
        mclForLoopIterator viter__;
        for (mclForStart(
               &viter__,
               mclMinus(mclPlus(mclVa(*l, "l"), _mxarray4_), mclVv(i, "i")),
               mclVa(*l, "l"),
               NULL);
             mclForNext(&viter__, &j);
             ) {
            /*
             * z(j+2)=0.0;
             */
            mclArrayAssign1(z, _mxarray1_, mclPlus(mclVv(j, "j"), _mxarray4_));
        /*
         * end;
         */
        }
        mclDestroyForLoopIterator(viter__);
    }
    /*
     * z(l+1+2)=z(l+1+2)-i+1;
     */
    mclArrayAssign1(
      z,
      mclPlus(
        mclMinus(
          mclArrayRef1(
            mclVa(*z, "z"),
            mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
          mclVv(i, "i")),
        _mxarray3_),
      mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
    /*
     * for i=-1 : l+1;
     */
    {
        int v_ = mclForIntStart(-1);
        int e_ = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray12_);
        } else {
            /*
             * c(i+2)=z(i+2);
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(
                  c, mclIntArrayRef1(mclVa(*z, "z"), v_ + 2), v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * if (c(1+2)<half) ;
     */
    if (mclLtBool(mclIntArrayRef1(mclVa(*c, "c"), 3), mclVg(&half, "half"))) {
        /*
         * c(-1+2)=one;
         */
        mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
        /*
         * c(l+1+2)=0.0;
         */
        mclArrayAssign1(
          c,
          _mxarray1_,
          mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
    /*
     * end;
     */
    }
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE ARSUB                             *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Accepts two arrays and subtracts each element *
     * %     *    in the second array from the element in the first array   *
     * %     *    and returns the solution.  The parameters L and RMAX are  *
     * %     *    the size of the array and the number of digits needed for *
     * %     *    the accuracy, respectively.                               *
     * %     *                                                              *
     * %     *  Subprograms called: ARADD                                   *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
    return_:
    mclValidateOutput(a, 1, nargout_, "a", "genhyper/aradd");
    mclValidateOutput(*b, 2, nargout_, "b", "genhyper/aradd");
    mclValidateOutput(*c, 3, nargout_, "c", "genhyper/aradd");
    mclValidateOutput(*z, 4, nargout_, "z", "genhyper/aradd");
    mclValidateOutput(*l, 5, nargout_, "l", "genhyper/aradd");
    mclValidateOutput(*rmax, 6, nargout_, "rmax", "genhyper/aradd");
    mxDestroyArray(ans);
    mxDestroyArray(ediff);
    mxDestroyArray(i);
    mxDestroyArray(j);
    mxDestroyArray(goon300);
    mxDestroyArray(goon190);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return a;
}

/*
 * The function "Mgenhyper_arsub" is the implementation version of the
 * "genhyper/arsub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1071-1104). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [a,b,c,wk1,wk2,l,rmax]=arsub(a,b,c,wk1,wk2,l,rmax);
 */
static mxArray * Mgenhyper_arsub(mxArray * * b,
                                 mxArray * * c,
                                 mxArray * * wk1,
                                 mxArray * * wk2,
                                 mxArray * * l,
                                 mxArray * * rmax,
                                 int nargout_,
                                 mxArray * a_in,
                                 mxArray * b_in,
                                 mxArray * c_in,
                                 mxArray * wk1_in,
                                 mxArray * wk2_in,
                                 mxArray * l_in,
                                 mxArray * rmax_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * a = NULL;
    mxArray * i = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&a, a_in);
    mclCopyInputArg(b, b_in);
    mclCopyInputArg(c, c_in);
    mclCopyInputArg(wk1, wk1_in);
    mclCopyInputArg(wk2, wk2_in);
    mclCopyInputArg(l, l_in);
    mclCopyInputArg(rmax, rmax_in);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * i=0;
     */
    mlfAssign(&i, _mxarray1_);
    /*
     * %
     * %
     * for i=-1 : l+1;
     */
    {
        int v_ = mclForIntStart(-1);
        int e_ = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray12_);
        } else {
            /*
             * wk2(i+2)=b(i+2);
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(
                  wk2, mclIntArrayRef1(mclVa(*b, "b"), v_ + 2), v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * wk2(-1+2)=(-one).*wk2(-1+2);
     */
    mclIntArrayAssign1(
      wk2,
      mclTimes(
        mclUminus(mclVg(&one, "one")), mclIntArrayRef1(mclVa(*wk2, "wk2"), 1)),
      1);
    /*
     * [a,wk2,c,wk1,l,rmax]=aradd(a,wk2,c,wk1,l,rmax);
     */
    mlfAssign(
      &a,
      mlfGenhyper_aradd(
        wk2,
        c,
        wk1,
        l,
        rmax,
        mclVa(a, "a"),
        mclVa(*wk2, "wk2"),
        mclVa(*c, "c"),
        mclVa(*wk1, "wk1"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    mclValidateOutput(a, 1, nargout_, "a", "genhyper/arsub");
    mclValidateOutput(*b, 2, nargout_, "b", "genhyper/arsub");
    mclValidateOutput(*c, 3, nargout_, "c", "genhyper/arsub");
    mclValidateOutput(*wk1, 4, nargout_, "wk1", "genhyper/arsub");
    mclValidateOutput(*wk2, 5, nargout_, "wk2", "genhyper/arsub");
    mclValidateOutput(*l, 6, nargout_, "l", "genhyper/arsub");
    mclValidateOutput(*rmax, 7, nargout_, "rmax", "genhyper/arsub");
    mxDestroyArray(ans);
    mxDestroyArray(i);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return a;
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE ARMULT                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Accepts two arrays and returns the product.   *
     * %     *    L and RMAX are the size of the arrays and the number of   *
     * %     *    digits needed to represent the numbers with the required  *
     * %     *    accuracy.                                                 *
     * %     *                                                              *
     * %     *  Subprograms called: none                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_armult" is the implementation version of the
 * "genhyper/armult" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1104-1175). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [a,b,c,z,l,rmax]=armult(a,b,c,z,l,rmax);
 */
static mxArray * Mgenhyper_armult(mxArray * * b,
                                  mxArray * * c,
                                  mxArray * * z,
                                  mxArray * * l,
                                  mxArray * * rmax,
                                  int nargout_,
                                  mxArray * a_in,
                                  mxArray * b_in,
                                  mxArray * c_in,
                                  mxArray * z_in,
                                  mxArray * l_in,
                                  mxArray * rmax_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * a = NULL;
    mxArray * i = NULL;
    mxArray * carry = NULL;
    mxArray * b2 = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&a, a_in);
    mclCopyInputArg(b, b_in);
    mclCopyInputArg(c, c_in);
    mclCopyInputArg(z, z_in);
    mclCopyInputArg(l, l_in);
    mclCopyInputArg(rmax, rmax_in);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * b2=0;carry=0;
     */
    mlfAssign(&b2, _mxarray1_);
    mlfAssign(&carry, _mxarray1_);
    /*
     * i=0;
     */
    mlfAssign(&i, _mxarray1_);
    /*
     * %
     * %
     * z(-1+2)=(abs(one).*sign(b)).*a(-1+2);
     */
    mclIntArrayAssign1(
      z,
      mclTimes(
        mclTimes(mlfAbs(mclVg(&one, "one")), mlfSign(mclVa(*b, "b"))),
        mclIntArrayRef1(mclVa(a, "a"), 1)),
      1);
    /*
     * b2=abs(b);
     */
    mlfAssign(&b2, mlfAbs(mclVa(*b, "b")));
    /*
     * z(l+1+2)=a(l+1+2);
     */
    mclArrayAssign1(
      z,
      mclArrayRef1(
        mclVa(a, "a"),
        mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
      mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
    /*
     * for i=0 : l;
     */
    {
        int v_ = mclForIntStart(0);
        int e_ = mclForIntEnd(mclVa(*l, "l"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray12_);
        } else {
            /*
             * z(i+2)=0.0;
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(z, _mxarray1_, v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * if (b2<=eps | a(1+2)<=eps) ;
     */
    {
        mxArray * a_
          = mclInitialize(mclLe(mclVv(b2, "b2"), mclVg(&eps, "eps")));
        if (mlfTobool(a_)
            || mlfTobool(
                 mclOr(
                   a_,
                   mclLe(
                     mclIntArrayRef1(mclVa(a, "a"), 3),
                     mclVg(&eps, "eps"))))) {
            mxDestroyArray(a_);
            /*
             * z(-1+2)=one;
             */
            mclIntArrayAssign1(z, mclVg(&one, "one"), 1);
            /*
             * z(l+1+2)=0.0;
             */
            mclArrayAssign1(
              z,
              _mxarray1_,
              mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
        /*
         * else;
         */
        } else {
            mxDestroyArray(a_);
            /*
             * for i=l : -1: 1 ;
             */
            {
                mclForLoopIterator viter__;
                for (mclForStart(
                       &viter__, mclVa(*l, "l"), _mxarray21_, _mxarray3_);
                     mclForNext(&viter__, &i);
                     ) {
                    /*
                     * z(i+2)=a(i+2).*b2+z(i+2);
                     */
                    mclArrayAssign1(
                      z,
                      mclPlus(
                        mclTimes(
                          mclArrayRef1(
                            mclVa(a, "a"), mclPlus(mclVv(i, "i"), _mxarray4_)),
                          mclVv(b2, "b2")),
                        mclArrayRef1(
                          mclVa(*z, "z"), mclPlus(mclVv(i, "i"), _mxarray4_))),
                      mclPlus(mclVv(i, "i"), _mxarray4_));
                    /*
                     * if (z(i+2)>=rmax) ;
                     */
                    if (mclGeBool(
                          mclArrayRef1(
                            mclVa(*z, "z"), mclPlus(mclVv(i, "i"), _mxarray4_)),
                          mclVa(*rmax, "rmax"))) {
                        /*
                         * carry=fix(z(i+2)./rmax);
                         */
                        mlfAssign(
                          &carry,
                          mlfFix(
                            mclRdivide(
                              mclArrayRef1(
                                mclVa(*z, "z"),
                                mclPlus(mclVv(i, "i"), _mxarray4_)),
                              mclVa(*rmax, "rmax"))));
                        /*
                         * z(i+2)=z(i+2)-carry.*rmax;
                         */
                        mclArrayAssign1(
                          z,
                          mclMinus(
                            mclArrayRef1(
                              mclVa(*z, "z"),
                              mclPlus(mclVv(i, "i"), _mxarray4_)),
                            mclTimes(
                              mclVv(carry, "carry"), mclVa(*rmax, "rmax"))),
                          mclPlus(mclVv(i, "i"), _mxarray4_));
                        /*
                         * z(i-1+2)=carry;
                         */
                        mclArrayAssign1(
                          z,
                          mclVv(carry, "carry"),
                          mclPlus(
                            mclMinus(mclVv(i, "i"), _mxarray3_), _mxarray4_));
                    /*
                     * end;
                     */
                    }
                /*
                 * end;
                 */
                }
                mclDestroyForLoopIterator(viter__);
            }
            /*
             * if (z(0+2)>=half) ;
             */
            if (mclGeBool(
                  mclIntArrayRef1(mclVa(*z, "z"), 2), mclVg(&half, "half"))) {
                mclForLoopIterator viter__;
                /*
                 * for i=l : -1: 1 ;
                 */
                for (mclForStart(
                       &viter__, mclVa(*l, "l"), _mxarray21_, _mxarray3_);
                     mclForNext(&viter__, &i);
                     ) {
                    /*
                     * z(i+2)=z(i-1+2);
                     */
                    mclArrayAssign1(
                      z,
                      mclArrayRef1(
                        mclVa(*z, "z"),
                        mclPlus(
                          mclMinus(mclVv(i, "i"), _mxarray3_), _mxarray4_)),
                      mclPlus(mclVv(i, "i"), _mxarray4_));
                /*
                 * end;
                 */
                }
                mclDestroyForLoopIterator(viter__);
                /*
                 * z(l+1+2)=z(l+1+2)+one;
                 */
                mclArrayAssign1(
                  z,
                  mclPlus(
                    mclArrayRef1(
                      mclVa(*z, "z"),
                      mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
                    mclVg(&one, "one")),
                  mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
                /*
                 * if (z(1+2)>=rmax) ;
                 */
                if (mclGeBool(
                      mclIntArrayRef1(mclVa(*z, "z"), 3),
                      mclVa(*rmax, "rmax"))) {
                    mclForLoopIterator viter__;
                    /*
                     * for i=l : -1: 1 ;
                     */
                    for (mclForStart(
                           &viter__, mclVa(*l, "l"), _mxarray21_, _mxarray3_);
                         mclForNext(&viter__, &i);
                         ) {
                        /*
                         * z(i+2)=z(i-1+2);
                         */
                        mclArrayAssign1(
                          z,
                          mclArrayRef1(
                            mclVa(*z, "z"),
                            mclPlus(
                              mclMinus(mclVv(i, "i"), _mxarray3_), _mxarray4_)),
                          mclPlus(mclVv(i, "i"), _mxarray4_));
                    /*
                     * end;
                     */
                    }
                    mclDestroyForLoopIterator(viter__);
                    /*
                     * carry=fix(z(1+2)./rmax);
                     */
                    mlfAssign(
                      &carry,
                      mlfFix(
                        mclRdivide(
                          mclIntArrayRef1(mclVa(*z, "z"), 3),
                          mclVa(*rmax, "rmax"))));
                    /*
                     * z(2+2)=z(2+2)-carry.*rmax;
                     */
                    mclIntArrayAssign1(
                      z,
                      mclMinus(
                        mclIntArrayRef1(mclVa(*z, "z"), 4),
                        mclTimes(mclVv(carry, "carry"), mclVa(*rmax, "rmax"))),
                      4);
                    /*
                     * z(1+2)=carry;
                     */
                    mclIntArrayAssign1(z, mclVv(carry, "carry"), 3);
                    /*
                     * z(l+1+2)=z(l+1+2)+one;
                     */
                    mclArrayAssign1(
                      z,
                      mclPlus(
                        mclArrayRef1(
                          mclVa(*z, "z"),
                          mclPlus(
                            mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
                        mclVg(&one, "one")),
                      mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
                /*
                 * end;
                 */
                }
                /*
                 * z(0+2)=0.0;
                 */
                mclIntArrayAssign1(z, _mxarray1_, 2);
            /*
             * end;
             */
            }
        }
    /*
     * end;
     */
    }
    /*
     * for i=-1 : l+1;
     */
    {
        int v_ = mclForIntStart(-1);
        int e_ = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray12_);
        } else {
            /*
             * c(i+2)=z(i+2);
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(
                  c, mclIntArrayRef1(mclVa(*z, "z"), v_ + 2), v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * if (c(1+2)<half) ;
     */
    if (mclLtBool(mclIntArrayRef1(mclVa(*c, "c"), 3), mclVg(&half, "half"))) {
        /*
         * c(-1+2)=one;
         */
        mclIntArrayAssign1(c, mclVg(&one, "one"), 1);
        /*
         * c(l+1+2)=0.0;
         */
        mclArrayAssign1(
          c,
          _mxarray1_,
          mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_));
    /*
     * end;
     */
    }
    mclValidateOutput(a, 1, nargout_, "a", "genhyper/armult");
    mclValidateOutput(*b, 2, nargout_, "b", "genhyper/armult");
    mclValidateOutput(*c, 3, nargout_, "c", "genhyper/armult");
    mclValidateOutput(*z, 4, nargout_, "z", "genhyper/armult");
    mclValidateOutput(*l, 5, nargout_, "l", "genhyper/armult");
    mclValidateOutput(*rmax, 6, nargout_, "rmax", "genhyper/armult");
    mxDestroyArray(ans);
    mxDestroyArray(b2);
    mxDestroyArray(carry);
    mxDestroyArray(i);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return a;
    /*
     * 
     * 
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE CMPADD                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Takes two arrays representing one real and    *
     * %     *    one imaginary part, and adds two arrays representing      *
     * %     *    another complex number and returns two array holding the  *
     * %     *    complex sum.                                              *
     * %     *              (CR,CI) = (AR+BR, AI+BI)                        *
     * %     *                                                              *
     * %     *  Subprograms called: ARADD                                   *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_cmpadd" is the implementation version of the
 * "genhyper/cmpadd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1175-1203). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [ar,ai,br,bi,cr,ci,wk1,l,rmax]=cmpadd(ar,ai,br,bi,cr,ci,wk1,l,rmax);
 */
static mxArray * Mgenhyper_cmpadd(mxArray * * ai,
                                  mxArray * * br,
                                  mxArray * * bi,
                                  mxArray * * cr,
                                  mxArray * * ci,
                                  mxArray * * wk1,
                                  mxArray * * l,
                                  mxArray * * rmax,
                                  int nargout_,
                                  mxArray * ar_in,
                                  mxArray * ai_in,
                                  mxArray * br_in,
                                  mxArray * bi_in,
                                  mxArray * cr_in,
                                  mxArray * ci_in,
                                  mxArray * wk1_in,
                                  mxArray * l_in,
                                  mxArray * rmax_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * ar = NULL;
    mclCopyInputArg(&ar, ar_in);
    mclCopyInputArg(ai, ai_in);
    mclCopyInputArg(br, br_in);
    mclCopyInputArg(bi, bi_in);
    mclCopyInputArg(cr, cr_in);
    mclCopyInputArg(ci, ci_in);
    mclCopyInputArg(wk1, wk1_in);
    mclCopyInputArg(l, l_in);
    mclCopyInputArg(rmax, rmax_in);
    /*
     * %
     * %
     * %
     * %
     * %
     * %
     * [ar,br,cr,wk1,l,rmax]=aradd(ar,br,cr,wk1,l,rmax);
     */
    mlfAssign(
      &ar,
      mlfGenhyper_aradd(
        br,
        cr,
        wk1,
        l,
        rmax,
        mclVa(ar, "ar"),
        mclVa(*br, "br"),
        mclVa(*cr, "cr"),
        mclVa(*wk1, "wk1"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    /*
     * [ai,bi,ci,wk1,l,rmax]=aradd(ai,bi,ci,wk1,l,rmax);
     */
    mlfAssign(
      ai,
      mlfGenhyper_aradd(
        bi,
        ci,
        wk1,
        l,
        rmax,
        mclVa(*ai, "ai"),
        mclVa(*bi, "bi"),
        mclVa(*ci, "ci"),
        mclVa(*wk1, "wk1"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    mclValidateOutput(ar, 1, nargout_, "ar", "genhyper/cmpadd");
    mclValidateOutput(*ai, 2, nargout_, "ai", "genhyper/cmpadd");
    mclValidateOutput(*br, 3, nargout_, "br", "genhyper/cmpadd");
    mclValidateOutput(*bi, 4, nargout_, "bi", "genhyper/cmpadd");
    mclValidateOutput(*cr, 5, nargout_, "cr", "genhyper/cmpadd");
    mclValidateOutput(*ci, 6, nargout_, "ci", "genhyper/cmpadd");
    mclValidateOutput(*wk1, 7, nargout_, "wk1", "genhyper/cmpadd");
    mclValidateOutput(*l, 8, nargout_, "l", "genhyper/cmpadd");
    mclValidateOutput(*rmax, 9, nargout_, "rmax", "genhyper/cmpadd");
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return ar;
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE CMPSUB                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Takes two arrays representing one real and    *
     * %     *    one imaginary part, and subtracts two arrays representing *
     * %     *    another complex number and returns two array holding the  *
     * %     *    complex sum.                                              *
     * %     *              (CR,CI) = (AR+BR, AI+BI)                        *
     * %     *                                                              *
     * %     *  Subprograms called: ARADD                                   *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_cmpsub" is the implementation version of the
 * "genhyper/cmpsub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1203-1230). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [ar,ai,br,bi,cr,ci,wk1,wk2,l,rmax]=cmpsub(ar,ai,br,bi,cr,ci,wk1,wk2,l,rmax);
 */
static mxArray * Mgenhyper_cmpsub(mxArray * * ai,
                                  mxArray * * br,
                                  mxArray * * bi,
                                  mxArray * * cr,
                                  mxArray * * ci,
                                  mxArray * * wk1,
                                  mxArray * * wk2,
                                  mxArray * * l,
                                  mxArray * * rmax,
                                  int nargout_,
                                  mxArray * ar_in,
                                  mxArray * ai_in,
                                  mxArray * br_in,
                                  mxArray * bi_in,
                                  mxArray * cr_in,
                                  mxArray * ci_in,
                                  mxArray * wk1_in,
                                  mxArray * wk2_in,
                                  mxArray * l_in,
                                  mxArray * rmax_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * ar = NULL;
    mclCopyInputArg(&ar, ar_in);
    mclCopyInputArg(ai, ai_in);
    mclCopyInputArg(br, br_in);
    mclCopyInputArg(bi, bi_in);
    mclCopyInputArg(cr, cr_in);
    mclCopyInputArg(ci, ci_in);
    mclCopyInputArg(wk1, wk1_in);
    mclCopyInputArg(wk2, wk2_in);
    mclCopyInputArg(l, l_in);
    mclCopyInputArg(rmax, rmax_in);
    /*
     * %
     * %
     * %
     * %
     * %
     * %
     * [ar,br,cr,wk1,wk2,l,rmax]=arsub(ar,br,cr,wk1,wk2,l,rmax);
     */
    mlfAssign(
      &ar,
      mlfGenhyper_arsub(
        br,
        cr,
        wk1,
        wk2,
        l,
        rmax,
        mclVa(ar, "ar"),
        mclVa(*br, "br"),
        mclVa(*cr, "cr"),
        mclVa(*wk1, "wk1"),
        mclVa(*wk2, "wk2"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    /*
     * [ai,bi,ci,wk1,wk2,l,rmax]=arsub(ai,bi,ci,wk1,wk2,l,rmax);
     */
    mlfAssign(
      ai,
      mlfGenhyper_arsub(
        bi,
        ci,
        wk1,
        wk2,
        l,
        rmax,
        mclVa(*ai, "ai"),
        mclVa(*bi, "bi"),
        mclVa(*ci, "ci"),
        mclVa(*wk1, "wk1"),
        mclVa(*wk2, "wk2"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    mclValidateOutput(ar, 1, nargout_, "ar", "genhyper/cmpsub");
    mclValidateOutput(*ai, 2, nargout_, "ai", "genhyper/cmpsub");
    mclValidateOutput(*br, 3, nargout_, "br", "genhyper/cmpsub");
    mclValidateOutput(*bi, 4, nargout_, "bi", "genhyper/cmpsub");
    mclValidateOutput(*cr, 5, nargout_, "cr", "genhyper/cmpsub");
    mclValidateOutput(*ci, 6, nargout_, "ci", "genhyper/cmpsub");
    mclValidateOutput(*wk1, 7, nargout_, "wk1", "genhyper/cmpsub");
    mclValidateOutput(*wk2, 8, nargout_, "wk2", "genhyper/cmpsub");
    mclValidateOutput(*l, 9, nargout_, "l", "genhyper/cmpsub");
    mclValidateOutput(*rmax, 10, nargout_, "rmax", "genhyper/cmpsub");
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return ar;
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE CMPMUL                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Takes two arrays representing one real and    *
     * %     *    one imaginary part, and multiplies it with two arrays     *
     * %     *    representing another complex number and returns the       *
     * %     *    complex product.                                          *
     * %     *                                                              *
     * %     *  Subprograms called: ARMULT, ARSUB, ARADD                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_cmpmul" is the implementation version of the
 * "genhyper/cmpmul" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1230-1266). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [ar,ai,br,bi,cr,ci,wk1,wk2,cr2,d1,d2,wk6,l,rmax]=cmpmul(ar,ai,br,bi,cr,ci,wk1,wk2,cr2,d1,d2,wk6,l,rmax);
 */
static mxArray * Mgenhyper_cmpmul(mxArray * * ai,
                                  mxArray * * br,
                                  mxArray * * bi,
                                  mxArray * * cr,
                                  mxArray * * ci,
                                  mxArray * * wk1,
                                  mxArray * * wk2,
                                  mxArray * * cr2,
                                  mxArray * * d1,
                                  mxArray * * d2,
                                  mxArray * * wk6,
                                  mxArray * * l,
                                  mxArray * * rmax,
                                  int nargout_,
                                  mxArray * ar_in,
                                  mxArray * ai_in,
                                  mxArray * br_in,
                                  mxArray * bi_in,
                                  mxArray * cr_in,
                                  mxArray * ci_in,
                                  mxArray * wk1_in,
                                  mxArray * wk2_in,
                                  mxArray * cr2_in,
                                  mxArray * d1_in,
                                  mxArray * d2_in,
                                  mxArray * wk6_in,
                                  mxArray * l_in,
                                  mxArray * rmax_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * ar = NULL;
    mxArray * i = NULL;
    mclCopyInputArg(&ar, ar_in);
    mclCopyInputArg(ai, ai_in);
    mclCopyInputArg(br, br_in);
    mclCopyInputArg(bi, bi_in);
    mclCopyInputArg(cr, cr_in);
    mclCopyInputArg(ci, ci_in);
    mclCopyInputArg(wk1, wk1_in);
    mclCopyInputArg(wk2, wk2_in);
    mclCopyInputArg(cr2, cr2_in);
    mclCopyInputArg(d1, d1_in);
    mclCopyInputArg(d2, d2_in);
    mclCopyInputArg(wk6, wk6_in);
    mclCopyInputArg(l, l_in);
    mclCopyInputArg(rmax, rmax_in);
    /*
     * %
     * %
     * %
     * %
     * i=0;
     */
    mlfAssign(&i, _mxarray1_);
    /*
     * %
     * %
     * [ar,br,d1,wk6,l,rmax]=armult(ar,br,d1,wk6,l,rmax);
     */
    mlfAssign(
      &ar,
      mlfGenhyper_armult(
        br,
        d1,
        wk6,
        l,
        rmax,
        mclVa(ar, "ar"),
        mclVa(*br, "br"),
        mclVa(*d1, "d1"),
        mclVa(*wk6, "wk6"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    /*
     * [ai,bi,d2,wk6,l,rmax]=armult(ai,bi,d2,wk6,l,rmax);
     */
    mlfAssign(
      ai,
      mlfGenhyper_armult(
        bi,
        d2,
        wk6,
        l,
        rmax,
        mclVa(*ai, "ai"),
        mclVa(*bi, "bi"),
        mclVa(*d2, "d2"),
        mclVa(*wk6, "wk6"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    /*
     * [d1,d2,cr2,wk1,wk2,l,rmax]=arsub(d1,d2,cr2,wk1,wk2,l,rmax);
     */
    mlfAssign(
      d1,
      mlfGenhyper_arsub(
        d2,
        cr2,
        wk1,
        wk2,
        l,
        rmax,
        mclVa(*d1, "d1"),
        mclVa(*d2, "d2"),
        mclVa(*cr2, "cr2"),
        mclVa(*wk1, "wk1"),
        mclVa(*wk2, "wk2"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    /*
     * [ar,bi,d1,wk6,l,rmax]=armult(ar,bi,d1,wk6,l,rmax);
     */
    mlfAssign(
      &ar,
      mlfGenhyper_armult(
        bi,
        d1,
        wk6,
        l,
        rmax,
        mclVa(ar, "ar"),
        mclVa(*bi, "bi"),
        mclVa(*d1, "d1"),
        mclVa(*wk6, "wk6"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    /*
     * [ai,br,d2,wk6,l,rmax]=armult(ai,br,d2,wk6,l,rmax);
     */
    mlfAssign(
      ai,
      mlfGenhyper_armult(
        br,
        d2,
        wk6,
        l,
        rmax,
        mclVa(*ai, "ai"),
        mclVa(*br, "br"),
        mclVa(*d2, "d2"),
        mclVa(*wk6, "wk6"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    /*
     * [d1,d2,ci,wk1,l,rmax]=aradd(d1,d2,ci,wk1,l,rmax);
     */
    mlfAssign(
      d1,
      mlfGenhyper_aradd(
        d2,
        ci,
        wk1,
        l,
        rmax,
        mclVa(*d1, "d1"),
        mclVa(*d2, "d2"),
        mclVa(*ci, "ci"),
        mclVa(*wk1, "wk1"),
        mclVa(*l, "l"),
        mclVa(*rmax, "rmax")));
    /*
     * for i=-1 : l+1;
     */
    {
        int v_ = mclForIntStart(-1);
        int e_ = mclForIntEnd(mclPlus(mclVa(*l, "l"), _mxarray3_));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray12_);
        } else {
            /*
             * cr(i+2)=cr2(i+2);
             * end;
             */
            for (; ; ) {
                mclIntArrayAssign1(
                  cr, mclIntArrayRef1(mclVa(*cr2, "cr2"), v_ + 2), v_ + 2);
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    mclValidateOutput(ar, 1, nargout_, "ar", "genhyper/cmpmul");
    mclValidateOutput(*ai, 2, nargout_, "ai", "genhyper/cmpmul");
    mclValidateOutput(*br, 3, nargout_, "br", "genhyper/cmpmul");
    mclValidateOutput(*bi, 4, nargout_, "bi", "genhyper/cmpmul");
    mclValidateOutput(*cr, 5, nargout_, "cr", "genhyper/cmpmul");
    mclValidateOutput(*ci, 6, nargout_, "ci", "genhyper/cmpmul");
    mclValidateOutput(*wk1, 7, nargout_, "wk1", "genhyper/cmpmul");
    mclValidateOutput(*wk2, 8, nargout_, "wk2", "genhyper/cmpmul");
    mclValidateOutput(*cr2, 9, nargout_, "cr2", "genhyper/cmpmul");
    mclValidateOutput(*d1, 10, nargout_, "d1", "genhyper/cmpmul");
    mclValidateOutput(*d2, 11, nargout_, "d2", "genhyper/cmpmul");
    mclValidateOutput(*wk6, 12, nargout_, "wk6", "genhyper/cmpmul");
    mclValidateOutput(*l, 13, nargout_, "l", "genhyper/cmpmul");
    mclValidateOutput(*rmax, 14, nargout_, "rmax", "genhyper/cmpmul");
    mxDestroyArray(i);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return ar;
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE ARYDIV                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Returns the double precision complex number   *
     * %     *    resulting from the division of four arrays, representing  *
     * %     *    two complex numbers.  The number returned will be in one  *
     * %     *    of two different forms:  either standard scientific or as *
     * %     *    the log (base 10) of the number.                          *
     * %     *                                                              *
     * %     *  Subprograms called: CONV21, CONV12, EADD, ECPDIV, EMULT.    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_arydiv" is the implementation version of the
 * "genhyper/arydiv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1266-1380). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [ar,ai,br,bi,c,l,lnpfq,rmax,ibit]=arydiv(ar,ai,br,bi,c,l,lnpfq,rmax,ibit);
 */
static mxArray * Mgenhyper_arydiv(mxArray * * ai,
                                  mxArray * * br,
                                  mxArray * * bi,
                                  mxArray * * c,
                                  mxArray * * l,
                                  mxArray * * lnpfq,
                                  mxArray * * rmax,
                                  mxArray * * ibit,
                                  int nargout_,
                                  mxArray * ar_in,
                                  mxArray * ai_in,
                                  mxArray * br_in,
                                  mxArray * bi_in,
                                  mxArray * c_in,
                                  mxArray * l_in,
                                  mxArray * lnpfq_in,
                                  mxArray * rmax_in,
                                  mxArray * ibit_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * ar = NULL;
    mxArray * rexp = NULL;
    mxArray * itnmax = NULL;
    mxArray * ir10 = NULL;
    mxArray * ii10 = NULL;
    mxArray * dnum = NULL;
    mxArray * x2 = NULL;
    mxArray * x1 = NULL;
    mxArray * x = NULL;
    mxArray * tenmax = NULL;
    mxArray * rr10 = NULL;
    mxArray * ri10 = NULL;
    mxArray * phi = NULL;
    mxArray * dum2 = NULL;
    mxArray * dum1 = NULL;
    mxArray * ans = NULL;
    mxArray * e3 = NULL;
    mxArray * n3 = NULL;
    mxArray * e2 = NULL;
    mxArray * n2 = NULL;
    mxArray * e1 = NULL;
    mxArray * n1 = NULL;
    mxArray * ce = NULL;
    mxArray * be = NULL;
    mxArray * ae = NULL;
    mxArray * cdum = NULL;
    mclCopyInputArg(&ar, ar_in);
    mclCopyInputArg(ai, ai_in);
    mclCopyInputArg(br, br_in);
    mclCopyInputArg(bi, bi_in);
    mclCopyInputArg(c, c_in);
    mclCopyInputArg(l, l_in);
    mclCopyInputArg(lnpfq, lnpfq_in);
    mclCopyInputArg(rmax, rmax_in);
    mclCopyInputArg(ibit, ibit_in);
    /*
     * %
     * %
     * cdum=[];ae=[];be=[];ce=[];n1=[];e1=[];n2=[];e2=[];n3=[];e3=[];
     */
    mlfAssign(&cdum, _mxarray12_);
    mlfAssign(&ae, _mxarray12_);
    mlfAssign(&be, _mxarray12_);
    mlfAssign(&ce, _mxarray12_);
    mlfAssign(&n1, _mxarray12_);
    mlfAssign(&e1, _mxarray12_);
    mlfAssign(&n2, _mxarray12_);
    mlfAssign(&e2, _mxarray12_);
    mlfAssign(&n3, _mxarray12_);
    mlfAssign(&e3, _mxarray12_);
    /*
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * %
     * ae=zeros(2,2);be=zeros(2,2);ce=zeros(2,2);dum1=0;dum2=0;e1=0;e2=0;e3=0;n1=0;n2=0;n3=0;phi=0;ri10=0;rr10=0;tenmax=0;x=0;x1=0;x2=0;
     */
    mlfAssign(&ae, mlfZeros(_mxarray4_, _mxarray4_, NULL));
    mlfAssign(&be, mlfZeros(_mxarray4_, _mxarray4_, NULL));
    mlfAssign(&ce, mlfZeros(_mxarray4_, _mxarray4_, NULL));
    mlfAssign(&dum1, _mxarray1_);
    mlfAssign(&dum2, _mxarray1_);
    mlfAssign(&e1, _mxarray1_);
    mlfAssign(&e2, _mxarray1_);
    mlfAssign(&e3, _mxarray1_);
    mlfAssign(&n1, _mxarray1_);
    mlfAssign(&n2, _mxarray1_);
    mlfAssign(&n3, _mxarray1_);
    mlfAssign(&phi, _mxarray1_);
    mlfAssign(&ri10, _mxarray1_);
    mlfAssign(&rr10, _mxarray1_);
    mlfAssign(&tenmax, _mxarray1_);
    mlfAssign(&x, _mxarray1_);
    mlfAssign(&x1, _mxarray1_);
    mlfAssign(&x2, _mxarray1_);
    /*
     * cdum=0;
     */
    mlfAssign(&cdum, _mxarray1_);
    /*
     * %
     * dnum=0;
     */
    mlfAssign(&dnum, _mxarray1_);
    /*
     * ii10=0;ir10=0;itnmax=0;rexp=0;
     */
    mlfAssign(&ii10, _mxarray1_);
    mlfAssign(&ir10, _mxarray1_);
    mlfAssign(&itnmax, _mxarray1_);
    mlfAssign(&rexp, _mxarray1_);
    /*
     * %
     * %
     * %
     * rexp=fix(ibit./2);
     */
    mlfAssign(&rexp, mlfFix(mclRdivide(mclVa(*ibit, "ibit"), _mxarray4_)));
    /*
     * x=rexp.*(ar(l+1+2)-2);
     */
    mlfAssign(
      &x,
      mclTimes(
        mclVv(rexp, "rexp"),
        mclMinus(
          mclArrayRef1(
            mclVa(ar, "ar"),
            mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
          _mxarray4_)));
    /*
     * rr10=x.*log10(two)./log10(ten);
     */
    mlfAssign(
      &rr10,
      mclRdivide(
        mclTimes(mclVv(x, "x"), mlfLog10(mclVg(&two, "two"))),
        mlfLog10(mclVg(&ten, "ten"))));
    /*
     * ir10=fix(rr10);
     */
    mlfAssign(&ir10, mlfFix(mclVv(rr10, "rr10")));
    /*
     * rr10=rr10-ir10;
     */
    mlfAssign(&rr10, mclMinus(mclVv(rr10, "rr10"), mclVv(ir10, "ir10")));
    /*
     * x=rexp.*(ai(l+1+2)-2);
     */
    mlfAssign(
      &x,
      mclTimes(
        mclVv(rexp, "rexp"),
        mclMinus(
          mclArrayRef1(
            mclVa(*ai, "ai"),
            mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
          _mxarray4_)));
    /*
     * ri10=x.*log10(two)./log10(ten);
     */
    mlfAssign(
      &ri10,
      mclRdivide(
        mclTimes(mclVv(x, "x"), mlfLog10(mclVg(&two, "two"))),
        mlfLog10(mclVg(&ten, "ten"))));
    /*
     * ii10=fix(ri10);
     */
    mlfAssign(&ii10, mlfFix(mclVv(ri10, "ri10")));
    /*
     * ri10=ri10-ii10;
     */
    mlfAssign(&ri10, mclMinus(mclVv(ri10, "ri10"), mclVv(ii10, "ii10")));
    /*
     * dum1=(abs(ar(1+2).*rmax.*rmax+ar(2+2).*rmax+ar(3+2)).*sign(ar(-1+2)));
     */
    mlfAssign(
      &dum1,
      mclTimes(
        mlfAbs(
          mclPlus(
            mclPlus(
              mclTimes(
                mclTimes(
                  mclIntArrayRef1(mclVa(ar, "ar"), 3), mclVa(*rmax, "rmax")),
                mclVa(*rmax, "rmax")),
              mclTimes(
                mclIntArrayRef1(mclVa(ar, "ar"), 4), mclVa(*rmax, "rmax"))),
            mclIntArrayRef1(mclVa(ar, "ar"), 5))),
        mlfSign(mclIntArrayRef1(mclVa(ar, "ar"), 1))));
    /*
     * dum2=(abs(ai(1+2).*rmax.*rmax+ai(2+2).*rmax+ai(3+2)).*sign(ai(-1+2)));
     */
    mlfAssign(
      &dum2,
      mclTimes(
        mlfAbs(
          mclPlus(
            mclPlus(
              mclTimes(
                mclTimes(
                  mclIntArrayRef1(mclVa(*ai, "ai"), 3), mclVa(*rmax, "rmax")),
                mclVa(*rmax, "rmax")),
              mclTimes(
                mclIntArrayRef1(mclVa(*ai, "ai"), 4), mclVa(*rmax, "rmax"))),
            mclIntArrayRef1(mclVa(*ai, "ai"), 5))),
        mlfSign(mclIntArrayRef1(mclVa(*ai, "ai"), 1))));
    /*
     * dum1=dum1.*10.^rr10;
     */
    mlfAssign(
      &dum1,
      mclTimes(mclVv(dum1, "dum1"), mlfPower(_mxarray0_, mclVv(rr10, "rr10"))));
    /*
     * dum2=dum2.*10.^ri10;
     */
    mlfAssign(
      &dum2,
      mclTimes(mclVv(dum2, "dum2"), mlfPower(_mxarray0_, mclVv(ri10, "ri10"))));
    /*
     * cdum=complex(dum1,dum2);
     */
    mlfAssign(&cdum, mlfComplex(mclVv(dum1, "dum1"), mclVv(dum2, "dum2")));
    /*
     * [cdum,ae]=conv12(cdum,ae);
     */
    mlfAssign(
      &cdum, mlfGenhyper_conv12(&ae, mclVv(cdum, "cdum"), mclVv(ae, "ae")));
    /*
     * ae(1,2)=ae(1,2)+ir10;
     */
    mclIntArrayAssign2(
      &ae,
      mclPlus(mclIntArrayRef2(mclVv(ae, "ae"), 1, 2), mclVv(ir10, "ir10")),
      1,
      2);
    /*
     * ae(2,2)=ae(2,2)+ii10;
     */
    mclIntArrayAssign2(
      &ae,
      mclPlus(mclIntArrayRef2(mclVv(ae, "ae"), 2, 2), mclVv(ii10, "ii10")),
      2,
      2);
    /*
     * x=rexp.*(br(l+1+2)-2);
     */
    mlfAssign(
      &x,
      mclTimes(
        mclVv(rexp, "rexp"),
        mclMinus(
          mclArrayRef1(
            mclVa(*br, "br"),
            mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
          _mxarray4_)));
    /*
     * rr10=x.*log10(two)./log10(ten);
     */
    mlfAssign(
      &rr10,
      mclRdivide(
        mclTimes(mclVv(x, "x"), mlfLog10(mclVg(&two, "two"))),
        mlfLog10(mclVg(&ten, "ten"))));
    /*
     * ir10=fix(rr10);
     */
    mlfAssign(&ir10, mlfFix(mclVv(rr10, "rr10")));
    /*
     * rr10=rr10-ir10;
     */
    mlfAssign(&rr10, mclMinus(mclVv(rr10, "rr10"), mclVv(ir10, "ir10")));
    /*
     * x=rexp.*(bi(l+1+2)-2);
     */
    mlfAssign(
      &x,
      mclTimes(
        mclVv(rexp, "rexp"),
        mclMinus(
          mclArrayRef1(
            mclVa(*bi, "bi"),
            mclPlus(mclPlus(mclVa(*l, "l"), _mxarray3_), _mxarray4_)),
          _mxarray4_)));
    /*
     * ri10=x.*log10(two)./log10(ten);
     */
    mlfAssign(
      &ri10,
      mclRdivide(
        mclTimes(mclVv(x, "x"), mlfLog10(mclVg(&two, "two"))),
        mlfLog10(mclVg(&ten, "ten"))));
    /*
     * ii10=fix(ri10);
     */
    mlfAssign(&ii10, mlfFix(mclVv(ri10, "ri10")));
    /*
     * ri10=ri10-ii10;
     */
    mlfAssign(&ri10, mclMinus(mclVv(ri10, "ri10"), mclVv(ii10, "ii10")));
    /*
     * dum1=(abs(br(1+2).*rmax.*rmax+br(2+2).*rmax+br(3+2)).*sign(br(-1+2)));
     */
    mlfAssign(
      &dum1,
      mclTimes(
        mlfAbs(
          mclPlus(
            mclPlus(
              mclTimes(
                mclTimes(
                  mclIntArrayRef1(mclVa(*br, "br"), 3), mclVa(*rmax, "rmax")),
                mclVa(*rmax, "rmax")),
              mclTimes(
                mclIntArrayRef1(mclVa(*br, "br"), 4), mclVa(*rmax, "rmax"))),
            mclIntArrayRef1(mclVa(*br, "br"), 5))),
        mlfSign(mclIntArrayRef1(mclVa(*br, "br"), 1))));
    /*
     * dum2=(abs(bi(1+2).*rmax.*rmax+bi(2+2).*rmax+bi(3+2)).*sign(bi(-1+2)));
     */
    mlfAssign(
      &dum2,
      mclTimes(
        mlfAbs(
          mclPlus(
            mclPlus(
              mclTimes(
                mclTimes(
                  mclIntArrayRef1(mclVa(*bi, "bi"), 3), mclVa(*rmax, "rmax")),
                mclVa(*rmax, "rmax")),
              mclTimes(
                mclIntArrayRef1(mclVa(*bi, "bi"), 4), mclVa(*rmax, "rmax"))),
            mclIntArrayRef1(mclVa(*bi, "bi"), 5))),
        mlfSign(mclIntArrayRef1(mclVa(*bi, "bi"), 1))));
    /*
     * dum1=dum1.*10.^rr10;
     */
    mlfAssign(
      &dum1,
      mclTimes(mclVv(dum1, "dum1"), mlfPower(_mxarray0_, mclVv(rr10, "rr10"))));
    /*
     * dum2=dum2.*10.^ri10;
     */
    mlfAssign(
      &dum2,
      mclTimes(mclVv(dum2, "dum2"), mlfPower(_mxarray0_, mclVv(ri10, "ri10"))));
    /*
     * cdum=complex(dum1,dum2);
     */
    mlfAssign(&cdum, mlfComplex(mclVv(dum1, "dum1"), mclVv(dum2, "dum2")));
    /*
     * [cdum,be]=conv12(cdum,be);
     */
    mlfAssign(
      &cdum, mlfGenhyper_conv12(&be, mclVv(cdum, "cdum"), mclVv(be, "be")));
    /*
     * be(1,2)=be(1,2)+ir10;
     */
    mclIntArrayAssign2(
      &be,
      mclPlus(mclIntArrayRef2(mclVv(be, "be"), 1, 2), mclVv(ir10, "ir10")),
      1,
      2);
    /*
     * be(2,2)=be(2,2)+ii10;
     */
    mclIntArrayAssign2(
      &be,
      mclPlus(mclIntArrayRef2(mclVv(be, "be"), 2, 2), mclVv(ii10, "ii10")),
      2,
      2);
    /*
     * [ae,be,ce]=ecpdiv(ae,be,ce);
     */
    mlfAssign(
      &ae,
      mlfGenhyper_ecpdiv(
        &be, &ce, mclVv(ae, "ae"), mclVv(be, "be"), mclVv(ce, "ce")));
    /*
     * if (lnpfq==0) ;
     */
    if (mclEqBool(mclVa(*lnpfq, "lnpfq"), _mxarray1_)) {
        /*
         * [ce,c]=conv21(ce,c);
         */
        mlfAssign(&ce, mlfGenhyper_conv21(c, mclVv(ce, "ce"), mclVa(*c, "c")));
    /*
     * else;
     */
    } else {
        /*
         * [ce(1,1),ce(1,2),ce(1,1),ce(1,2),n1,e1]=emult(ce(1,1),ce(1,2),ce(1,1),ce(1,2),n1,e1);
         */
        mclFeval(
          mlfIndexVarargout(
            &ce, "(?,?)", _mxarray3_, _mxarray3_,
            &ce, "(?,?)", _mxarray3_, _mxarray4_,
            &ce, "(?,?)", _mxarray3_, _mxarray3_,
            &ce, "(?,?)", _mxarray3_, _mxarray4_,
            &n1, "",
            &e1, "",
            NULL),
          mlxGenhyper_emult,
          mclIntArrayRef2(mclVv(ce, "ce"), 1, 1),
          mclIntArrayRef2(mclVv(ce, "ce"), 1, 2),
          mclIntArrayRef2(mclVv(ce, "ce"), 1, 1),
          mclIntArrayRef2(mclVv(ce, "ce"), 1, 2),
          mclVv(n1, "n1"),
          mclVv(e1, "e1"),
          NULL);
        /*
         * [ce(2,1),ce(2,2),ce(2,1),ce(2,2),n2,e2]=emult(ce(2,1),ce(2,2),ce(2,1),ce(2,2),n2,e2);
         */
        mclFeval(
          mlfIndexVarargout(
            &ce, "(?,?)", _mxarray4_, _mxarray3_,
            &ce, "(?,?)", _mxarray4_, _mxarray4_,
            &ce, "(?,?)", _mxarray4_, _mxarray3_,
            &ce, "(?,?)", _mxarray4_, _mxarray4_,
            &n2, "",
            &e2, "",
            NULL),
          mlxGenhyper_emult,
          mclIntArrayRef2(mclVv(ce, "ce"), 2, 1),
          mclIntArrayRef2(mclVv(ce, "ce"), 2, 2),
          mclIntArrayRef2(mclVv(ce, "ce"), 2, 1),
          mclIntArrayRef2(mclVv(ce, "ce"), 2, 2),
          mclVv(n2, "n2"),
          mclVv(e2, "e2"),
          NULL);
        /*
         * [n1,e1,n2,e2,n3,e3]=eadd(n1,e1,n2,e2,n3,e3);
         */
        mlfAssign(
          &n1,
          mlfGenhyper_eadd(
            &e1,
            &n2,
            &e2,
            &n3,
            &e3,
            mclVv(n1, "n1"),
            mclVv(e1, "e1"),
            mclVv(n2, "n2"),
            mclVv(e2, "e2"),
            mclVv(n3, "n3"),
            mclVv(e3, "e3")));
        /*
         * n1=ce(1,1);
         */
        mlfAssign(&n1, mclIntArrayRef2(mclVv(ce, "ce"), 1, 1));
        /*
         * e1=ce(1,2)-ce(2,2);
         */
        mlfAssign(
          &e1,
          mclMinus(
            mclIntArrayRef2(mclVv(ce, "ce"), 1, 2),
            mclIntArrayRef2(mclVv(ce, "ce"), 2, 2)));
        /*
         * x2=ce(2,1);
         */
        mlfAssign(&x2, mclIntArrayRef2(mclVv(ce, "ce"), 2, 1));
        /*
         * %
         * %      TENMAX - MAXIMUM SIZE OF EXPONENT OF 10
         * %
         * %      THE FOLLOWING CODE CAN BE USED TO DETERMINE TENMAX, BUT IT
         * %
         * %      WILL LIKELY GENERATE AN IEEE FLOATING POINT UNDERFLOW ERROR
         * %
         * %      ON A SUN WORKSTATION.  REPLACE TENMAX WITH THE VALUE APPROPRIATE
         * %
         * %      FOR YOUR MACHINE.
         * %
         * %
         * tenmax=320;
         */
        mlfAssign(&tenmax, _mxarray22_);
        /*
         * itnmax=1;
         */
        mlfAssign(&itnmax, _mxarray3_);
        /*
         * dnum=0.1d0;
         */
        mlfAssign(&dnum, _mxarray23_);
        /*
         * itnmax=itnmax+1;
         */
        mlfAssign(&itnmax, mclPlus(mclVv(itnmax, "itnmax"), _mxarray3_));
        /*
         * dnum=dnum.*0.1d0;
         */
        mlfAssign(&dnum, mclTimes(mclVv(dnum, "dnum"), _mxarray23_));
        /*
         * while (dnum>0.0);
         */
        while (mclGtBool(mclVv(dnum, "dnum"), _mxarray1_)) {
            /*
             * itnmax=itnmax+1;
             */
            mlfAssign(&itnmax, mclPlus(mclVv(itnmax, "itnmax"), _mxarray3_));
            /*
             * dnum=dnum.*0.1d0;
             */
            mlfAssign(&dnum, mclTimes(mclVv(dnum, "dnum"), _mxarray23_));
        /*
         * end;
         */
        }
        /*
         * itnmax=itnmax-1;
         */
        mlfAssign(&itnmax, mclMinus(mclVv(itnmax, "itnmax"), _mxarray3_));
        /*
         * tenmax=real(itnmax);
         */
        mlfAssign(&tenmax, mlfReal(mclVv(itnmax, "itnmax")));
        /*
         * %
         * if (e1>tenmax) ;
         */
        if (mclGtBool(mclVv(e1, "e1"), mclVv(tenmax, "tenmax"))) {
            /*
             * x1=tenmax;
             */
            mlfAssign(&x1, mclVv(tenmax, "tenmax"));
        /*
         * elseif (e1<-tenmax);
         */
        } else if (mclLtBool(
                     mclVv(e1, "e1"), mclUminus(mclVv(tenmax, "tenmax")))) {
            /*
             * x1=0.0;
             */
            mlfAssign(&x1, _mxarray1_);
        /*
         * else;
         */
        } else {
            /*
             * x1=n1.*(ten.^e1);
             */
            mlfAssign(
              &x1,
              mclTimes(
                mclVv(n1, "n1"),
                mlfPower(mclVg(&ten, "ten"), mclVv(e1, "e1"))));
        /*
         * end;
         */
        }
        /*
         * if (x2~=0.0) ;
         */
        if (mclNeBool(mclVv(x2, "x2"), _mxarray1_)) {
            /*
             * phi=atan2(x2,x1);
             */
            mlfAssign(&phi, mlfAtan2(mclVv(x2, "x2"), mclVv(x1, "x1")));
        /*
         * else;
         */
        } else {
            /*
             * phi=0.0;
             */
            mlfAssign(&phi, _mxarray1_);
        /*
         * end;
         */
        }
        /*
         * c=complex(half.*(log(n3)+e3.*log(ten)),phi);
         */
        mlfAssign(
          c,
          mlfComplex(
            mclTimes(
              mclVg(&half, "half"),
              mclPlus(
                mlfLog(mclVv(n3, "n3")),
                mclTimes(mclVv(e3, "e3"), mlfLog(mclVg(&ten, "ten"))))),
            mclVv(phi, "phi")));
    /*
     * end;
     */
    }
    mclValidateOutput(ar, 1, nargout_, "ar", "genhyper/arydiv");
    mclValidateOutput(*ai, 2, nargout_, "ai", "genhyper/arydiv");
    mclValidateOutput(*br, 3, nargout_, "br", "genhyper/arydiv");
    mclValidateOutput(*bi, 4, nargout_, "bi", "genhyper/arydiv");
    mclValidateOutput(*c, 5, nargout_, "c", "genhyper/arydiv");
    mclValidateOutput(*l, 6, nargout_, "l", "genhyper/arydiv");
    mclValidateOutput(*lnpfq, 7, nargout_, "lnpfq", "genhyper/arydiv");
    mclValidateOutput(*rmax, 8, nargout_, "rmax", "genhyper/arydiv");
    mclValidateOutput(*ibit, 9, nargout_, "ibit", "genhyper/arydiv");
    mxDestroyArray(cdum);
    mxDestroyArray(ae);
    mxDestroyArray(be);
    mxDestroyArray(ce);
    mxDestroyArray(n1);
    mxDestroyArray(e1);
    mxDestroyArray(n2);
    mxDestroyArray(e2);
    mxDestroyArray(n3);
    mxDestroyArray(e3);
    mxDestroyArray(ans);
    mxDestroyArray(dum1);
    mxDestroyArray(dum2);
    mxDestroyArray(phi);
    mxDestroyArray(ri10);
    mxDestroyArray(rr10);
    mxDestroyArray(tenmax);
    mxDestroyArray(x);
    mxDestroyArray(x1);
    mxDestroyArray(x2);
    mxDestroyArray(dnum);
    mxDestroyArray(ii10);
    mxDestroyArray(ir10);
    mxDestroyArray(itnmax);
    mxDestroyArray(rexp);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return ar;
    /*
     * 
     * 
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE EMULT                             *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Takes one base and exponent and multiplies it *
     * %     *    by another numbers base and exponent to give the product  *
     * %     *    in the form of base and exponent.                         *
     * %     *                                                              *
     * %     *  Subprograms called: none                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_emult" is the implementation version of the
 * "genhyper/emult" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1380-1409). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [n1,e1,n2,e2,nf,ef]=emult(n1,e1,n2,e2,nf,ef);
 */
static mxArray * Mgenhyper_emult(mxArray * * e1,
                                 mxArray * * n2,
                                 mxArray * * e2,
                                 mxArray * * nf,
                                 mxArray * * ef,
                                 int nargout_,
                                 mxArray * n1_in,
                                 mxArray * e1_in,
                                 mxArray * n2_in,
                                 mxArray * e2_in,
                                 mxArray * nf_in,
                                 mxArray * ef_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * n1 = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&n1, n1_in);
    mclCopyInputArg(e1, e1_in);
    mclCopyInputArg(n2, n2_in);
    mclCopyInputArg(e2, e2_in);
    mclCopyInputArg(nf, nf_in);
    mclCopyInputArg(ef, ef_in);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * nf=n1.*n2;
     */
    mlfAssign(nf, mclTimes(mclVa(n1, "n1"), mclVa(*n2, "n2")));
    /*
     * ef=e1+e2;
     */
    mlfAssign(ef, mclPlus(mclVa(*e1, "e1"), mclVa(*e2, "e2")));
    /*
     * if (abs(nf)>=ten) ;
     */
    if (mclGeBool(mlfAbs(mclVa(*nf, "nf")), mclVg(&ten, "ten"))) {
        /*
         * nf=nf./ten;
         */
        mlfAssign(nf, mclRdivide(mclVa(*nf, "nf"), mclVg(&ten, "ten")));
        /*
         * ef=ef+one;
         */
        mlfAssign(ef, mclPlus(mclVa(*ef, "ef"), mclVg(&one, "one")));
    /*
     * end;
     */
    }
    mclValidateOutput(n1, 1, nargout_, "n1", "genhyper/emult");
    mclValidateOutput(*e1, 2, nargout_, "e1", "genhyper/emult");
    mclValidateOutput(*n2, 3, nargout_, "n2", "genhyper/emult");
    mclValidateOutput(*e2, 4, nargout_, "e2", "genhyper/emult");
    mclValidateOutput(*nf, 5, nargout_, "nf", "genhyper/emult");
    mclValidateOutput(*ef, 6, nargout_, "ef", "genhyper/emult");
    mxDestroyArray(ans);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return n1;
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE EDIV                              *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : returns the solution in the form of base and  *
     * %     *    exponent of the division of two exponential numbers.      *
     * %     *                                                              *
     * %     *  Subprograms called: none                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_ediv" is the implementation version of the
 * "genhyper/ediv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1409-1438). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [n1,e1,n2,e2,nf,ef]=ediv(n1,e1,n2,e2,nf,ef);
 */
static mxArray * Mgenhyper_ediv(mxArray * * e1,
                                mxArray * * n2,
                                mxArray * * e2,
                                mxArray * * nf,
                                mxArray * * ef,
                                int nargout_,
                                mxArray * n1_in,
                                mxArray * e1_in,
                                mxArray * n2_in,
                                mxArray * e2_in,
                                mxArray * nf_in,
                                mxArray * ef_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * n1 = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&n1, n1_in);
    mclCopyInputArg(e1, e1_in);
    mclCopyInputArg(n2, n2_in);
    mclCopyInputArg(e2, e2_in);
    mclCopyInputArg(nf, nf_in);
    mclCopyInputArg(ef, ef_in);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * nf=n1./n2;
     */
    mlfAssign(nf, mclRdivide(mclVa(n1, "n1"), mclVa(*n2, "n2")));
    /*
     * ef=e1-e2;
     */
    mlfAssign(ef, mclMinus(mclVa(*e1, "e1"), mclVa(*e2, "e2")));
    /*
     * if ((abs(nf)<one) & (nf~=zero)) ;
     */
    {
        mxArray * a_
          = mclInitialize(mclLt(mlfAbs(mclVa(*nf, "nf")), mclVg(&one, "one")));
        if (mlfTobool(a_)
            && mlfTobool(
                 mclAnd(a_, mclNe(mclVa(*nf, "nf"), mclVg(&zero, "zero"))))) {
            mxDestroyArray(a_);
            /*
             * nf=nf.*ten;
             */
            mlfAssign(nf, mclTimes(mclVa(*nf, "nf"), mclVg(&ten, "ten")));
            /*
             * ef=ef-one;
             */
            mlfAssign(ef, mclMinus(mclVa(*ef, "ef"), mclVg(&one, "one")));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    mclValidateOutput(n1, 1, nargout_, "n1", "genhyper/ediv");
    mclValidateOutput(*e1, 2, nargout_, "e1", "genhyper/ediv");
    mclValidateOutput(*n2, 3, nargout_, "n2", "genhyper/ediv");
    mclValidateOutput(*e2, 4, nargout_, "e2", "genhyper/ediv");
    mclValidateOutput(*nf, 5, nargout_, "nf", "genhyper/ediv");
    mclValidateOutput(*ef, 6, nargout_, "ef", "genhyper/ediv");
    mxDestroyArray(ans);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return n1;
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE EADD                              *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Returns the sum of two numbers in the form    *
     * %     *    of a base and an exponent.                                *
     * %     *                                                              *
     * %     *  Subprograms called: none                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_eadd" is the implementation version of the
 * "genhyper/eadd" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1438-1484). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [n1,e1,n2,e2,nf,ef]=eadd(n1,e1,n2,e2,nf,ef);
 */
static mxArray * Mgenhyper_eadd(mxArray * * e1,
                                mxArray * * n2,
                                mxArray * * e2,
                                mxArray * * nf,
                                mxArray * * ef,
                                int nargout_,
                                mxArray * n1_in,
                                mxArray * e1_in,
                                mxArray * n2_in,
                                mxArray * e2_in,
                                mxArray * nf_in,
                                mxArray * ef_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * n1 = NULL;
    mxArray * ediff = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&n1, n1_in);
    mclCopyInputArg(e1, e1_in);
    mclCopyInputArg(n2, n2_in);
    mclCopyInputArg(e2, e2_in);
    mclCopyInputArg(nf, nf_in);
    mclCopyInputArg(ef, ef_in);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * ediff=0;
     */
    mlfAssign(&ediff, _mxarray1_);
    /*
     * %
     * %
     * ediff=e1-e2;
     */
    mlfAssign(&ediff, mclMinus(mclVa(*e1, "e1"), mclVa(*e2, "e2")));
    /*
     * if (ediff>36.0d0) ;
     */
    if (mclGtBool(mclVv(ediff, "ediff"), _mxarray24_)) {
        /*
         * nf=n1;
         */
        mlfAssign(nf, mclVa(n1, "n1"));
        /*
         * ef=e1;
         */
        mlfAssign(ef, mclVa(*e1, "e1"));
    /*
     * elseif (ediff<-36.0d0);
     */
    } else if (mclLtBool(mclVv(ediff, "ediff"), _mxarray25_)) {
        /*
         * nf=n2;
         */
        mlfAssign(nf, mclVa(*n2, "n2"));
        /*
         * ef=e2;
         */
        mlfAssign(ef, mclVa(*e2, "e2"));
    /*
     * else;
     */
    } else {
        /*
         * nf=n1.*(ten.^ediff)+n2;
         */
        mlfAssign(
          nf,
          mclPlus(
            mclTimes(
              mclVa(n1, "n1"),
              mlfPower(mclVg(&ten, "ten"), mclVv(ediff, "ediff"))),
            mclVa(*n2, "n2")));
        /*
         * ef=e2;
         */
        mlfAssign(ef, mclVa(*e2, "e2"));
        /*
         * while (1);
         */
        for (;;) {
            /*
             * if (abs(nf)<ten) ;
             */
            if (mclLtBool(mlfAbs(mclVa(*nf, "nf")), mclVg(&ten, "ten"))) {
                /*
                 * while ((abs(nf)<one) & (nf~=0.0));
                 */
                for (;;) {
                    mxArray * a_
                      = mclInitialize(
                          mclLt(mlfAbs(mclVa(*nf, "nf")), mclVg(&one, "one")));
                    if (mlfTobool(a_)
                        && mlfTobool(
                             mclAnd(
                               a_, mclNe(mclVa(*nf, "nf"), _mxarray1_)))) {
                        mxDestroyArray(a_);
                    } else {
                        mxDestroyArray(a_);
                        break;
                    }
                    /*
                     * nf=nf.*ten;
                     */
                    mlfAssign(
                      nf, mclTimes(mclVa(*nf, "nf"), mclVg(&ten, "ten")));
                    /*
                     * ef=ef-one;
                     */
                    mlfAssign(
                      ef, mclMinus(mclVa(*ef, "ef"), mclVg(&one, "one")));
                /*
                 * end;
                 */
                }
                /*
                 * break;
                 */
                break;
            /*
             * else;
             */
            } else {
                /*
                 * nf=nf./ten;
                 */
                mlfAssign(nf, mclRdivide(mclVa(*nf, "nf"), mclVg(&ten, "ten")));
                /*
                 * ef=ef+one;
                 */
                mlfAssign(ef, mclPlus(mclVa(*ef, "ef"), mclVg(&one, "one")));
            /*
             * end;
             */
            }
        /*
         * end;
         */
        }
    /*
     * end;
     */
    }
    mclValidateOutput(n1, 1, nargout_, "n1", "genhyper/eadd");
    mclValidateOutput(*e1, 2, nargout_, "e1", "genhyper/eadd");
    mclValidateOutput(*n2, 3, nargout_, "n2", "genhyper/eadd");
    mclValidateOutput(*e2, 4, nargout_, "e2", "genhyper/eadd");
    mclValidateOutput(*nf, 5, nargout_, "nf", "genhyper/eadd");
    mclValidateOutput(*ef, 6, nargout_, "ef", "genhyper/eadd");
    mxDestroyArray(ans);
    mxDestroyArray(ediff);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return n1;
    /*
     * 
     * 
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE ESUB                              *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Returns the solution to the subtraction of    *
     * %     *    two numbers in the form of base and exponent.             *
     * %     *                                                              *
     * %     *  Subprograms called: EADD                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_esub" is the implementation version of the
 * "genhyper/esub" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1484-1508). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [n1,e1,n2,e2,nf,ef]=esub(n1,e1,n2,e2,nf,ef);
 */
static mxArray * Mgenhyper_esub(mxArray * * e1,
                                mxArray * * n2,
                                mxArray * * e2,
                                mxArray * * nf,
                                mxArray * * ef,
                                int nargout_,
                                mxArray * n1_in,
                                mxArray * e1_in,
                                mxArray * n2_in,
                                mxArray * e2_in,
                                mxArray * nf_in,
                                mxArray * ef_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * n1 = NULL;
    mxArray * dumvar3 = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&n1, n1_in);
    mclCopyInputArg(e1, e1_in);
    mclCopyInputArg(n2, n2_in);
    mclCopyInputArg(e2, e2_in);
    mclCopyInputArg(nf, nf_in);
    mclCopyInputArg(ef, ef_in);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * [n1,e1,dumvar3,e2,nf,ef]=eadd(n1,e1,n2.*(-one),e2,nf,ef);
     */
    mlfAssign(
      &n1,
      mlfGenhyper_eadd(
        e1,
        &dumvar3,
        e2,
        nf,
        ef,
        mclVa(n1, "n1"),
        mclVa(*e1, "e1"),
        mclTimes(mclVa(*n2, "n2"), mclUminus(mclVg(&one, "one"))),
        mclVa(*e2, "e2"),
        mclVa(*nf, "nf"),
        mclVa(*ef, "ef")));
    mclValidateOutput(n1, 1, nargout_, "n1", "genhyper/esub");
    mclValidateOutput(*e1, 2, nargout_, "e1", "genhyper/esub");
    mclValidateOutput(*n2, 3, nargout_, "n2", "genhyper/esub");
    mclValidateOutput(*e2, 4, nargout_, "e2", "genhyper/esub");
    mclValidateOutput(*nf, 5, nargout_, "nf", "genhyper/esub");
    mclValidateOutput(*ef, 6, nargout_, "ef", "genhyper/esub");
    mxDestroyArray(ans);
    mxDestroyArray(dumvar3);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return n1;
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE CONV12                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Converts a number from complex notation to a  *
     * %     *    form of a 2x2 real array.                                 *
     * %     *                                                              *
     * %     *  Subprograms called: none                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_conv12" is the implementation version of the
 * "genhyper/conv12" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1508-1564). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [cn,cae]=conv12(cn,cae);
 */
static mxArray * Mgenhyper_conv12(mxArray * * cae,
                                  int nargout_,
                                  mxArray * cn_in,
                                  mxArray * cae_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * cn = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&cn, cn_in);
    mclCopyInputArg(cae, cae_in);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * %
     * %
     * cae(1,1)=real(cn);
     */
    mclIntArrayAssign2(cae, mlfReal(mclVa(cn, "cn")), 1, 1);
    /*
     * cae(1,2)=0.0;
     */
    mclIntArrayAssign2(cae, _mxarray1_, 1, 2);
    /*
     * while (1);
     */
    for (;;) {
        /*
         * if (abs(cae(1,1))<ten) ;
         */
        if (mclLtBool(
              mlfAbs(mclIntArrayRef2(mclVa(*cae, "cae"), 1, 1)),
              mclVg(&ten, "ten"))) {
            /*
             * while (1);
             */
            for (;;) {
                /*
                 * if ((abs(cae(1,1))>=one) | (cae(1,1)==0.0)) ;
                 */
                mxArray * a_
                  = mclInitialize(
                      mclGe(
                        mlfAbs(mclIntArrayRef2(mclVa(*cae, "cae"), 1, 1)),
                        mclVg(&one, "one")));
                if (mlfTobool(a_)
                    || mlfTobool(
                         mclOr(
                           a_,
                           mclEq(
                             mclIntArrayRef2(mclVa(*cae, "cae"), 1, 1),
                             _mxarray1_)))) {
                    mxDestroyArray(a_);
                    /*
                     * cae(2,1)=imag(cn);
                     */
                    mclIntArrayAssign2(cae, mlfImag(mclVa(cn, "cn")), 2, 1);
                    /*
                     * cae(2,2)=0.0;
                     */
                    mclIntArrayAssign2(cae, _mxarray1_, 2, 2);
                    /*
                     * while (1);
                     */
                    for (;;) {
                        /*
                         * if (abs(cae(2,1))<ten) ;
                         */
                        if (mclLtBool(
                              mlfAbs(mclIntArrayRef2(mclVa(*cae, "cae"), 2, 1)),
                              mclVg(&ten, "ten"))) {
                            /*
                             * while ((abs(cae(2,1))<one) & (cae(2,1)~=0.0));
                             */
                            for (;;) {
                                mxArray * a_4
                                  = mclInitialize(
                                      mclLt(
                                        mlfAbs(
                                          mclIntArrayRef2(
                                            mclVa(*cae, "cae"), 2, 1)),
                                        mclVg(&one, "one")));
                                if (mlfTobool(a_4)
                                    && mlfTobool(
                                         mclAnd(
                                           a_4,
                                           mclNe(
                                             mclIntArrayRef2(
                                               mclVa(*cae, "cae"), 2, 1),
                                             _mxarray1_)))) {
                                    mxDestroyArray(a_4);
                                } else {
                                    mxDestroyArray(a_4);
                                    break;
                                }
                                /*
                                 * cae(2,1)=cae(2,1).*ten;
                                 */
                                mclIntArrayAssign2(
                                  cae,
                                  mclTimes(
                                    mclIntArrayRef2(mclVa(*cae, "cae"), 2, 1),
                                    mclVg(&ten, "ten")),
                                  2,
                                  1);
                                /*
                                 * cae(2,2)=cae(2,2)-one;
                                 */
                                mclIntArrayAssign2(
                                  cae,
                                  mclMinus(
                                    mclIntArrayRef2(mclVa(*cae, "cae"), 2, 2),
                                    mclVg(&one, "one")),
                                  2,
                                  2);
                            /*
                             * end;
                             */
                            }
                            /*
                             * break;
                             */
                            break;
                        /*
                         * else;
                         */
                        } else {
                            /*
                             * cae(2,1)=cae(2,1)./ten;
                             */
                            mclIntArrayAssign2(
                              cae,
                              mclRdivide(
                                mclIntArrayRef2(mclVa(*cae, "cae"), 2, 1),
                                mclVg(&ten, "ten")),
                              2,
                              1);
                            /*
                             * cae(2,2)=cae(2,2)+one;
                             */
                            mclIntArrayAssign2(
                              cae,
                              mclPlus(
                                mclIntArrayRef2(mclVa(*cae, "cae"), 2, 2),
                                mclVg(&one, "one")),
                              2,
                              2);
                        /*
                         * end;
                         */
                        }
                    /*
                     * end;
                     */
                    }
                    /*
                     * break;
                     */
                    break;
                /*
                 * else;
                 */
                } else {
                    mxDestroyArray(a_);
                    /*
                     * cae(1,1)=cae(1,1).*ten;
                     */
                    mclIntArrayAssign2(
                      cae,
                      mclTimes(
                        mclIntArrayRef2(mclVa(*cae, "cae"), 1, 1),
                        mclVg(&ten, "ten")),
                      1,
                      1);
                    /*
                     * cae(1,2)=cae(1,2)-one;
                     */
                    mclIntArrayAssign2(
                      cae,
                      mclMinus(
                        mclIntArrayRef2(mclVa(*cae, "cae"), 1, 2),
                        mclVg(&one, "one")),
                      1,
                      2);
                }
            /*
             * end;
             * end;
             */
            }
            /*
             * break;
             */
            break;
        /*
         * else;
         */
        } else {
            /*
             * cae(1,1)=cae(1,1)./ten;
             */
            mclIntArrayAssign2(
              cae,
              mclRdivide(
                mclIntArrayRef2(mclVa(*cae, "cae"), 1, 1), mclVg(&ten, "ten")),
              1,
              1);
            /*
             * cae(1,2)=cae(1,2)+one;
             */
            mclIntArrayAssign2(
              cae,
              mclPlus(
                mclIntArrayRef2(mclVa(*cae, "cae"), 1, 2), mclVg(&one, "one")),
              1,
              2);
        /*
         * end;
         */
        }
    /*
     * end;
     */
    }
    mclValidateOutput(cn, 1, nargout_, "cn", "genhyper/conv12");
    mclValidateOutput(*cae, 2, nargout_, "cae", "genhyper/conv12");
    mxDestroyArray(ans);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return cn;
    /*
     * 
     * 
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE CONV21                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Converts a number represented in a 2x2 real   *
     * %     *    array to the form of a complex number.                    *
     * %     *                                                              *
     * %     *  Subprograms called: none                                    *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_conv21" is the implementation version of the
 * "genhyper/conv21" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1564-1619). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [cae,cn]=conv21(cae,cn);
 */
static mxArray * Mgenhyper_conv21(mxArray * * cn,
                                  int nargout_,
                                  mxArray * cae_in,
                                  mxArray * cn_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * cae = NULL;
    mxArray * itnmax = NULL;
    mxArray * tenmax = NULL;
    mxArray * dnum = NULL;
    mxArray * ans = NULL;
    mclCopyInputArg(&cae, cae_in);
    mclCopyInputArg(cn, cn_in);
    /*
     * %
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * global  nout;
     * %
     * %
     * %
     * dnum=0;tenmax=0;
     */
    mlfAssign(&dnum, _mxarray1_);
    mlfAssign(&tenmax, _mxarray1_);
    /*
     * itnmax=0;
     */
    mlfAssign(&itnmax, _mxarray1_);
    /*
     * %
     * %
     * %     TENMAX - MAXIMUM SIZE OF EXPONENT OF 10
     * %
     * itnmax=1;
     */
    mlfAssign(&itnmax, _mxarray3_);
    /*
     * dnum=0.1d0;
     */
    mlfAssign(&dnum, _mxarray23_);
    /*
     * itnmax=itnmax+1;
     */
    mlfAssign(&itnmax, mclPlus(mclVv(itnmax, "itnmax"), _mxarray3_));
    /*
     * dnum=dnum.*0.1d0;
     */
    mlfAssign(&dnum, mclTimes(mclVv(dnum, "dnum"), _mxarray23_));
    /*
     * while  (dnum>0.0);
     */
    while (mclGtBool(mclVv(dnum, "dnum"), _mxarray1_)) {
        /*
         * itnmax=itnmax+1;
         */
        mlfAssign(&itnmax, mclPlus(mclVv(itnmax, "itnmax"), _mxarray3_));
        /*
         * dnum=dnum.*0.1d0;
         */
        mlfAssign(&dnum, mclTimes(mclVv(dnum, "dnum"), _mxarray23_));
    /*
     * end;
     */
    }
    /*
     * itnmax=itnmax-2;
     */
    mlfAssign(&itnmax, mclMinus(mclVv(itnmax, "itnmax"), _mxarray4_));
    /*
     * tenmax=real(itnmax);
     */
    mlfAssign(&tenmax, mlfReal(mclVv(itnmax, "itnmax")));
    /*
     * %
     * if (cae(1,2)>tenmax | cae(2,2)>tenmax) ;
     */
    {
        mxArray * a_
          = mclInitialize(
              mclGt(
                mclIntArrayRef2(mclVa(cae, "cae"), 1, 2),
                mclVv(tenmax, "tenmax")));
        if (mlfTobool(a_)
            || mlfTobool(
                 mclOr(
                   a_,
                   mclGt(
                     mclIntArrayRef2(mclVa(cae, "cae"), 2, 2),
                     mclVv(tenmax, "tenmax"))))) {
            mxDestroyArray(a_);
            /*
             * %      CN=CMPLX(TENMAX,TENMAX)
             * %
             * itnmax,
             */
            mclPrintArray(mclVv(itnmax, "itnmax"), "itnmax");
            /*
             * %format (' error - value of exponent required for summation',' was larger',./,' than the maximum machine exponent ',1i3,./,[' suggestions:'],./,' 1) re-run using lnpfq=1.',./,' 2) if you are using a vax, try using the',' fortran./g_floating option');
             * error('stop encountered in original fortran code');
             */
            mlfError(_mxarray9_, NULL);
        /*
         * elseif (cae(2,2)<-tenmax);
         */
        } else {
            mxDestroyArray(a_);
            if (mclLtBool(
                  mclIntArrayRef2(mclVa(cae, "cae"), 2, 2),
                  mclUminus(mclVv(tenmax, "tenmax")))) {
                /*
                 * cn=complex(cae(1,1).*(10.^cae(1,2)),0.0);
                 */
                mlfAssign(
                  cn,
                  mlfComplex(
                    mclTimes(
                      mclIntArrayRef2(mclVa(cae, "cae"), 1, 1),
                      mlfPower(
                        _mxarray0_, mclIntArrayRef2(mclVa(cae, "cae"), 1, 2))),
                    _mxarray1_));
            /*
             * else;
             */
            } else {
                /*
                 * cn=complex(cae(1,1).*(10.^cae(1,2)),cae(2,1).*(10.^cae(2,2)));
                 */
                mlfAssign(
                  cn,
                  mlfComplex(
                    mclTimes(
                      mclIntArrayRef2(mclVa(cae, "cae"), 1, 1),
                      mlfPower(
                        _mxarray0_, mclIntArrayRef2(mclVa(cae, "cae"), 1, 2))),
                    mclTimes(
                      mclIntArrayRef2(mclVa(cae, "cae"), 2, 1),
                      mlfPower(
                        _mxarray0_,
                        mclIntArrayRef2(mclVa(cae, "cae"), 2, 2)))));
            }
        }
    /*
     * end;
     */
    }
    mclValidateOutput(cae, 1, nargout_, "cae", "genhyper/conv21");
    mclValidateOutput(*cn, 2, nargout_, "cn", "genhyper/conv21");
    mxDestroyArray(ans);
    mxDestroyArray(dnum);
    mxDestroyArray(tenmax);
    mxDestroyArray(itnmax);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return cae;
    /*
     * return;
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE ECPMUL                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Multiplies two numbers which are each         *
     * %     *    represented in the form of a two by two array and returns *
     * %     *    the solution in the same form.                            *
     * %     *                                                              *
     * %     *  Subprograms called: EMULT, ESUB, EADD                       *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_ecpmul" is the implementation version of the
 * "genhyper/ecpmul" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1619-1650). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [a,b,c]=ecpmul(a,b,c);
 */
static mxArray * Mgenhyper_ecpmul(mxArray * * b,
                                  mxArray * * c,
                                  int nargout_,
                                  mxArray * a_in,
                                  mxArray * b_in,
                                  mxArray * c_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * a = NULL;
    mxArray * c2 = NULL;
    mxArray * e2 = NULL;
    mxArray * n2 = NULL;
    mxArray * e1 = NULL;
    mxArray * n1 = NULL;
    mclCopyInputArg(&a, a_in);
    mclCopyInputArg(b, b_in);
    mclCopyInputArg(c, c_in);
    /*
     * %
     * %
     * n1=[];e1=[];n2=[];e2=[];c2=[];
     */
    mlfAssign(&n1, _mxarray12_);
    mlfAssign(&e1, _mxarray12_);
    mlfAssign(&n2, _mxarray12_);
    mlfAssign(&e2, _mxarray12_);
    mlfAssign(&c2, _mxarray12_);
    /*
     * c2=zeros(2,2);e1=0;e2=0;n1=0;n2=0;
     */
    mlfAssign(&c2, mlfZeros(_mxarray4_, _mxarray4_, NULL));
    mlfAssign(&e1, _mxarray1_);
    mlfAssign(&e2, _mxarray1_);
    mlfAssign(&n1, _mxarray1_);
    mlfAssign(&n2, _mxarray1_);
    /*
     * %
     * %
     * [a(1,1),a(1,2),b(1,1),b(1,2),n1,e1]=emult(a(1,1),a(1,2),b(1,1),b(1,2),n1,e1);
     */
    mclFeval(
      mlfIndexVarargout(
        &a, "(?,?)", _mxarray3_, _mxarray3_,
        &a, "(?,?)", _mxarray3_, _mxarray4_,
        b, "(?,?)", _mxarray3_, _mxarray3_,
        b, "(?,?)", _mxarray3_, _mxarray4_,
        &n1, "",
        &e1, "",
        NULL),
      mlxGenhyper_emult,
      mclIntArrayRef2(mclVa(a, "a"), 1, 1),
      mclIntArrayRef2(mclVa(a, "a"), 1, 2),
      mclIntArrayRef2(mclVa(*b, "b"), 1, 1),
      mclIntArrayRef2(mclVa(*b, "b"), 1, 2),
      mclVv(n1, "n1"),
      mclVv(e1, "e1"),
      NULL);
    /*
     * [a(2,1),a(2,2),b(2,1),b(2,2),n2,e2]=emult(a(2,1),a(2,2),b(2,1),b(2,2),n2,e2);
     */
    mclFeval(
      mlfIndexVarargout(
        &a, "(?,?)", _mxarray4_, _mxarray3_,
        &a, "(?,?)", _mxarray4_, _mxarray4_,
        b, "(?,?)", _mxarray4_, _mxarray3_,
        b, "(?,?)", _mxarray4_, _mxarray4_,
        &n2, "",
        &e2, "",
        NULL),
      mlxGenhyper_emult,
      mclIntArrayRef2(mclVa(a, "a"), 2, 1),
      mclIntArrayRef2(mclVa(a, "a"), 2, 2),
      mclIntArrayRef2(mclVa(*b, "b"), 2, 1),
      mclIntArrayRef2(mclVa(*b, "b"), 2, 2),
      mclVv(n2, "n2"),
      mclVv(e2, "e2"),
      NULL);
    /*
     * [n1,e1,n2,e2,c2(1,1),c2(1,2)]=esub(n1,e1,n2,e2,c2(1,1),c2(1,2));
     */
    mclFeval(
      mlfIndexVarargout(
        &n1, "",
        &e1, "",
        &n2, "",
        &e2, "",
        &c2, "(?,?)", _mxarray3_, _mxarray3_,
        &c2, "(?,?)", _mxarray3_, _mxarray4_,
        NULL),
      mlxGenhyper_esub,
      mclVv(n1, "n1"),
      mclVv(e1, "e1"),
      mclVv(n2, "n2"),
      mclVv(e2, "e2"),
      mclIntArrayRef2(mclVv(c2, "c2"), 1, 1),
      mclIntArrayRef2(mclVv(c2, "c2"), 1, 2),
      NULL);
    /*
     * [a(1,1),a(1,2),b(2,1),b(2,2),n1,e1]=emult(a(1,1),a(1,2),b(2,1),b(2,2),n1,e1);
     */
    mclFeval(
      mlfIndexVarargout(
        &a, "(?,?)", _mxarray3_, _mxarray3_,
        &a, "(?,?)", _mxarray3_, _mxarray4_,
        b, "(?,?)", _mxarray4_, _mxarray3_,
        b, "(?,?)", _mxarray4_, _mxarray4_,
        &n1, "",
        &e1, "",
        NULL),
      mlxGenhyper_emult,
      mclIntArrayRef2(mclVa(a, "a"), 1, 1),
      mclIntArrayRef2(mclVa(a, "a"), 1, 2),
      mclIntArrayRef2(mclVa(*b, "b"), 2, 1),
      mclIntArrayRef2(mclVa(*b, "b"), 2, 2),
      mclVv(n1, "n1"),
      mclVv(e1, "e1"),
      NULL);
    /*
     * [a(2,1),a(2,2),b(1,1),b(1,2),n2,e2]=emult(a(2,1),a(2,2),b(1,1),b(1,2),n2,e2);
     */
    mclFeval(
      mlfIndexVarargout(
        &a, "(?,?)", _mxarray4_, _mxarray3_,
        &a, "(?,?)", _mxarray4_, _mxarray4_,
        b, "(?,?)", _mxarray3_, _mxarray3_,
        b, "(?,?)", _mxarray3_, _mxarray4_,
        &n2, "",
        &e2, "",
        NULL),
      mlxGenhyper_emult,
      mclIntArrayRef2(mclVa(a, "a"), 2, 1),
      mclIntArrayRef2(mclVa(a, "a"), 2, 2),
      mclIntArrayRef2(mclVa(*b, "b"), 1, 1),
      mclIntArrayRef2(mclVa(*b, "b"), 1, 2),
      mclVv(n2, "n2"),
      mclVv(e2, "e2"),
      NULL);
    /*
     * [n1,e1,n2,e2,c(2,1),c(2,2)]=eadd(n1,e1,n2,e2,c(2,1),c(2,2));
     */
    mclFeval(
      mlfIndexVarargout(
        &n1, "",
        &e1, "",
        &n2, "",
        &e2, "",
        c, "(?,?)", _mxarray4_, _mxarray3_,
        c, "(?,?)", _mxarray4_, _mxarray4_,
        NULL),
      mlxGenhyper_eadd,
      mclVv(n1, "n1"),
      mclVv(e1, "e1"),
      mclVv(n2, "n2"),
      mclVv(e2, "e2"),
      mclIntArrayRef2(mclVa(*c, "c"), 2, 1),
      mclIntArrayRef2(mclVa(*c, "c"), 2, 2),
      NULL);
    /*
     * c(1,1)=c2(1,1);
     */
    mclIntArrayAssign2(c, mclIntArrayRef2(mclVv(c2, "c2"), 1, 1), 1, 1);
    /*
     * c(1,2)=c2(1,2);
     */
    mclIntArrayAssign2(c, mclIntArrayRef2(mclVv(c2, "c2"), 1, 2), 1, 2);
    mclValidateOutput(a, 1, nargout_, "a", "genhyper/ecpmul");
    mclValidateOutput(*b, 2, nargout_, "b", "genhyper/ecpmul");
    mclValidateOutput(*c, 3, nargout_, "c", "genhyper/ecpmul");
    mxDestroyArray(n1);
    mxDestroyArray(e1);
    mxDestroyArray(n2);
    mxDestroyArray(e2);
    mxDestroyArray(c2);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return a;
    /*
     * 
     * 
     * %
     * %
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                 SUBROUTINE ECPDIV                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Divides two numbers and returns the solution. *
     * %     *    All numbers are represented by a 2x2 array.               *
     * %     *                                                              *
     * %     *  Subprograms called: EADD, ECPMUL, EDIV, EMULT               *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_ecpdiv" is the implementation version of the
 * "genhyper/ecpdiv" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1650-1683). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [a,b,c]=ecpdiv(a,b,c);
 */
static mxArray * Mgenhyper_ecpdiv(mxArray * * b,
                                  mxArray * * c,
                                  int nargout_,
                                  mxArray * a_in,
                                  mxArray * b_in,
                                  mxArray * c_in) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * a = NULL;
    mxArray * ans = NULL;
    mxArray * e3 = NULL;
    mxArray * n3 = NULL;
    mxArray * e2 = NULL;
    mxArray * n2 = NULL;
    mxArray * e1 = NULL;
    mxArray * n1 = NULL;
    mxArray * c2 = NULL;
    mxArray * b2 = NULL;
    mclCopyInputArg(&a, a_in);
    mclCopyInputArg(b, b_in);
    mclCopyInputArg(c, c_in);
    /*
     * %
     * %
     * b2=[];c2=[];n1=[];e1=[];n2=[];e2=[];n3=[];e3=[];
     */
    mlfAssign(&b2, _mxarray12_);
    mlfAssign(&c2, _mxarray12_);
    mlfAssign(&n1, _mxarray12_);
    mlfAssign(&e1, _mxarray12_);
    mlfAssign(&n2, _mxarray12_);
    mlfAssign(&e2, _mxarray12_);
    mlfAssign(&n3, _mxarray12_);
    mlfAssign(&e3, _mxarray12_);
    /*
     * global  zero   half   one   two   ten   eps;
     * %
     * b2=zeros(2,2);c2=zeros(2,2);e1=0;e2=0;e3=0;n1=0;n2=0;n3=0;
     */
    mlfAssign(&b2, mlfZeros(_mxarray4_, _mxarray4_, NULL));
    mlfAssign(&c2, mlfZeros(_mxarray4_, _mxarray4_, NULL));
    mlfAssign(&e1, _mxarray1_);
    mlfAssign(&e2, _mxarray1_);
    mlfAssign(&e3, _mxarray1_);
    mlfAssign(&n1, _mxarray1_);
    mlfAssign(&n2, _mxarray1_);
    mlfAssign(&n3, _mxarray1_);
    /*
     * %
     * %
     * b2(1,1)=b(1,1);
     */
    mclIntArrayAssign2(&b2, mclIntArrayRef2(mclVa(*b, "b"), 1, 1), 1, 1);
    /*
     * b2(1,2)=b(1,2);
     */
    mclIntArrayAssign2(&b2, mclIntArrayRef2(mclVa(*b, "b"), 1, 2), 1, 2);
    /*
     * b2(2,1)=-one.*b(2,1);
     */
    mclIntArrayAssign2(
      &b2,
      mclTimes(
        mclUminus(mclVg(&one, "one")), mclIntArrayRef2(mclVa(*b, "b"), 2, 1)),
      2,
      1);
    /*
     * b2(2,2)=b(2,2);
     */
    mclIntArrayAssign2(&b2, mclIntArrayRef2(mclVa(*b, "b"), 2, 2), 2, 2);
    /*
     * [a,b2,c2]=ecpmul(a,b2,c2);
     */
    mlfAssign(
      &a,
      mlfGenhyper_ecpmul(
        &b2, &c2, mclVa(a, "a"), mclVv(b2, "b2"), mclVv(c2, "c2")));
    /*
     * [b(1,1),b(1,2),b(1,1),b(1,2),n1,e1]=emult(b(1,1),b(1,2),b(1,1),b(1,2),n1,e1);
     */
    mclFeval(
      mlfIndexVarargout(
        b, "(?,?)", _mxarray3_, _mxarray3_,
        b, "(?,?)", _mxarray3_, _mxarray4_,
        b, "(?,?)", _mxarray3_, _mxarray3_,
        b, "(?,?)", _mxarray3_, _mxarray4_,
        &n1, "",
        &e1, "",
        NULL),
      mlxGenhyper_emult,
      mclIntArrayRef2(mclVa(*b, "b"), 1, 1),
      mclIntArrayRef2(mclVa(*b, "b"), 1, 2),
      mclIntArrayRef2(mclVa(*b, "b"), 1, 1),
      mclIntArrayRef2(mclVa(*b, "b"), 1, 2),
      mclVv(n1, "n1"),
      mclVv(e1, "e1"),
      NULL);
    /*
     * [b(2,1),b(2,2),b(2,1),b(2,2),n2,e2]=emult(b(2,1),b(2,2),b(2,1),b(2,2),n2,e2);
     */
    mclFeval(
      mlfIndexVarargout(
        b, "(?,?)", _mxarray4_, _mxarray3_,
        b, "(?,?)", _mxarray4_, _mxarray4_,
        b, "(?,?)", _mxarray4_, _mxarray3_,
        b, "(?,?)", _mxarray4_, _mxarray4_,
        &n2, "",
        &e2, "",
        NULL),
      mlxGenhyper_emult,
      mclIntArrayRef2(mclVa(*b, "b"), 2, 1),
      mclIntArrayRef2(mclVa(*b, "b"), 2, 2),
      mclIntArrayRef2(mclVa(*b, "b"), 2, 1),
      mclIntArrayRef2(mclVa(*b, "b"), 2, 2),
      mclVv(n2, "n2"),
      mclVv(e2, "e2"),
      NULL);
    /*
     * [n1,e1,n2,e2,n3,e3]=eadd(n1,e1,n2,e2,n3,e3);
     */
    mlfAssign(
      &n1,
      mlfGenhyper_eadd(
        &e1,
        &n2,
        &e2,
        &n3,
        &e3,
        mclVv(n1, "n1"),
        mclVv(e1, "e1"),
        mclVv(n2, "n2"),
        mclVv(e2, "e2"),
        mclVv(n3, "n3"),
        mclVv(e3, "e3")));
    /*
     * [c2(1,1),c2(1,2),n3,e3,c(1,1),c(1,2)]=ediv(c2(1,1),c2(1,2),n3,e3,c(1,1),c(1,2));
     */
    mclFeval(
      mlfIndexVarargout(
        &c2, "(?,?)", _mxarray3_, _mxarray3_,
        &c2, "(?,?)", _mxarray3_, _mxarray4_,
        &n3, "",
        &e3, "",
        c, "(?,?)", _mxarray3_, _mxarray3_,
        c, "(?,?)", _mxarray3_, _mxarray4_,
        NULL),
      mlxGenhyper_ediv,
      mclIntArrayRef2(mclVv(c2, "c2"), 1, 1),
      mclIntArrayRef2(mclVv(c2, "c2"), 1, 2),
      mclVv(n3, "n3"),
      mclVv(e3, "e3"),
      mclIntArrayRef2(mclVa(*c, "c"), 1, 1),
      mclIntArrayRef2(mclVa(*c, "c"), 1, 2),
      NULL);
    /*
     * [c2(2,1),c2(2,2),n3,e3,c(2,1),c(2,2)]=ediv(c2(2,1),c2(2,2),n3,e3,c(2,1),c(2,2));
     */
    mclFeval(
      mlfIndexVarargout(
        &c2, "(?,?)", _mxarray4_, _mxarray3_,
        &c2, "(?,?)", _mxarray4_, _mxarray4_,
        &n3, "",
        &e3, "",
        c, "(?,?)", _mxarray4_, _mxarray3_,
        c, "(?,?)", _mxarray4_, _mxarray4_,
        NULL),
      mlxGenhyper_ediv,
      mclIntArrayRef2(mclVv(c2, "c2"), 2, 1),
      mclIntArrayRef2(mclVv(c2, "c2"), 2, 2),
      mclVv(n3, "n3"),
      mclVv(e3, "e3"),
      mclIntArrayRef2(mclVa(*c, "c"), 2, 1),
      mclIntArrayRef2(mclVa(*c, "c"), 2, 2),
      NULL);
    mclValidateOutput(a, 1, nargout_, "a", "genhyper/ecpdiv");
    mclValidateOutput(*b, 2, nargout_, "b", "genhyper/ecpdiv");
    mclValidateOutput(*c, 3, nargout_, "c", "genhyper/ecpdiv");
    mxDestroyArray(b2);
    mxDestroyArray(c2);
    mxDestroyArray(n1);
    mxDestroyArray(e1);
    mxDestroyArray(n2);
    mxDestroyArray(e2);
    mxDestroyArray(n3);
    mxDestroyArray(e3);
    mxDestroyArray(ans);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return a;
    /*
     * 
     * 
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                   FUNCTION IPREMAX                           *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Predicts the maximum term in the pFq series   *
     * %     *    via a simple scanning of arguments.                       *
     * %     *                                                              *
     * %     *  Subprograms called: none.                                   *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
}

/*
 * The function "Mgenhyper_ipremax" is the implementation version of the
 * "genhyper/ipremax" M-function from file "c:\projects\mzdde\genhyper.m"
 * (lines 1683-1735). It contains the actual compiled code for that M-function.
 * It is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [ipremax]=ipremax(a,b,ip,iq,z);
 */
static mxArray * Mgenhyper_ipremax(int nargout_,
                                   mxArray * a,
                                   mxArray * b,
                                   mxArray * ip,
                                   mxArray * iq,
                                   mxArray * z) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * ipremax = NULL;
    mxArray * j = NULL;
    mxArray * i = NULL;
    mxArray * xterm = NULL;
    mxArray * xmax = NULL;
    mxArray * xl = NULL;
    mxArray * expon = NULL;
    mxArray * ans = NULL;
    mclCopyArray(&a);
    mclCopyArray(&b);
    mclCopyArray(&ip);
    mclCopyArray(&iq);
    mclCopyArray(&z);
    /*
     * %
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * global  nout;
     * %
     * %
     * %
     * %
     * %
     * expon=0;xl=0;xmax=0;xterm=0;
     */
    mlfAssign(&expon, _mxarray1_);
    mlfAssign(&xl, _mxarray1_);
    mlfAssign(&xmax, _mxarray1_);
    mlfAssign(&xterm, _mxarray1_);
    /*
     * %
     * i=0;j=0;
     */
    mlfAssign(&i, _mxarray1_);
    mlfAssign(&j, _mxarray1_);
    /*
     * %
     * xterm=0;
     */
    mlfAssign(&xterm, _mxarray1_);
    /*
     * for j=1 : 100000;
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = 100000;
        if (v_ > e_) {
            mlfAssign(&j, _mxarray12_);
        } else {
            /*
             * %
             * %      Estimate the exponent of the maximum term in the pFq series.
             * %
             * %
             * expon=zero;
             * xl=real(j);
             * for i=1 : ip;
             * expon=expon+real(factor(a(i)+xl-one))-real(factor(a(i)-one));
             * end;
             * for i=1 : iq;
             * expon=expon-real(factor(b(i)+xl-one))+real(factor(b(i)-one));
             * end;
             * expon=expon+xl.*real(log(z))-real(factor(complex(xl,zero)));
             * xmax=log10(exp(one)).*expon;
             * if ((xmax<xterm) & (j>2)) ;
             * ipremax=j;
             * return;
             * end;
             * xterm=max([xmax,xterm]);
             * end;
             */
            for (; ; ) {
                mlfAssign(&expon, mclVg(&zero, "zero"));
                mlfAssign(&xl, mlfScalar(svDoubleScalarReal((double) v_)));
                {
                    int v_0 = mclForIntStart(1);
                    int e_0 = mclForIntEnd(mclVa(ip, "ip"));
                    if (v_0 > e_0) {
                        mlfAssign(&i, _mxarray12_);
                    } else {
                        for (; ; ) {
                            mlfAssign(
                              &expon,
                              mclMinus(
                                mclPlus(
                                  mclVv(expon, "expon"),
                                  mlfReal(
                                    mlfGenhyper_factor(
                                      mclMinus(
                                        mclPlus(
                                          mclIntArrayRef1(mclVa(a, "a"), v_0),
                                          mclVv(xl, "xl")),
                                        mclVg(&one, "one"))))),
                                mlfReal(
                                  mlfGenhyper_factor(
                                    mclMinus(
                                      mclIntArrayRef1(mclVa(a, "a"), v_0),
                                      mclVg(&one, "one"))))));
                            if (v_0 == e_0) {
                                break;
                            }
                            ++v_0;
                        }
                        mlfAssign(&i, mlfScalar(v_0));
                    }
                }
                {
                    int v_1 = mclForIntStart(1);
                    int e_1 = mclForIntEnd(mclVa(iq, "iq"));
                    if (v_1 > e_1) {
                        mlfAssign(&i, _mxarray12_);
                    } else {
                        for (; ; ) {
                            mlfAssign(
                              &expon,
                              mclPlus(
                                mclMinus(
                                  mclVv(expon, "expon"),
                                  mlfReal(
                                    mlfGenhyper_factor(
                                      mclMinus(
                                        mclPlus(
                                          mclIntArrayRef1(mclVa(b, "b"), v_1),
                                          mclVv(xl, "xl")),
                                        mclVg(&one, "one"))))),
                                mlfReal(
                                  mlfGenhyper_factor(
                                    mclMinus(
                                      mclIntArrayRef1(mclVa(b, "b"), v_1),
                                      mclVg(&one, "one"))))));
                            if (v_1 == e_1) {
                                break;
                            }
                            ++v_1;
                        }
                        mlfAssign(&i, mlfScalar(v_1));
                    }
                }
                mlfAssign(
                  &expon,
                  mclMinus(
                    mclPlus(
                      mclVv(expon, "expon"),
                      mclTimes(
                        mclVv(xl, "xl"), mlfReal(mlfLog(mclVa(z, "z"))))),
                    mlfReal(
                      mlfGenhyper_factor(
                        mlfComplex(mclVv(xl, "xl"), mclVg(&zero, "zero"))))));
                mlfAssign(
                  &xmax,
                  mclTimes(
                    mlfLog10(mlfExp(mclVg(&one, "one"))),
                    mclVv(expon, "expon")));
                {
                    mxArray * a_
                      = mclInitialize(
                          mclLt(mclVv(xmax, "xmax"), mclVv(xterm, "xterm")));
                    if (mlfTobool(a_)
                        && mlfTobool(mclAnd(a_, mclBoolToArray(v_ > 2)))) {
                        mxDestroyArray(a_);
                        mlfAssign(&ipremax, mlfScalar(v_));
                        goto return_;
                    } else {
                        mxDestroyArray(a_);
                    }
                }
                mlfAssign(
                  &xterm,
                  mlfMax(
                    NULL,
                    mlfHorzcat(
                      mclVv(xmax, "xmax"), mclVv(xterm, "xterm"), NULL),
                    NULL,
                    NULL));
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&j, mlfScalar(v_));
        }
    }
    /*
     * ' error in ipremax--did not find maximum exponent',
     */
    mclPrintAns(&ans, _mxarray26_);
    /*
     * error('stop encountered in original fortran code');
     */
    mlfError(_mxarray9_, NULL);
    /*
     * 
     * 
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                   FUNCTION FACTOR                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : This function is the log of the factorial.    *
     * %     *                                                              *
     * %     *  Subprograms called: none.                                   *
     * %     *                                                              *
     * %     ****************************************************************
     * %
     */
    return_:
    mclValidateOutput(ipremax, 1, nargout_, "ipremax", "genhyper/ipremax");
    mxDestroyArray(ans);
    mxDestroyArray(expon);
    mxDestroyArray(xl);
    mxDestroyArray(xmax);
    mxDestroyArray(xterm);
    mxDestroyArray(i);
    mxDestroyArray(j);
    mxDestroyArray(z);
    mxDestroyArray(iq);
    mxDestroyArray(ip);
    mxDestroyArray(b);
    mxDestroyArray(a);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return ipremax;
}

/*
 * The function "Mgenhyper_factor" is the implementation version of the
 * "genhyper/factor" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1735-1766). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [factor]=factor(z);
 */
static mxArray * Mgenhyper_factor(int nargout_, mxArray * z) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * factor = NULL;
    mxArray * pi = NULL;
    mxArray * ans = NULL;
    mclCopyArray(&z);
    /*
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * %
     * %
     * %
     * pi=0;
     */
    mlfAssign(&pi, _mxarray1_);
    /*
     * %
     * if (((real(z)==one) & (imag(z)==zero)) | (abs(z)==zero)) ;
     */
    {
        mxArray * a_
          = mclInitialize(mclEq(mlfReal(mclVa(z, "z")), mclVg(&one, "one")));
        if (mlfTobool(a_)) {
            mlfAssign(
              &a_,
              mclAnd(a_, mclEq(mlfImag(mclVa(z, "z")), mclVg(&zero, "zero"))));
        } else {
            mlfAssign(&a_, mlfScalar(0));
        }
        if (mlfTobool(a_)
            || mlfTobool(
                 mclOr(
                   a_, mclEq(mlfAbs(mclVa(z, "z")), mclVg(&zero, "zero"))))) {
            mxDestroyArray(a_);
            /*
             * factor=complex(zero,zero);
             */
            mlfAssign(
              &factor, mlfComplex(mclVg(&zero, "zero"), mclVg(&zero, "zero")));
            /*
             * return;
             */
            goto return_;
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end;
     */
    }
    /*
     * pi=two.*two.*atan(one);
     */
    mlfAssign(
      &pi,
      mclTimes(
        mclTimes(mclVg(&two, "two"), mclVg(&two, "two")),
        mlfAtan(mclVg(&one, "one"))));
    /*
     * factor=half.*log(two.*pi)+(z+half).*log(z)-z+(one./(12.0d0.*z)).*(one-(one./(30.d0.*z.*z)).*(one-(two./(7.0d0.*z.*z))));
     */
    mlfAssign(
      &factor,
      mclPlus(
        mclMinus(
          mclPlus(
            mclTimes(
              mclVg(&half, "half"),
              mlfLog(mclTimes(mclVg(&two, "two"), mclVv(pi, "pi")))),
            mclTimes(
              mclPlus(mclVa(z, "z"), mclVg(&half, "half")),
              mlfLog(mclVa(z, "z")))),
          mclVa(z, "z")),
        mclTimes(
          mclRdivide(mclVg(&one, "one"), mclTimes(_mxarray28_, mclVa(z, "z"))),
          mclMinus(
            mclVg(&one, "one"),
            mclTimes(
              mclRdivide(
                mclVg(&one, "one"),
                mclTimes(mclTimes(_mxarray29_, mclVa(z, "z")), mclVa(z, "z"))),
              mclMinus(
                mclVg(&one, "one"),
                mclRdivide(
                  mclVg(&two, "two"),
                  mclTimes(
                    mclTimes(_mxarray30_, mclVa(z, "z")), mclVa(z, "z")))))))));
    /*
     * 
     * 
     * %     ****************************************************************
     * %     *                                                              *
     * %     *                   FUNCTION CGAMMA                            *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Description : Calculates the complex gamma function.  Based *
     * %     *     on a program written by F.A. Parpia published in Computer*
     * %     *     Physics Communications as the `GRASP2' program (public   *
     * %     *     domain).                                                 *
     * %     *                                                              *
     * %     *                                                              *
     * %     *  Subprograms called: none.                                   *
     * %     *                                                              *
     * %     ****************************************************************
     */
    return_:
    mclValidateOutput(factor, 1, nargout_, "factor", "genhyper/factor");
    mxDestroyArray(ans);
    mxDestroyArray(pi);
    mxDestroyArray(z);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return factor;
}

/*
 * The function "Mgenhyper_cgamma" is the implementation version of the
 * "genhyper/cgamma" M-function from file "c:\projects\mzdde\genhyper.m" (lines
 * 1766-2019). It contains the actual compiled code for that M-function. It is
 * a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [cgamma]=cgamma(arg,lnpfq);
 */
static mxArray * Mgenhyper_cgamma(int nargout_,
                                  mxArray * arg,
                                  mxArray * lnpfq) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_genhyper);
    mxArray * cgamma = NULL;
    mxArray * itnmax = NULL;
    mxArray * i = NULL;
    mxArray * negarg = NULL;
    mxArray * first = NULL;
    mxArray * zfacr = NULL;
    mxArray * zfaci = NULL;
    mxArray * twoi = NULL;
    mxArray * termr = NULL;
    mxArray * termi = NULL;
    mxArray * tenth = NULL;
    mxArray * tenmax = NULL;
    mxArray * resr = NULL;
    mxArray * resi = NULL;
    mxArray * precis = NULL;
    mxArray * pi = NULL;
    mxArray * ovlfr = NULL;
    mxArray * ovlfi = NULL;
    mxArray * ovlfac = NULL;
    mxArray * obasqr = NULL;
    mxArray * obasqi = NULL;
    mxArray * obasq = NULL;
    mxArray * hlntpi = NULL;
    mxArray * fn = NULL;
    mxArray * fd = NULL;
    mxArray * facneg = NULL;
    mxArray * fac = NULL;
    mxArray * expmax = NULL;
    mxArray * dnum = NULL;
    mxArray * diff = NULL;
    mxArray * clngr = NULL;
    mxArray * clngi = NULL;
    mxArray * argur2 = NULL;
    mxArray * argur = NULL;
    mxArray * argum = NULL;
    mxArray * argui2 = NULL;
    mxArray * argui = NULL;
    mxArray * argr = NULL;
    mxArray * argi = NULL;
    mxArray * ans = NULL;
    mclCopyArray(&arg);
    mclCopyArray(&lnpfq);
    /*
     * %
     * %
     * %
     * %
     * %
     * global  zero   half   one   two   ten   eps;
     * global  nout;
     * %
     * %
     * %
     * argi=0;argr=0;argui=0;argui2=0;argum=0;argur=0;argur2=0;clngi=0;clngr=0;diff=0;dnum=0;expmax=0;fac=0;facneg=0;fd=zeros(7,1);fn=zeros(7,1);hlntpi=0;obasq=0;obasqi=0;obasqr=0;ovlfac=0;ovlfi=0;ovlfr=0;pi=0;precis=0;resi=0;resr=0;tenmax=0;tenth=0;termi=0;termr=0;twoi=0;zfaci=0;zfacr=0;
     */
    mlfAssign(&argi, _mxarray1_);
    mlfAssign(&argr, _mxarray1_);
    mlfAssign(&argui, _mxarray1_);
    mlfAssign(&argui2, _mxarray1_);
    mlfAssign(&argum, _mxarray1_);
    mlfAssign(&argur, _mxarray1_);
    mlfAssign(&argur2, _mxarray1_);
    mlfAssign(&clngi, _mxarray1_);
    mlfAssign(&clngr, _mxarray1_);
    mlfAssign(&diff, _mxarray1_);
    mlfAssign(&dnum, _mxarray1_);
    mlfAssign(&expmax, _mxarray1_);
    mlfAssign(&fac, _mxarray1_);
    mlfAssign(&facneg, _mxarray1_);
    mlfAssign(&fd, mlfZeros(_mxarray30_, _mxarray3_, NULL));
    mlfAssign(&fn, mlfZeros(_mxarray30_, _mxarray3_, NULL));
    mlfAssign(&hlntpi, _mxarray1_);
    mlfAssign(&obasq, _mxarray1_);
    mlfAssign(&obasqi, _mxarray1_);
    mlfAssign(&obasqr, _mxarray1_);
    mlfAssign(&ovlfac, _mxarray1_);
    mlfAssign(&ovlfi, _mxarray1_);
    mlfAssign(&ovlfr, _mxarray1_);
    mlfAssign(&pi, _mxarray1_);
    mlfAssign(&precis, _mxarray1_);
    mlfAssign(&resi, _mxarray1_);
    mlfAssign(&resr, _mxarray1_);
    mlfAssign(&tenmax, _mxarray1_);
    mlfAssign(&tenth, _mxarray1_);
    mlfAssign(&termi, _mxarray1_);
    mlfAssign(&termr, _mxarray1_);
    mlfAssign(&twoi, _mxarray1_);
    mlfAssign(&zfaci, _mxarray1_);
    mlfAssign(&zfacr, _mxarray1_);
    /*
     * %
     * first=0;negarg=0;cgamma=0;
     */
    mlfAssign(&first, _mxarray1_);
    mlfAssign(&negarg, _mxarray1_);
    mlfAssign(&cgamma, _mxarray1_);
    /*
     * i=0;itnmax=0;
     */
    mlfAssign(&i, _mxarray1_);
    mlfAssign(&itnmax, _mxarray1_);
    /*
     * %
     * %
     * %
     * %----------------------------------------------------------------------*
     * %     *
     * %     THESE ARE THE BERNOULLI NUMBERS B02, B04, ..., B14, EXPRESSED AS *
     * %     RATIONAL NUMBERS. FROM ABRAMOWITZ AND STEGUN, P. 810.            *
     * %     *
     * fn=[1.0d00,-1.0d00,1.0d00,-1.0d00,5.0d00,-691.0d00,7.0d00];
     */
    mlfAssign(&fn, _mxarray31_);
    /*
     * fd=[6.0d00,30.0d00,42.0d00,30.0d00,66.0d00,2730.0d00,6.0d00];
     */
    mlfAssign(&fd, _mxarray33_);
    /*
     * %
     * %----------------------------------------------------------------------*
     * %
     * hlntpi=[1.0d00];
     */
    mlfAssign(&hlntpi, _mxarray3_);
    /*
     * %
     * first=[true];
     */
    mlfAssign(&first, mlfTrue(NULL));
    /*
     * %
     * tenth=[0.1d00];
     */
    mlfAssign(&tenth, _mxarray23_);
    /*
     * %
     * argr=real(arg);
     */
    mlfAssign(&argr, mlfReal(mclVa(arg, "arg")));
    /*
     * argi=imag(arg);
     */
    mlfAssign(&argi, mlfImag(mclVa(arg, "arg")));
    /*
     * %
     * %     ON THE FIRST ENTRY TO THIS ROUTINE, SET UP THE CONSTANTS REQUIRED
     * %     FOR THE REFLECTION FORMULA (CF. ABRAMOWITZ AND STEGUN 6.1.17) AND
     * %     STIRLING'S APPROXIMATION (CF. ABRAMOWITZ AND STEGUN 6.1.40).
     * %
     * if (first) ;
     */
    if (mlfTobool(mclVv(first, "first"))) {
        /*
         * pi=4.0d0.*atan(one);
         */
        mlfAssign(&pi, mclTimes(_mxarray14_, mlfAtan(mclVg(&one, "one"))));
        /*
         * %
         * %      SET THE MACHINE-DEPENDENT PARAMETERS:
         * %
         * %
         * %      TENMAX - MAXIMUM SIZE OF EXPONENT OF 10
         * %
         * %
         * itnmax=1;
         */
        mlfAssign(&itnmax, _mxarray3_);
        /*
         * dnum=tenth;
         */
        mlfAssign(&dnum, mclVv(tenth, "tenth"));
        /*
         * itnmax=itnmax+1;
         */
        mlfAssign(&itnmax, mclPlus(mclVv(itnmax, "itnmax"), _mxarray3_));
        /*
         * dnum=dnum.*tenth;
         */
        mlfAssign(&dnum, mclTimes(mclVv(dnum, "dnum"), mclVv(tenth, "tenth")));
        /*
         * while (dnum>0.0);
         */
        while (mclGtBool(mclVv(dnum, "dnum"), _mxarray1_)) {
            /*
             * itnmax=itnmax+1;
             */
            mlfAssign(&itnmax, mclPlus(mclVv(itnmax, "itnmax"), _mxarray3_));
            /*
             * dnum=dnum.*tenth;
             */
            mlfAssign(
              &dnum, mclTimes(mclVv(dnum, "dnum"), mclVv(tenth, "tenth")));
        /*
         * end;
         */
        }
        /*
         * itnmax=itnmax-1;
         */
        mlfAssign(&itnmax, mclMinus(mclVv(itnmax, "itnmax"), _mxarray3_));
        /*
         * tenmax=real(itnmax);
         */
        mlfAssign(&tenmax, mlfReal(mclVv(itnmax, "itnmax")));
        /*
         * %
         * %      EXPMAX - MAXIMUM SIZE OF EXPONENT OF E
         * %
         * %
         * dnum=tenth.^itnmax;
         */
        mlfAssign(
          &dnum, mlfPower(mclVv(tenth, "tenth"), mclVv(itnmax, "itnmax")));
        /*
         * expmax=-log(dnum);
         */
        mlfAssign(&expmax, mclUminus(mlfLog(mclVv(dnum, "dnum"))));
        /*
         * %
         * %      PRECIS - MACHINE PRECISION
         * %
         * %
         * precis=one;
         */
        mlfAssign(&precis, mclVg(&one, "one"));
        /*
         * precis=precis./two;
         */
        mlfAssign(
          &precis, mclRdivide(mclVv(precis, "precis"), mclVg(&two, "two")));
        /*
         * dnum=precis+one;
         */
        mlfAssign(&dnum, mclPlus(mclVv(precis, "precis"), mclVg(&one, "one")));
        /*
         * while (dnum>one);
         */
        while (mclGtBool(mclVv(dnum, "dnum"), mclVg(&one, "one"))) {
            /*
             * precis=precis./two;
             */
            mlfAssign(
              &precis, mclRdivide(mclVv(precis, "precis"), mclVg(&two, "two")));
            /*
             * dnum=precis+one;
             */
            mlfAssign(
              &dnum, mclPlus(mclVv(precis, "precis"), mclVg(&one, "one")));
        /*
         * end;
         */
        }
        /*
         * precis=two.*precis;
         */
        mlfAssign(
          &precis, mclTimes(mclVg(&two, "two"), mclVv(precis, "precis")));
        /*
         * %
         * hlntpi=half.*log(two.*pi);
         */
        mlfAssign(
          &hlntpi,
          mclTimes(
            mclVg(&half, "half"),
            mlfLog(mclTimes(mclVg(&two, "two"), mclVv(pi, "pi")))));
        /*
         * %
         * for i=1 : 7;
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = 7;
            if (v_ > e_) {
                mlfAssign(&i, _mxarray12_);
            } else {
                /*
                 * fn(i)=fn(i)./fd(i);
                 * twoi=two.*real(i);
                 * fn(i)=fn(i)./(twoi.*(twoi-one));
                 * end;
                 */
                for (; ; ) {
                    mclIntArrayAssign1(
                      &fn,
                      mclRdivide(
                        mclIntArrayRef1(mclVv(fn, "fn"), v_),
                        mclIntArrayRef1(mclVv(fd, "fd"), v_)),
                      v_);
                    mlfAssign(
                      &twoi,
                      mclTimes(
                        mclVg(&two, "two"),
                        mlfScalar(svDoubleScalarReal((double) v_))));
                    mclIntArrayAssign1(
                      &fn,
                      mclRdivide(
                        mclIntArrayRef1(mclVv(fn, "fn"), v_),
                        mclTimes(
                          mclVv(twoi, "twoi"),
                          mclMinus(mclVv(twoi, "twoi"), mclVg(&one, "one")))),
                      v_);
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i, mlfScalar(v_));
            }
        }
        /*
         * %
         * first=false;
         */
        mlfAssign(&first, mlfFalse(NULL));
    /*
     * %
     * end;
     */
    }
    /*
     * %
     * %     CASES WHERE THE ARGUMENT IS REAL
     * %
     * if (argi==0.0) ;
     */
    if (mclEqBool(mclVv(argi, "argi"), _mxarray1_)) {
        /*
         * %
         * %      CASES WHERE THE ARGUMENT IS REAL AND NEGATIVE
         * %
         * %
         * if (argr<=0.0) ;
         */
        if (mclLeBool(mclVv(argr, "argr"), _mxarray1_)) {
            /*
             * %
             * %       STOP WITH AN ERROR MESSAGE IF THE ARGUMENT IS TOO NEAR A POLE
             * %
             * %
             * diff=abs(real(round(argr))-argr);
             */
            mlfAssign(
              &diff,
              mlfAbs(
                mclMinus(
                  mlfReal(mlfRound(mclVv(argr, "argr"))),
                  mclVv(argr, "argr"))));
            /*
             * if (diff<=two.*precis) ;
             */
            if (mclLeBool(
                  mclVv(diff, "diff"),
                  mclTimes(mclVg(&two, "two"), mclVv(precis, "precis")))) {
                /*
                 * ,
                 * argr , argi,
                 */
                mclPrintArray(mclVv(argr, "argr"), "argr");
                mclPrintArray(mclVv(argi, "argi"), "argi");
                /*
                 * %format (' argument (',1p,1d14.7,',',1d14.7,') too close to a',' pole.');
                 * error('stop encountered in original fortran code');
                 */
                mlfError(_mxarray9_, NULL);
            /*
             * else;
             */
            } else {
                /*
                 * %
                 * %        OTHERWISE USE THE REFLECTION FORMULA (ABRAMOWITZ AND STEGUN 6.1
                 * %        .17)
                 * %        TO ENSURE THAT THE ARGUMENT IS SUITABLE FOR STIRLING'S
                 * %
                 * %        FORMULA
                 * %
                 * %
                 * argum=pi./(-argr.*sin(pi.*argr));
                 */
                mlfAssign(
                  &argum,
                  mclRdivide(
                    mclVv(pi, "pi"),
                    mclTimes(
                      mclUminus(mclVv(argr, "argr")),
                      mlfSin(mclTimes(mclVv(pi, "pi"), mclVv(argr, "argr"))))));
                /*
                 * if (argum<0.0) ;
                 */
                if (mclLtBool(mclVv(argum, "argum"), _mxarray1_)) {
                    /*
                     * argum=-argum;
                     */
                    mlfAssign(&argum, mclUminus(mclVv(argum, "argum")));
                    /*
                     * clngi=pi;
                     */
                    mlfAssign(&clngi, mclVv(pi, "pi"));
                /*
                 * else;
                 */
                } else {
                    /*
                     * clngi=0.0;
                     */
                    mlfAssign(&clngi, _mxarray1_);
                /*
                 * end;
                 */
                }
                /*
                 * facneg=log(argum);
                 */
                mlfAssign(&facneg, mlfLog(mclVv(argum, "argum")));
                /*
                 * argur=-argr;
                 */
                mlfAssign(&argur, mclUminus(mclVv(argr, "argr")));
                /*
                 * negarg=true;
                 */
                mlfAssign(&negarg, mlfTrue(NULL));
            /*
             * %
             * end;
             */
            }
        /*
         * %
         * %       CASES WHERE THE ARGUMENT IS REAL AND POSITIVE
         * %
         * %
         * else;
         */
        } else {
            /*
             * %
             * clngi=0.0;
             */
            mlfAssign(&clngi, _mxarray1_);
            /*
             * argur=argr;
             */
            mlfAssign(&argur, mclVv(argr, "argr"));
            /*
             * negarg=false;
             */
            mlfAssign(&negarg, mlfFalse(NULL));
        /*
         * %
         * end;
         */
        }
        /*
         * %
         * %      USE ABRAMOWITZ AND STEGUN FORMULA 6.1.15 TO ENSURE THAT
         * %
         * %      THE ARGUMENT IN STIRLING'S FORMULA IS GREATER THAN 10
         * %
         * %
         * ovlfac=one;
         */
        mlfAssign(&ovlfac, mclVg(&one, "one"));
        /*
         * while (argur<ten);
         */
        while (mclLtBool(mclVv(argur, "argur"), mclVg(&ten, "ten"))) {
            /*
             * ovlfac=ovlfac.*argur;
             */
            mlfAssign(
              &ovlfac,
              mclTimes(mclVv(ovlfac, "ovlfac"), mclVv(argur, "argur")));
            /*
             * argur=argur+one;
             */
            mlfAssign(
              &argur, mclPlus(mclVv(argur, "argur"), mclVg(&one, "one")));
        /*
         * end;
         */
        }
        /*
         * %
         * %      NOW USE STIRLING'S FORMULA TO COMPUTE LOG (GAMMA (ARGUM))
         * %
         * %
         * clngr=(argur-half).*log(argur)-argur+hlntpi;
         */
        mlfAssign(
          &clngr,
          mclPlus(
            mclMinus(
              mclTimes(
                mclMinus(mclVv(argur, "argur"), mclVg(&half, "half")),
                mlfLog(mclVv(argur, "argur"))),
              mclVv(argur, "argur")),
            mclVv(hlntpi, "hlntpi")));
        /*
         * fac=argur;
         */
        mlfAssign(&fac, mclVv(argur, "argur"));
        /*
         * obasq=one./(argur.*argur);
         */
        mlfAssign(
          &obasq,
          mclRdivide(
            mclVg(&one, "one"),
            mclTimes(mclVv(argur, "argur"), mclVv(argur, "argur"))));
        /*
         * for i=1 : 7;
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = 7;
            if (v_ > e_) {
                mlfAssign(&i, _mxarray12_);
            } else {
                /*
                 * fac=fac.*obasq;
                 * clngr=clngr+fn(i).*fac;
                 * end;
                 */
                for (; ; ) {
                    mlfAssign(
                      &fac, mclTimes(mclVv(fac, "fac"), mclVv(obasq, "obasq")));
                    mlfAssign(
                      &clngr,
                      mclPlus(
                        mclVv(clngr, "clngr"),
                        mclTimes(
                          mclIntArrayRef1(mclVv(fn, "fn"), v_),
                          mclVv(fac, "fac"))));
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i, mlfScalar(v_));
            }
        }
        /*
         * %
         * %      INCLUDE THE CONTRIBUTIONS FROM THE RECURRENCE AND REFLECTION
         * %
         * %      FORMULAE
         * %
         * %
         * clngr=clngr-log(ovlfac);
         */
        mlfAssign(
          &clngr,
          mclMinus(mclVv(clngr, "clngr"), mlfLog(mclVv(ovlfac, "ovlfac"))));
        /*
         * if (negarg) ;
         */
        if (mlfTobool(mclVv(negarg, "negarg"))) {
            /*
             * clngr=facneg-clngr;
             */
            mlfAssign(
              &clngr, mclMinus(mclVv(facneg, "facneg"), mclVv(clngr, "clngr")));
        /*
         * end;
         */
        }
    /*
     * %
     * else;
     */
    } else {
        /*
         * %
         * %      CASES WHERE THE ARGUMENT IS COMPLEX
         * %
         * %
         * argur=argr;
         */
        mlfAssign(&argur, mclVv(argr, "argr"));
        /*
         * argui=argi;
         */
        mlfAssign(&argui, mclVv(argi, "argi"));
        /*
         * argui2=argui.*argui;
         */
        mlfAssign(
          &argui2, mclTimes(mclVv(argui, "argui"), mclVv(argui, "argui")));
        /*
         * %
         * %      USE THE RECURRENCE FORMULA (ABRAMOWITZ AND STEGUN 6.1.15)
         * %
         * %      TO ENSURE THAT THE MAGNITUDE OF THE ARGUMENT IN STIRLING'S
         * %
         * %      FORMULA IS GREATER THAN 10
         * %
         * %
         * ovlfr=one;
         */
        mlfAssign(&ovlfr, mclVg(&one, "one"));
        /*
         * ovlfi=0.0;
         */
        mlfAssign(&ovlfi, _mxarray1_);
        /*
         * argum=sqrt(argur.*argur+argui2);
         */
        mlfAssign(
          &argum,
          mlfSqrt(
            mclPlus(
              mclTimes(mclVv(argur, "argur"), mclVv(argur, "argur")),
              mclVv(argui2, "argui2"))));
        /*
         * while (argum<ten);
         */
        while (mclLtBool(mclVv(argum, "argum"), mclVg(&ten, "ten"))) {
            /*
             * termr=ovlfr.*argur-ovlfi.*argui;
             */
            mlfAssign(
              &termr,
              mclMinus(
                mclTimes(mclVv(ovlfr, "ovlfr"), mclVv(argur, "argur")),
                mclTimes(mclVv(ovlfi, "ovlfi"), mclVv(argui, "argui"))));
            /*
             * termi=ovlfr.*argui+ovlfi.*argur;
             */
            mlfAssign(
              &termi,
              mclPlus(
                mclTimes(mclVv(ovlfr, "ovlfr"), mclVv(argui, "argui")),
                mclTimes(mclVv(ovlfi, "ovlfi"), mclVv(argur, "argur"))));
            /*
             * ovlfr=termr;
             */
            mlfAssign(&ovlfr, mclVv(termr, "termr"));
            /*
             * ovlfi=termi;
             */
            mlfAssign(&ovlfi, mclVv(termi, "termi"));
            /*
             * argur=argur+one;
             */
            mlfAssign(
              &argur, mclPlus(mclVv(argur, "argur"), mclVg(&one, "one")));
            /*
             * argum=sqrt(argur.*argur+argui2);
             */
            mlfAssign(
              &argum,
              mlfSqrt(
                mclPlus(
                  mclTimes(mclVv(argur, "argur"), mclVv(argur, "argur")),
                  mclVv(argui2, "argui2"))));
        /*
         * end;
         */
        }
        /*
         * %
         * %      NOW USE STIRLING'S FORMULA TO COMPUTE LOG (GAMMA (ARGUM))
         * %
         * %
         * argur2=argur.*argur;
         */
        mlfAssign(
          &argur2, mclTimes(mclVv(argur, "argur"), mclVv(argur, "argur")));
        /*
         * termr=half.*log(argur2+argui2);
         */
        mlfAssign(
          &termr,
          mclTimes(
            mclVg(&half, "half"),
            mlfLog(mclPlus(mclVv(argur2, "argur2"), mclVv(argui2, "argui2")))));
        /*
         * termi=atan2(argui,argur);
         */
        mlfAssign(
          &termi, mlfAtan2(mclVv(argui, "argui"), mclVv(argur, "argur")));
        /*
         * clngr=(argur-half).*termr-argui.*termi-argur+hlntpi;
         */
        mlfAssign(
          &clngr,
          mclPlus(
            mclMinus(
              mclMinus(
                mclTimes(
                  mclMinus(mclVv(argur, "argur"), mclVg(&half, "half")),
                  mclVv(termr, "termr")),
                mclTimes(mclVv(argui, "argui"), mclVv(termi, "termi"))),
              mclVv(argur, "argur")),
            mclVv(hlntpi, "hlntpi")));
        /*
         * clngi=(argur-half).*termi+argui.*termr-argui;
         */
        mlfAssign(
          &clngi,
          mclMinus(
            mclPlus(
              mclTimes(
                mclMinus(mclVv(argur, "argur"), mclVg(&half, "half")),
                mclVv(termi, "termi")),
              mclTimes(mclVv(argui, "argui"), mclVv(termr, "termr"))),
            mclVv(argui, "argui")));
        /*
         * fac=(argur2+argui2).^(-2);
         */
        mlfAssign(
          &fac,
          mlfPower(
            mclPlus(mclVv(argur2, "argur2"), mclVv(argui2, "argui2")),
            _mxarray35_));
        /*
         * obasqr=(argur2-argui2).*fac;
         */
        mlfAssign(
          &obasqr,
          mclTimes(
            mclMinus(mclVv(argur2, "argur2"), mclVv(argui2, "argui2")),
            mclVv(fac, "fac")));
        /*
         * obasqi=-two.*argur.*argui.*fac;
         */
        mlfAssign(
          &obasqi,
          mclTimes(
            mclTimes(
              mclTimes(mclUminus(mclVg(&two, "two")), mclVv(argur, "argur")),
              mclVv(argui, "argui")),
            mclVv(fac, "fac")));
        /*
         * zfacr=argur;
         */
        mlfAssign(&zfacr, mclVv(argur, "argur"));
        /*
         * zfaci=argui;
         */
        mlfAssign(&zfaci, mclVv(argui, "argui"));
        /*
         * for i=1 : 7;
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = 7;
            if (v_ > e_) {
                mlfAssign(&i, _mxarray12_);
            } else {
                /*
                 * termr=zfacr.*obasqr-zfaci.*obasqi;
                 * termi=zfacr.*obasqi+zfaci.*obasqr;
                 * fac=fn(i);
                 * clngr=clngr+termr.*fac;
                 * clngi=clngi+termi.*fac;
                 * zfacr=termr;
                 * zfaci=termi;
                 * end;
                 */
                for (; ; ) {
                    mlfAssign(
                      &termr,
                      mclMinus(
                        mclTimes(
                          mclVv(zfacr, "zfacr"), mclVv(obasqr, "obasqr")),
                        mclTimes(
                          mclVv(zfaci, "zfaci"), mclVv(obasqi, "obasqi"))));
                    mlfAssign(
                      &termi,
                      mclPlus(
                        mclTimes(
                          mclVv(zfacr, "zfacr"), mclVv(obasqi, "obasqi")),
                        mclTimes(
                          mclVv(zfaci, "zfaci"), mclVv(obasqr, "obasqr"))));
                    mlfAssign(&fac, mclIntArrayRef1(mclVv(fn, "fn"), v_));
                    mlfAssign(
                      &clngr,
                      mclPlus(
                        mclVv(clngr, "clngr"),
                        mclTimes(mclVv(termr, "termr"), mclVv(fac, "fac"))));
                    mlfAssign(
                      &clngi,
                      mclPlus(
                        mclVv(clngi, "clngi"),
                        mclTimes(mclVv(termi, "termi"), mclVv(fac, "fac"))));
                    mlfAssign(&zfacr, mclVv(termr, "termr"));
                    mlfAssign(&zfaci, mclVv(termi, "termi"));
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&i, mlfScalar(v_));
            }
        }
        /*
         * %
         * %      ADD IN THE RELEVANT PIECES FROM THE RECURRENCE FORMULA
         * %
         * %
         * clngr=clngr-half.*log(ovlfr.*ovlfr+ovlfi.*ovlfi);
         */
        mlfAssign(
          &clngr,
          mclMinus(
            mclVv(clngr, "clngr"),
            mclTimes(
              mclVg(&half, "half"),
              mlfLog(
                mclPlus(
                  mclTimes(mclVv(ovlfr, "ovlfr"), mclVv(ovlfr, "ovlfr")),
                  mclTimes(mclVv(ovlfi, "ovlfi"), mclVv(ovlfi, "ovlfi")))))));
        /*
         * clngi=clngi-atan2(ovlfi,ovlfr);
         */
        mlfAssign(
          &clngi,
          mclMinus(
            mclVv(clngi, "clngi"),
            mlfAtan2(mclVv(ovlfi, "ovlfi"), mclVv(ovlfr, "ovlfr"))));
    /*
     * %
     * end;
     */
    }
    /*
     * if (lnpfq==1) ;
     */
    if (mclEqBool(mclVa(lnpfq, "lnpfq"), _mxarray3_)) {
        /*
         * cgamma=complex(clngr,clngi);
         */
        mlfAssign(
          &cgamma, mlfComplex(mclVv(clngr, "clngr"), mclVv(clngi, "clngi")));
        /*
         * return;
         */
        goto return_;
    /*
     * end;
     */
    }
    /*
     * %
     * %     NOW EXPONENTIATE THE COMPLEX LOG GAMMA FUNCTION TO GET
     * %     THE COMPLEX GAMMA FUNCTION
     * %
     * if ((clngr<=expmax) & (clngr>=-expmax)) ;
     */
    {
        mxArray * a_
          = mclInitialize(
              mclLe(mclVv(clngr, "clngr"), mclVv(expmax, "expmax")));
        if (mlfTobool(a_)
            && mlfTobool(
                 mclAnd(
                   a_,
                   mclGe(
                     mclVv(clngr, "clngr"),
                     mclUminus(mclVv(expmax, "expmax")))))) {
            mxDestroyArray(a_);
            /*
             * fac=exp(clngr);
             */
            mlfAssign(&fac, mlfExp(mclVv(clngr, "clngr")));
        /*
         * else;
         */
        } else {
            mxDestroyArray(a_);
            /*
             * ,
             * clngr,
             */
            mclPrintArray(mclVv(clngr, "clngr"), "clngr");
            /*
             * %format (' argument to exponential function (',1p,1d14.7,') out of range.');
             * error('stop encountered in original fortran code');
             */
            mlfError(_mxarray9_, NULL);
        }
    /*
     * end;
     */
    }
    /*
     * resr=fac.*cos(clngi);
     */
    mlfAssign(
      &resr, mclTimes(mclVv(fac, "fac"), mlfCos(mclVv(clngi, "clngi"))));
    /*
     * resi=fac.*sin(clngi);
     */
    mlfAssign(
      &resi, mclTimes(mclVv(fac, "fac"), mlfSin(mclVv(clngi, "clngi"))));
    /*
     * cgamma=complex(resr,resi);
     */
    mlfAssign(&cgamma, mlfComplex(mclVv(resr, "resr"), mclVv(resi, "resi")));
    /*
     * %
     * return;
     */
    return_:
    mclValidateOutput(cgamma, 1, nargout_, "cgamma", "genhyper/cgamma");
    mxDestroyArray(ans);
    mxDestroyArray(argi);
    mxDestroyArray(argr);
    mxDestroyArray(argui);
    mxDestroyArray(argui2);
    mxDestroyArray(argum);
    mxDestroyArray(argur);
    mxDestroyArray(argur2);
    mxDestroyArray(clngi);
    mxDestroyArray(clngr);
    mxDestroyArray(diff);
    mxDestroyArray(dnum);
    mxDestroyArray(expmax);
    mxDestroyArray(fac);
    mxDestroyArray(facneg);
    mxDestroyArray(fd);
    mxDestroyArray(fn);
    mxDestroyArray(hlntpi);
    mxDestroyArray(obasq);
    mxDestroyArray(obasqi);
    mxDestroyArray(obasqr);
    mxDestroyArray(ovlfac);
    mxDestroyArray(ovlfi);
    mxDestroyArray(ovlfr);
    mxDestroyArray(pi);
    mxDestroyArray(precis);
    mxDestroyArray(resi);
    mxDestroyArray(resr);
    mxDestroyArray(tenmax);
    mxDestroyArray(tenth);
    mxDestroyArray(termi);
    mxDestroyArray(termr);
    mxDestroyArray(twoi);
    mxDestroyArray(zfaci);
    mxDestroyArray(zfacr);
    mxDestroyArray(first);
    mxDestroyArray(negarg);
    mxDestroyArray(i);
    mxDestroyArray(itnmax);
    mxDestroyArray(lnpfq);
    mxDestroyArray(arg);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return cgamma;
}
