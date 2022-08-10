function ToneCalibration()

close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Initialize and show the GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Opens figure window named 'name' -- called "parent"
hndl.StartFig = figure('name','Calibration',...
    'Visible','on','Units','normalized','Position',[0.05,0.05,0.9,0.85]); % Opens at given location on screen
% Makes struct called 'hndl' with matrix StartFig
set(gcf, 'UserData', hndl);

% Pulls data in from previous trials via HDR file
hndl = get(gcf, 'UserData'); % get variables structure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hardcoded Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Stimulus

hndl.SRate = 41000;
hndl.Duration = 4;

% Colors

hndl.colors.white=[1 1 1];
hndl.colors.gray=[0.9255 0.9137 0.8471];
hndl.colors.green=[0.5 1 0.25];
hndl.colors.blue=[0.5 0.5 1];
hndl.colors.red=[1 0.25 0.25];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Left Side: Buttons and File Fig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Left Side Buttons

hndl.Fig.Play = uicontrol('Style', 'pushbutton', 'String', 'Play', ...
    'FontWeight', 'bold', ...
    'FontSize', 48, ...
    'backgroundcolor',hndl.colors.green, ...
    'callback',@PlayPN, ...
    'Units', 'normalized', 'Position',[0.05,0.4,0.9,0.5]);

hndl.Fig.IncLevel = uicontrol('Style', 'pushbutton', 'String', '+dB', ...
    'FontWeight', 'bold', ...
    'FontSize', 18, ...
    'backgroundcolor',hndl.colors.blue, ...
    'callback',@IncLevel, ...
    'Units', 'normalized', 'Position',[0.05,0.2,0.15,0.1]);
hndl.Fig.DecLevel = uicontrol('Style', 'pushbutton', 'String', '-dB', ...
    'FontWeight', 'bold', ...
    'FontSize', 18, ...
    'backgroundcolor',hndl.colors.blue, ...
    'callback',@DecLevel, ...
    'Units', 'normalized', 'Position',[0.05,0.1,0.15,0.1]);
hndl.Fig.LevelChange = uicontrol('Style', 'edit', ...
    'String', '0', ...
    'FontSize', 32, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.2,0.1,0.15,0.2]);

uicontrol('Style','text','String','Freq (kHz):', ...
    'FontSize',32,...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.35,0.1,0.15,0.15]);
hndl.Fig.Freq = uicontrol('Style','edit', ...
    'String', '1', ...
    'FontSize', 32, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.5,0.1,0.15,0.2]);

uicontrol('Style','text','String','Amplitude:', ...
    'FontSize',32,...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.65,0.1,0.15,0.15]);
hndl.Fig.OutLevel = uicontrol('Style','edit', ...
    'String', '0.05', ...
    'FontSize', 32, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.8,0.1,0.15,0.2]);

set(hndl.StartFig, 'UserData', hndl);
SetParams;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Subfunctions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SetParams(varargin)

    hndl = get(gcf, 'UserData');
    
    % Generate tone
    t = 1/hndl.SRate : 1/hndl.SRate : hndl.Duration;
    hndl.Freq = str2double(get(hndl.Fig.Freq,'String'));
    hndl.Tone = sin(2 * pi * 1000 * hndl.Freq * t);
    
    % Attenuate to desired level
    hndl.OutLevel=str2double(get(hndl.Fig.OutLevel,'String'));
    hndl.LevelChange=str2double(get(hndl.Fig.LevelChange,'String'));
    hndl.Tone = (hndl.Tone ./ rms(hndl.Tone)) * hndl.OutLevel;
       
    set(gcf, 'UserData', hndl);

end

function IncLevel(varargin)

    hndl = get(gcf, 'UserData');

    hndl.OutLevel = hndl.OutLevel * 10^(hndl.LevelChange/20);
    set(hndl.Fig.OutLevel,'String',sprintf('%s',hndl.OutLevel));
    
    set(gcf, 'UserData', hndl);

    SetParams;
    
end

function DecLevel(varargin)

    hndl = get(gcf, 'UserData');

    hndl.OutLevel = hndl.OutLevel * 10^(-hndl.LevelChange/20);
    set(hndl.Fig.OutLevel,'String',sprintf('%s',hndl.OutLevel));
    
    set(gcf, 'UserData', hndl);
    
    SetParams;

end

function PlayPN(~,~,~)

    hndl = get(gcf, 'UserData');

    sound(hndl.Tone,hndl.SRate);
    
end