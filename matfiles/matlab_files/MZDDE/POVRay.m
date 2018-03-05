function [POVStat, POVOut] = POVRay(POVexe, CommOpt, InFile, Subst, OutFile)
% POVRay : Matlab interface to POV-Ray, the Persistance of Vision Raytracer
%
% POV-Ray is a classic rendering program which uses a raytracing technique.
% The POV-Ray scene is described using a scene description language.
% This function permits pre-processing of the scene description in order
% to substitute values in #declare statements before calling POV-Ray to
% render the scene.
%
% Usage :
%  [POVStat, POVOut] = POVRay(POVexe, CommOpt, InFile)
%  [POVStat, POVOut] = POVRay(POVexe, CommOpt, InFile, Substitute)
%  [POVStat, POVOut] = POVRay(POVexe, CommOpt, InFile, Substitute, OutFile)
%
% Where
%    POVexe is the full path and filename of the POV-Ray
%      executable. POV-Ray should not be running when this function is
%      called.
%    CommOpt must contain the desired command line options. 
%      This must include all controls not in the .ini file as well
%      as controls for resolution, output file type and bit depth.
%      See POV-Ray Command Line documentation for further command line
%      options of which there are many. The +H and +W options must be
%      given in order to set the size of the output image.
%      See below for some simple examples. POV-Ray's default 
%      behaviour can be extensively controlled using the POVRAY.INI
%      file which can be edited from the Tools menu in the POV-Ray
%      editor. 
%    InFile is the full filename of the input .pov file to use.
%      The .pov extension must be included. This is implemented through
%      the +I command line option.
%    Substitute is a cell array of strings containing names of
%      #declare variables with values to substitute for the default
%      values given in the .pov file. The purpose of the substitutions
%      is to have control of parameters within the .pov file. Note that
%      only the first occurrence of a particular #declare variable is
%      changed. Subsequent #declare statements referring to the same
%      variable will be unchanged. Also, ONLY #declare statements that
%      consist of a single line of text and that
%      are terminated with a semicolon will be subject to substitution.
%      Only // type comments are permitted on the #declare macro line.
%      If the Subst cell array is not empty, the input scene file is
%      subject to substitution and written to a file with the extension
%      .sub.pov before rendering starts.
%    OutFile is the filename of the output image. If this parameter
%      is not given, the output filename defaults to the input filename
%      but with the appropriate file extension. This is implemented
%      through the +o command line option.
%
% Example :
%  POVexe = 'C:\Program Files\POV-Ray for Windows v3.6\bin\pvengine.exe';
%  CommOpt = ''; % no other options, see POV-Ray docs for more options 
%  InFile = 'D:\Derek\MZDDE\POVRay\POVTest.pov';
%  Subst = {'BlobPigment', 'color red 1 green 0 blue 1'};
%
% Note : To get POV-Ray to exit after rendering, an option must be set
% from the "Render" menu within POV-Ray. Select "On Completion" from 
% the Render menu and choose "Exit POV-Ray for Windows". If this
% option is not set, Matlab will wait until you manually close
% POV-Ray.



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



if ~exist(InFile, 'file')
    error(['Input file ' InFile ' not found.']);
end

if exist('Subst', 'var')
    if ~iscellstr(Subst) || size(Subst,2) ~= 2
      error('Input Subsitute must be a cell array of strings with two columns.')
    end
    % Prepare regular expressions to scan with
    SubstDone = zeros(size(Subst,1)); % These are flags for when substitution has been done
    for iSubst = 1:size(Subst,1)
      ReguExp{iSubst} = [Subst{iSubst,1} '\s*=.*;\s*$'];
    end
    % open the output file
    [Pathstr,Name,Ext] = fileparts(InFile);
    SubstFile = [Pathstr '\' Name '.sub' Ext]; % This is substituted file 
    fout = fopen(SubstFile, 'w');
    % Read the input file and perform substitutions 
    fid = fopen(InFile, 'r');
    % Read line for line and find the relevant #declare statements
    while ~feof(fid)
        Line = fgetl(fid);
        Comment = '';
        % Strip off any comments
        ComStart = findstr(Line, '//');
        if ~isempty(ComStart) 
            Comment = Line(ComStart(1):end);
            if ComStart(1) > 1
              Line = Line(1:(ComStart(1)-1));
            else
              Line = '';
            end
        end
        % Any comment has been stripped off now
        % First determine if this is a #declare statement terminated with a ;
        if regexp(Line, '^\s*#declare\s+\w+\s*=.*;\s*$')
            for iSubst = 1:size(Subst,1)
                % Run through the regular expressions
                if ~SubstDone(iSubst) & regexp(Line, ReguExp{iSubst})
                    % Find the equals sign
                    Equals = findstr(Line, '=');
                    % Replace the part after the equals sign
                    Line = [Line(1:(Equals-1)) '= ' Subst{iSubst,2} '; '];
                    % Perform substitution only once
                    % Mark this substitution as done
                    SubstDone(iSubst) = 1;
                end
            end
        end
        fprintf(fout, '%s%s\n', Line, Comment);
    end
    fclose(fout);
    fclose(fid);
    % Issue warnings for substitutions not done.
    for iSubst = 1:size(Subst,1)
        if ~SubstDone(iSubst)
            warning(['Substitution of #declare ' Subst{iSubst,1} ' with ' Subst{iSubst,2} ' not found/performed.'])
        end
    end
end

% Build the command line and run POV-RAY
if exist('SubstFile', 'var')
  CommLine = ['"' POVexe '" ' CommOpt ' +I' SubstFile];
else
  CommLine = ['"' POVexe '" ' CommOpt ' +I' InFile];
end
if exist('OutFile', 'var')
    CommLine = [CommLine ' +o' [Pathstr '\' OutFile]];
end
% CommLine = [CommLine ' &']; % Use this to detach the process and allow 
% Matlab to return immediately
% CommLine % debug

% Finally, call POV-Ray
[POVStat, POVOut] = dos(CommLine);
