function SequenceNumbers = zGetSequence()
% zGetSequence - returns the sequence number of the lens in the Server’s memory, then the sequence number of the
% lens in the LDE, as a row vector.
%
% Usage : SequenceNumbers = zGetSequence
% Each time a lens is changed, the sequence number is incremented. If a new lens is loaded, the sequence number is
% reset to zero.
%
% See also : zGetRefresh, zPushLens
%

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

global ZemaxDDEChannel ZemaxDDETimeout
Reply = ddereq(ZemaxDDEChannel, 'GetSequence', [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%i,%i');
SequenceNumbers = col';


