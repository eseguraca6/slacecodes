function varargout = ZEMAXBusy(varargin)
% ZEMAXBUSY M-file for ZEMAXBusy.fig
%      ZEMAXBUSY, by itself, creates a new ZEMAXBUSY or raises the existing
%      singleton*.
%
%      H = ZEMAXBUSY returns the handle to a new ZEMAXBUSY or the handle to
%      the existing singleton*.
%
%      ZEMAXBUSY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZEMAXBUSY.M with the given input arguments.
%
%      ZEMAXBUSY('Property','Value',...) creates a new ZEMAXBUSY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ZEMAXBusy_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ZEMAXBusy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

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

% $Header: C:\\Projects\\RCS\\C\\Projects\\MZDDE\\ZEMAXBusy.m,v 1.2 2005-04-22 09:48:01+02 dgriffith Exp dgriffith $
% $Revision: 221 $

% Edit the above text to modify the response to help ZEMAXBusy

% Last Modified by GUIDE v2.5 25-Mar-2002 12:19:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZEMAXBusy_OpeningFcn, ...
                   'gui_OutputFcn',  @ZEMAXBusy_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ZEMAXBusy is made visible.
function ZEMAXBusy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ZEMAXBusy (see VARARGIN)

% Choose default command line output for ZEMAXBusy
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ZEMAXBusy wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ZEMAXBusy_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
