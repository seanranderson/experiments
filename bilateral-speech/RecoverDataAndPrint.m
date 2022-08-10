
hndl.fid = fopen('test_recovery.txt','w');
for ii = 1:length(hndl.Response)

    
    % Record response
    if strcmp(hndl.Conditions{hndl.Trial,3},'0') || strcmp(hndl.Conditions{hndl.Trial,3},'1')
        nWords = 1;
    elseif strcmp(hndl.Conditions{hndl.Trial,3},'2') || strcmp(hndl.Conditions{hndl.Trial,3},'3') || ...
            strcmp(hndl.Conditions{hndl.Trial,3},'4')
        nWords = 2;
    end

    
    PresWord1Text = hndl.PosWords{str2num(hndl.Conditions{ii,1})};
    PresWord2Text = hndl.PosWords{str2num(hndl.Conditions{ii,2})};
    RespWord1Text = hndl.PosWords{str2num(hndl.Response{ii,1})};
    if str2num(hndl.Response{ii,2}) == 0
        RespWord2Text = '';
    else
        RespWord2Text = hndl.PosWords{str2num(hndl.Response{ii,2})};
    end

    
    % fprintf(hndl.fid,'ID,Run,Trial,Word1,Word2,nPresented,TrialType,VocLeft,VocRight,Rho,ILD,Resp1,Resp2,nResponsed,LeftToken,RightToken,RTimeSec,PresWord1Text,PresWord2Text,RespWord1Text,RespWord2Text\n');
    fprintf(hndl.fid,'%s,%d,%d,%s,%s,%d,%s,%s,%s,%s,%s,%s,%d,%d,%0.2f,%s,%s,%s,%s\n',...
        hndl.SubID,hndl.RunNum,ii,...
        hndl.Conditions{ii,1:2},nWords,...
        hndl.Conditions{ii,3:end},hndl.Response{ii,:},...
        hndl.Token(1),hndl.Token(2),hndl.ResponseTime,...
        PresWord1Text,PresWord2Text,RespWord1Text,RespWord2Text);

end

fclose(fid);