function ZemaxOperands = ZemaxOperands()
% ZEMAXOperands - ZEMAX Operand and Type Key - ZEMAX Version 19 September 2002
%
% Usage : ZEMAXOperandList = ZEMAXOperands
% Returns a column vector of operand names.
% This key may be different for other versions of ZEMAX.
%
%   1= ABSO       66= FICL      131= MNCA      196= P1VA      261= REAZ
%   2= ACOS       67= FICP      132= MNCG      197= P2GT      262= RELI
%   3= AMAG       68= FOUC      133= MNCT      198= P2LT      263= RENA
%   4= ANAR       69= GBPD      134= MNCV      199= P2VA      264= RENB
%   5= ASIN       70= GBPR      135= MNDT      200= P3GT      265= RENC
%   6= ASTI       71= GBPS      136= MNEA      201= P3LT      266= RETX
%   7= ATAN       72= GBPW      137= MNEG      202= P3VA      267= RETY
%   8= AXCL       73= GBPP      138= MNET      203= P4GT      268= RGLA
%   9= BIOC       74= GBSD      139= MNIN      204= P4LT      269= RSCH
%  10= BIOD       75= GBSR      140= MNPD      205= P4VA      270= RSCE
%  11= BIPF       76= GBSS      141= MNSD      206= P5GT      271= RSRE
%  12= BLNK       77= GBSW      142= MSWA      207= P5LT      272= RSRH
%  13= BSER       78= GBSP      143= MSWS      208= P5VA      273= RWCH
%  14= CENX       79= GCOS      144= MSWT      209= P6GT      274= RWCE
%  15= CENY       80= GENC      145= MTFA      210= P6LT      275= RWRE
%  16= CMFV       81= GLCA      146= MTFS      211= P6VA      276= RWRH
%  17= CMGT       82= GLCB      147= MTFT      212= P7GT      277= SAGX
%  18= CMLT       83= GLCC      148= MXAB      213= P7LT      278= SAGY
%  19= CMVA       84= GLCX      149= MXCA      214= P7VA      279= SFNO
%  20= CODA       85= GLCY      150= MXCG      215= P8GT      280= SINE
%  21= COGT       86= GLCZ      151= MXCT      216= P8LT      281= SKIS
%  22= COLT       87= GMTA      152= MXCV      217= P8VA      282= SKIN
%  23= COMA       88= GMTS      153= MXDT      218= PANA      283= SPCH
%  24= CONF       89= GMTT      154= MXEA      219= PANB      284= SPHA
%  25= CONS       90= GOTO      155= MXEG      220= PANC      285= SQRT
%  26= COSI       91= GPIM      156= MXET      221= PARA      286= SSAG
%  27= COVA       92= GRMN      157= MXIN      222= PARB      287= SUMM
%  28= CTGT       93= GRMX      158= MXPD      223= PARC      288= SVIG
%  29= CTLT       94= GTCE      159= MXSD      224= PARR      289= TANG
%  30= CTVA       95= HACG      160= NPGT      225= PARX      290= TFNO
%  31= CVGT       96= HHCN      161= NPLT      226= PARY      291= TGTH
%  32= CVLT       97= I1GT      162= NPVA      227= PARZ      292= TMAS
%  33= CVOL       98= I2GT      163= NPXG      228= PATX      293= TOTR
%  34= CVVA       99= I3GT      164= NPXL      229= PATY      294= TRAC
%  35= DENC      100= I4GT      165= NPXV      230= PETC      295= TRAD
%  36= DENF      101= I5GT      166= NPYG      231= PETZ      296= TRAE
%  37= DIFF      102= I6GT      167= NPYL      232= PIMH      297= TRAI
%  38= DIMX      103= I1LT      168= NPYV      233= PLEN      298= TRAN
%  39= DISC      104= I2LT      169= NPZG      234= PMAG      299= TRAR
%  40= DISG      105= I3LT      170= NPZL      235= POWR      300= TRAX
%  41= DIST      106= I4LT      171= NPZV      236= PRIM      301= TRAY
%  42= DIVI      107= I5LT      172= NSDD      237= PROD      302= TRCX
%  43= DLTN      108= I6LT      173= NSTR      238= PMGT      303= TRCY
%  44= DMFS      109= I1VA      174= NTXG      239= PMLT      304= TTGT
%  45= DMGT      110= I2VA      175= NTXL      240= PMVA      305= TTHI
%  46= DMLT      111= I3VA      176= NTXV      241= POPD      306= TTLT
%  47= DMVA      112= I4VA      177= NTYG      242= QOAC      307= TTVA
%  48= DXDX      113= I5VA      178= NTYL      243= QSUM      308= UDOP
%  49= DXDY      114= I6VA      179= NTYV      244= RAGA      309= USYM
%  50= DYDX      115= IMAE      180= NTZG      245= RAGB      310= VOLU
%  51= DYDY      116= INDX      181= NTZL      246= RAGC      311= WFNO
%  52= EFFL      117= ISFN      182= NTZV      247= RAGX      312= XDVA
%  53= EFLX      118= ISNA      183= OSCD      248= RAGY      313= XDGT
%  54= EFLY      119= LACL      184= OBSN      249= RAGZ      314= XDLT
%  55= ENDX      120= LINV      185= OOFF      250= RAED      315= XENC
%  56= ENPP      121= LOGE      186= OPDC      251= RAEN      316= XNEA
%  57= EPDI      122= LOGT      187= OPDM      252= RAID      317= XNEG
%  58= EQUA      123= LONA      188= OPDX      253= RAIN      318= XNET
%  59= ETGT      124= LPTD      189= OPGT      254= RANG      319= XXEA
%  60= ETLT      125= MAXX      190= OPLT      255= REAA      320= XXEG
%  61= ETVA      126= MCOG      191= OPVA      256= REAB      321= XXET
%  62= EXPP      127= MCOL      192= OPTH      257= REAC      322= YNIP
%  63= FCGS      128= MCOV      193= OSUM      258= REAR      323= ZERN
%  64= FCGT      129= MINN      194= P1GT      259= REAX      324= ZPLM
%  65= FCUR      130= MNAB      195= P1LT      260= REAY      325= ZTHI

