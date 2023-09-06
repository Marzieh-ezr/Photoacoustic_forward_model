fs=1e9/5/1480;

N_model  = length(S_model);
dF_model = fs/N_model;
dx_model=1/fs;
f_model  = (-fs/2:dF_model:fs/2-dF_model)';
x_model=dx_model:dx_model:dx_model*N_model;

N_exp  = length(S_exp);
dF_exp = fs/N_exp;
dx_exp=1/fs
f_exp  = (-fs/2:dF_exp:fs/2-dF_exp)';
x_exp=dx_exp:dx_exp:dx_exp*N_exp;

spektrum_model = fftshift(fft(S_model));
spektrum_exp = fftshift(fft(S_exp));

subplot(2,1,1),plot(x_model,S_model)
hold on 
plot(x_exp,S_exp)

subplot(2,1,2),plot(f_model,abs(spektrum_model));
hold on
plot(f_exp,abs(spektrum_exp));