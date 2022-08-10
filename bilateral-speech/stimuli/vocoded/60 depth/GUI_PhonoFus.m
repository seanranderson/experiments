function GUI_PhonoFus()

close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Initialize and show the GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rand('state', sum(1000*clock));
% Opens figure window named 'name' -- called "parent"
hndl.StartFig = figure('name','Experimenter Interface',...
    'Visible','on','Units','normalized','Position',[0.05,0.05,0.9,0.85]); % Opens at given location on screen
% Makes struct called 'hndl' with matrix StartFig
set(gcf, 'UserData', hndl);

% Pulls data in from previous trials via HDR file
% % ReadHeader;
hndl = get(gcf, 'UserData'); % get variables structure
hndl.Feedback = 0;

% Add paths to required libraries

addpath(genpath('Sean''s Vocoder'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hardcoded Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Stimulus

hndl.StartITD = [0 100 200 400 800 1200 1600];

% Signal Output

hndl.SRate = 48000;
hndl.ISI = 0.2;
hndl.TDT.on = 0;
hndl.atten=[39.2 37.2];

% Colors

hndl.colors.white=[1 1 1];
hndl.colors.gray=[0.9255 0.9137 0.8471];
hndl.colors.green=[0.5 1 0.25];
hndl.colors.blue=[0.5 0.5 1];
hndl.colors.red=[1 0.25 0.25];

% Vocoder

hndl.vocoder.PreEmph = 'off';
hndl.vocoder.NumChannels = 8; % number of channels in vocoder
hndl.vocoder.FLower = 150; % lower frequency boundary (Hz)
hndl.vocoder.FUpper = 8000; % higher frequency boundary (Hz)
hndl.vocoder.BPOrderA = 4; % analysis filter order
hndl.vocoder.SRate = 44100; % sampling rate (Hz)
hndl.vocoder.LPOrderE = 2; % envelope filter order
hndl.vocoder.LPCutoffE = 50; % envelope filter cutoff (Hz)
hndl.vocoder.BWPercentage = 0.8; % factor applied to channel bandwidth to reduce overlap in noise vocoder synthesis
hndl.vocoder.OutputCFType = 'geometric'; % determines which center frequencies to use for synthesis step

hndl.vocoder = BuildVocoder(hndl.vocoder);

hndl.CalibStim = audioread('../Stimuli/PinkNoise.wav');
hndl.RMSCalib = rms(hndl.CalibStim)^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Left Side: Buttons and File Fig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Left Side Buttons

hndl.Fig.StartExp = uicontrol('Style', 'pushbutton', 'String', 'Start Experiment', ...
    'FontWeight', 'bold', ...
    'FontSize', 18, ...
    'backgroundcolor',hndl.colors.green, ...
    'callback',@StartExp, ...
    'Units', 'normalized', 'Position',[0.05,0.75,0.2,0.2]);

hndl.Fig.Calibration = uicontrol('Style', 'pushbutton', 'String', 'Calibration', ...
    'FontWeight', 'bold', ...
    'FontSize', 14, ...
    'backgroundcolor',hndl.colors.blue, ...
    'callback',@Calibration, ...
    'Units', 'normalized', 'Position',[0.05,0.5,0.2,0.1]);
hndl.Fig.CalLeft = uicontrol('Style','edit', ...
    'String', '0', ...
    'FontSize', 11, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.2625,0.5,0.1,0.1]);
hndl.Fig.CalRight = uicontrol('Style','edit', ...
    'String', '0', ...
    'FontSize', 11, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.3625,0.5,0.1,0.1]);

hndl.Fig.UseTDT = uicontrol('Style', 'checkbox', 'String', 'Use TDT', ...
    'FontWeight', 'bold', ...
    'FontSize', 12, ...
    'value',0, ...
    'callback',@UseTDT, ...
    'Units', 'normalized', 'Position',[0.05,0.6,0.2,0.1]);
hndl.Fig.Feedback = uicontrol('Style', 'checkbox', 'String', 'Feedback', ...
    'FontWeight', 'bold', ...
    'FontSize', 12, ...
    'value',hndl.Feedback, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.26,0.6,0.2,0.1]);

