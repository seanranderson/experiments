function GenGUI(str,img,btn)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data and clear existing figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    hndl = get(gcf, 'UserData');
    clf(hndl.ExpFig);
    hndl.npanel = hndl.npanel + 1;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate text, images, and buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    uicontrol('Style','text',...
        'String',str.data, ...
        'backgroundcolor',hndl.colors.gray,...
        'FontSize',1,...
        'FontUnits','normalized',...
        'Units', 'normalized', 'Position',[str.pos str.siz],...
        'HorizontalAlignment','Center');
    
    if exist('img','var')
        if ~isempty(img)
            h = subplot(2, 1, 2);
            h.Position = h.Position + [img.pos];
            imshow(imread(img.filename,img.type));
            axis off;
        end
    end
    
    if exist('btn','var')
        if ~isempty(btn)
            for ii = 1:btn.n
                eval(sprintf(strcat("hndl.ExpButtons.%s = ",...
                    "uicontrol('Style', 'pushbutton', 'String', '%s',",...
                    "'FontWeight', 'bold',",...
                    "'FontSize', 8,",...
                    "'FontUnits','normalized',",...
                    "'backgroundcolor',hndl.colors.%s,",...
                    "'callback',{@%s,hndl.npanel},",...
                    "'Units', 'normalized',",...
                    "'Position',[%0.3f %0.3f %0.3f %0.3f]);"),...
                    btn.string{ii},btn.string{ii},...
                    btn.color{ii},btn.callback{ii},...
                    btn.pos{ii}(1),btn.pos{ii}(2),...
                    btn.siz{ii}(1),btn.siz{ii}(2)));
            end
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Next and help buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    hndl.ExpButtons.Next = uicontrol('Style', 'pushbutton', 'String', 'Next', ...
        'FontWeight', 'bold', ...
        'FontSize', 8, ...
        'FontUnits','normalized',...
        'backgroundcolor',[1 0.1 0.1], ...
        'callback',{@WelcomeScreenHomeDelivery,hndl.npanel}, ...
        'Units', 'normalized', 'Position',[0.885,0.1,0.1,0.052]);

    hndl.ExpButtons.GetHelp = uicontrol('Style', 'pushbutton', 'String', 'Help', ...
        'FontWeight', 'bold', ...
        'FontSize', 8, ...
        'FontUnits','normalized',...
        'backgroundcolor',[1 0.1 0.1], ...
        'callback',{@Help,0}, ...
        'Units', 'normalized', 'Position',[0.115,0.1,0.1,0.052]);

    set(gcf, 'UserData', hndl);
    
end