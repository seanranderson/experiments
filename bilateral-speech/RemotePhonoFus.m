% This is the main script to conduct the phonological fusion experiment.
% It is broken down into panels (i.e., experimental screens) that will 
% be presented to the participant. 
% 
% Sean R. Anderson - sean.hearing@gmail.com

function RemotePhonoFus(npanel)

if ~exist('npanel','var')
    npanel = 5;
end

switch npanel
    case 1
        %% Initialize the familiarization, code important info
        hndl = get(gcf, 'UserData');
        hndl.Ramp = 0;
        hndl.SRate = 44100;
        hndl.StimulusPath = '../PhonoFus/Stimuli/';
        hndl.CalibStim = audioread('Stimuli/PinkNoise.wav');
        hndl.RMSCalib = rms(hndl.CalibStim)^2; % not used...
        hndl.CalLeft = 9.976e-3; % RMS factor determined during calibration 65 dB(A)
        hndl.CalRight = 1.145e-2;
        hndl.PosWords= {'Bed','Led','Red','Bled','Bread',...
        'Pay','Lay','Ray','Play','Pray',...
        'Go','Low','Row','Glow','Grow'};
        set(gcf, 'UserData', hndl);
        
        RemotePhonoFus(2);
        
    case 2
        
        str.data = {"In this experiment, you'll be played words",...
            'and asked to report what they were. Your options',...
            'will appear on the screen.',...
            ' ',...
            "If anything is unclear or doesn't appear to be working,",...
            'please feel free to click the "Help" button',...
            'in the lefthand corner at any time!'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 3
        
        str.data = {'We will play some normal speech',...
            '(like you hear every day) and some "mechanical" speech',...
            'that someone with hearing loss might hear.',... 
            ' ',...
            "Before starting the experiment, we're going to give",...
            'you several different examples to get your feet wet.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 4
        
        str.data = {"First, let's show you some examples of what mechanical",...
            'speech sounds like! On the next screen, select a word,',...
            'then press "Play" to hear what it sounds like.',...
            "We'll play it only to your right ear"};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 5
        
        hndl = get(gcf, 'UserData');
        hndl.npanel = hndl.npanel + 1;
        hndl.RunNum = 100;

        set(gcf, 'UserData', hndl);
        PhonoFus_Famil(hndl,npanel);
        
    case 6
        
        str.data = {"Great! Now we'll give you a quiz to make sure",...
            'you can understand the words.',...
            ' ',...
            'We will play the same word to both ears. Your job is to',...
            'choose the word that was played out of the options',...
            "on the next screen. If you're not sure, just guess.",...
            ' ',...
            "If anything is unclear or doesn't appear to be working,",...
            'please feel free to click the "Help" button',...
            'in the lefthand corner at any time.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 7
        
        %% Quiz 1: Vocoded words
        
        % Getting skipped??? FIX THIS
        
        hndl = get(gcf, 'UserData');
                        
        practicemat = GenPhonoFusTrials(hndl.PosWords,[100 100],1);
        practicemat = practicemat{1}(str2num(cat(1,practicemat{1}{:,2})) == 1,:);
        [~,ia] = unique(practicemat(:,7));
        practicemat = practicemat(ia,:);
        practicemat = practicemat(randperm(length(practicemat)),:);
        
        hndl.Conditions = cat(2,practicemat(:,7),... % left word index
            practicemat(:,8),... % right word index
            practicemat(:,2),... % trial type
            practicemat(:,3),... % DR left
            practicemat(:,4)); % DR right
        
        % Generate output file
        hndl.fid = fopen(sprintf('%s_Pretest1_Run%0.3d.out',hndl.SubID,hndl.RunNum),'w');
        if hndl.fid == -1
            error('Could not write output file!');
        end
        fprintf(hndl.fid,'ID,Run,Trial,Word1,Word2,nPresented,TrialType,VocLeft,VocRight,Resp1,Resp2,nResponded,TokenLeft,TokenRight,RTsec,PresWord1Text,PresWord2Text,RespWord1Text,RespWord2Text\n');
        
        hndl.npanel = hndl.npanel + 1;

        set(gcf, 'UserData', hndl);
        
        LoadStimulus;
        
        % Play stimulus
        hndl = get(gcf, 'UserData');
        sound(hndl.TrialStimulus,hndl.SRate);
        tic;
                
        % Pull up response screen
        PhonoFus_20AFC(hndl,1);
                
    case 8
        
        str.data = {"Excellent work! Now we're going to degrade the speech a bit.",...
            'It may be more difficult to understand this way. This is just',...
            'to familiarize you with what these words sound like.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 9
        
        str.data = {'We will play the same word to both ears. Your job is to',...
            'choose the word that was played out of the options',...
            "on the next screen. If you're not sure, just guess.",...
            ' ',...
            "If anything is unclear or doesn't appear to be working,",...
            'please feel free to click the "Help" button',...
            'in the lefthand corner at any time.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 10
        
        %% Quiz 2: Single words
        hndl = get(gcf, 'UserData');
        
        hndl.RunNum = 200;
        
        practicemat = GenPhonoFusTrials(hndl.PosWords,[40 40],1);
        practicemat = practicemat{1}(str2num(cat(1,practicemat{1}{:,2})) == 1,:);
        [~,ia] = unique(practicemat(:,7));
        practicemat = practicemat(ia,:);
        practicemat = practicemat(randperm(length(practicemat)),:);
        
        hndl.Conditions = cat(2,practicemat(:,7),... % left word index
            practicemat(:,8),... % right word index
            practicemat(:,2),... % trial type
            practicemat(:,3),... % DR left
            practicemat(:,4)); % DR right
        
        % Generate output file
        hndl.fid = fopen(sprintf('%s_Pretest2_Run%0.3d.out',hndl.SubID,hndl.RunNum),'w');
        if hndl.fid == -1
            error('Could not write output file!');
        end
        fprintf(hndl.fid,'ID,Run,Trial,Word1,Word2,nPresented,TrialType,VocLeft,VocRight,Resp1,Resp2,nResponded,TokenLeft,TokenRight,RTsec,PresWord1Text,PresWord2Text,RespWord1Text,RespWord2Text\n');
        
        
        hndl.npanel = hndl.npanel + 1;
        set(gcf, 'UserData', hndl);
        
        LoadStimulus;
        
        % Play stimulus
        hndl = get(gcf, 'UserData');
        sound(hndl.TrialStimulus,hndl.SRate);
        tic;
                
        % Pull up response screen
        PhonoFus_20AFC(hndl,1);
                
    case 11
        
        str.data = {"Great! Now we're going to start to play one or two words",...
            'at a time. To make things simpler, we will use normal speech.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 12
        
        str.data = {'We will play either the same or different words',...
            'to both ears. Your job is to choose the words that were played',... 
            'out of the options on the next screen.',... 
            "If you're not sure, just guess.",...
            ' ',...
            "If anything is unclear or doesn't appear to be working,",...
            'please feel free to click the "Help" button',...
            'in the lefthand corner at any time.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 13
        
        %% Quiz: 3 words
        hndl = get(gcf, 'UserData');
        
        hndl.RunNum = 300;
        
        practicemat = GenPhonoFusTrials(hndl.PosWords,[-1 -1],1);
        tmp1 = practicemat{1}(str2num(cat(1,practicemat{1}{:,2})) == 4,:);
        tmp2 = practicemat{1}(str2num(cat(1,practicemat{1}{:,2})) == 1,:);
        practicemat = cat(1,tmp1(randperm(length(tmp1),10),:),tmp2(randperm(length(tmp2),10),:));
        practicemat = practicemat(randperm(length(practicemat)),:);
        
        hndl.Conditions = cat(2,practicemat(:,7),... % left word index
            practicemat(:,8),... % right word index
            practicemat(:,2),... % trial type
            practicemat(:,3),... % DR left
            practicemat(:,4)); % DR right
                        
        % Generate output file
        hndl.fid = fopen(sprintf('%s_Pretest3_Run%0.3d.out',hndl.SubID,hndl.RunNum),'w');
        if hndl.fid == -1
            error('Could not write output file!');
        end
        fprintf(hndl.fid,'ID,Run,Trial,Word1,Word2,nPresented,TrialType,VocLeft,VocRight,Resp1,Resp2,nResponded,TokenLeft,TokenRight,RTsec,PresWord1Text,PresWord2Text,RespWord1Text,RespWord2Text\n');
        
        hndl.npanel = hndl.npanel + 1;
        
        set(gcf, 'UserData', hndl);
        
        LoadStimulus;

        % Play stimulus
        hndl = get(gcf, 'UserData');
        sound(hndl.TrialStimulus,hndl.SRate);
        tic;
        
        % Pull up response screen
        PhonoFus_20AFC(hndl,1);
        
    case 14
        
        str.data = {"Good job! Now you're ready to begin the longer part",...
            "of the experiment. You'll do the same thing:",... 
            ' ',...
            'Choose the 1 or 2 words you hear on each trial. They may be',...
            'normal or mechanical, and this may change on every new trial.',...
            'You will only be able to listen once, so listen carefully!'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 15
        %% Begin the experiment
        hndl = get(gcf, 'UserData');
        DRs = [-1 -1;100 100;100 60;60 60;60 40;100 40;40 40]; 
        hndl.nBlocks = 10; 
        
        % Generate experiment trials
        hndl.trialmat = GenPhonoFusTrials(hndl.PosWords,DRs,hndl.nBlocks);
        hndl.RunNum = 1;
        hndl.Conditions = cat(2,hndl.trialmat{hndl.RunNum}(:,7),... % left word index
            hndl.trialmat{hndl.RunNum}(:,8),... % right word index
            hndl.trialmat{hndl.RunNum}(:,2),... % trial type
            hndl.trialmat{hndl.RunNum}(:,3),... % DR left
            hndl.trialmat{hndl.RunNum}(:,4)); % DR right
        
        hndl.npanel = hndl.npanel + 1;
        
        set(gcf, 'UserData', hndl);
        
        RemotePhonoFus(16);
        
    case 16
                
        hndl = get(gcf, 'UserData');
        
        % Institute break
        str.data = {'Now is a great time for a break! Stretch your legs,',...
            'get some water, or use the bathroom.',...
            'Thanks for your hard work!',...
            ' ',...
            sprintf('%d tests of %d remaining',hndl.nBlocks - hndl.RunNum + 1,hndl.nBlocks),...
            ' ',...
            'When you are ready to begin the next test,',...
            'press "Next" below.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 17
        
        %% Left/Right check
        hndl = get(gcf,'UserData');
        LRCheck(hndl,1);
        
    case 18
        
        hndl = get(gcf,'UserData');
        LRCheck(hndl,2);
        
    case 19
             
        hndl = get(gcf, 'UserData');
        
        % Emergency save data
        save(sprintf('DataPreBlock%d.mat',hndl.RunNum));
        
        % Update conditions matrix
        hndl.Conditions = cat(2,hndl.trialmat{hndl.RunNum}(:,7),... % left word index
            hndl.trialmat{hndl.RunNum}(:,8),... % right word index
            hndl.trialmat{hndl.RunNum}(:,2),... % trial type
            hndl.trialmat{hndl.RunNum}(:,3),... % DR left
            hndl.trialmat{hndl.RunNum}(:,4)); % DR right
        
        % Checks
        if hndl.SRate ~= 44100
            error('Sampling rate incompatible with tablet!');
        end
        
        % Generate output file
        hndl.fid = fopen(sprintf('%s_Run%0.3d.out',hndl.SubID,hndl.RunNum),'w');
        if hndl.fid == -1
            error('Could not write output file!');
        end
        fprintf(hndl.fid,'ID,Run,Trial,Word1,Word2,nPresented,TrialType,VocLeft,VocRight,Resp1,Resp2,nResponded,TokenLeft,TokenRight,RTsec,PresWord1Text,PresWord2Text,RespWord1Text,RespWord2Text\n');
        
        hndl.npanel = 20 + hndl.panadj;
        
        set(gcf, 'UserData', hndl);
        
        LoadStimulus;
        
        hndl = get(gcf, 'UserData');
        
        % Play stimulus
        sound(hndl.TrialStimulus,hndl.SRate);
        % Start response clock
        tic;
        
        % Pull up response screen
        PhonoFus_20AFC(hndl,1);
        
    case 20
        %% Continue to next block or finish
        hndl = get(gcf, 'UserData');
        if hndl.RunNum > hndl.nBlocks
            hndl.npanel = 21 + hndl.panadj;
            set(gcf, 'UserData', hndl);
            RemotePhonoFus(21);
        else
            hndl.npanel = 16 + hndl.panadj;
            set(gcf, 'UserData', hndl);
            RemotePhonoFus(16);
        end
        
    case 21
        
        str.data = {"Great work! You've finished!",...
            ' ',...
            'Please re-pack the experimental equipment into the box',...
            'and wait for the experimenter to pick up the equipment,',...
            "or contact the experimenter to let them know you've",...
            'finished early.',...
            ' ',...
            'Thank you for your participation!'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
    case 22
        
        hndl = get(gcf, 'UserData');
        close(hndl.ExpFig);

end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Subfunctions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LoadStimulus

    hndl = get(gcf, 'UserData');

    % Initializations
    hndl.wordList = [];
    hndl.nWords = 0;
    hndl.Trial = 1;
    if str2num(hndl.Conditions{hndl.Trial,3}) == 1 % diotic trial
        hndl.Token = randperm(2);
    else
        hndl.Token = [randperm(2,1) randperm(2,1)]; % dichotic trial
    end
    
    % Load stimuli - a little clunky - this should be its own function
    if str2double(hndl.Conditions{1,5}) > 0 % Load vocoded
        vLeft = audioread(...
            [hndl.StimulusPath sprintf('Vocoded/%s depth/%s_%d_voc_16_of_16ch_LNN_e_600_comp_%s_s_0.wav',... % eventually ../Stimuli/Vocoded/%s depth/%s_voc_16_of_16ch_LNN_e_600_comp_%s_s_0_%d.wav
            hndl.Conditions{hndl.Trial,4},...
            hndl.PosWords{str2num(hndl.Conditions{hndl.Trial,1})},...
            hndl.Token(1),...
            hndl.Conditions{hndl.Trial,4})]); % add hndl.Tokens(1,1) here for any trial type
        vLeft = [vLeft vLeft];
    else % Load unprocessed
        yLeft = audioread([hndl.StimulusPath ...
            sprintf('%s_%d.wav',hndl.PosWords{str2num(hndl.Conditions{1,1})},hndl.Token(1))]);
        vLeft = [yLeft yLeft];
    end
    if str2double(hndl.Conditions{1,5}) > 0 % Load vocoded
        vRight = audioread(...
            [hndl.StimulusPath sprintf('Vocoded/%s depth/%s_%d_voc_16_of_16ch_LNN_e_600_comp_%s_s_0.wav',...
            hndl.Conditions{hndl.Trial,5},...
            hndl.PosWords{str2num(hndl.Conditions{hndl.Trial,2})},...
            hndl.Token(2),...
            hndl.Conditions{hndl.Trial,5})]);
        vRight = [vRight vRight]; 
    else % Load unprocessed
       yRight =  audioread([hndl.StimulusPath ...
            sprintf('%s_%d.wav',hndl.PosWords{str2num(hndl.Conditions{1,2})},hndl.Token(2))]);
       vRight = [yRight yRight];
    end
    
    hndl.TrialStimulus = AddTemporalRamps([vLeft(:,1) vRight(:,2)],...
        hndl.Ramp/1000,hndl.SRate,2);
    
    hndl.TrialStimulus(:,1) = (hndl.TrialStimulus(:,1) ./ ...
        rms(hndl.TrialStimulus(:,1))) * hndl.CalLeft;
    hndl.TrialStimulus(:,2) = (hndl.TrialStimulus(:,2) ./ ...
        rms(hndl.TrialStimulus(:,2))) * hndl.CalLeft;

        
    set(gcf, 'UserData', hndl);

end
