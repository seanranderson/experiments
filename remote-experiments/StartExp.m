function StartExp(npanel)
% This is a generic function to add the desired path to the experimental
% code. Replace the section below with correct paths and functions.
% 
% Sean R. Anderson - sean.hearing@gmail.com

    addpath('../bilateral-speech/');
    addpath('../bilateral-speech/stimuli');
    RemotePhonoFus(npanel);

end
