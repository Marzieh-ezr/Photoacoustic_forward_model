function [S_model_processed, S_exp_processed] =processsignals_alternative(S_model,S_exp, Model, Medium, Geometry)

global X_exp
global X_model

global X_exp_pos
global X_model_pos
global Y_exp_pos
global Y_model_pos

size_model=size(S_model);
size_exp=size(S_exp);

% synchronize sample rates of experimental and simulated signal.
[num,dem]=rat(Model.sample_rate_model./Model.sample_rate_exp);
if size_model(1,2)<size_exp(1,2)
    S_model=resample(S_model,dem,num);
    sample_rate=Model.sample_rate_exp;
else 
    S_exp=resample(S_exp,num,dem);
    sample_rate=Model.sample_rate_model;
end

%apply low pass filter on experimental signal to eliminate noise.
%S_exp_lowpass=lowpassfilter(S_exp, 5e-9, 0.06);

%correct offset of experimental signal.
S_exp=S_exp-mean(S_exp(1:150));

%match time delays of experimental and simulated signals
index_S_exp=find(S_exp==max(S_exp(:)));
index_S_model=find(S_model==max(S_model(:)));
%delay=index_S_model-index_S_exp;%based on finding maximum of the signal
delay=finddelay(S_exp,S_model);%based on finding maximum cross corralation
size_exp=size(S_exp);
size_model=size(S_model);

if delay >=0;
S_exp_delayed=zeros(1,delay+size_exp(1,2));
    S_exp_delayed(delay+1:end)=S_exp;
S_exp=S_exp_delayed;
else
    delay=-delay;
S_model_delayed=zeros(1,delay+size_model(1,2));
S_model_delayed(delay+1:end)=S_model;
S_model=S_model_delayed; 
end
size_exp=size(S_exp);
size_model=size(S_model);

%select signal inside the cuvette for furthure comparisons.
dx=1/sample_rate*Medium.sound_speed_sample;
x_exp=dx:dx:dx*size_exp(1,2);
x_model=dx:dx:dx*size_model(1,2);

[X_exp, Y_exp] = selectsignal(x_exp,S_exp,Geometry.distance/1,Geometry.cuvette_length/0.5);
[X_model, Y_model] = selectsignal(x_model,S_model,Geometry.distance/1,Geometry.cuvette_length/0.5);
%normalizing signal.
Y_model=Y_model/max(Y_model(:));
Y_exp=Geometry.a*Y_exp/max(Y_exp(:));


[X_exp_pos, Y_exp_pos] = selectsignal(x_exp,S_exp,Geometry.distance/0.96,Geometry.cuvette_length/1.45);
[X_model_pos, Y_model_pos] = selectsignal(x_model,S_model,Geometry.distance/0.96,Geometry.cuvette_length/1.45);
%normalizing signal.
Y_model_pos=Y_model_pos/max(Y_model_pos(:));
Y_exp_pos=Geometry.a*Y_exp_pos/max(Y_exp_pos(:));
%S=size(Y_model_pos);
%Y_model_pos=Y_model_pos/abs(Y_model_pos(floor(S(1,1)/1.5),1));
%Y_exp_pos=Y_exp_pos/abs(Y_exp_pos(floor(S(1,1)/1.5),1));

S_exp_processed=Y_exp;
S_model_processed=Y_model;
end