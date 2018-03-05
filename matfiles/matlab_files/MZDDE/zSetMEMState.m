function Success = zSetMEMState(Surface, Object, AddressingMode, MirrorStateMatrix)
% Set the mirror states of a ZEMAX MEMS non-sequential digital mirror device (DMD or DLP).
%
% Usage : Success = zSetMEMState(Surface, Object, AddressingMode, MirrorStateMatrix)
%
% where the Surface is the Non-sequential group, and Object is the MEMS object within the group,
% the AddressingMode has the value 0, 1 or 2 for row addressing, column addressing or pixel addressing respectively.
% In the row or column mode, entire rows respectively columns of mirrors have the same state.
% MirrorStateMatrix is an array of integers having value 0, 1 or 2 only. In row or column addressing mode, MirrorStateMatrix
% must be a vector having the same number of rows respectively columns as the MEMS.
% In the pixel addressing mode, MirrorStateMatrix must have the same number of rows and columns as the MEMS.
% Returns 0 or 1 for failure and success respectively.
%
% The number of X Pixels of the MEMS is the number of columns.
% The number of Y Pixels of the MEMS is the number of rows.
%
% In pixel addressing mode, the state of the MEMS should have the same orientation as
% the Matlab matrix MirrorStateMatrix, when looking at the MEMS down the positive z axis
% with positive y upwards and positive x to the left.
%
% This command works only on the lens in the DDE server.

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
% $Author: DGriffith $

% Check the type and mode of the MEMS surface
type = zGetNSCObjectData(Surface,Object,0);
if ~strcmp(type,'NSC_DMDT')
    error('This object is not a DMD MEMS');    
end

memsmode = zGetNSCParameter(Surface,Object,9);

if memsmode ~= AddressingMode
    error(['The MEMS addressing mode (mode ' num2str(memsmode) ') is currently not the same as the mode you have requested (mode ' num2str(AddressingMode) ')']);
end

memscols = zGetNSCParameter(Surface,Object,1);
memsrows = zGetNSCParameter(Surface,Object,2);

staterows = size(MirrorStateMatrix,1);
statecols = size(MirrorStateMatrix,2);

% Check that the state array is within the range 0 - 2
MirrorStateMatrix = round(MirrorStateMatrix);
if any(any(MirrorStateMatrix < 0)) || any(any(MirrorStateMatrix > 2))
    error('MirrorStateMatrix must be in range 0 to 2.');
end

% Flip the statematrix so that it has the same orientation as the ZEMAX plot
MirrorStateMatrix = fliplr(flipud(MirrorStateMatrix));
% Now check if the number of rows, column and/or pixels matches the size of the state matrix
% and set up the parameters of the MEMS.
switch memsmode
    case 0
        % Array is addressed by rows
        if (length(MirrorStateMatrix) ~= memsrows)
            error(['Length of MirrorStateMatrix must be equal to number of rows in MEMS (' num2str(memsrows) ' rows).']);
        end
        % Compute the number of parameters that must be set in the non-seq editor
        parms = floor(memsrows / 15)+1;
        for parm = 1:1:parms
            % Synthesize the value for the parameter
            bigX = 0;
            for therow = ((parm-1)*15+1):1:(parm*15)
                if therow <= memsrows
                    bigX = bigX + MirrorStateMatrix(therow) * 3^(rem(therow-1,15));
                end
            end
            % Set the parameter
            zSetNSCParameter(Surface, Object, parm+9, bigX);
        end
    case 1
        % Array is addressed by columns
         if (length(MirrorStateMatrix) ~= memscols)
            error(['Length of MirrorStateMatrix must be equal to number of columns in MEMS (' num2str(memscols) ' columns).']);
        end
        parms = floor(memscols / 15)+1;
        for parm = 1:1:parms
            % Synthesize the value for the parameter
            bigX = 0;
            for thecol = ((parm-1)*15+1):1:(parm*15)
                if thecol <= memscols
                    bigX = bigX + MirrorStateMatrix(thecol) * 3^(rem(thecol-1,15));
                end
            end
            % Set the parameter
            zSetNSCParameter(Surface, Object, parm+9, bigX);
        end
        
    otherwise
        % Array is addressed by pixels
       
        if (staterows ~= memsrows) || (statecols ~= memscols)
            disp(['Size of MEMS is ' num2str(memsrows) ' rows (Y Pixels) by ' num2str(memscols) ' columns (X Pixels).'])
            error('Size of MirrorStateMatrix is not the same as the MEMS');
        end
        MirrorStateMatrix = MirrorStateMatrix'; % Take the transpose for correct pixel addressing
        
        parms = floor(memsrows * memscols / 15)+1;
        for parm = 1:1:parms
            % Synthesize the value for the parameter
            bigX = 0;
            for thepix = ((parm-1)*15+1):1:(parm*15)
                if thepix <= memscols * memsrows
                    bigX = bigX + MirrorStateMatrix(thepix) * 3^(rem(thepix-1,15));
                end
            end
            % Set the parameter
            zSetNSCParameter(Surface, Object, parm+9, bigX);
        end       
end
Success = zGetUpdate;


