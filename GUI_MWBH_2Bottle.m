% Magic Wine Bottle Holder - 2 Bottle
% Written by: JoshTheEngineer
% Started: 05/15/16
% Updated: 05/15/16 - Transferring code over from Wine_Bottle_Holder_1Bottle.m
%          05/24/16 - Everything works as expected
%                   - Bottle angle plotting based on hole diameter works

function varargout = GUI_MWBH_2Bottle(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_MWBH_2Bottle_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_MWBH_2Bottle_OutputFcn, ...
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
% End initialization code - DO NOT EDIT

% --- Executes just before GUI_MWBH_1Bottle is made visible.
function GUI_MWBH_2Bottle_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_MWBH_2Bottle_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% INITIALIZE VARIABLES
inchToM  = 0.0254;                                                          % Convert in to m
mToInch  = 1/0.0254;                                                        % Convert m to in
mmToM    = 1/1000;                                                          % Convert mm to m
cmToM    = 1/100;                                                           % Convert cm to m
ccToL    = 0.001;                                                           % Convert cm^3 to L

b1Height = str2double(get(handles.edit1Height,'String'));                   % Total height [in]
b1LBody  = str2double(get(handles.edit1BodyLength,'String'));               % Length of body [in]
b1DNeck  = str2double(get(handles.edit1NeckDiameter,'String'));             % Neck diameter [in]
b1LNeck  = str2double(get(handles.edit1NeckLength,'String'));               % Neck length [in]
b1DBase  = str2double(get(handles.edit1BaseDiameter,'String'));             % Base diameter [in]
b1Lcg    = str2double(get(handles.edit1CGfromBase,'String'));               % Base to CG length [in]
b1Rho    = str2double(get(handles.edit1WineDensity,'String'));              % Wine density [kg/L]
b1V      = str2double(get(handles.edit1WineVolume,'String'));               % Wine volume [L]

b2Height = str2double(get(handles.edit2Height,'String'));                   % Total height [in]
b2LBody  = str2double(get(handles.edit2BodyLength,'String'));               % Length of body [in]
b2DNeck  = str2double(get(handles.edit2NeckDiameter,'String'));             % Neck diameter [in]
b2LNeck  = str2double(get(handles.edit2NeckLength,'String'));               % Neck length [in]
b2DBase  = str2double(get(handles.edit2BaseDiameter,'String'));             % Base diameter [in]
b2Lcg    = str2double(get(handles.edit2CGfromBase,'String'));               % Base to CG length [in]
b2Rho    = str2double(get(handles.edit2WineDensity,'String'));              % Wine density [kg/L]
b2V      = str2double(get(handles.edit2WineVolume,'String'));               % Wine volume [L]

wVolume = str2double(get(handles.editWoodVolume,'String'));                 % Wood volume [in^3]
wMass   = str2double(get(handles.editWoodMass,'String'));                   % Wood mass [kg]
wRho    = wMass/(wVolume*inchToM^3);                                        % Wood density [kg/m^3]
set(handles.editWoodDensity,'String',num2str(wRho));

wT          = str2double(get(handles.editWoodThickness,'String'));          % Wood thickness [in]
wW          = str2double(get(handles.editWoodWidth,'String'));              % Wood width [in]
useMinAngle = get(handles.checkUseMinAngle,'Value');                        % FLAG: Use minimum angle [1] or not [0]
pctLAdd     = str2double(get(handles.editAddLength,'String'));              % Add percentage of length [%]
theta       = str2double(get(handles.editAngle,'String'));                  % Angle of wood w.r.t. table [deg]
sepPct      = str2double(get(handles.editVertSep,'String'));                % Bottle vertical separation [%]
iterMax     = str2double(get(handles.editMaxIterations,'String'));          % Maximum number of iterations [#]
errorTol    = str2double(get(handles.editErrorTolerance,'String'));         % Error tolerance - stopping criteria [#]
oldTheta    = theta;

% Assign variables into base workspace
assignin('base','b1Height',b1Height);
assignin('base','b1LBody',b1LBody);
assignin('base','b1DNeck',b1DNeck);
assignin('base','b1LNeck',b1LNeck);
assignin('base','b1DBase',b1DBase);
assignin('base','b1Lcg',b1Lcg);
assignin('base','b1Rho',b1Rho);
assignin('base','b1V',b1V);
assignin('base','b2Height',b2Height);
assignin('base','b2LBody',b2LBody);
assignin('base','b2DNeck',b2DNeck);
assignin('base','b2LNeck',b2LNeck);
assignin('base','b2DBase',b2DBase);
assignin('base','b2Lcg',b2Lcg);
assignin('base','b2Rho',b2Rho);
assignin('base','b2V',b2V);
assignin('base','wVolume',wVolume);
assignin('base','wMass',wMass);
assignin('base','wRho',wRho);
assignin('base','wT',wT);
assignin('base','wW',wW);
assignin('base','useMinAngle',useMinAngle);
assignin('base','pctLAdd',pctLAdd);
assignin('base','theta',theta);
assignin('base','oldTheta',oldTheta);
assignin('base','sepPct',sepPct);
assignin('base','iterMax',iterMax);
assignin('base','errorTol',errorTol);
assignin('base','inchToM',inchToM);
assignin('base','mToInch',mToInch);
assignin('base','mmToM',mmToM);
assignin('base','cmToM',cmToM);
assignin('base','ccToL',ccToL);

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% --------------------------- INITIALIZATION ---------------------------- %
% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %

% POP -------------------- Select Wine Bottle 1 ---------------------------
function popBottle1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP -------------------- Select Wine Bottle 2 ---------------------------
function popBottle2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP --------------------- Select Wood Type ------------------------------
function popWood_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ------------------ Units: Total Height ------------------------------
function popUnitsHeight_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ----------------- Units: Body Length --------------------------------
function popUnitsBodyLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ----------------- Units: Neck Diameter ------------------------------
function popUnitsNeckDiameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ----------------- Units: Neck Length --------------------------------
function popUnitsNeckLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ---------------- Units: Base Diameter -------------------------------
function popUnitsBaseDiameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP --------------- Units: CG from Base ---------------------------------
function popUnitsCGfromBase_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ------------------ Units: Wine Density ------------------------------
function popUnitsWineDensity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP -------------------- Units: Wine Volume -----------------------------
function popUnitsWineVolume_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ------------------ Units: Wood Volume -------------------------------
function popUnitsWoodVolume_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ------------------ Units: Wood Mass ---------------------------------
function popUnitsWoodMass_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP ------------------ Units: Wood Density ------------------------------
function popUnitsWoodDensity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP -------------------- Units: Wood Thickness --------------------------
function popUnitsWoodThickness_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP -------------------- Units: Wood Width ------------------------------
function popUnitsWoodWidth_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP -------------------- Units: Angle -----------------------------------
function popUnitsAngle_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Bottle Height 1 --------------------------------
function edit1Height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Body Length 1 ---------------------------------
function edit1BodyLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Neck Diameter 1 --------------------------------
function edit1NeckDiameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Neck Length 1 ----------------------------------
function edit1NeckLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Base Diameter 1 --------------------------------
function edit1BaseDiameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ---------------- CG Distance from Base 1 ---------------------------
function edit1CGfromBase_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Wine Density 1 --------------------------------
function edit1WineDensity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Wine Volume 1 ---------------------------------
function edit1WineVolume_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Bottle Height 2 --------------------------------
function edit2Height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Body Length 2 ---------------------------------
function edit2BodyLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Neck Diameter 2 --------------------------------
function edit2NeckDiameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------  Neck Length 2 ---------------------------------
function edit2NeckLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Base Diameter 2 --------------------------------
function edit2BaseDiameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT --------------- CG Distance from Base 2 ----------------------------
function edit2CGfromBase_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Wine Density 2 ---------------------------------
function edit2WineDensity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Wine Volume 2 ---------------------------------
function edit2WineVolume_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------------------- Wood Volume --------------------------------
function editWoodVolume_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------------ Wood Mass ---------------------------------
function editWoodMass_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------------ Wood Density ------------------------------
function editWoodDensity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------ Add Length Percentage ---------------------------
function editAddLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ---------------- Wood Angle w.r.t Table ----------------------------
function editAngle_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Maximum Iterations -----------------------------
function editMaxIterations_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT --------------------- Error Tolerance ------------------------------
function editErrorTolerance_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Wood Width ------------------------------------
function editWoodWidth_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT --------------------- Wood Thickness -------------------------------
function editWoodThickness_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------- Bottle Vertical Separation Percentage ------------------
function editVertSep_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% SLIDER ------------------ Hole Size Selection ---------------------------
function sliderHoleD_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% ----------------------------- CALLBACKS ------------------------------- %
% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %

% EDIT ------------------- Bottle Height 1 --------------------------------
function edit1Height_Callback(hObject, eventdata, handles)
b1Height = str2double(get(hObject,'String'));
assignin('base','b1Height',b1Height);

% EDIT -------------------- Body Length 1 ---------------------------------
function edit1BodyLength_Callback(hObject, eventdata, handles)
b1LBody = str2double(get(hObject,'String'));
assignin('base','b1LBody',b1LBody);

% EDIT ------------------- Neck Diameter 1 --------------------------------
function edit1NeckDiameter_Callback(hObject, eventdata, handles)
b1DNeck = str2double(get(hObject,'String'));
assignin('base','b1DNeck',b1DNeck);

% EDIT -------------------  Neck Length 1 ---------------------------------
function edit1NeckLength_Callback(hObject, eventdata, handles)
b1LNeck = str2double(get(hObject,'String'));
assignin('base','b1LNeck',b1LNeck);

% EDIT ------------------- Base Diameter 1 --------------------------------
function edit1BaseDiameter_Callback(hObject, eventdata, handles)
b1DBase = str2double(get(hObject,'String'));
assignin('base','b1DBase',b1DBase);

% EDIT --------------- CG Distance from Base 1 ----------------------------
function edit1CGfromBase_Callback(hObject, eventdata, handles)
b1Lcg = str2double(get(hObject,'String'));
assignin('base','b1Lcg',b1Lcg);

% EDIT ------------------- Wine Density 1 ---------------------------------
function edit1WineDensity_Callback(hObject, eventdata, handles)
b1Rho = str2double(get(hObject,'String'));
asssignin('base','b1Rho',b1Rho);

% EDIT -------------------- Wine Volume 1 ---------------------------------
function edit1WineVolume_Callback(hObject, eventdata, handles)
b1V = str2double(get(hObject,'String'));
assignin('base','b1V',b1V);

% EDIT ------------------- Bottle Height 2 --------------------------------
function edit2Height_Callback(hObject, eventdata, handles)
b2Height = str2double(get(hObject,'String'));
assignin('base','b2Height',b2Height);

% EDIT -------------------- Body Length 2 ---------------------------------
function edit2BodyLength_Callback(hObject, eventdata, handles)
b2LBody = str2double(get(hObject,'String'));
assignin('base','b2LBody',b2LBody);

% EDIT ------------------- Neck Diameter 2 --------------------------------
function edit2NeckDiameter_Callback(hObject, eventdata, handles)
b2DNeck = str2double(get(hObject,'String'));
assignin('base','b2DNeck',b2DNeck);

% EDIT -------------------  Neck Length 2 ---------------------------------
function edit2NeckLength_Callback(hObject, eventdata, handles)
b2LNeck = str2double(get(hObject,'String'));
assignin('base','b2LNeck',b2LNeck);

% EDIT ------------------- Base Diameter 2 --------------------------------
function edit2BaseDiameter_Callback(hObject, eventdata, handles)
b2DBase = str2double(get(hObject,'String'));
assignin('base','b2DBase',b2DBase);

% EDIT --------------- CG Distance from Base 2 ----------------------------
function edit2CGfromBase_Callback(hObject, eventdata, handles)
b2Lcg = str2double(get(hObject,'String'));
assignin('base','b2Lcg',b2Lcg);

% EDIT ------------------- Wine Density 2 ---------------------------------
function edit2WineDensity_Callback(hObject, eventdata, handles)
b2Rho = str2double(get(hObject,'String'));
assignin('base','b2Rho',b2Rho);

% EDIT -------------------- Wine Volume 2 ---------------------------------
function edit2WineVolume_Callback(hObject, eventdata, handles)
b2V = str2double(get(hObject,'String'));
assignin('base','b2V',b2V);

% EDIT --------------------- Wood Volume ----------------------------------
function editWoodVolume_Callback(hObject, eventdata, handles)
wVolume = str2double(get(hObject,'String'));
assignin('base','wVolume',wVolume);

% EDIT ------------------------ Wood Mass ---------------------------------
function editWoodMass_Callback(hObject, eventdata, handles)
wMass = str2double(get(hObject,'String'));
assignin('base','wMass',wMass);

% EDIT ------------------------ Wood Density ------------------------------
function editWoodDensity_Callback(hObject, eventdata, handles)
wRho = str2double(get(hObject,'String'));
assignin('base','wRho',wRho);

% EDIT ------------------ Add Length Percentage ---------------------------
function editAddLength_Callback(hObject, eventdata, handles)
pctLAdd = str2double(get(hObject,'String'));
assignin('base','pctLAdd',pctLAdd);

% EDIT ---------------- Wood Angle w.r.t Table ----------------------------
function editAngle_Callback(hObject, eventdata, handles)
theta = str2double(get(hObject,'String'));
assignin('base','theta',theta);

% EDIT ------------------- Maximum Iterations -----------------------------
function editMaxIterations_Callback(hObject, eventdata, handles)
iterMax = str2double(get(hObject,'String'));
assignin('base','iterMax',iterMax);

% EDIT --------------------- Error Tolerance ------------------------------
function editErrorTolerance_Callback(hObject, eventdata, handles)
errorTol = str2double(get(hObject,'String'));
assignin('base','errorTol',errorTol);

% EDIT --------------------- Wood Thickness -------------------------------
function editWoodThickness_Callback(hObject, eventdata, handles)
wT = str2double(get(hObject,'String'));
assignin('base','wT',wT);

% EDIT ----------------------- Wood Width ---------------------------------
function editWoodWidth_Callback(hObject, eventdata, handles)
wW = str2double(get(hObject,'String'));
assignin('base','wW',wW);

% EDIT ----------- Bottle Vertical Separation Percentage ------------------
function editVertSep_Callback(hObject, eventdata, handles)
sepPct = str2double(get(hObject,'String'));
assignin('base','sepPct',sepPct);

% CHECK ------------------ Use Minimum Angle ------------------------------
function checkUseMinAngle_Callback(hObject, eventdata, handles)
if (get(hObject,'Value') ~= get(hObject,'Max'))
    oldTheta = evalin('base','oldTheta');
    set(handles.editAngle,'String',num2str(oldTheta),...
                          'BackgroundColor',[1 1 1],...
                          'ForegroundColor','k');
end

% CHECK -------------------- Show CG Plots --------------------------------
function checkShowCGPlots_Callback(hObject, eventdata, handles)

% CHECK ----------------- Solution in Metric Units ------------------------
function checkMetricUnits_Callback(hObject, eventdata, handles)

% POP -------------------- Bottle Selection 1 -----------------------------
function popSelectBottle_Callback(hObject, eventdata, handles)

% POP -------------------- Select Wine Bottle 2 ---------------------------
function popBottle2_Callback(hObject, eventdata, handles)

% POP -------------------- Select Wine Bottle 1 ---------------------------
function popBottle1_Callback(hObject, eventdata, handles)

% Set values for each bottle type
if (get(hObject,'Value') == 1)                                              % BORDEAUX
    bHeight = 12;                                                           % Total height [in]
    bLBody  = 7.5;                                                          % Length of body [in]
    bDNeck  = 1;                                                            % Neck diameter [in]
    bLNeck  = 3.5;                                                          % Neck length [in]
    bDBase  = 3;                                                            % Base diameter [in]
    bLcg    = 4.5;                                                          % Length from base to CG [in]
    bRho    = 0.9755;                                                       % Wine density [kg/L]
    bV      = 0.75;                                                         % Wine volume [L]
elseif (get(hObject,'Value') == 2)                                          % BURGUNDY
    bHeight = 11.75;                                                        % Total height [in]
    bLBody  = 5.5;                                                          % Length of body [in]
    bDNeck  = 1.25;                                                         % Neck diameter [in]
    bLNeck  = 2.5;                                                          % Neck length [in]
    bDBase  = 3;                                                            % Base diameter [in]
    bLcg    = 4.25;                                                         % Length from base to CG [in]
    bRho    = 0.9755;                                                       % Wine density [kg/L]
    bV      = 0.75;                                                         % Wine volume [L]
elseif (get(hObject,'Value') == 3)                                          % CUSTOM BOTTLE
    % User enters in custom values
end

% Update the edit text boxes and pop menus appropriately
if (get(hObject,'Value') == 3)
    % Set the background color to yellow and allow users to edit values
    set(handles.edit1Height,'BackgroundColor','y','Enable','On');
    set(handles.edit1BodyLength,'BackgroundColor','y','Enable','On');
    set(handles.edit1NeckDiameter,'BackgroundColor','y','Enable','On');
    set(handles.edit1NeckLength,'BackgroundColor','y','Enable','On');
    set(handles.edit1BaseDiameter,'BackgroundColor','y','Enable','On');
    set(handles.edit1CGfromBase,'BackgroundColor','y','Enable','On');
    set(handles.edit1WineDensity,'BackgroundColor','y','Enable','On');
    set(handles.edit1WineVolume,'BackgroundColor','y','Enable','On');
    
    % Allow users to change the units
    set(handles.popUnitsHeight,'Enable','On');
    set(handles.popUnitsBodyLength,'Enable','On');
    set(handles.popUnitsNeckDiameter,'Enable','On');
    set(handles.popUnitsNeckLength,'Enable','On');
    set(handles.popUnitsBaseDiameter,'Enable','On');
    set(handles.popUnitsCGfromBase,'Enable','On');
    set(handles.popUnitsWineDensity,'Enable','On');
    set(handles.popUnitsWineVolume,'Enable','On');
else
    % Update the values in the edit text box
    set(handles.edit1Height,'String',num2str(bHeight));
    set(handles.edit1BodyLength,'String',num2str(bLBody));
    set(handles.edit1NeckDiameter,'String',num2str(bDNeck));
    set(handles.edit1NeckLength,'String',num2str(bLNeck));
    set(handles.edit1BaseDiameter,'String',num2str(bDBase));
    set(handles.edit1CGfromBase,'String',num2str(bLcg));
    set(handles.edit1WineDensity,'String',num2str(bRho));
    set(handles.edit1WineVolume,'String',num2str(bV));
    
    % Set the background color to white and make it inactive so user
    %  can't change values
    set(handles.edit1Height,'BackgroundColor',[1 1 1],...
                           'Enable','Inactive');
    set(handles.edit1BodyLength,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    set(handles.edit1NeckDiameter,'BackgroundColor',[1 1 1],...
                                 'Enable','Inactive');
    set(handles.edit1NeckLength,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    set(handles.edit1BaseDiameter,'BackgroundColor',[1 1 1],...
                                 'Enable','Inactive');
    set(handles.edit1CGfromBase,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    set(handles.edit1WineDensity,'BackgroundColor',[1 1 1],...
                                'Enable','Inactive');
    set(handles.edit1WineVolume,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    
    % Reset the units back to their default and make them inactive so
    %  the user can't change inputs
    set(handles.popUnitsHeight,'Value',1,'Enable','Inactive');
    set(handles.popUnitsBodyLength,'Value',1,'Enable','Inactive');
    set(handles.popUnitsNeckDiameter,'Value',1,'Enable','Inactive');
    set(handles.popUnitsNeckLength,'Value',1,'Enable','Inactive');
    set(handles.popUnitsBaseDiameter,'Value',1,'Enable','Inactive');
    set(handles.popUnitsCGfromBase,'Value',1,'Enable','Inactive');
    set(handles.popUnitsWineDensity,'Value',1,'Enable','Inactive');
    set(handles.popUnitsWineVolume,'Value',1,'Enable','Inactive');
    
    % Assign variables into base workspace
    assignin('base','bHeight',bHeight);
    assignin('base','bLBody',bLBody);
    assignin('base','bDNeck',bDNeck);
    assignin('base','bLNeck',bLNeck);
    assignin('base','bDBase',bDBase);
    assignin('base','bLcg',bLcg);
    assignin('base','bRho',bRho);
    assignin('base','bV',bV);
end

% POP --------------------- Select Wood Type ------------------------------
function popWood_Callback(hObject, eventdata, handles)
inchToM = evalin('base','inchToM');

% Set values for each wood type
if (get(hObject,'Value') == 1)                                              % PALLET
    wVolume = 90;                                                           % Wood volume [in^3]
    wMass   = 0.500;                                                        % Wood mass [kg]
    wRho    = wMass/(wVolume*(inchToM^3));                                  % Wood density [kg/m^3]
elseif (get(hObject,'Value') == 2)                                          % MAPLE
    wVolume = 90;                                                           % Wood volume [in^3]
    wMass   = 1.070;                                                        % Wood mass [kg]
    wRho    = wMass/(wVolume*(inchToM^3));                                  % Wood density [kg/m^3]
elseif (get(hObject,'Value') == 3)                                          % CHERRY
    wVolume = 90;                                                           % Wood volume [in^3]
    wMass   = 0.870;                                                        % Wood mass [kg]
    wRho    = wMass/(wVolume*(inchToM^3));                                  % Wood density [kg/m^3]
elseif (get(hObject,'Value') == 4)                                          % LOWES MAPLE
    wVolume = 42.6125;                                                      % Wood volume [in^3]
    wMass   = 0.494;                                                        % Wood mass [kg]
    wRho    = wMass/(wVolume*(inchToM^3));                                  % Wood density [kg/m^3]
elseif (get(hObject,'Value') == 5)                                          % CUSTOM (Volume/Mass)
    % User enters custom volume and mass
elseif (get(hObject,'Value') == 6)                                          % CUSTOM (Density)
    % User enters a custom density
end

% Update the edit text boxes and pop menus appropriately
if (get(hObject,'Value') == 5)
    % Set the background color to yellow and allow user to change values
    set(handles.editWoodVolume,'BackgroundColor','y','Enable','On');
    set(handles.editWoodMass,'BackgroundColor','y','Enable','On');
    set(handles.editWoodDensity,'BackgroundColor',[1 1 1],...
                                'Enable','Inactive');
    
    % Allow user to change the units
    set(handles.popUnitsWoodVolume,'Enable','On');
    set(handles.popUnitsWoodMass,'Enable','On');
    set(handles.popUnitsWoodDensity,'Enable','Inactive');
elseif (get(hObject,'Value') == 6)
    % Set the background color to yellow and allow user to change values
    set(handles.editWoodVolume,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    set(handles.editWoodMass,'BackgroundColor',[1 1 1],...
                             'Enable','Inactive');
    set(handles.editWoodDensity,'BackgroundColor','y','Enable','On');
    
    % Allow user to change the units
    set(handles.popUnitsWoodVolume,'Enable','Inactive');
    set(handles.popUnitsWoodMass,'Enable','Inactive');
    set(handles.popUnitsWoodDensity,'Enable','On');
else
    % Update the edit text box values
    set(handles.editWoodVolume,'String',num2str(wVolume));
    set(handles.editWoodMass,'String',num2str(wMass));
    set(handles.editWoodDensity,'String',num2str(wRho));
    
    % Change background color to white and make inactive so user
    %  can't change values
    set(handles.editWoodVolume,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    set(handles.editWoodMass,'BackgroundColor',[1 1 1],...
                             'Enable','Inactive');
    set(handles.editWoodDensity,'BackgroundColor',[1 1 1],...
                                'Enable','Inactive');
    
    % Set default units and make inactive so user can't change units
    set(handles.popUnitsWoodVolume,'Value',1,'Enable','Inactive');
    set(handles.popUnitsWoodMass,'Value',1,'Enable','Inactive');
    set(handles.popUnitsWoodDensity,'Value',1,'Enable','Inactive');
    
    % Assign variables into base workspace
    assignin('base','wVolume',wVolume);
    assignin('base','wMass',wMass);
    assignin('base','wRho',wRho);
end

% POP ------------------ Units: Total Height ------------------------------
function popUnitsHeight_Callback(hObject, eventdata, handles)

% POP ----------------- Units: Body Length --------------------------------
function popUnitsBodyLength_Callback(hObject, eventdata, handles)

% POP ----------------- Units: Neck Diameter ------------------------------
function popUnitsNeckDiameter_Callback(hObject, eventdata, handles)

% POP ----------------- Units: Neck Length --------------------------------
function popUnitsNeckLength_Callback(hObject, eventdata, handles)

% POP ---------------- Units: Base Diameter -------------------------------
function popUnitsBaseDiameter_Callback(hObject, eventdata, handles)

% POP --------------- Units: CG from Base ---------------------------------
function popUnitsCGfromBase_Callback(hObject, eventdata, handles)

% POP ------------------ Units: Wine Density ------------------------------
function popUnitsWineDensity_Callback(hObject, eventdata, handles)

% POP -------------------- Units: Wine Volume -----------------------------
function popUnitsWineVolume_Callback(hObject, eventdata, handles)

% POP ------------------ Units: Wood Volume -------------------------------
function popUnitsWoodVolume_Callback(hObject, eventdata, handles)

% POP ------------------ Units: Wood Mass ---------------------------------
function popUnitsWoodMass_Callback(hObject, eventdata, handles)

% POP ------------------ Units: Wood Density ------------------------------
function popUnitsWoodDensity_Callback(hObject, eventdata, handles)

% POP -------------------- Units: Wood Thickness --------------------------
function popUnitsWoodThickness_Callback(hObject, eventdata, handles)

% POP -------------------- Units: Wood Width ------------------------------
function popUnitsWoodWidth_Callback(hObject, eventdata, handles)

% POP ----------------------- Units: Angle --------------------------------
function popUnitsAngle_Callback(hObject, eventdata, handles)

% SLIDER ------------------ Hole Size Selection ---------------------------
function sliderHoleD_Callback(hObject, eventdata, handles)

% Evaluate in relevant variables
holeDArr  = evalin('base','holeDArr');

% Get the current value of the slider selection
sliderVal = get(handles.sliderHoleD,'Value');
sliderInd = floor(sliderVal);
assignin('base','sliderInd',sliderInd);

% Set background color if we get too far off the horizontal
if (sliderInd < 15)
    set(hObject,'BackgroundColor','r');
elseif (sliderInd >= 15 && sliderInd < 30)
    set(hObject,'BackgroundColor','y');
elseif (sliderInd >= 30);
    set(hObject,'BackgroundColor','g');
end

% Set the hole diameter selected in the text box indicator
set(handles.textHoleDVal,'String',[num2str(holeDArr(floor(sliderVal))) ' in']);

% Call the function that plots the wood/bottle system
plotSystem(handles);

% PUSH ---------------- Design Wine Bottle Holder -------------------------
function pushDesignBottleHolder_Callback(hObject, eventdata, handles)

% Load relevant variables into this callback
inchToM  = evalin('base','inchToM');
mToInch  = evalin('base','mToInch');
mmToM    = evalin('base','mmToM');
cmToM    = evalin('base','cmToM');
ccToL    = evalin('base','ccToL');
b1Height  = evalin('base','b1Height');
b1LBody   = evalin('base','b1LBody');
b1DNeck   = evalin('base','b1DNeck');
b1LNeck   = evalin('base','b1LNeck');
b1DBase   = evalin('base','b1DBase');
b1Lcg     = evalin('base','b1Lcg');
b1Rho     = evalin('base','b1Rho');
b1V       = evalin('base','b1V');
b2Height  = evalin('base','b2Height');
b2LBody   = evalin('base','b2LBody');
b2DNeck   = evalin('base','b2DNeck');
b2LNeck   = evalin('base','b2LNeck');
b2DBase   = evalin('base','b2DBase');
b2Lcg     = evalin('base','b2Lcg');
b2Rho     = evalin('base','b2Rho');
b2V       = evalin('base','b2V');
wVolume  = evalin('base','wVolume');
wMass    = evalin('base','wMass');
wRho     = evalin('base','wRho');
wT       = evalin('base','wT');
wW       = evalin('base','wW');
theta    = evalin('base','theta');
pctLAdd  = evalin('base','pctLAdd');
sepPct   = evalin('base','sepPct');
iterMax  = evalin('base','iterMax');
errorTol = evalin('base','errorTol');

% ==============================================
% ===== PopUp Menu and CheckBox Selections =====
% ==============================================

bType       = get(handles.popBottle1,'Value');                               % Bottle type
wType       = get(handles.popWood,'Value');                                 % Wood type
uH          = get(handles.popUnitsHeight,'Value');                          % Units: Height
uBL         = get(handles.popUnitsBodyLength,'Value');                      % Units: Body length
uND         = get(handles.popUnitsNeckDiameter,'Value');                    % Units: Neck diameter
uNL         = get(handles.popUnitsNeckLength,'Value');                      % Units: Neck length
uBD         = get(handles.popUnitsBaseDiameter,'Value');                    % Units: Base diameter
uCGfB       = get(handles.popUnitsCGfromBase,'Value');                      % Units: CG from base
uWineD      = get(handles.popUnitsWineDensity,'Value');                     % Units: Wine density
uWineV      = get(handles.popUnitsWineVolume,'Value');                      % Units: Wine volume
uWoodV      = get(handles.popUnitsWoodVolume,'Value');                      % Units: Wood volume
uWoodM      = get(handles.popUnitsWoodMass,'Value');                        % Units: Wood mass
uWoodD      = get(handles.popUnitsWoodDensity,'Value');                     % Units: Wood density
uWT         = get(handles.popUnitsWoodThickness,'Value');                   % Units: Wood thickness
uWW         = get(handles.popUnitsWoodWidth,'Value');                       % Units: Wood width
uAngle      = get(handles.popUnitsAngle,'Value');                           % Units: Angle w.r.t. table
useMinAngle = get(handles.checkUseMinAngle,'Value');                        % FLAG: [1] Use minimum angle
                                                                            %       [0] Do not use minimum angle
showCGPlots = get(handles.checkShowCGPlots,'Value');                        % FLAG: [1] Show CG plots on external plot
                                                                            %       [0] Do not show external CG plots
metricUnits = get(handles.checkMetricUnits,'Value');                        % FLAG: [1] Show solution using metric units
                                                                            %       [0] Show solution using English units

% =======================================
% ===== GET EVERYTHING READY TO RUN =====
% =======================================

set(handles.editAngle,'BackgroundColor',[1 1 1],...
                      'ForegroundColor','k');                               % Set angle field to normal
textInfo   = [];                                                            % Erase everything in info text box
numLinesTI = length(textInfo);                                              % Get number of lines in the array
textInfo{numLinesTI+1} = 'Designing bottle holder';                         % Indicate that design has begun
set(handles.textInfo,'String',textInfo);                                    % Set the text info
drawnow();                                                                  % Update immediately

% ============================
% ===== UNIT CONVERSIONS =====
% ============================

% --- Bottle variables ---
if (uH == 1)                                                                % Height
    b1Height = b1Height*inchToM;                                              % From [in]
    b2Height = b2Height*inchToM;                                              % From [in]
elseif (uH == 2)
    b1Height = b1Height*mmToM;                                                % From [mm]
    b2Height = b2Height*mmToM;                                                % From [mm]
elseif (uH == 3)
    b1Height = b1Height*cmToM;                                                % From [cm]
    b2Height = b2Height*cmToM;                                                % From [cm]
end

if (uBL == 1)                                                               % Body length
    b1LBody = b1LBody*inchToM;                                                % From [in]
    b2LBody = b2LBody*inchToM;                                                % From [in]
elseif (uBL == 2)
    b1LBody = b1LBody*mmToM;                                                  % From [mm]
    b2LBody = b2LBody*mmToM;                                                  % From [mm]
elseif (uBL == 3)
    b1LBody = b1LBody*cmToM;                                                  % From [cm]
    b2LBody = b2LBody*cmToM;                                                  % From [cm]
end

if (uND == 1)                                                               % Neck diameter
    b1DNeck = b1DNeck*inchToM;                                                % From [in]
    b2DNeck = b2DNeck*inchToM;                                                % From [in]
elseif (uND == 2)
    b1DNeck = b1DNeck*mmToM;                                                  % From [mm]
    b2DNeck = b2DNeck*mmToM;                                                  % From [mm]
elseif (uND == 3)
    b1DNeck = b1DNeck*cmToM;                                                  % From [cm]
    b2DNeck = b2DNeck*cmToM;                                                  % From [cm]
end

if (uNL == 1)                                                               % Neck length
    b1LNeck = b1LNeck*inchToM;                                                % From [in]
    b2LNeck = b2LNeck*inchToM;                                                % From [in]
elseif (uNL == 2)
    b1LNeck = b1LNeck*mmToM;                                                  % From [mm]
    b2LNeck = b2LNeck*mmToM;                                                  % From [mm]
elseif (uNL == 3)
    b1LNeck = b1LNeck*cmToM;                                                  % From [cm]
    b2LNeck = b21LNeck*cmToM;                                                  % From [cm]
end

if (uBD == 1)                                                               % Base diameter
    b1DBase = b1DBase*inchToM;                                                % From [in]
    b2DBase = b2DBase*inchToM;                                                % From [in]
elseif (uBD == 2)
    b1DBase = b1DBase*mmToM;                                                  % From [mm]
    b2DBase = b21DBase*mmToM;                                                  % From [mm]
elseif (uBD == 3)
    b1DBase = b1DBase*cmToM;                                                  % From [cm]
    b2DBase = b2DBase*cmToM;                                                  % From [cm]
end

if (uCGfB == 1)                                                             % CG from Base
    b1Lcg = b1Lcg*inchToM;                                                    % From [in]
    b2Lcg = b2Lcg*inchToM;                                                    % From [in]
elseif (uCGfB == 2)
    b1Lcg = b1Lcg*mmToM;                                                      % From [mm]
    b2Lcg = b2Lcg*mmToM;                                                      % From [mm]
elseif (uCGfB == 3)
    b1Lcg = b1Lcg*cmToM;                                                      % From [cm]
    b2Lcg = b2Lcg*cmToM;                                                      % From [cm]
end

if (uWineV == 2)                                                            % Wine volume
    b1V = b1V*ccToL;                                                          % From [cm^3]
    b2V = b2V*ccToL;                                                          % From [cm^3]
end

% --- Wood variables ---

if (get(handles.popWood,'Value') == 5)
    % Convert volume and mass
    if (uWoodV == 1)
        wVolume = wVolume*(inchToM^3);
    elseif (uWoodV == 2)
        wVolume = (wVolume*mmToM)*(mToInch^3);
    elseif (uWoodV == 3)
        wVolume = (wVolume*cmToM)*(mToInch^3);
    end
    
    if (uWoodM == 2)
        wMass = wMass/1000;
    elseif (uWoodM == 3)
        wMass = wMass*1;
    end
    
    % Compute density
    wRho = wMass/wVolume;
elseif (get(handles.popWood,'Value') == 6)
    % Convert density
    if (uWoodD == 2)
        wRho = wRho*27679.9;                                                % From [lbm/in^3]
    end
end

% --- Run variables ---
if (uWT == 1)                                                               % Wood thickness
    wT = wT*inchToM;                                                        % [in]
elseif (uWT == 2)
    wT = wT*mmToM;                                                          % [mm]
elseif (uWT == 3)
    wT = wT*cmToM;                                                          % [cm]
end

if (uWW == 1)                                                               % Wood width
    wW = wW*inchToM;                                                        % [in]
elseif (uWW == 2)
    wW = wW*mmToM;                                                          % [mm]
elseif (uWW == 3)
    wW = wW*cmToM;                                                          % [cm]
end

if (uAngle == 2)                                                            % Angle w.r.t table
    theta = theta*(180/pi);                                                 % [rad]
end

% ====================================
% ===== WINE BOTTLE COMPUTATIONS =====
% ====================================

% Calculated
b1WShol    = (b1DBase-b1DNeck)/2;                                           % Width of shoulder [m]
b1HShol    = b1Height-b1LBody-b1LNeck;                                      % Height of shoulder [m]
b1NeckToCG = b1Height-b1Lcg-(0.5*b1LNeck);                                  % Length from neck center to cg [m]

b2WShol    = (b2DBase-b2DNeck)/2;                                           % Width of shoulder [m]
b2HShol    = b2Height-b2LBody-b2LNeck;                                      % Height of shoulder [m]
b2NeckToCG = b2Height-b2Lcg-(0.5*b2LNeck);                                  % Length from neck center to cg [m]

% Mass and weight of the wine bottle
b1Mass   = b1Rho*b1V;                                                       % Mass of wine bottle [kg]
b1Weight = b1Mass*9.81;                                                     % Weight of wine bottle [N]

b2Mass   = b2Rho*b2V;                                                       % Mass of wine bottle [kg]
b2Weight = b2Mass*9.81;                                                     % Weight of wine bottle [N]

% ==============================================
% ===== MINIMUM BOTTLE VERTICAL SEPARATION =====
% ==============================================

% Convert percentage to decimal
sepPct = sepPct/100;

% Minimum vertical separation distance [m]
minSep = (sepPct*b1DBase) + (sepPct*b2DBase);
minSep = minSep + (sepPct*minSep);

% ======================================
% ===== MINIMUM ANGLE CALCULATIONS =====
% ======================================

% Extra angles needed
del      = 90-theta;                                                        % Complementary angle [deg]
oldTheta = theta;                                                           % Remember this theta when min angle no checked [deg]
assignin('base','oldTheta',oldTheta);                                       % Needs to be available to checkUseMinAngle

% First computation with smallest possible thickness
num      = 0.5*b1DBase;                                                     % Numerator
den      = ((0.5*b1LNeck)-(wT/2)) + b1HShol;                                % Denominator
minAngle = atand(num/den);                                                  % Initial min angle [deg]

% Recompute with updated thickness based on angle
actualT  = (wT/2)/sind(minAngle);                                           % Adjusted thickness
den      = ((0.5*b1LNeck)-actualT) + b1HShol;                               % Denominator
minAngle = atand(num/den);                                                  % Actual min angle [deg]

% If the user wants to use the minimum angle for calculations
if (useMinAngle == 1)
    % Set minimum angle [deg]
    theta = minAngle;
    
    % Complmentary angle used in computations [deg]
    del = 90-theta;
    
    % Set the value in the angle edit text box
    set(handles.editAngle,'String',num2str(theta),...
                          'BackgroundColor','r',...
                          'ForegroundColor',[1 1 1]);
else
    % If the theta requested is smaller than the minimum angle
    if (theta < minAngle)
        textInfo{1} = 'Angle requested is too small (not possible)!';       % Set the info text
        set(handles.textInfo,'String',textInfo);                            % Make the info text visible in GUI
        set(handles.editAngle,'BackgroundColor','r',...                     % Make the edit text box red to show error
                              'ForegroundColor',[1 1 1]);
        drawnow();                                                          % Make sure everything displays now
        return;                                                             % Stop running the program
    end
end

% ==================================
% ===== COMPUTATION ITERATIONS =====
% ==================================

% Clear old data from figure if calculating again
if (showCGPlots == 1)
    figure(1);                                                              % Select figure 1
    cla;                                                                    % Clear the axes
end

% X-distance separation of two bottle CGs
xSepCG = minSep/tand(theta);

% Initial pivot points
b1LPivot = 0;
b2LPivot = b1LPivot-xSepCG;

% A couple more inputs (can change adjustM, but not oldM)
adjustM  = 0.01;                                                            % Pivot adjustment refinement
oldM     = 1;                                                               % Old moment

% Iterative loop to converge on pivot distance
% - Loop as many times as necessary
% - If solution converges, the loop will exit
% - If solution does not converge, the loop will end at iterMax
for i = 1:1:iterMax
    
%     % Store old pivot lengths for error calculation
%     b1LPivotOld = b1LPivot;                                                 % For pivot error calculation
%     b2LPivotOld = b2LPivot;                                                 % For pivot error calculation
    
    % Hole lengths
    w1LHole = (b1NeckToCG-b1LPivot)/sind(del);                              % Base to bottom hole
    w2LHole = minSep/sind(theta);                                           % Bottom hole to top hole
    wLHole  = w1LHole + w2LHole;                                            % Base to top hole
    
    % Total length of board
    wLTot = wLHole + (0.5*b2DNeck);                                         % Add half diameter of bottle neck to enclose bottle neck in wood
    wLTot = wLTot + (pctLAdd/100)*wLTot;                                    % Add specified percentage to length
    wLTot = wLTot + (wT/tand(theta));                                       % Added length due to thickness and angle
    
    % Wood volume
    wVolume = wT*wW*wLTot;                                                  % Volume of wood [m^3]
    
    % Calculate mass and weight of wood board
    wMass   = wRho*wVolume;                                                 % Wood mass [kg]
    wWeight = wMass*9.81;                                                   % Wood weight [N]
    
    % Distance (magnitude) of wood CG to pivot [m]
    wLPivot = -(wLTot/2)*cosd(theta);                                       % New pivot length
    
    % Calculate moment
    % - Negative moment = system tips to wood side
    % - Positive moment = system tips to bottle side
    sumM = (wWeight*wLPivot)+(b2Weight*b2LPivot)+(b1Weight*b1LPivot);
    fprintf('Moment: %2.4f \n',sumM);
    
    % Change moment adjustment
    % - If we crossed over from negative moment to positive moment or vice versa
    % - Need to increase adjustment resolution (make adjustM smaller)
    if (oldM*sumM < 0)
        adjustM = 0.1*adjustM;
    end
    
    % Reset old moment to the moment just calculated
    oldM = sumM;
    
    % Add or subtract distance based on moment
    if (sumM > -errorTol && sumM < errorTol)
        fprintf('Solution converged after %i iterations!\n\n',i);
        break;
    elseif (sumM < 0)
        b1LPivot = b1LPivot + adjustM;                                      % Move bottles to the right
    elseif (sumM > 0)
        b1LPivot = b1LPivot - adjustM;                                      % Move bottles to the left
    end
    
    % Calculate new top bottle pivot point
    b2LPivot = b1LPivot - xSepCG;
    
    % Plot bottle/wood CG distances to show convergence
    if (showCGPlots == 1)
        if (i == 1)
            figure(1);
            cla; hold on;
            drawnow();
        end
        plot(wLPivot*mToInch,i,'ko');                                           % Plot wood CG point
        plot(b2LPivot*mToInch,i,'bo');                                          % Plot top bottle CG point
        plot(b1LPivot*mToInch,i,'ro');                                          % Plot bottom bottle CG point
        title('CG Plot');
        ylabel('Iteration');
        xlabel('Distance [m]');
        drawnow();
    end
    
end

% Minimum vertical height of bottom bottle
minY = w1LHole*mToInch*cosd(del);

if (i == iterMax)
    fprintf('No solution found!\n');
    fprintf('- Increase iterations\n');
    fprintf('- Increase error tolerance\n\n');
end

% Compute clearance of bottle and ground
clearance = w1LHole*sind(theta)-(0.5*b1DBase);
if (clearance <= 0)
    fprintf('Bottle will touch the ground!\n\n');
else
    fprintf('Clearance   : %2.2f [in]\n',clearance*mToInch);
end

% =========================
% ===== HOLE DRILLING =====
% =========================

% Absolute minimum hole diameter
minHoleD = b1DNeck;

% Maximum hole diameter (corresponds to flat hole diameter)
a = b1DNeck/sind(theta);                                                     % Due solely to neck diameter and angle of wood
b = wT/tand(theta);                                                         % Due solely to thickness and angle of wood
maxHoleD = a + b;                                                           % Addition of both effects

% Range for hole diameters
numHoles  = 100;
holeDArr  = linspace(minHoleD,maxHoleD,numHoles)';
alpha     = zeros(length(holeDArr),1);
beta      = zeros(length(holeDArr),1);

% Solve for zero of function to get alpha
for i = 1:1:length(holeDArr)
    h = holeDArr(i);
    b = b1DNeck;
    w = wT;
    
    myfun    = @(h,w,a,b) (h*sind(a))-(cosd(a)*w)-b;
    fun      = @(a) myfun(h,w,a,b);
    alpha(i) = fzero(fun,0);
    beta(i)  = 90-alpha(i);
end
assignin('base','beta',beta);

% Convert the hole diameter array to inches
holeDArr = holeDArr*mToInch;
assignin('base','holeDArr',holeDArr);
assignin('base','numHoles',numHoles);

% Set relevant fields associated with the slider
set(handles.sliderHoleD,'Min',1);
set(handles.sliderHoleD,'Max',numHoles);
set(handles.sliderHoleD,'SliderStep',[1/(numHoles-1), 1/(numHoles-1)]);
set(handles.sliderHoleD,'Value',numHoles);

set(handles.textMinHoleDVal,'String',[num2str(minHoleD*mToInch) ' in']);
set(handles.textMaxHoleDVal,'String',[num2str(maxHoleD*mToInch) ' in']);
set(handles.textHoleDVal,'String',[num2str(holeDArr(numHoles)) ' in']);

% ================================
% ===== PRINT FINAL SOLUTION =====
% ================================

if (metricUnits == 1)                                                       % Show solution in metric units
    final_wL        = wLTot*100;
    final_wT        = wT*100;
    final_wW        = wW*100;
    final_theta     = theta;
    final_w1LHole   = w1LHole*100;
    final_w2LHole   = w2LHole*100;
    final_minHoleD  = minHoleD*100;
    final_maxHoleD  = maxHoleD*100;
    final_clearance = clearance*100;
    unitStr         = 'cm';
elseif (metricUnits == 0)                                                   % Show solution in English units
    final_wL        = wLTot*mToInch;
    final_wT        = wT*mToInch;
    final_wW        = wW*mToInch;
    final_theta     = theta;
    final_w1LHole   = w1LHole*mToInch;
    final_w2LHole   = w2LHole*mToInch;
    final_minHoleD  = minHoleD*mToInch;
    final_maxHoleD  = maxHoleD*mToInch;
    final_clearance = clearance*mToInch;
    unitStr         = 'in';
end

fprintf('----------------------------------------------------\n');
fprintf('---------------- Final Solutions -------------------\n');
fprintf('----------------------------------------------------\n');
fprintf('********************* WOOD *************************\n');
fprintf('Length      : %2.2f [%s]\n',final_wL,unitStr);
fprintf('Thickness   : %2.2f [%s]\n',final_wT,unitStr);
fprintf('Width       : %2.2f [%s]\n',final_wW,unitStr);
fprintf('Angle       : %2.1f [deg]\n',final_theta);
fprintf('Clearance   : %2.2f [%s]\n',final_clearance,unitStr);
fprintf('********************* HOLE *************************\n');
fprintf('L to Hole 1 : %2.2f [%s]\n',final_w1LHole,unitStr);
fprintf('L to Hole 2 : %2.2f [%s]\n',final_w2LHole,unitStr);
fprintf('Min Hole D  : %2.2f [%s]\n',final_minHoleD,unitStr);
fprintf('Flat Hole D : %2.2f [%s]\n',final_maxHoleD,unitStr);

% Construct text cell array for printing in GUI
textSol{1}  = '============= WOOD =============';
textSol{2}  = ['Length       : ' num2str(final_wL) ' ' unitStr];
textSol{3}  = ['Thickness  : ' num2str(final_wT) ' ' unitStr];
textSol{4}  = ['Width         : ' num2str(final_wW) ' ' unitStr];
textSol{5}  = ['Angle         : ' num2str(final_theta) ' deg'];
textSol{6}  = ['Clearance  : ' num2str(final_clearance) ' ' unitStr];
textSol{7}  = '============= HOLE =============';
textSol{8}  = ['L to Hole 1  : ' num2str(final_w1LHole) ' ' unitStr];
textSol{9}  = ['L to Hole 2  : ' num2str(final_w2LHole) ' ' unitStr];
textSol{10}  = ['Min Hole D  : ' num2str(final_minHoleD) ' ' unitStr];
textSol{11} = ['Flat Hole D  : ' num2str(final_maxHoleD) ' ' unitStr];

set(handles.textSolution,'String',textSol);

% =============================================
% ===== CONVERT DIMENSIONS BACK TO INCHES =====
% =============================================

% Bottle dimensions
b1Height = b1Height*mToInch;
b1Lcg    = b1Lcg*mToInch;
b1DNeck  = b1DNeck*mToInch;
b1DBase  = b1DBase*mToInch;
b1HShol  = b1HShol*mToInch;
b1WShol  = b1WShol*mToInch;
b1LBody  = b1LBody*mToInch;
b1LNeck  = b1LNeck*mToInch;
b2Height = b2Height*mToInch;
b2Lcg    = b2Lcg*mToInch;
b2DNeck  = b2DNeck*mToInch;
b2DBase  = b2DBase*mToInch;
b2HShol  = b2HShol*mToInch;
b2WShol  = b2WShol*mToInch;
b2LBody  = b2LBody*mToInch;
b2LNeck  = b2LNeck*mToInch;

% Wood dimensions
w1LHole = w1LHole*mToInch;                                                  % Distance from base to hole
w2LHole = w2LHole*mToInch;                                                  % Distance from base to hole
wW      = wW*mToInch;                                                       % Wood width [in]
wLTot   = wLTot*mToInch;                                                    % Wood length [in]
wT      = wT*mToInch;                                                       % Wood thickness [in]

% Assign variables into the base workspace
assignin('base','b1Height',b1Height);
assignin('base','b1DNeck',b1DNeck);
assignin('base','b1DBase',b1DBase);
assignin('base','b1WShol',b1WShol);
assignin('base','b1HShol',b1HShol);
assignin('base','b1LBody',b1LBody);
assignin('base','b1LNeck',b1LNeck);
assignin('base','w1LHole',w1LHole);
assignin('base','b2Height',b2Height);
assignin('base','b2DNeck',b2DNeck);
assignin('base','b2DBase',b2DBase);
assignin('base','b2WShol',b2WShol);
assignin('base','b2HShol',b2HShol);
assignin('base','b2LBody',b2LBody);
assignin('base','b2LNeck',b2LNeck);
assignin('base','w2LHole',w2LHole);
assignin('base','wW',wW);
assignin('base','wLTot',wLTot);
assignin('base','wT',wT);
assignin('base','theta',theta);

% ===========================================
% ===== PLOTTING THE WOOD/BOTTLE SYSTEM =====
% ===========================================

plotSystem(handles);

% ==========================
% ===== WRAP IT ALL UP =====
% ==========================

% Update text info box
numLinesTI = length(textInfo);
textInfo{numLinesTI+1} = 'Finished design!';                                % Indicate that design has begun
set(handles.textInfo,'String',textInfo);                                    % Set the text info
drawnow();                                                                  % Update immediately

% Set the slider background color to green so user knows it's good to use
set(handles.sliderHoleD,'BackgroundColor','g');

% PUSH ---------------------- Exit the GUI --------------------------------
function pushExit_Callback(hObject, eventdata, handles)
clc;
delete(handles.figureWBH_2Bottle);

% FUNCTION ------------ Plots the Wood/Bottle System ----------------------
function plotSystem(handles)

% Load in relevant variables
b1DBase  = evalin('base','b1DBase');
b1LBody  = evalin('base','b1LBody');
b1WShol  = evalin('base','b1WShol');
b1HShol  = evalin('base','b1HShol');
b1LNeck  = evalin('base','b1LNeck');
b1DNeck  = evalin('base','b1DNeck');
b1Height = evalin('base','b1Height');
b1Lcg    = evalin('base','b1Lcg');
b2DBase  = evalin('base','b2DBase');
b2LBody  = evalin('base','b2LBody');
b2WShol  = evalin('base','b2WShol');
b2HShol  = evalin('base','b2HShol');
b2LNeck  = evalin('base','b2LNeck');
b2DNeck  = evalin('base','b2DNeck');
b2Height = evalin('base','b2Height');
b2Lcg    = evalin('base','b2Lcg');
wLTot    = evalin('base','wLTot');
wT       = evalin('base','wT');
theta    = evalin('base','theta');
w1LHole  = evalin('base','w1LHole');
w2LHole  = evalin('base','w2LHole');
beta     = evalin('base','beta');

% Select the appropriate axes
axes(handles.plotWBH);
cla; hold on;
axis('equal');

% Bottom Bottle
x0 = 0;            y0 = 0;
x1 = x0 + b1DBase; y1 = y0;
x2 = x1;           y2 = y1 + b1LBody;
x3 = x2 - b1WShol; y3 = y2 + b1HShol;
x4 = x3;           y4 = y3 + b1LNeck;
x5 = x4 - b1DNeck; y5 = y4;
x6 = x5;           y6 = y5 - b1LNeck;
x7 = x6 - b1WShol; y7 = y6 - b1HShol;
bX1 = [x0 x1 x2 x3 x4 x5 x6 x7 x0];
bY1 = [y0 y1 y2 y3 y4 y5 y6 y7 y0];

% Top Bottle
x0 = 0;            y0 = 0;
x1 = x0 + b2DBase; y1 = y0;
x2 = x1;           y2 = y1 + b2LBody;
x3 = x2 - b2WShol; y3 = y2 + b2HShol;
x4 = x3;           y4 = y3 + b2LNeck;
x5 = x4 - b2DNeck; y5 = y4;
x6 = x5;           y6 = y5 - b2LNeck;
x7 = x6 - b2WShol; y7 = y6 - b2HShol;
bX2 = [x0 x1 x2 x3 x4 x5 x6 x7 x0];
bY2 = [y0 y1 y2 y3 y4 y5 y6 y7 y0];

% Bottle CG location
bXcg = b1DBase/2;
bYcg = b1Lcg;

% Bottle neck center location
bXHoleC = b1DBase/2;
bYHoleC = b1Height - (0.5*b1LNeck);

% Extra variables needed for plotting (thickness at angle)
wT2 = wT/sind(theta);

% Coordinates of side view of wood board
x0 = wT2/2;
y0 = 0;
x1 = x0 - wLTot*cosd(theta);
y1 = y0 + wLTot*sind(theta);
x2 = x1 - wT2;
y2 = y1;
x3 = x2 + wLTot*cosd(theta);
y3 = 0;
wX = [x0 x1 x2 x3 x0];
wY = [y0 y1 y2 y3 y0];

% Hole-center coordinates
wXHoleC1 = -w1LHole*cosd(theta);
wYHoleC1 =  w1LHole*sind(theta);
wXHoleC2 = -(w1LHole+w2LHole)*cosd(theta);
wYHoleC2 =  (w1LHole+w2LHole)*sind(theta);

% Plot the system
plotWoodSide = plot(wX,wY,'k-');
plotWoodHole1 = plot(wXHoleC1,wYHoleC1,'ro');
plotWoodHole2 = plot(wXHoleC2,wYHoleC2,'bo');

% Translate plot
dx1 = wXHoleC1-bXHoleC;
dy1 = wYHoleC1-bYHoleC;
dx2 = wXHoleC2-bXHoleC;
dy2 = wYHoleC2-bYHoleC;

bX1 = bX1+dx1;
bY1 = bY1+dy1;
bX2 = bX2+dx2;
bY2 = bY2+dy2;
plotBottle1Trans = plot(bX1,bY1,'r-');
plotBottle2Trans = plot(bX2,bY2,'b-');

% Get values of the slider
sliderInd = floor(get(handles.sliderHoleD,'Value'));

% Rotation wine bottle
axisOfRot = [0 0 1];                                                        % Rotate about Z-axis
origin1   = [wXHoleC1 wYHoleC1 0];                                          % Rotate about half-neck
origin2   = [wXHoleC2 wYHoleC2 0];                                          % Rotate about half-neck
thetaRot  = 90 + (90-theta) - beta(sliderInd);                              % Rotate based on hole size
rotate(plotBottle1Trans,axisOfRot,thetaRot,origin1);
rotate(plotBottle2Trans,axisOfRot,thetaRot,origin2);
