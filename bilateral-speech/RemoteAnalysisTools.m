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
% %                     accuracy = (subdat(:,2) == subdat(:,5)) | (subdat(:,4)==subdat(:,7)); %| (dat(:,2) == dat(:,6));
                    


                        acc = sum(accuracy)/length(accuracy);
                else % Two words
                    %% BOTH
                    accuracy = ((subdat(:,2) == subdat(:,5)) & (subdat(:,3) == subdat(:,6))) ... 
                        | ((subdat(:,2) == subdat(:,6)) & (subdat(:,3) == subdat(:,5)));
                    %% EITHER
% %                     accuracy = ((subdat(:,2) == subdat(:,5)) | (subdat(:,3) == subdat(:,6))) ... 
% %                         | ((subdat(:,2) == subdat(:,6)) | (subdat(:,3) == subdat(:,5)));
                    



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

        %         nwords = unique(dat(:,4));
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