hndl.Fig.RawData = uicontrol('Style', 'pushbutton', 'String', 'Open Raw Data', ...
    'FontWeight', 'bold', ...
    'FontSize', 14, ...
    'backgroundcolor',hndl.colors.blue, ...
    'callback',@OpenRawData, ...
    'enable','on', ...
    'Units', 'normalized', 'Position',[0.1,0.05,0.2,0.1]);
hndl.Fig.Result = uicontrol('Style', 'pushbutton', 'String', 'Results', ...
    'FontWeight', 'bold', ...
    'FontSize', 14, ...
    'backgroundcolor',hndl.colors.blue, ...
    'callback',@Calc_Results, ...
    'Units', 'normalized', 'Position',[0.3,0.05,0.2,0.1]);

% Left Side Fields

uicontrol('Style','text','String','Data Path:', ...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.025,0.35,0.075,0.025]);
hndl.Fig.DataPath = uicontrol('Style', 'edit', ...
    'String', '--',...%hndl.DataPath, ...
    'FontSize', 11, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.1,0.35,0.4,0.05]);

uicontrol('Style','text','String','Listener ID:', ...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.025,0.3,0.075,0.025]);
hndl.Fig.ListenerID = uicontrol('Style', 'edit', ...
    'String', '--',...hndl.ListenerID, ...
    'FontSize', 11, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.1,0.3,0.4,0.05]);

uicontrol('Style','text','String','Run #:', ...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.025,0.25,0.075,0.025]);
hndl.Fig.RunNum = uicontrol('Style', 'edit', ...
    'String', '--',...%num2str(hndl.RunNum), ...
    'FontSize', 11, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.1,0.25,0.4,0.05]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Right Side: Experimental Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hndl.Fig.Variables = uibuttongroup('Units', 'Normalized',...
    'backgroundcolor',hndl.colors.gray,...
    'Position',[0.525 0.05 0.45 0.9]);
uicontrol('Style','text','String','Variables', ...
    'Parent',hndl.Fig.Variables,...
    'FontSize', 18, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.red, ...
    'Units', 'normalized', 'Position',[0.05,0.925,0.9,0.05]);

uicontrol('Style','text','String','N Reps:', ...
    'Parent',hndl.Fig.Variables,...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.5,0.8,0.15,0.05]);
hndl.Fig.NReps = uicontrol('Style', 'edit', ...
    'Parent',hndl.Fig.Variables,...
    'String', 1, ...
    'FontSize', 10, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.65,0.8,0.2,0.05]);

hndl.Fig.LevelRove = uicontrol('Style', 'checkbox', 'String', 'Level Rove', ...
    'Parent',hndl.Fig.Variables,...
    'FontWeight', 'bold', ...
    'FontSize', 10, ...
    'value',hndl.Feedback, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.5,0.7,0.2,0.05]);

hndl.Fig.Plot = uicontrol('Style', 'checkbox', 'String', 'Plot', ...
    'Parent',hndl.Fig.Variables,...
    'FontWeight', 'bold', ...
    'FontSize', 10, ...
    'value',hndl.Feedback, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.75,0.7,0.2,0.05]);

uicontrol('Style','pushbutton','String','Clear Table', ...
    'Parent',hndl.Fig.Variables,...
    'FontSize',15,...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.red, ...
    'callback',@ClearTable, ...
    'Units', 'normalized', 'Position',[0.05,0.5,0.3,0.05]);

uicontrol('Style','text','String','Ramp (ms):', ...
    'Parent',hndl.Fig.Variables,...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.5,0.65,0.15,0.05]);
hndl.Fig.Ramp = uicontrol('Style', 'edit', ...
    'Parent',hndl.Fig.Variables,...
    'String', 10, ...
    'FontSize', 10, ...
    'FontWeight', 'bold', ...
    'backgroundcolor',hndl.colors.white, ...
    'callback',@SetParams,...
    'Units', 'normalized', 'Position',[0.75,0.65,0.2,0.05]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


uicontrol('Style','text','String','Vocoder Parameters:', ...
    'FontSize',12,...
    'Parent',hndl.Fig.Variables,...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.375,0.4,0.3,0.05]);
