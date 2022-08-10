% This function executes a screening protocol to confirm that the participant 
% is wearing their headphones in the correct orientation, with the left 
% channel going to the left ear.
% 
% Sean R. Anderson - sean.hearing@gmail.com

function LRCheck(hndl,start)
    % User GUI for familarization protocol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show Experimental Screen, Run Experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('start','var')
    start = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% open experimental screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~start
    hndl.ExpFig = figure('name','L/R Check',...
        'numbertitle','off',...
        'MenuBar','none',...
        'Visible','on','Units','normalized','Position',[0.,0.,1,1]);
    
    hndl.colors.white=[1 1 1];
%     hndl.colors.gray = [0.9255 0.9137 0.8471];
    hndl.colors.green = [0.5 1 0.25];
    hndl.colors.blue = [0.5 0.5 1];
    hndl.colors.red = [1 0.25 0.25];
    hndl.colors.gray = [0.8 0.8 0.8];
    hndl.colors.orange = [0.947 0.686 0.098];
    hndl.colors.gray = [0.937254902 0.937254902 0.937254902];
    
    hndl.LRChecks = 0;
end

if start == 1
        str.data = {"Time for another headphone check!",...
            ' ',...
            'On each trial, we will present 1 beep. Please choose whether',...
            "it was presented on the left or right side.",...
            ' ',...
            'If anything is unclear, please press the "Help" button ',...
            'on the bottom left. When you are ready,',...
            'click the "Next" button below.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
else

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Experiment Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %     hndl = get(gcf, 'UserData');

    % STIMULUS
    % Hard-coded stimulus parameters
    
    hndl.SRate = 44100;             % Sampling rate in Hz
    hndl.PipDur = 1.0;              % Tone pip duration in sec
    hndl.ISI = 0.5;                 % Inter-stimulus interval in sec
    hndl.RampDur = 0.1;               % Pip onset/offset ramp duration in sec
    
    % INITIATILIZATIONS
    % Variables required on each trial
    
    hndl.Correct = 0; % number of correct responses
    hndl.Trial = 0; % number of trials completed
    
    % BUTTONS
    % Parameters guiding how GUI buttons will be set up
    
    xoffset = 0.2;
    yoffset = 0.0;
    nButtons = 2;
    widthButton = (1 - 2*xoffset)/nButtons;
    heightButton = 0.2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set up experimental screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    uicontrol('Style','text','String','', ...
        'FontWeight', 'bold', ...
        'backgroundcolor',hndl.colors.gray,...
        'FontSize',10,...
        'Units', 'normalized',...
        'Position',[0.0 0.0 1.0 1.0]);

    uicontrol('Style','text','String','The sound was played on the:', ...
        'FontWeight', 'bold', ...
        'backgroundcolor',hndl.colors.gray,...
        'FontSize',25,...
        'Units', 'normalized',...
        'Position',[xoffset+widthButton-widthButton,...
            yoffset+2.25*heightButton,...
            2 * widthButton,0.075]);

    hndl.ExpButtons.Play = uicontrol('Style', 'pushbutton', ...
        'String', 'Play', ...
        'FontWeight', 'bold', ...
        'FontSize', 40, ...
        'Enable','on',...
        'backgroundcolor',hndl.colors.green, ...
        'callback',{@Play}, ...
        'Units', 'normalized', 'Position',[0.33,0.65,0.33,0.15]);

    hndl.ExpButtons.Button1 = uicontrol('Style', 'pushbutton', ...
        'FontWeight', 'bold', ...
        'String','Left',...
        'FontSize', 40, ...
        'backgroundcolor',hndl.colors.blue, ...
        'Enable','off', ...
        'callback',{@UpdateResponse,1}, ...
        'Units', 'normalized',...
        'Position',[xoffset,yoffset+heightButton,...
            widthButton,heightButton]);

    hndl.ExpButtons.Button2 = uicontrol('Style', 'pushbutton', ...
        'FontWeight', 'bold', ...
        'String','Right',...
        'FontSize', 40, ...
        'backgroundcolor',hndl.colors.blue, ...
        'Enable','off', ...
        'callback',{@UpdateResponse,2}, ...
        'Units', 'normalized',...
        'Position',[xoffset+widthButton,yoffset+heightButton,...
            widthButton,heightButton]);
    
    hndl.ExpButtons.GetHelp = uicontrol('Style', 'pushbutton', 'String', 'Help', ...
        'FontWeight', 'bold', ...
        'FontSize', 8, ...
        'FontUnits','normalized',...
        'backgroundcolor',[1 0.1 0.1], ...
        'callback',{@Help,0}, ...
        'Units', 'normalized', 'Position',[0.4,0.1,0.1,0.052]);

    if ~isfield(hndl,'SubID')
        hndl.SubID = 'AAA';
    end
    hndl.LRChecks = hndl.LRChecks + 1;
    hndl.fid = fopen(sprintf('%s_%d_LRCheck.txt',hndl.SubID,hndl.LRChecks),'w');
    fprintf(hndl.fid,'ID,CorrectEar,ResponseEar,RTsec\n');
    
    set(gcf, 'UserData', hndl);
    
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Subfunctions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Calculate next trial
function UpdateResponse(obj,events,input)

    hndl = get(gcf, 'UserData');
    
    hndl.RTsec = toc;
    
    finishedFlag = 0;

    % Enable response buttons
    set(hndl.ExpButtons.Button1,'Enable','off');
    set(hndl.ExpButtons.Button2,'Enable','off');
    
    buttonData = input; % eval(sprintf('get(hndl.ExpButtons.Button%d);',input));

    if buttonData == 1
        RespEar = 'L';
    elseif buttonData == 2
        RespEar = 'R';
    end
    if hndl.LRidx == 1
        TargEar = 'L';
    elseif hndl.LRidx == 2
        TargEar = 'R';
    end
    
    
    % Write output of trial
    fprintf(hndl.fid,'%s,%s,%s,%0.2f\n',...
        hndl.SubID,TargEar,RespEar,hndl.RTsec);

    % Check response for accuracy
    correctTrial = (buttonData == hndl.LRidx);
    
    hndl.Trial = hndl.Trial + 1;
    if correctTrial
        % right!
        hndl.Correct = hndl.Correct + 1;
    else
        % wrong...
        hndl.Correct = hndl.Correct;
    end

    % Determine if completed & correct
    if hndl.Trial >= 2 
        
        finishedFlag = 1;
        
        % Close raw data file
        fclose(hndl.fid);
        
        if hndl.Correct >= 2 % both trials correct

            % Move to next task
            hndl.npanel = hndl.npanel + 1;
            set(gcf, 'UserData', hndl);
            WelcomeScreenHomeDelivery([],[],hndl.npanel);
        
        else % at least one trial wrong

            hndl.npanel = hndl.npanel - 1;
            set(gcf, 'UserData', hndl);
            
            % Ask listener to put on headphones, try again
            str.data = {'Hmm... It looks like there was a problem.'...
                ' ',...
                'Please check to make sure that the headphones are on the',...
                'correct ears (blue tape on left, red tape on right).',...
                ' ',...
                'If you are having technical issues, please contact the',...
                'experimenter with the instructions you received or',... 
                'press the "Help" button on the bottom left.',...
                ' ',...
                'If you are ready to try again, click the "Next" button below.'};
            str.pos = [0.2 0.3];
            str.siz = [0.6 0.35];

            GenGUI(str);            
        end
        
    else            
        % Enable play button
        set(hndl.ExpButtons.Play,'BackgroundColor',hndl.colors.green);        
        set(hndl.ExpButtons.Play,'Enable','on');
            
    end
        
    if finishedFlag
        % do NOT assign values to hndl
    else
        % Assign data to hndl
        set(gcf, 'UserData', hndl);
    end

end
    
%% Play stimulus on press of green button
function Play(~,~,~)

    hndl = get(gcf, 'UserData'); % get variables structure

    % Disable play button
    set(hndl.ExpButtons.Play,'BackgroundColor',[1 1 1]);        
    set(hndl.ExpButtons.Play,'Enable','off');

    totalDur = round(hndl.PipDur * hndl.SRate);
    t = 1/hndl.SRate : 1/hndl.SRate : hndl.PipDur;

    pip = AddTemporalRamps(sin(2 * pi * 250 * t),hndl.RampDur,hndl.SRate,2);
    
    hndl.LRidx = randperm(2,1);
    if hndl.LRidx == 1
        hndl.Stim = [(pip ./ rms(pip) * 3.19E-02) zeros(totalDur,1)]; % 70 dB(A)
    elseif hndl.LRidx == 2
        hndl.Stim = [zeros(totalDur,1) (pip ./ rms(pip) * 3.79E-02)]; % 70 dB(A)
    end

    sound(hndl.Stim,hndl.SRate);
    pause(length(hndl.Stim)/hndl.SRate);
    tic;
    
    % Enable response buttons
    set(hndl.ExpButtons.Button1,'Enable','on');
    set(hndl.ExpButtons.Button2,'Enable','on');

    set(gcf, 'UserData', hndl);

end
