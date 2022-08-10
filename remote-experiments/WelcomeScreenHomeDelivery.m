% This function executes a protocol to orient the participant to how they 
% will receive instructions and confirm that home delivery equipment is 
% set up correctly.
% 
% Sean R. Anderson - sean.hearing@gmail.com

function WelcomeScreenHomeDelivery(~,~,npanel)

addpath(genpath('experiment protocols'));
addpath('Audiogram');

%% Initialize variables
if ~exist('npanel','var')    
    hndl.ExpFig = figure('name','Experiment Dialogue',...
        'numbertitle','off',...
        'MenuBar','none',...
        'Visible','on','Units','normalized','Position',[0.,0.,1,1]);

    %% Hard-coded experimental variables
    hndl.SubID = 'AAA';
    hndl.DataPath = './';
    
    % COLORS
    % Hex colors for buttons/backgrounds
    hndl.npanel = 1;
    npanel = hndl.npanel;
    hndl.colors.white=[1 1 1];
    hndl.colors.green = [0.5 1 0.25];
    hndl.colors.blue = [0.5 0.5 1];
    hndl.colors.red = [1 0.25 0.25];
    hndl.colors.gray = [0.8 0.8 0.8];
    hndl.colors.orange = [0.947 0.686 0.098];
    hndl.colors.gray = [0.937254902 0.937254902 0.937254902];
    hndl.HeadphoneTries = 0;
    hndl.LRChecks = 0;

    set(gcf, 'UserData', hndl);
end

switch npanel
    case 1
        %% Hard-coded variables for experiment
        hndl = get(gcf,'UserData');
        set(gcf, 'UserData', hndl);
        
        %% Welcome panel
        str.data = {'Welcome!',...
            'Thank you for agreeing to participate in our experiment.',...
            ' ',...
            'Before we begin,'...
            'please ensure that you are in a quiet, private place,',...
            'comfortably positioned to work until the end of your appointment.',...
            ' ',...
            'When you are ready, click the "Next" button below.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);

    case 2
        %% Check setup
        str.data = {'Next, we need to ensure that the equipment is set up correctly.',...
            'Please confirm that the equipment looks like the picture below,'...
            'and that all necessary pieces are powered on.',...
            'When this is complete, click the "Next" button below.'};
        str.pos = [0.2 0.55];
        str.siz = [0.6 0.35];
        
        img.filename = 'HomeDeliveryCheck.png';
        img.type = 'png';
        img.pos = [0 0 0 0.1];
        
        GenGUI(str,img);
    case 3
        %% Begin
        str.data = {"Looks like you're ready to begin!",...
            ' ',...
            'Next, we will do some equipment and hearing checks.'...
            'If anything is unclear',...
            'please press the "Help" button on the bottom left.',...
            ' ',...
            'When you are ready, click the "Next" button below.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
    case 4
        %% Headphone screening (based on Woods et al., 2017)
        hndl = get(gcf,'UserData');
        HeadphoneScreening(hndl,1);
    case 5
        hndl = get(gcf,'UserData');
        HeadphoneScreening(hndl,2);
    case 6
        %% Left/Right check
        hndl = get(gcf,'UserData');
        LRCheck(hndl,1);
    case 7
        hndl = get(gcf,'UserData');
        LRCheck(hndl,2);
    case 8
        %% Audiogram
        hndl = get(gcf,'UserData');
        hndl.panadj = npanel - 1;
        set(gcf,'UserData',hndl);
        Audiogram(hndl,npanel - hndl.panadj);
    case 9
        hndl = get(gcf,'UserData');
        Audiogram(hndl,npanel - hndl.panadj);
        hndl = get(gcf,'UserData');
        hndl.panadj = npanel;
        set(gcf,'UserData',hndl);
    case 10
        %% Begin
        str.data = {"Looks like you're ready to begin the experiment!",...
            ' ',...
            'Next, we will take you through a tutorial',...
            'for this experiment. If anything is unclear',...
            'please press the "Help" button on the bottom left.',...
            ' ',...
            'When you are ready, click the "Next" button below.'};
        str.pos = [0.2 0.3];
        str.siz = [0.6 0.35];

        GenGUI(str);
        
        hndl = get(gcf,'UserData');
        hndl.panadj = npanel;
        set(gcf,'UserData',hndl);
    otherwise
        %% Begin experimental protocol
        hndl = get(gcf,'UserData');
        StartExp(npanel - hndl.panadj);
end