uicontrol('Style','text',...
    'String','rho = 0 correlated, 1 decorrelated, -1 anticorrelated', ...
    'FontSize',10,...
    'Parent',hndl.Fig.Variables,...
    'FontWeight', 'bold', ...
    'Units', 'normalized', 'Position',[0.05,0.375,0.9,0.05]);
hndl.Fig.TaskParams = uitable('Units','normalized', ...
    'parent',hndl.Fig.Variables,...
    'Position',[0.05,0.15,0.9,0.22], ...
    'fontsize',10,...
    'Data',NewTable(1,hndl),...
    'ColumnName', {'L Spread (mm)','R Spread (mm)','rho','ILD (dB)'},...
    'ColumnFormat', {'char','char','char','char'},...
    'ColumnEditable', [true true true true],...
    'ColumnWidth',{100,100,70,85},...
    'CellEditCallback',{@SetParams,1}, ...
    'enable','on');


set(hndl.StartFig, 'UserData', hndl);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Subfunctions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function datatable = NewTable(type,hndl)
    switch type
        case 1 % Choice of vocoder in either ear
            nrows = 6;
            datatable = cell(nrows,4);
            for ii = 1:nrows
                datatable{ii,1} = '';
                datatable{ii,2} = '';
                datatable{ii,3} = '';
                datatable{ii,4} = '';
            end
    end
end

function SetParams(~,~,~)

    hndl = get(gcf, 'UserData');

    hndl.NReps=str2double(get(hndl.Fig.NReps,'String'));
    hndl.CalLeft=str2double(get(hndl.Fig.CalLeft,'String'));
    hndl.CalRight=str2double(get(hndl.Fig.CalRight,'String'));
    hndl.LevelRove=get(hndl.Fig.LevelRove,'Value');    
    hndl.Plot=get(hndl.Fig.Plot,'Value');
    hndl.Ramp=str2double(get(hndl.Fig.Ramp,'String'));
    
    hndl.VocoderConds=get(hndl.Fig.TaskParams,'Data');

    hndl.DataPath = get(hndl.Fig.DataPath,'string');
    hndl.ListenerID = upper(get(hndl.Fig.ListenerID,'string'));
    set(hndl.Fig.ListenerID,'string',hndl.ListenerID);
    hndl.RunNum = str2double(get(hndl.Fig.RunNum,'string'));
    
    hndl.StimulusPath = '../Stimuli/';
    
    set(gcf, 'UserData', hndl);
    
    WriteHeader;

end

