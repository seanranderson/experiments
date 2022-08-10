function out = AddTemporalRamps(in,rftime,SRate,type)

% RFtime is in seconds

% takes column vector(s)
[m,n]=size(in);

% if length of columns greater than rows, assume transposition is necessary
if m < n
    in=in';
    temp=m;
    m=n;
    n=temp;
    disp('Warning: Please pass column vectors for multi-channel signals. Windowed transposed matrix. ');
end

NSamples = length(in(:,1));
NSamplesEdge = rftime*SRate;

steady = ones(1,NSamples-2*NSamplesEdge);

if type == 0 % linear
    front = linspace(0,1,NSamplesEdge);
elseif type == 1 % raised cosine, Hanning
    t = (1:NSamplesEdge);
    front = 0.5 * ( 1 - cos(pi*t/NSamplesEdge) );
elseif type == 2 % raised cosine, Hamming
    t = (1:NSamplesEdge);
    front = 0.54 - 0.46 * cos(pi*t/NSamplesEdge);
elseif type == 3 % Gaussian Window
    t = (1:NSamplesEdge);
    sigma = 0.5;
    front = exp( -0.5*( (t - (NSamplesEdge - 1)) / (sigma*(NSamplesEdge - 1)/2) ).^2 );
end
back = front;
back(:) = front(end:-1:1);
TempEnv = [front,steady,back]';

for ii = 1:n
    out(:,ii) = TempEnv .* in(:,ii);
end