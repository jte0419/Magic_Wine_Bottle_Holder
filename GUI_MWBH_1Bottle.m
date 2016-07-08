% Magic Wine Bottle Holder - 1 Bottle
% Written by: JoshTheEngineer
% Started: 05/15/16
% Updated: 05/15/16 - Transferring code over from Wine_Bottle_Holder_1Bottle.m
%          05/23/16 - Everything works as expected
%                   - Bottle angle plotting based on hole diameter works

function varargout = GUI_MWBH_1Bottle(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_MWBH_1Bottle_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_MWBH_1Bottle_OutputFcn, ...
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
function GUI_MWBH_1Bottle_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_MWBH_1Bottle_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% INITIALIZE VARIABLES
inchToM  = 0.0254;                                                          % Convert in to m
mToInch  = 1/0.0254;                                                        % Convert m to in
mmToM    = 1/1000;                                                          % Convert mm to m
cmToM    = 1/100;                                                           % Convert cm to m
ccToL    = 0.001;                                                           % Convert cm^3 to L

bHeight = str2double(get(handles.editHeight,'String'));                     % Total height [in]
bLBody  = str2double(get(handles.editBodyLength,'String'));                 % Length of body [in]
bDNeck  = str2double(get(handles.editNeckDiameter,'String'));               % Neck diameter [in]
bLNeck  = str2double(get(handles.editNeckLength,'String'));                 % Neck length [in]
bDBase  = str2double(get(handles.editBaseDiameter,'String'));               % Base diameter [in]
bLcg    = str2double(get(handles.editCGfromBase,'String'));                 % Base to CG length [in]
bRho    = str2double(get(handles.editWineDensity,'String'));                % Wine density [kg/L]
bV      = str2double(get(handles.editWineVolume,'String'));                 % Wine volume [L]

wVolume = str2double(get(handles.editWoodVolume,'String'));                 % Wood volume [in^3]
wMass   = str2double(get(handles.editWoodMass,'String'));                   % Wood mass [kg]
wRho    = wMass/(wVolume*inchToM^3);
set(handles.editWoodDensity,'String',num2str(wRho));
% wRho    = str2double(get(handles.editWoodDensity,'String'));                % Wood density [kg/m^3]

wT          = str2double(get(handles.editWoodThickness,'String'));          % Wood thickness [in]
wW          = str2double(get(handles.editWoodWidth,'String'));              % Wood width [in]
useMinAngle = get(handles.checkUseMinAngle,'Value');                        % FLAG: Use minimum angle [1] or not [0]
pctLAdd     = str2double(get(handles.editAddLength,'String'));              % Add percentage of length [%]
theta       = str2double(get(handles.editAngle,'String'));                  % Angle of wood w.r.t. table [deg]
iterMax     = str2double(get(handles.editMaxIterations,'String'));          % Maximum number of iterations [#]
errorTol    = str2double(get(handles.editErrorTolerance,'String'));         % Error tolerance - stopping criteria [#]
oldTheta    = theta;

% Assign variables into base workspace
assignin('base','bHeight',bHeight);
assignin('base','bLBody',bLBody);
assignin('base','bDNeck',bDNeck);
assignin('base','bLNeck',bLNeck);
assignin('base','bDBase',bDBase);
assignin('base','bLcg',bLcg);
assignin('base','bRho',bRho);
assignin('base','bV',bV);
assignin('base','wVolume',wVolume);
assignin('base','wMass',wMass);
assignin('base','wRho',wRho);
assignin('base','wT',wT);
assignin('base','wW',wW);
assignin('base','useMinAngle',useMinAngle);
assignin('base','pctLAdd',pctLAdd);
assignin('base','theta',theta);
assignin('base','oldTheta',oldTheta);
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

% POP --------------------- Select Wine Bottle ----------------------------
function popBottle_CreateFcn(hObject, eventdata, handles)
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

% EDIT ---------------------- Bottle Height -------------------------------
function editHeight_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------------------- Body Length --------------------------------
function editBodyLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------------------- Neck Diameter ------------------------------
function editNeckDiameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Neck Length ------------------------------------
function editNeckLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ------------------- Base Diameter ----------------------------------
function editBaseDiameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT ----------------- CG Distance from Base ----------------------------
function editCGfromBase_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Wine Density ----------------------------------
function editWineDensity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% EDIT -------------------- Wine Volume -----------------------------------
function editWineVolume_CreateFcn(hObject, eventdata, handles)
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

% SLIDER ------------------- Set the Hole Diameter ------------------------
function sliderHoleD_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% ----------------------------- CALLBACKS ------------------------------- %
% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %

% EDIT ---------------------- Bottle Height -------------------------------
function editHeight_Callback(hObject, eventdata, handles)
bHeight = str2double(get(hObject,'String'));
assignin('base','bHeight',bHeight);

% EDIT ----------------------- Body Length --------------------------------
function editBodyLength_Callback(hObject, eventdata, handles)
bLBody = str2double(get(hObject,'String'));
assignin('base','bLBody',bLBody);

% EDIT ----------------------- Neck Diameter ------------------------------
function editNeckDiameter_Callback(hObject, eventdata, handles)
bDNeck = str2double(get(hObject,'String'));
assignin('base','bDNeck',bDNeck);

% EDIT ------------------- Neck Length ------------------------------------
function editNeckLength_Callback(hObject, eventdata, handles)
bLNeck = str2double(get(hObject,'String'));
assignin('base','bLNeck',bLNeck);

% EDIT ------------------- Base Diameter ----------------------------------
function editBaseDiameter_Callback(hObject, eventdata, handles)
bDBase = str2double(get(hObject,'String'));
assignin('base','bDBase',bDBase);

% EDIT ----------------- CG Distance from Base ----------------------------
function editCGfromBase_Callback(hObject, eventdata, handles)
bLcg = str2double(get(hObject,'String'));
assignin('base','bLcg',bLcg);

% EDIT -------------------- Wine Density ----------------------------------
function editWineDensity_Callback(hObject, eventdata, handles)
bRho = str2double(get(hObject,'String'));
asssignin('base','bRho',bRho);

% EDIT -------------------- Wine Volume -----------------------------------
function editWineVolume_Callback(hObject, eventdata, handles)
bV = str2double(get(hObject,'String'));
assignin('base','bV',bV);

% EDIT ----------------------- Wood Volume --------------------------------
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

% POP --------------------- Select Wine Bottle ----------------------------
function popBottle_Callback(hObject, eventdata, handles)

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
    set(handles.editHeight,'BackgroundColor','y','Enable','On');
    set(handles.editBodyLength,'BackgroundColor','y','Enable','On');
    set(handles.editNeckDiameter,'BackgroundColor','y','Enable','On');
    set(handles.editNeckLength,'BackgroundColor','y','Enable','On');
    set(handles.editBaseDiameter,'BackgroundColor','y','Enable','On');
    set(handles.editCGfromBase,'BackgroundColor','y','Enable','On');
    set(handles.editWineDensity,'BackgroundColor','y','Enable','On');
    set(handles.editWineVolume,'BackgroundColor','y','Enable','On');
    
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
    set(handles.editHeight,'String',num2str(bHeight));
    set(handles.editBodyLength,'String',num2str(bLBody));
    set(handles.editNeckDiameter,'String',num2str(bDNeck));
    set(handles.editNeckLength,'String',num2str(bLNeck));
    set(handles.editBaseDiameter,'String',num2str(bDBase));
    set(handles.editCGfromBase,'String',num2str(bLcg));
    set(handles.editWineDensity,'String',num2str(bRho));
    set(handles.editWineVolume,'String',num2str(bV));
    
    % Set the background color to white and make it inactive so user
    %  can't change values
    set(handles.editHeight,'BackgroundColor',[1 1 1],...
                           'Enable','Inactive');
    set(handles.editBodyLength,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    set(handles.editNeckDiameter,'BackgroundColor',[1 1 1],...
                                 'Enable','Inactive');
    set(handles.editNeckLength,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    set(handles.editBaseDiameter,'BackgroundColor',[1 1 1],...
                                 'Enable','Inactive');
    set(handles.editCGfromBase,'BackgroundColor',[1 1 1],...
                               'Enable','Inactive');
    set(handles.editWineDensity,'BackgroundColor',[1 1 1],...
                                'Enable','Inactive');
    set(handles.editWineVolume,'BackgroundColor',[1 1 1],...
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

% SLIDER ------------------- Set the Hole Diameter ------------------------
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
bHeight  = evalin('base','bHeight');
bLBody   = evalin('base','bLBody');
bDNeck   = evalin('base','bDNeck');
bLNeck   = evalin('base','bLNeck');
bDBase   = evalin('base','bDBase');
bLcg     = evalin('base','bLcg');
bRho     = evalin('base','bRho');
bV       = evalin('base','bV');
wVolume  = evalin('base','wVolume');
wMass    = evalin('base','wMass');
wRho     = evalin('base','wRho');
wT       = evalin('base','wT');
wW       = evalin('base','wW');
theta    = evalin('base','theta');
pctLAdd  = evalin('base','pctLAdd');
iterMax  = evalin('base','iterMax');
errorTol = evalin('base','errorTol');

% ==============================================
% ===== PopUp Menu and CheckBox Selections =====
% ==============================================

bType       = get(handles.popBottle,'Value');                               % Bottle type
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
                      'ForegroundColor','k');
textInfo = [];
set(handles.textInfo,'String',textInfo);

% ============================
% ===== UNIT CONVERSIONS =====
% ============================

% --- Bottle variables ---
if (uH == 1)                                                                % Height
    bHeight = bHeight*inchToM;                                              % From [in]
elseif (uH == 2)
    bHeight = bHeight*mmToM;                                                % From [mm]
elseif (uH == 3)
    bHeight = bHeight*cmToM;                                                % From [cm]
end

if (uBL == 1)                                                               % Body length
    bLBody = bLBody*inchToM;                                                % From [in]
elseif (uBL == 2)
    bLBody = bLBody*mmToM;                                                  % From [mm]
elseif (uBL == 3)
    bLBody = bLBody*cmToM;                                                  % From [cm]
end

if (uND == 1)                                                               % Neck diameter
    bDNeck = bDNeck*inchToM;                                                % From [in]
elseif (uND == 2)
    bDNeck = bDNeck*mmToM;                                                  % From [mm]
elseif (uND == 3)
    bDNeck = bDNeck*cmToM;                                                  % From [cm]
end

if (uNL == 1)                                                               % Neck length
    bLNeck = bLNeck*inchToM;                                                % From [in]
elseif (uNL == 2)
    bLNeck = bLNeck*mmToM;                                                  % From [mm]
elseif (uNL == 3)
    bLNeck = bLNeck*cmToM;                                                  % From [cm]
end

if (uBD == 1)                                                               % Base diameter
    bDBase = bDBase*inchToM;                                                % From [in]
elseif (uBD == 2)
    bDBase = bDBase*mmToM;                                                  % From [mm]
elseif (uBD == 3)
    bDBase = bDBase*cmToM;                                                  % From [cm]
end

if (uCGfB == 1)                                                             % CG from Base
    bLcg = bLcg*inchToM;                                                    % From [in]
elseif (uCGfB == 2)
    bLcg = bLcg*mmToM;                                                      % From [mm]
elseif (uCGfB == 3)
    bLcg = bLcg*cmToM;                                                      % From [cm]
end

if (uWineV == 2)                                                            % Wine volume
    bV = bV*ccToL;                                                          % From [cm^3]
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
bWShol    = (bDBase-bDNeck)/2;                                              % Width of shoulder [m]
bHShol    = bHeight-bLBody-bLNeck;                                          % Height of shoulder [m]
bNeckToCG = bHeight-bLcg-(0.5*bLNeck);                                      % Length from neck center to cg [m]

% Mass and weight of the wine bottle
bMass   = bRho*bV;                                                          % Mass of wine bottle [kg]
bWeight = bMass*9.81;                                                       % Weight of wine bottle [N]

% Initial values
bLPivot = 0;                                                                % Distance from wine bottle CG to pivot [m]

% ======================================
% ===== MINIMUM ANGLE CALCULATIONS =====
% ======================================

% Extra angles needed
del      = 90-theta;                                                        % Complementary angle [deg]
oldTheta = theta;                                                           % Remember this theta when min angle no checked [deg]
assignin('base','oldTheta',oldTheta);                                       % Needs to be available to checkUseMinAngle

% First computation with smallest possible thickness
num      = 0.5*bDBase;                                                      % Numerator
den      = ((0.5*bLNeck)-(wT/2)) + bHShol;                                  % Denominator
minAngle = atand(num/den);                                                  % Initial min angle [deg]

% Recompute with updated thickness based on angle
actualT  = (wT/2)/sind(minAngle);                                           % Adjusted thickness
den      = ((0.5*bLNeck)-actualT) + bHShol;                                 % Denominator
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
    else
        
    end
end

% ==================================
% ===== COMPUTATION ITERATIONS =====
% ==================================

% Clear old data from figure if calculating again
if (showCGPlots == 1)
    figure(1);
    cla;
end

% Iterative loop to converge on pivot distance
for i = 1:1:iterMax
    
    % For error comparison later (initial value is zero)
    % - Initially zero so bottle cg is over base
    bLPivotOld = bLPivot;
    
    % Minimum length to have bottle CG over base of wood
    wLHole = (bNeckToCG-bLPivot)/sind(del);
    if (i == 1)
        fprintf('Maximum Board Length: %2.2f [in]\n\n',wLHole*mToInch);
    end
    
    % Length adjustements
    wL = wLHole + (0.5*bDNeck);                                             % Add half diameter of bottle neck to enclose bottle neck in wood
    wL = wL + (pctLAdd/100)*wL;                                             % Add specified percentage to length
    wL = wL + (wT/tand(theta));                                             % Added length due to thickness and angle
    
    % Wood volume
    wVolume = wT*wW*wL;                                                     % Volume of wood [m^3]

    % Calculate mass and weight of wood board
    wMass   = wRho*wVolume;                                                 % Wood mass [kg]
    wWeight = wMass*9.81;                                                   % Wood weight [N]
    
    % Distance (magnitude) of wood cg to pivot [m]
    wLPivot = (wL/2)*cosd(theta);
    
    % Calculate needed distance from bottle cg to pivot [m]
    bLPivot = (wWeight*wLPivot)/bWeight;
    fprintf('Wood/Bottle Pivot: %2.2f/%2.2f [in]\n',...
                        wLPivot*mToInch,bLPivot*mToInch);
    
    % Check if new solution is within error tolerance
    if (abs(bLPivotOld-bLPivot) <= errorTol)
        fprintf('Solution Converged after %i iterations!\n\n',i);
        break;
    end
    
    % Plot bottle/wood CG distances to show convergence
    if (showCGPlots == 1)
        figure(1);
        subplot(1,2,1);
            hold on;
            plot(-wLPivot,i,'ko');
            axis auto;
            title('Wood Board CG');
            xlabel('Distance [m]');
            ylabel('Iteration []');
        subplot(1,2,2);
            hold on;
            plot(bLPivot,i,'ro');
            axis auto;
            title('Bottle CG');
            xlabel('Distance [m]');
            ylabel('Iteration []');
    end
    
end

if (i == iterMax)
    fprintf('No solution found!\n');
    fprintf('- Increase iterations\n');
    fprintf('- Increase error tolerance\n\n');
end

% Compute clearance of bottle and ground
clearance = wLHole*sind(theta)-(0.5*bDBase);
if (clearance <= 0)
    fprintf('Bottle will touch the ground!\n\n');
else
    fprintf('Clearance   : %2.2f [in]\n',clearance*mToInch);
end

% =========================
% ===== HOLE DRILLING =====
% =========================

% Absolute minimum hole diameter
minHoleD = bDNeck;

% Maximum hole diameter (corresponds to flat hole diameter)
a = bDNeck/sind(theta);                                                     % Due solely to neck diameter and angle of wood
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
    b = bDNeck;
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
    final_wL        = wL*100;
    final_wT        = wT*100;
    final_wW        = wW*100;
    final_theta     = theta;
    final_wLHole    = wLHole*100;
    final_minHoleD  = minHoleD*100;
    final_maxHoleD  = maxHoleD*100;
    final_clearance = clearance*100;
    unitStr         = 'cm';
elseif (metricUnits == 0)                                                   % Show solution in English units
    final_wL        = wL*mToInch;
    final_wT        = wT*mToInch;
    final_wW        = wW*mToInch;
    final_theta     = theta;
    final_wLHole    = wLHole*mToInch;
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
fprintf('L to Hole   : %2.2f [%s]\n',final_wLHole,unitStr);
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
textSol{8}  = ['L to Hole     : ' num2str(final_wLHole) ' ' unitStr];
textSol{9}  = ['Min Hole D  : ' num2str(final_minHoleD) ' ' unitStr];
textSol{10} = ['Flat Hole D  : ' num2str(final_maxHoleD) ' ' unitStr];

set(handles.textSolution,'String',textSol);

% =============================================
% ===== CONVERT DIMENSIONS BACK TO INCHES =====
% =============================================

% Bottle dimensions
bHeight = bHeight*mToInch;
bLcg    = bLcg*mToInch;
bDNeck  = bDNeck*mToInch;
bDBase  = bDBase*mToInch;
bHShol  = bHShol*mToInch;
bWShol  = bWShol*mToInch;
bLBody  = bLBody*mToInch;
bLNeck  = bLNeck*mToInch;

% Wood dimensions
wLHole = wLHole*mToInch;                                                    % Distance from base to hole
wW     = wW*mToInch;                                                        % Wood width [in]
wL     = wL*mToInch;                                                        % Wood length [in]
wT     = wT*mToInch;                                                        % Wood thickness [in]

% Assign variables into the base workspace
assignin('base','bHeight',bHeight);
assignin('base','bDNeck',bDNeck);
assignin('base','bDBase',bDBase);
assignin('base','bWShol',bWShol);
assignin('base','bHShol',bHShol);
assignin('base','bLBody',bLBody);
assignin('base','bLNeck',bLNeck);
assignin('base','wLHole',wLHole);
assignin('base','wW',wW);
assignin('base','wL',wL);
assignin('base','wT',wT);
assignin('base','theta',theta);

% ===========================================
% ===== PLOTTING THE WOOD/BOTTLE SYSTEM =====
% ===========================================

% Call the plotting function
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
delete(handles.figureWBH_1Bottle);

% FUNCTION ------------ Plots the Wood/Bottle System ----------------------
function plotSystem(handles)

% Evaluate in relevant variables
bDBase    = evalin('base','bDBase');
bLBody    = evalin('base','bLBody');
bWShol    = evalin('base','bWShol');
bHShol    = evalin('base','bHShol');
bLNeck    = evalin('base','bLNeck');
bDNeck    = evalin('base','bDNeck');
bHeight   = evalin('base','bHeight');
wL        = evalin('base','wL');
wT        = evalin('base','wT');
theta     = evalin('base','theta');
wLHole    = evalin('base','wLHole');
beta      = evalin('base','beta');

% Select the appropriate axes
axes(handles.plotWBH);
cla; hold on;
axis('equal');

% Bottle coordinates
x0 = 0;           y0 = 0;
x1 = x0 + bDBase; y1 = y0;
x2 = x1;          y2 = y1 + bLBody;
x3 = x2 - bWShol; y3 = y2 + bHShol;
x4 = x3;          y4 = y3 + bLNeck;
x5 = x4 - bDNeck; y5 = y4;
x6 = x5;          y6 = y5 - bLNeck;
x7 = x6 - bWShol; y7 = y6 - bHShol;
bX = [x0 x1 x2 x3 x4 x5 x6 x7 x0];
bY = [y0 y1 y2 y3 y4 y5 y6 y7 y0];

% Bottle neck center location
bXHoleC = bDBase/2;
bYHoleC = bHeight - (0.5*bLNeck);

% Extra variables needed for plotting (thickness at angle)
wT2 = wT/sind(theta);

% Coordinates of side view of wood board
x0 = wT2/2;
y0 = 0;
x1 = x0 - wL*cosd(theta);
y1 = y0 + wL*sind(theta);
x2 = x1 - wT2;
y2 = y1;
x3 = x2 + wL*cosd(theta);
y3 = 0;
wX = [x0 x1 x2 x3 x0];
wY = [y0 y1 y2 y3 y0];

% Hole-center coordinates
wXHoleC = -wLHole*cosd(theta);
wYHoleC = wLHole*sind(theta);

% Plot the system
plotWoodSide = plot(wX,wY,'k-');
plotWoodHole = plot(wXHoleC,wYHoleC,'ro');
plotBottle   = plot(bX,bY,'r-');

% Translate plot
dx = wXHoleC - bXHoleC;
dy = wYHoleC - bYHoleC;

bX = bX + dx;
bY = bY + dy;
plotBottleTrans = plot(bX,bY,'r-');

% Get values of the slider
sliderInd = floor(get(handles.sliderHoleD,'Value'));

% Rotation wine bottle
axisOfRot = [0 0 1];                                                        % Rotate about Z-axis
origin    = [wXHoleC wYHoleC 0];                                            % Rotate about half-neck
thetaRot  = 90 + (90-theta) - beta(sliderInd);
rotate(plotBottleTrans,axisOfRot,thetaRot,origin);
delete(plotBottle);