function GenCondList

    hndl = get(gcf, 'UserData');
    
    % Reformat condition matrix
    for ii = 1:size(hndl.VocoderConds,1)
       iscond(ii) = ~all(cellfun(@isequal,{'' '' '' ''},hndl.VocoderConds(ii,:))); 
    end
    VocoderConds = hndl.VocoderConds(iscond,:);
    
    % Define each word pair 
    fullSet = [1:15;1:15]';
    posFusTwo = [1 2;1 3;6 7;6 8;11 12;11 13];
    posFusTwo = [posFusTwo;fliplr(posFusTwo)];
    nonFus = [1 4;1 5;2 3;4 5;2 4;3 5;2 5;3 4];
    nonFus = [nonFus;nonFus+5;nonFus+10];
    nonFus = [nonFus;fliplr(nonFus)];
    diffVowelOne = [1 6;1 7;1 8;1 9;1 10;...
                    2 6;2 7;2 8;2 9;2 10;...
                    3 6;3 7;3 8;3 9;3 10;...
                    4 6;4 7;4 8;4 9;4 10;...
                    5 6;5 7;5 8;5 9;5 10];
    diffVowelTwo = [6 11;6 12;6 13;6 14;6 15;...
                    7 11;7 12;7 13;7 14;7 15;...
                    8 11;8 12;8 13;8 14;8 15;...
                    9 11;9 12;9 13;9 14;9 15;...
                    10 11;10 12;10 13;10 14;10 15];
    diffVowelThree = [1 11;1 12;1 13;1 14;1 15;...
                      2 11;2 12;2 13;2 14;2 15;...
                      3 11;3 12;3 13;3 14;3 15;...
                      4 11;4 12;4 13;4 14;4 15;...
                      5 11;5 12;5 13;5 14;5 15];
    diffVowel = [diffVowelOne;diffVowelTwo;diffVowelThree;...
        fliplr(diffVowelOne);fliplr(diffVowelTwo);fliplr(diffVowelThree)];
    
    % Split into monaural and binaural, then combine
    hndl.MonauralWords = []; hndl.BinauralWords = [];
    for ii = 1:hndl.NReps
        if any(strncmp('',VocoderConds(:,1),1)) || ...
                any(strncmp('',VocoderConds(:,2),1)) % Monaural

            % Present each word 1 time per rep 
            conditionsMon = (1:15)';
            
            
            hndl.MonauralWords(((ii-1)*size(conditionsMon,1)+1):(ii*size(conditionsMon,1)),:) ...
                = conditionsMon;
        end
        if any(~strncmp('',VocoderConds(:,1),1)) || ...
                any(~strncmp('',VocoderConds(:,2),1))

            % Present a subset of words - 33 per condition
                % Sample without replacement
            nmono = 11;
            tmp = randperm(15);
            if nmono <= 15
                monotics(:,1) = fullSet(tmp(1:nmono));
                monotics(:,2) = monotics(:,1);
            else
                error('Too many monotic to choose without replacement!');
            end

            nfuseable = 6;
            if nfuseable <= 12
                tmp = randperm(12);
                fuseable = posFusTwo(tmp(1:nfuseable),:);
            else
                error('Too many fuseable to choose without replacement!');
            end

            nnonfuseable = 5;
            if nnonfuseable <= 24
                tmp = randperm(24);
                nonfuseable = nonFus(tmp(1:nnonfuseable),:);
            else
                error('Too many non-fuseable to choose without replacement!');
            end

            ndichoticVowel = 11;
            if ndichoticVowel <= size(diffVowel,1)
                tmp = randperm(size(diffVowel,1));
                dichoticVowel = diffVowel(tmp(1:ndichoticVowel),:);
            else
                error('Too many dichotic vowels to choose without replacement!');
            end

            conditionssub = [monotics;fuseable;nonfuseable;dichoticVowel];
            condtype = [repmat(1,nmono,1);repmat(2,nfuseable,1);...
                        repmat(3,nnonfuseable,1);repmat(4,ndichoticVowel,1)];
            conditionsBin = [conditionssub condtype];
            
            hndl.BinauralWords(((ii-1)*size(conditionsBin,1)+1):(ii*size(conditionsBin,1)),:) ...
                = conditionsBin;
        end
    end
    
    % Build cell array of all conditions
    hndl.Conditions = {};
    rowstart = 1;
    for ii = 1:size(VocoderConds,1)
        % Works because each rep should be same size
        if ~strncmp('',VocoderConds(ii,1),1) && strncmp('',VocoderConds(ii,2),1)
            % Monaural - Left
                % Define rows
            rows = rowstart:(rowstart+size(hndl.MonauralWords,1)-1);
                % Update for next iteration
            rowstart = max(rows) + 1;
            
                % Populate cell array
            hndl.Conditions(rows,1) = cellstr(num2str(hndl.MonauralWords(:,1)));
            hndl.Conditions(rows,2) = cellstr(num2str(zeros(length(hndl.MonauralWords),1)));
            hndl.Conditions(rows,3) = cellstr(num2str(zeros(length(hndl.MonauralWords),1)));
            hndl.Conditions(rows,4) = VocoderConds(ii,1);
            hndl.Conditions(rows,5) = VocoderConds(ii,2);
            hndl.Conditions(rows,6) = VocoderConds(ii,3);
            hndl.Conditions(rows,7) = VocoderConds(ii,4); 
        elseif ~strncmp('',VocoderConds(ii,2),1) && strncmp('',VocoderConds(ii,1),1)
            % Monaural - Right
                % Define rows
            rows = rowstart:(rowstart+size(hndl.MonauralWords,1)-1);
                % Update for next iteration
            rowstart = max(rows) + 1;
            
            % Populate cell array
            hndl.Conditions(rows,1) = cellstr(num2str(zeros(length(hndl.MonauralWords),1)));
            hndl.Conditions(rows,2) = cellstr(num2str(hndl.MonauralWords(:,1)));
            hndl.Conditions(rows,3) = cellstr(num2str(zeros(length(hndl.MonauralWords),1)));
            hndl.Conditions(rows,4) = VocoderConds(ii,1);
            hndl.Conditions(rows,5) = VocoderConds(ii,2);
            hndl.Conditions(rows,6) = VocoderConds(ii,3);
            hndl.Conditions(rows,7) = VocoderConds(ii,4);
        else
            % Binaural
                % Works because each rep should be same size
                % Define rows
            rows = rowstart:(rowstart+size(hndl.BinauralWords,1)-1);
                % Update for next iteration
            rowstart = max(rows) + 1;
            
            % Populate cell array
            hndl.Conditions(rows,1) = cellstr(num2str(hndl.BinauralWords(:,1)));
            hndl.Conditions(rows,2) = cellstr(num2str(hndl.BinauralWords(:,2)));
            hndl.Conditions(rows,3) = cellstr(num2str(hndl.BinauralWords(:,3)));
            hndl.Conditions(rows,4) = VocoderConds(ii,1);
            hndl.Conditions(rows,5) = VocoderConds(ii,2);
            hndl.Conditions(rows,6) = VocoderConds(ii,3);
            hndl.Conditions(rows,7) = VocoderConds(ii,4);
        end
    end

    % Randomize order of conditions
    hndl.Conditions = hndl.Conditions(randperm(size(hndl.Conditions,1)),:);
    
    set(gcf, 'UserData', hndl);

