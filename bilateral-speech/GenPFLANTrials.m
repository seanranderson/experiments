function [trialmat,block_idx] = GenPhonoFusTrials(Words,DRs,nBlocks)
%% This function generates the trial structure for the PFLAN experiment. 
% 
% It takes two inputs:
%   Words is a cell of strings (words) used in the experiment
%       Assumptions: Corpus is arranged in groups of five in the following
%       order: stop consonant, liquid 1, liquid 1, stop + liquid cluster 1,
%       stop + liquid cluster 2
%   DRs is a n x 2 cell of values for dynamic range, though the code will 
%   generate an output for any n x 2 cell.
% 
% The output is a 2 x n cell of word pairs for experimental trials. The
% code is written such that word pairs are balanced for three stimulus sets
% (i.e., three vowels; with approx 150 trials per trial type). 
% 
% Sean R. Anderson - 071621 - sean.hearing@gmail.com

    nrow = 1 : (length(Words) / 5); % AKA number of stimulus sets
    
    %% Type 1 trials = same word
    DioticTrials.str = repmat(Words', 10, 2);
    for ii = 1:length(Words)
        DioticTrials.num{ii} = num2str(ii);
    end
    DioticTrials.num = repmat(DioticTrials.num', 10, 2);
    
    %% Type 2 trials = same vowels/phonological fusion
    n = 0;
    for ii = nrow
        for jj = 2:3 % /l/ and /r/
            n = n + 1;
            TrueFus.str{n,1} = Words{1 + (ii - 1) * 5};
            TrueFus.str{n,2} = Words{jj + (ii - 1) * 5};
            TrueFus.num{n,1} = num2str(1 + (ii - 1) * 5);
            TrueFus.num{n,2} = num2str(jj + (ii - 1) * 5);
            
            n = n + 1;
            TrueFus.str{n,1} = Words{jj + (ii - 1) * 5};
            TrueFus.str{n,2} = Words{1 + (ii - 1) * 5};
            TrueFus.num{n,1} = num2str(jj + (ii - 1) * 5);
            TrueFus.num{n,2} = num2str(1 + (ii - 1) * 5);
        end
    end
    TrueFus.str = repmat(TrueFus.str, 5, 1); % 5 reps each (balanced L/R)
    TrueFus.num = repmat(TrueFus.num, 5, 1); % 5 reps each (balanced L/R)
    n = 0;
    % All other possible pairings
    for ii = nrow
        n = n + 1;
        Rhyming.str{n,1} = Words{1 + (ii - 1) * 5}; Rhyming.num{n,1} = num2str(1 + (ii - 1) * 5);
        Rhyming.str{n,2} = Words{4 + (ii - 1) * 5}; Rhyming.num{n,2} = num2str(4 + (ii - 1) * 5);
        n = n + 1;
        Rhyming.str{n,1} = Words{1 + (ii - 1) * 5}; Rhyming.num{n,1} = num2str(1 + (ii - 1) * 5);
        Rhyming.str{n,2} = Words{5 + (ii - 1) * 5}; Rhyming.num{n,2} = num2str(5 + (ii - 1) * 5);
        n = n + 1;
        Rhyming.str{n,1} = Words{2 + (ii - 1) * 5}; Rhyming.num{n,1} = num2str(2 + (ii - 1) * 5);
        Rhyming.str{n,2} = Words{3 + (ii - 1) * 5}; Rhyming.num{n,2} = num2str(3 + (ii - 1) * 5);
        n = n + 1;
        Rhyming.str{n,1} = Words{2 + (ii - 1) * 5}; Rhyming.num{n,1} = num2str(2 + (ii - 1) * 5);
        Rhyming.str{n,2} = Words{4 + (ii - 1) * 5}; Rhyming.num{n,2} = num2str(4 + (ii - 1) * 5);
        n = n + 1;
        Rhyming.str{n,1} = Words{2 + (ii - 1) * 5}; Rhyming.num{n,1} = num2str(2 + (ii - 1) * 5);
        Rhyming.str{n,2} = Words{5 + (ii - 1) * 5}; Rhyming.num{n,2} = num2str(5 + (ii - 1) * 5);
        n = n + 1;
        Rhyming.str{n,1} = Words{3 + (ii - 1) * 5}; Rhyming.num{n,1} = num2str(3 + (ii - 1) * 5);
        Rhyming.str{n,2} = Words{4 + (ii - 1) * 5}; Rhyming.num{n,2} = num2str(4 + (ii - 1) * 5);
        n = n + 1;
        Rhyming.str{n,1} = Words{3 + (ii - 1) * 5}; Rhyming.num{n,1} = num2str(3 + (ii - 1) * 5);
        Rhyming.str{n,2} = Words{5 + (ii - 1) * 5}; Rhyming.num{n,2} = num2str(5 + (ii - 1) * 5);
        n = n + 1;
        Rhyming.str{n,1} = Words{4 + (ii - 1) * 5}; Rhyming.num{n,1} = num2str(4 + (ii - 1) * 5);
        Rhyming.str{n,2} = Words{5 + (ii - 1) * 5}; Rhyming.num{n,2} = num2str(5 + (ii - 1) * 5);
    end
    nrhymes = length(Rhyming.str);
    for ii = 1:nrhymes
        Rhyming.str{ii + nrhymes,1} = Rhyming.str{ii,2};
        Rhyming.str{ii + nrhymes,2} = Rhyming.str{ii,1};
        Rhyming.num{ii + nrhymes,1} = Rhyming.num{ii,2};
        Rhyming.num{ii + nrhymes,2} = Rhyming.num{ii,1};
    end
    Rhyming.str = repmat(Rhyming.str, 2, 1); % 2 reps each (balanced L/R)
%     FusionTrials.str = cat(2, TrueFus.str, Rhyming.str);
    Rhyming.num = repmat(Rhyming.num, 2, 1); % 2 reps each (balanced L/R)
%     FusionTrials.num = cat(2, TrueFus.num, Rhyming.num);
    
    %% Type 3 trials = diff vowels
    
    n = 0; DichoticTrials.str = [];
    for ii = 1:length(Words)
        row = floor((ii-1)/5)+1;%mod(ii-1,4)+1;
        for jj = (nrow(row ~=nrow))
            for kk = 1:5
                n = n + 1;
                DichoticTrials.str{n,1} = Words{ii};
                DichoticTrials.str{n,2} = Words{kk + (jj-1) * 5};
                DichoticTrials.num{n,1} = num2str(ii);
                DichoticTrials.num{n,2} = num2str(kk + (jj-1) * 5);
            end
        end
    end

%% Balance trials and reps across blocks
    ntrials = size(DRs,1) * (length(DioticTrials.str) + length(TrueFus.str) + ...
        length(Rhyming.str) + length(DichoticTrials.str));
    trialsperblock = ntrials / nBlocks;
    % Option 1: Shuffle all trials
    trialsperDR = trialsperblock / (size(DRs,1) * 3); % for 3 trial types
        % Generate idxs for each trial type for each DR
    for ii = 1:size(DRs,1)
        DR_trial_Diotic_idx(ii,:) = randperm( length( DioticTrials.str));
        DR_trial_TrueFus_idx(ii,:) = randperm( length( TrueFus.str));
        DR_trial_Rhyming_idx(ii,:) = randperm( length( Rhyming.str));
        DR_trial_Dichotic_idx(ii,:) = randperm( length( DichoticTrials.str));
    end
        % Subset idxs according to nblocks and combine into matrix
    for ii = 1:nBlocks
        for jj = 1:size(DRs,1)
            % break into blocks
            if ii == nBlocks
                % include all remaining trials
                DioticChunk.str = DioticTrials.str(DR_trial_Diotic_idx(jj,...
                        floor( length( DioticTrials.str) / nBlocks) * (ii-1) + 1 : end),:);
                TrueFusChunk.str = TrueFus.str(DR_trial_TrueFus_idx(jj,...
                        floor( length( TrueFus.str) / nBlocks) * (ii-1) + 1 : end),:); 
                RhymingChunk.str = Rhyming.str(DR_trial_Rhyming_idx(jj,...
                        floor( length( Rhyming.str) / nBlocks) * (ii-1) + 1 : end),:); 
                DichoticChunk.str = DichoticTrials.str(DR_trial_Dichotic_idx(jj,...
                        floor( length( DichoticTrials.str) / nBlocks) * (ii-1) + 1 : end),:); 
                    
                DioticChunk.num = DioticTrials.num(DR_trial_Diotic_idx(jj,...
                        floor( length( DioticTrials.num) / nBlocks) * (ii-1) + 1 : end),:);
                TrueFusChunk.num = TrueFus.num(DR_trial_TrueFus_idx(jj,...
                        floor( length( TrueFus.num) / nBlocks) * (ii-1) + 1 : end),:); 
                RhymingChunk.num = Rhyming.num(DR_trial_Rhyming_idx(jj,...
                        floor( length( Rhyming.num) / nBlocks) * (ii-1) + 1 : end),:); 
                DichoticChunk.num = DichoticTrials.num(DR_trial_Dichotic_idx(jj,...
                        floor( length( DichoticTrials.num) / nBlocks) * (ii-1) + 1 : end),:); 
            else
                DioticChunk.str = DioticTrials.str(DR_trial_Diotic_idx(jj,...
                        floor( length( DioticTrials.str) / nBlocks) * (ii-1) + 1 : ... 
                        floor( length( DioticTrials.str) / nBlocks) * ii),:);
                TrueFusChunk.str = TrueFus.str(DR_trial_TrueFus_idx(jj,...
                        floor( length( TrueFus.str) / nBlocks) * (ii-1) + 1 : ... 
                        floor( length( TrueFus.str) / nBlocks) * ii),:);
                RhymingChunk.str = Rhyming.str(DR_trial_Rhyming_idx(jj,...
                        floor( length( Rhyming.str) / nBlocks) * (ii-1) + 1 : ... 
                        floor( length( Rhyming.str) / nBlocks) * ii),:);
                DichoticChunk.str = DichoticTrials.str(DR_trial_Dichotic_idx(jj,...
                        floor( length( DichoticTrials.str) / nBlocks) * (ii-1) + 1 : ... 
                        floor( length( DichoticTrials.str) / nBlocks) * ii),:);
                
                DioticChunk.num = DioticTrials.num(DR_trial_Diotic_idx(jj,...
                        floor( length( DioticTrials.num) / nBlocks) * (ii-1) + 1 : ... 
                        floor( length( DioticTrials.num) / nBlocks) * ii),:);
                TrueFusChunk.num = TrueFus.num(DR_trial_TrueFus_idx(jj,...
                        floor( length( TrueFus.num) / nBlocks) * (ii-1) + 1 : ... 
                        floor( length( TrueFus.num) / nBlocks) * ii),:);
                RhymingChunk.num = Rhyming.num(DR_trial_Rhyming_idx(jj,...
                        floor( length( Rhyming.num) / nBlocks) * (ii-1) + 1 : ... 
                        floor( length( Rhyming.num) / nBlocks) * ii),:);
                DichoticChunk.num = DichoticTrials.num(DR_trial_Dichotic_idx(jj,...
                        floor( length( DichoticTrials.num) / nBlocks) * (ii-1) + 1 : ... 
                        floor( length( DichoticTrials.num) / nBlocks) * ii),:);
            end
            
            % Output: Block, PairType, DRleft, DRright, StimLeft, StimRight
            if jj == 1
                trialmat{ii} = cat(2,...
                    cat(1,repmat(cat(2,{num2str(ii)},{num2str(1)},{num2str(DRs(jj,1))},{num2str(DRs(jj,2))}), length(DioticChunk.str), 1),...
                    repmat(cat(2,{num2str(ii)},{num2str(2)},{num2str(DRs(jj,1))},{num2str(DRs(jj,2))}), length(TrueFusChunk.str), 1),...
                    repmat(cat(2,{num2str(ii)},{num2str(3)},{num2str(DRs(jj,1))},{num2str(DRs(jj,2))}), length(RhymingChunk.str), 1),...
                    repmat(cat(2,{num2str(ii)},{num2str(4)},{num2str(DRs(jj,1))},{num2str(DRs(jj,2))}), length(DichoticChunk.str), 1)),...
                    cat(1,DioticChunk.str, TrueFusChunk.str, RhymingChunk.str, DichoticChunk.str),...
                    cat(1,DioticChunk.num, TrueFusChunk.num, RhymingChunk.num, DichoticChunk.num));
            else
                trialmat{ii} = cat(1,trialmat{ii},cat(2,...
                    cat(1,repmat(cat(2,{num2str(ii)},{num2str(1)},{num2str(DRs(jj,1))},{num2str(DRs(jj,2))}), length(DioticChunk.str), 1),...
                    repmat(cat(2,{num2str(ii)},{num2str(2)},{num2str(DRs(jj,1))},{num2str(DRs(jj,2))}), length(TrueFusChunk.str), 1),...
                    repmat(cat(2,{num2str(ii)},{num2str(3)},{num2str(DRs(jj,1))},{num2str(DRs(jj,2))}), length(RhymingChunk.str), 1),...
                    repmat(cat(2,{num2str(ii)},{num2str(4)},{num2str(DRs(jj,1))},{num2str(DRs(jj,2))}), length(DichoticChunk.str), 1)),...
                    cat(1,DioticChunk.str, TrueFusChunk.str, RhymingChunk.str, DichoticChunk.str),...
                    cat(1,DioticChunk.num, TrueFusChunk.num, RhymingChunk.num, DichoticChunk.num)));
            end
            
        end
        
        % Shuffle trials in block
        shuff_idx = randperm(length(trialmat{ii}));
        trialmat{ii} = trialmat{ii}(shuff_idx,:);
        
    end
    
    % Option 2: Test same trials in each block

end

