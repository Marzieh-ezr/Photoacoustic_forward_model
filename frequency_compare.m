size_model=size(S_model);
size_exp=size(S_exp);


S_exp=S_exp-mean(S_exp(1:500));

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

%choosing the positive part of the signals
S_model=S_model(3628:4368)
S_exp=S_exp(3628:4368)

fs=1e9/5; %sample rate [HZ]

%finding properties of simulated signal
N_model  = length(S_model);
dF_model = fs/N_model;
dx_model=1/fs;
f_model  = (-fs/2:dF_model:fs/2-dF_model)';
x_model=dx_model:dx_model:dx_model*N_model;

%finding properties of experimental signal
N_exp  = length(S_exp);
dF_exp = fs/N_exp;
dx_exp=1/fs
f_exp  = (-fs/2:dF_exp:fs/2-dF_exp)';
x_exp=dx_exp:dx_exp:dx_exp*N_exp;

%finding spectrum of signals 
spektrum_model = fftshift(fft(S_model));
spektrum_exp = fftshift(fft(S_exp));
%================================================================================
%visualization
subplot(2,1,1),plot(x_model,S_model/max(S_model(:))/1)
hold on 
plot(x_exp,S_exp/max(S_exp(:)))
legend("simulated PA signal", "experimental PA Signal")
subplot(2,1,2),plot(f_model,abs(spektrum_model)/max(abs(spektrum_model(:))));
hold on
plot(f_exp,abs(spektrum_exp)/max(abs(spektrum_exp(:))));
legend("simulated signal spectrum","experimental signal spectrum")