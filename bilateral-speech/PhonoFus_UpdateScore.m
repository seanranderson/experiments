function PhonoFus_UpdateScore

    hndl = get(gcf, 'UserData'); % get variables structure
        
    % Record response time
    hndl.ResponseTime = toc;
    
    % Take in response
    hndl.Response(hndl.Trial,1) = cellstr(num2str(hndl.wordList(1)));
    if length(hndl.wordList) == 2
        hndl.Response(hndl.Trial,2) = cellstr(num2str(hndl.wordList(2)));
        hndl.Response(hndl.Trial,3) = cellstr('2');
    elseif length(hndl.wordList) == 1
        hndl.Response(hndl.Trial,2) = cellstr('0');
        hndl.Response(hndl.Trial,3) = cellstr('1');
    end
    
    % Record response
    if strcmp(hndl.Conditions{hndl.Trial,3},'0') || strcmp(hndl.Conditions{hndl.Trial,3},'1')
        nWords = 1;
    elseif strcmp(hndl.Conditions{hndl.Trial,3},'2') || strcmp(hndl.Conditions{hndl.Trial,3},'3') || ...
            strcmp(hndl.Conditions{hndl.Trial,3},'4')
        nWords = 2;
    end
    
    % Update progress bar
    uicontrol('Style','text','String','', ...
        'FontWeight', 'bold', ...
        'backgroundcolor',hndl.colors.orange,...
        'FontSize',10,...
        'Units', 'normalized',...
        'Position',[0.05 0.675 ...
        0.9*hndl.Trial/size(hndl.Conditions,1) 0.05]);
    
    % Store word(s) reported
    PresWord1Text = hndl.PosWords{str2num(hndl.Conditions{hndl.Trial,1})};
    PresWord2Text = hndl.PosWords{str2num(hndl.Conditions{hndl.Trial,2})};
    RespWord1Text = hndl.PosWords{str2num(hndl.Response{hndl.Trial,1})};
    if str2num(hndl.Response{hndl.Trial,2}) == 0
        RespWord2Text = '';
    else
        RespWord2Text = hndl.PosWords{str2num(hndl.Response{hndl.Trial,2})};
    end

    % Write output to text file
    fprintf(hndl.fid,'%s,%d,%d,%s,%s,%d,%s,%s,%s,%s,%s,%s,%d,%d,%0.2f,%s,%s,%s,%s\n',...
        hndl.SubID,hndl.RunNum,hndl.Trial,...
        hndl.Conditions{hndl.Trial,1:2},nWords,...
        hndl.Conditions{hndl.Trial,3:end},hndl.Response{hndl.Trial,:},...
        hndl.Token(1),hndl.Token(2),hndl.ResponseTime,...
        PresWord1Text,PresWord2Text,RespWord1Text,RespWord2Text);
    
    % Check if finished
    hndl.wordList = [];
    hndl.nWords = 0;
    set(hndl.ExpButtons.Submit,'BackgroundColor',[1 1 1]);        
    set(hndl.ExpButtons.Submit,'Enable','off');
    hndl.Trial = hndl.Trial + 1;
    set(gcf, 'UserData', hndl);

    if hndl.Trial > size(hndl.Conditions,1)
        
         % End the experiment, write output
        fclose(hndl.fid);
        hndl.RunNum = hndl.RunNum + 1;
        set(gcf, 'UserData', hndl);
        
        % Pretest checks
            % 100% DR vocoded
        if hndl.RunNum >= 100 && hndl.RunNum < 200
            
            if sum(cellfun(@str2num,hndl.Response(:,1)) == ...
                    cellfun(@str2num,hndl.Conditions(:,1))) / ...
                    (hndl.Trial - 1) < 0.7
                
                hndl.npanel = hndl.npanel - 2;
                set(gcf, 'UserData', hndl);

                % Ask listener to try again
                str.data = {'Hmm... It looks like there was a problem.'...
                    ' ',...
                    'These words can be hard to understand. We want to make',...
                    'sure that before we continue, the "mechanical" speech',...
                    'makes sense to you.',...
                    ' ',...
                    "Let's give the practice one more try.",...
                    ' ',...
                    'If you are having technical issues, please contact the',...
                    'experimenter with the instructions you received or',... 
                    'press the "Help" button on the bottom left.',...
                    ' ',...
                    'If you are ready to try again, click the "Next" button below.'};
                str.pos = [0.2 0.3];
                str.siz = [0.6 0.35];

                GenGUI(str);
                
            else
                
                RemotePFLAN(hndl.npanel - hndl.panadj);
                
            end
            
            % 40% DR vocoded
        elseif hndl.RunNum >= 200 && hndl.RunNum < 300
            % No checks, just report results
            
            RemotePFLAN(hndl.npanel - hndl.panadj);
            
            % 1 vs. 2 words, natural speech
        elseif hndl.RunNum >= 300
            if sum(cellfun(@str2num,hndl.Response(:,3)) == 2) / (hndl.Trial - 1) > 0.8
                
                hndl.npanel = hndl.npanel - 2;
                set(gcf, 'UserData', hndl);

                % Ask listener to try again
                str.data = {'Hmm... It looks like there was a problem.',...
                    ' ',...
                    'Some trials played the same word in both ears,',...
                    'and others played different words to each ear.',...
                    'It seems like most of your responses were 2 words,',...
                    'with too few 1 word responses.',...
                    ' ',...
                    "Let's give the practice one more try.",...
                    ' ',...
                    'If you are having technical issues, please contact the',...
                    'experimenter with the instructions you received or',... 
                    'press the "Help" button on the bottom left.',...
                    ' ',...
                    'If you are ready to try again, click the "Next" button below.'};
                str.pos = [0.2 0.3];
                str.siz = [0.6 0.35];

                GenGUI(str);
                
            elseif sum(cellfun(@str2num,hndl.Response(:,3)) == 1) / hndl.Trial > 0.8
                
                hndl.npanel = hndl.npanel - 2;
                set(gcf, 'UserData', hndl);

                % Ask listener to try again
                str.data = {'Hmm... It looks like there was a problem.',...
                    ' ',...
                    'Some trials played the same word in both ears,',...
                    'and others played different words to each ear.',...
                    'It seems like most of your responses were 1 word,',...
                    'with too few 2 word responses.',...
                    ' ',...
                    "Let's give the practice one more try.",...
                    ' ',...
                    'If you are having technical issues, please contact the',...
                    'experimenter with the instructions you received or',... 
                    'press the "Help" button on the bottom left.',...
                    ' ',...
                    'If you are ready to try again, click the "Next" button below.'};
                str.pos = [0.2 0.3];
                str.siz = [0.6 0.35];

                GenGUI(str);
                
            else 
                
                RemotePFLAN(hndl.npanel - hndl.panadj);
                
            end
            
        else
            
            RemotePFLAN(hndl.npanel - hndl.panadj);
            
        end
    else

        % Load in next stimulus
        if str2num(hndl.Conditions{hndl.Trial,3}) == 1 % diotic trial
            hndl.Token = randperm(2);
        else
            hndl.Token = [randperm(2,1) randperm(2,1)]; % dichotic trial
        end
        
        % Load stimuli - a little clunky - this should be its own function
        if str2double(hndl.Conditions{hndl.Trial,5}) > 0 % Load vocoded
            vLeft = audioread(...
                [hndl.StimulusPath sprintf('Vocoded/%s depth/%s_%d_voc_16_of_16ch_LNN_e_600_comp_%s_s_0.wav',... % eventually ../Stimuli/Vocoded/%s depth/%s_voc_16_of_16ch_LNN_e_600_comp_%s_s_0_%d.wav
                hndl.Conditions{hndl.Trial,4},...
                hndl.PosWords{str2num(hndl.Conditions{hndl.Trial,1})},...
                hndl.Token(1),...
                hndl.Conditions{hndl.Trial,4})]); % add hndl.Tokens(1,1) here for any trial type
            vLeft = [vLeft vLeft];
        else % Load unprocessed
            yLeft = audioread([hndl.StimulusPath ...
                sprintf('%s_%d.wav',hndl.PosWords{str2num(hndl.Conditions{hndl.Trial,1})},hndl.Token(1))]);
            vLeft = [yLeft yLeft];
        end
        if str2double(hndl.Conditions{hndl.Trial,5}) > 0 % Load vocoded
            vRight = audioread(...
                [hndl.StimulusPath sprintf('Vocoded/%s depth/%s_%d_voc_16_of_16ch_LNN_e_600_comp_%s_s_0.wav',...
                hndl.Conditions{hndl.Trial,5},...
                hndl.PosWords{str2num(hndl.Conditions{hndl.Trial,2})},...
                hndl.Token(2),...
                hndl.Conditions{hndl.Trial,5})]);
            vRight = [vRight vRight]; 
        else % Load unprocessed
            yRight =  audioread([hndl.StimulusPath ...
                sprintf('%s_%d.wav',hndl.PosWords{str2num(hndl.Conditions{hndl.Trial,2})},hndl.Token(2))]);
            vRight = [yRight yRight];
        end

        vLeft = resample(vLeft,hndl.SRate,44100);
        vRight = resample(vRight,hndl.SRate,44100);
    
        hndl.TrialStimulus = AddTemporalRamps([vLeft(:,1) vRight(:,2)],...
            hndl.Ramp/1000,hndl.SRate,2);

        hndl.TrialStimulus(:,1) = (hndl.TrialStimulus(:,1) ./ ...
            rms(hndl.TrialStimulus(:,1))) * hndl.CalLeft;
        hndl.TrialStimulus(:,2) = (hndl.TrialStimulus(:,2) ./ ...
            rms(hndl.TrialStimulus(:,2))) * hndl.CalLeft;

        % Play out
        sound(hndl.TrialStimulus,hndl.SRate);
        tic; % begin response clock
        set(gcf, 'UserData', hndl);
    end
end
