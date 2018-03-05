function BufferData = zSetBuffer(BufferNumber, Text)
% zSetBuffer  - store client specific data with the window being created or updated.
%
% Usage : BufferData = zSetBuffer(BufferNumber, Text)
%
% The buffer data can be used to store user selected options, instead of using the settings data on the command line of the
% zMakeTextWindow or zMakeGraphicWindow items. The data must be in a string format. The syntax is:
% zSetBuffer(1,'any text you want......');
% There are 16 buffers provided, numbered 0 through 15, and each can be set using zSetBuffer(0,'.....'); zSetBuffer(1,'.....')etc. % 
% The string given is the only text that is stored; and it may be a maximum of 240 characters.
% Note the buffer data is not associated with any particular window until either the zMakeTextWindow or
% zMakeGraphicWindow items are issued. Once ZEMAX receives the MakeTextWindow or MakeGraphicWindow
% item, the buffer data is then copied to the appropriate window memory, and then may later be retrieved from that
% window's buffer using zGetBuffer. 
%
% See also GetBuffer.
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
DDECommand = sprintf('SetBuffer,%i,%s',BufferNumber, Text);
BufferData = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);


