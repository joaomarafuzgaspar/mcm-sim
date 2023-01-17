function varargout = gostop(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gostop_OpeningFcn, ...
                   'gui_OutputFcn',  @gostop_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function gostop_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);


function varargout = gostop_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in btnGo.
function btnGo_Callback(hObject, eventdata, handles)
set(handles.btnStop, 'userdata', 0);
i = 1;
while i > 0
	% your iterative computation here
	i = i + 1;
	pause(0.1);
	if get(handles.btnStop, 'userdata') % stop condition
		break;
	end
end

% --- Executes on button press in btnStop.
function btnStop_Callback(hObject, eventdata, handles)
set(handles.btnStop,'userdata',1)