end

function StartExp(~,~,~)

    SetParams;
    
    % Checks
    
    GenCondList;
    
    WriteHeader;
    
    hndl = get(gcf,'UserData');
    hndl.fid = fopen(sprintf('%s_Run%0.3d.out',hndl.ListenerID,hndl.RunNum),'w');
    if hndl.fid == -1
        error('Could not write output file!');
    end
    fprintf(hndl.fid,'ID,Run,Trial,Word1,Word2,nPresented,TrialType,VocLeft,VocRight,Rho,ILD,Resp1,Resp2,nResponsed\n');
    set(gcf, 'UserData', hndl);
    
    PhonoFus_BigBegin;

end

function ClearTable(varargin)
    hndl = get(gcf, 'UserData');
    
    tab=get(hndl.Fig.TaskParams,'data');

    nrows = size(tab,1);
    datatable = cell(nrows,4);
    for ii = 1:nrows
        datatable{ii,1} = '';
        datatable{ii,2} = '';
        datatable{ii,3} = '';
        datatable{ii,4} = '';
    end
    
    set(hndl.Fig.TaskParams,'data',datatable);
    SetParams;
    
end

function Calc_Results(~,~,~)

    titleStr = {'Diotic','Fuseable','Non-Fuseable','Dichotic Vowel'};
    hndl = get(gcf, 'UserData');
    [filename,pathname] = uigetfile([hndl.DataPath '\*.out'],'Choose the .out file to open.',...
        'Multiselect','on');
    if iscell(filename)
        for ii=1:length(filename)
            fid = fopen([pathname filename{ii}],'r'); fgets(fid);
            linestring = fgets(fid); jj = 1;
            while linestring ~= -1
                tmp = strsplit(linestring,',');
                vocconds{jj} = {tmp{8} tmp{9}};
                subdat(jj,:) = [str2num(tmp{7}) str2num(tmp{4}) str2num(tmp{5}) str2num(tmp{6}) ...
                    str2num(tmp{12}) str2num(tmp{13}) str2num(tmp{14})]; %#ok<*ST2NM>
                monosdat(jj,:) = [str2num(tmp{7}) str2num(tmp{4}) str2num(tmp{5}) str2num(tmp{6}) ...
                str2num(tmp{11}) str2num(tmp{12}) str2num(tmp{13})];
                linestring = fgets(fid); jj = jj + 1;
            end
             dat{ii} = subdat;
             monodat{ii} = monosdat;
             voc{ii} = cat(1,vocconds{:});
             fclose(fid);
        end
    else
        fid = fopen([pathname filename],'r'); fgets(fid);
        linestring = fgets(fid); jj = 1;
        while linestring ~= -1
            tmp = strsplit(linestring,',');
            if jj==565
                disp(jj)
            end
            vocconds{jj} = {tmp{8} tmp{9}};
            dat(jj,:) = [str2num(tmp{7}) str2num(tmp{4}) str2num(tmp{5}) str2num(tmp{6}) ...
                str2num(tmp{12}) str2num(tmp{13}) str2num(tmp{14})]; %#ok<*ST2NM>
            monodat(jj,:) = [str2num(tmp{7}) str2num(tmp{4}) str2num(tmp{5}) str2num(tmp{6}) ...
                str2num(tmp{11}) str2num(tmp{12}) str2num(tmp{13})];
            linestring = fgets(fid); jj = jj + 1;
        end
        voc = cat(1,vocconds{:});
        fclose(fid);
    end
    if iscell(dat)
        dat=cat(1,dat{:});
        monodat=cat(1,monodat{:});
        voc = cat(1,voc{:});
    end
    
    origdat = dat; origmono = monodat;
    vocdat = strcat(voc(:,1),voc(:,2));
    uvocs = unique(vocdat);
    for jj = 1:length(uvocs)
        % subset by vocoder condition
        vocindex = strfind(vocdat,uvocs{jj});
        vocindex(cellfun('isempty',vocindex)) = {0};
        vocindex = cell2mat(vocindex);
        dat = origdat(logical(vocindex),:);
        figure('Name',uvocs{jj});
        stimtypes = unique(dat(:,1));
        if length(stimtypes) == 1 % all monaural
                accuracy = (monodat(:,2) == monodat(:,5)) | (monodat(:,3) == monodat(:,5));
                acc = sum(accuracy)/length(accuracy);
                figure; bar(acc); ylim([0 1]); ylabel('Percent Correct');
                text(0.5,0.4,sprintf('p = %0.3f',acc));
        else        
            for ii = 1:length(stimtypes)
                subdat = dat(logical(dat(:,1)==stimtypes(ii)),:);
                if stimtypes(ii) == 1 % One word
                    % OPTION FOR BOTH CORRECT OR ONE CORRECT
                    %% BOTH
                    accuracy = (subdat(:,2) == subdat(:,5)) & (subdat(:,4)==subdat(:,7)); %| (dat(:,2) == dat(:,6));
                    %% EITHER
                    acc = sum(accuracy)/length(accuracy);
                else % Two words
                    %% BOTH
                    accuracy = ((subdat(:,2) == subdat(:,5)) & (subdat(:,3) == subdat(:,6))) ... 
                        | ((subdat(:,2) == subdat(:,6)) & (subdat(:,3) == subdat(:,5)));
                    %% EITHER
                    acc = sum(accuracy)/length(accuracy);
                end

                if ii == 2
                    % Get cats - use rules - loop through
                    % Ideal - both are correct
                    % Fused - 1 word, combo
                    % Biased left - only left correct
                    % Biased right - only right correct
                    % Interference - none of the above
                end
                
                % All words correct
                subplot(2,4,ii);
                bar(acc); ylim([0 1]); title(titleStr{ii}); ylabel('Percent Correct');
                text(0.5,0.5,sprintf('n = %d',length(accuracy)));
                text(0.5,0.4,sprintf('p = %0.3f',acc));

                accuracy = (subdat(:,4) == subdat(:,7));
                acc = sum(accuracy)/length(accuracy);

                % Number of words reported is correct
                subplot(2,4,4+ii);
                bar(acc); ylim([0 1]); title(titleStr{ii}); ylabel('Percent Correct');
                text(1,0.5,sprintf('n = %d',length(accuracy)));
                text(0.5,0.4,sprintf('p = %0.3f',acc));
            end
        end
    end
    disp(uvocs);

end
