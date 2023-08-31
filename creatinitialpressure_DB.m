function initialpressure_DB=creatinitialpressure_DB(Model, Medium, Geometry)
%this function creats an initial pressure distribution inside the cuvette.
%it assumes that the laser beam is divergence.
I=load('C:\Users\Marzieh\Documents\Marzieh\codes\forward_model\Intensity_profile_inside_cuvette\Intensityprofile_blue.mat');
Intensity=I.intensityprofile;
S=size(Intensity);
Intensity=Intensity(:,round(S(1,2)/2):end-1);
H_1=round((Geometry.cuvette_face)/Model.dx);
p_0=zeros(Model.Nx,Model.Ny);
for i=1:round(Geometry.cuvette_length/Model.dx)
   for j=1:round(Geometry.cuvette_diameter/(2*Model.dy))
       x=Model.dx*i;
       y=Model.dy*j;
       alpha=atan(y/(x+0.0338));
       light_path=((x+0.0338)/cos(alpha))-(0.0338/cos(alpha));
       p_0(H_1+i,j)=Intensity(i,j)*Model.amplitude*Medium.absorption*Model.dx*exp(-Medium.absorption*light_path);%Tophat
    end
end
initialpressure_DB=p_0;
end