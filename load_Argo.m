function [addep,z,temp,sal]= load_Argo(lon,lat,month)
%Load Argo data and interpolates tp the lat,lon specified.
%ADDEP output is in cm/dyn
%By Marlos Goes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath([preffix,'mgoes/matlab/'])

%direc_phod = '/automount1/mgoes/ARGO/IPRC/';
%direc_mgoes = '/data/mgoes/ARGO/IPRC/';
%if exist(direc_phod), direc=direc_phod; else direc=direc_mgoes;end

direc = 'IPRC/';

if nargin<3
%For annual data. 
    filename = [direc,'argo_CLIM_2005-2016_grd.nc'];

    sal = ncread(filename,'SALT'); sal = squeeze(nanmean(sal,4));
    temp = ncread(filename,'TEMP');temp = squeeze(nanmean(temp,4));
    addep = ncread(filename,'ADDEP'); addep = squeeze(nanmean(addep,4));

else

    filename = [direc,'argo_CLIM_2005-2016_grd.nc'];

    sal  = ncread(filename,'SALT',[1 1 1 month],[Inf Inf Inf 1]);
    temp = ncread(filename,'TEMP',[1 1 1 month],[Inf Inf Inf 1]);
    addep = ncread(filename,'ADDEP',[1 1 1 month],[Inf Inf Inf 1]);

end


MISS = min(addep(:));
if MISS<-100
   sal(sal == MISS) = nan;
   temp(temp == MISS) = nan;
   addep(addep == MISS) = nan;
end

x = double(ncread(filename,'LONGITUDE'));
y = double(ncread(filename,'LATITUDE'));
z = ncread(filename,'LEVEL');

x(x>180) = x(x>180)-360; %FROM 0-360 to -180-180
[~,ilon] = sort(x);

addep = addep(ilon,:,:,:);  %SOMHOW WAS INVERTED
temp  = temp(ilon,:,:,:);   %SOMHOW WAS INVERTED
sal   = sal(ilon,:,:,:);    %SOMHOW WAS INVERTED
x = x(ilon);

%Use intepolation instead
[lon,lat,addep] = interp_sat2xbt(x,y,addep,lon,lat,[],'linear');%,'nearest');
addep = addep*100/10;  %Transform to dyn cm and geopotential anomaly

return

