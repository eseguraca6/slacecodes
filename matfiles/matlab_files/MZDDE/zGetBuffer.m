function BufferData = zGetBuffer(n,TempFile)
% zGetBuffer  - Retrieve Zemax DDE client specific data from a window being updated
%
% zGetBuffer(n,TempFile)
% where n is the buffer number, which must be between 0 and 15 inclusive; and TempFile is the name of the
% temporary file for the window being updated. The tempfile name is passed to the client when ZEMAX calls the
% client; see the discussion "How ZEMAX calls the client" in the ZEMAX manual. Note each window may have it’s 
% own buffer data, and ZEMAX uses the filename to identify the window for which the buffer contents are required. 
%
% The buffer data is returned in an unscanned string.
%
% See also zSetBuffer.
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
DDECommand = sprintf('GetBuffer,%i,%s',n,TempFile);
BufferData = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);

