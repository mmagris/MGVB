wd = '\\uni.au.dk\Users\au477086\Desktop\Scripts_Mostafa';
cd(wd)
addpath(genpath(wd))
rmpath(genpath(fullfile('VBLab/VB/EMGVB')))
rmpath(genpath(fullfile('Temp')))

clear
clc
%%
seed = 1;
rng(seed)

x = rand(10000,3);
[~,y_prob] = predict_glm(x,[0.3;-1;2],0.1);

y = binornd(1,y_prob);

data = [y,x];


glmfit(x,y,'binomial')

data(1:7000,:);

%%

rng(seed)
r = rand(4,4);
r = r*r';

clc

setting.Prior.Mu        = 0;
setting.Prior.Sig       = 1;
setting.Block.blks      = [1,1,1,1];
setting.useHfunc        = 0;


rng(seed)
bMGVB.out = MGVBb(@h_func_b_logistic,data,...
    'NumParams',4,...
    'Setting',setting,...
    'LearningRate',0.025,...
    'NumSample',80,...
    'MaxPatience',15000,...
    'MaxIter',10,...
    'GradWeight',0.4,...
    'WindowSize',30,...
    'SigInitScale',0.01,...
    'StepAdaptive',10000,...
    'GradientMax',20000,...
    'GradClipInit',100,...
    'SaveParams',true,...
    'Verbose',2,...
    'LBPlot',true);




%% Use full/diagonal code

% clc

setting.isDiag          = 0;

rng(seed)
pMGVB.out = MGVBm(@h_func_m,data,...
    'NumParams',4,...
    'Setting',setting,...
    'LearningRate',0.025,...
    'NumSample',80,...
    'MaxPatience',15000,...
    'MaxIter',100,...
    'GradWeight',0.4,...
    'WindowSize',30,...
    'SigInitScale',0.01,...
    'StepAdaptive',10000,...
    'GradientMax',20000,...
    'GradClipInit',100,...
    'SaveParams',true,...
    'Verbose',2,...
    'LBPlot',false);


%%

use = bMGVB.out.Post;

mu = use.mu;
s  = use.Sig;

tab_mu = [mu(1:3),p(1:3)];

fm = @(m,s) exp(m+s/2);
tab_s = [fm(mu(4),s(4,1)),p(end)];

array2table([tab_mu;tab_s],'VariableNames',{'Estimated','True'})

plot(use.iter.mu)
hold on
plot(exp(use.iter.mu(:,end)),'r')
hold off