%% Copyright 2002-2009, DPSS, CSIR
% This file is subject to the terms and conditions of the BSD Licence.
% For further details, see the file BSDlicence.txt
%
% Contact : dgriffith@csir.co.za
% 
% 
%
%
%


% $Revision: 221 $

ZemaxOperands = [
'ABSO';
'ACOS';
'AMAG';
'ANAR';
'ASIN';
'ASTI';
'ATAN';
'AXCL';
'BIOC';
'BIOD';
'BIPF';
'BLNK';
'BSER';
'CENX';
'CENY';
'CMFV';
'CMGT';
'CMLT';
'CMVA';
'CODA';
'COGT';
'COLT';
'COMA';
'CONF';
'CONS';
'COSI';
'COVA';
'CTGT';
'CTLT';
'CTVA';
'CVGT';
'CVLT';
'CVOL';
'CVVA';
'DENC';
'DENF';
'DIFF';
'DIMX';
'DISC';
'DISG';
'DIST';
'DIVI';
'DLTN';
'DMFS';
'DMGT';
'DMLT';
'DMVA';
'DXDX';
'DXDY';
'DYDX';
'DYDY';
'EFFL';
'EFLX';
'EFLY';
'ENDX';
'ENPP';
'EPDI';
'EQUA';
'ETGT';
'ETLT';
'ETVA';
'EXPP';
'FCGS';
'FCGT';
'FCUR';
'FICL';
'FICP';
'FOUC';
'GBPD';
'GBPR';
'GBPS';
'GBPW';
'GBPP';
'GBSD';
'GBSR';
'GBSS';
'GBSW';
'GBSP';
'GCOS';
'GENC';
'GLCA';
'GLCB';
'GLCC';
'GLCX';
'GLCY';
'GLCZ';
'GMTA';
'GMTS';
'GMTT';
'GOTO';
'GPIM';
'GRMN';
'GRMX';
'GTCE';
'HACG';
'HHCN';
'I1GT';
'I2GT';
'I3GT';
'I4GT';
'I5GT';
'I6GT';
'I1LT';
'I2LT';
'I3LT';
'I4LT';
'I5LT';
'I6LT';
'I1VA';
'I2VA';
'I3VA';
'I4VA';
'I5VA';
'I6VA';
'IMAE';
'INDX';
'ISFN';
'ISNA';
'LACL';
'LINV';
'LOGE';
'LOGT';
'LONA';
'LPTD';
'MAXX';
'MCOG';
'MCOL';
'MCOV';
'MINN';
'MNAB';
'MNCA';
'MNCG';
'MNCT';
'MNCV';
'MNDT';
'MNEA';
'MNEG';
'MNET';
'MNIN';
'MNPD';
'MNSD';
'MSWA';
'MSWS';
'MSWT';
'MTFA';
'MTFS';
'MTFT';
'MXAB';
'MXCA';
'MXCG';
'MXCT';
'MXCV';
'MXDT';
'MXEA';
'MXEG';
'MXET';
'MXIN';
'MXPD';
'MXSD';
'NPGT';
'NPLT';
'NPVA';
'NPXG';
'NPXL';
'NPXV';
'NPYG';
'NPYL';
'NPYV';
'NPZG';
'NPZL';
'NPZV';
'NSDD';
'NSTR';
'NTXG';
'NTXL';
'NTXV';
'NTYG';
'NTYL';
'NTYV';
'NTZG';
'NTZL';
'NTZV';
'OSCD';
'OBSN';
'OOFF';
'OPDC';
'OPDM';
'OPDX';
'OPGT';
'OPLT';
'OPVA';
'OPTH';
'OSUM';
'P1GT';
'P1LT';
'P1VA';
'P2GT';
'P2LT';
'P2VA';
'P3GT';
'P3LT';
'P3VA';
'P4GT';
'P4LT';
'P4VA';
'P5GT';
'P5LT';
'P5VA';
'P6GT';
'P6LT';
'P6VA';
'P7GT';
'P7LT';
'P7VA';
'P8GT';
'P8LT';
'P8VA';
'PANA';
'PANB';
'PANC';
'PARA';
'PARB';
'PARC';
'PARR';
'PARX';
'PARY';
'PARZ';
'PATX';
'PATY';
'PETC';
'PETZ';
'PIMH';
'PLEN';
'PMAG';
'POWR';
'PRIM';
'PROD';
'PMGT';
'PMLT';
'PMVA';
'POPD';
'QOAC';
'QSUM';
'RAGA';
'RAGB';
'RAGC';
'RAGX';
'RAGY';
'RAGZ';
'RAED';
'RAEN';
'RAID';
'RAIN';
'RANG';
'REAA';
'REAB';
'REAC';
'REAR';
'REAX';
'REAY';
'REAZ';
'RELI';
'RENA';
'RENB';
'RENC';
'RETX';
'RETY';
'RGLA';
'RSCH';
'RSCE';
'RSRE';
'RSRH';
'RWCH';
'RWCE';
'RWRE';
'RWRH';
'SAGX';
'SAGY';
'SFNO';
'SINE';
'SKIS';
'SKIN';
'SPCH';
'SPHA';
'SQRT';
'SSAG';
'SUMM';
'SVIG';
'TANG';
'TFNO';
'TGTH';
'TMAS';
'TOTR';
'TRAC';
'TRAD';
'TRAE';
'TRAI';
'TRAN';
'TRAR';
'TRAX';
'TRAY';
'TRCX';
'TRCY';
'TTGT';
'TTHI';
'TTLT';
'TTVA';
'UDOP';
'USYM';
'VOLU';
'WFNO';
'XDVA';
'XDGT';
'XDLT';
'XENC';
'XNEA';
'XNEG';
'XNET';
'XXEA';
'XXEG';
'XXET';
'YNIP';
'ZERN';
'ZPLM';
'ZTHI'];
