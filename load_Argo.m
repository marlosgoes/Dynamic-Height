%Load Argo data and interpolates tp the lat,lon specified.
%ADDEP output is in cm/dyn
function [addep,z,temp,sal]= load_Argo(lon,lat,month)
if exist('/data/mgoes','dir')
    preffix = '/data/';
else
    preffix = '/automount1/';
    preffix = '/phodnet/share/';
end

addpath([preffix,'mgoes/matlab/'])
%addpath([preffix,'mgoes/AX8/SATELLITE/matlab']) %WAS FOR THE interp_sat2xbt.m but I moved it here
%addpath('/automount1/mgoes/SATELLITE/matlab')
%FOR PHODNET
addpath([preffix,'mgoes/matlab/netcdf'])
addpath([preffix,'mgoes/matlab/netcdf/nctype'])
addpath([preffix,'mgoes/matlab/netcdf/ncsource'])
addpath([preffix,'mgoes/matlab/netcdf/ncutility'])
addpath([preffix,'mgoes/matlab/netcdf/mexnc'])

%direc_phod = '/automount1/mgoes/ARGO/IPRC/';
%direc_mgoes = '/data/mgoes/ARGO/IPRC/';
%if exist(direc_phod), direc=direc_phod; else direc=direc_mgoes;end
direc = [preffix,'mgoes/ARGO/IPRC/'];
direc = '/phodnet/share/mgoes/IVENIS/AX97/IPRC/';
% keyboard
if nargin<3
%For annual data. 
  %filename = [direc,'ArgoData.nc'];
%  filename = [direc,'argo_CLIM_2005-2012_grd.nc'];
filename = [direc,'argo_CLIM_2005-2016_grd.nc'];
%  nc = netcdf(filename);%,'nowrite');
%  sal = nc{'SALT'}(:); sal = squeeze(nanmean(sal));sal = permute(sal,[2 3 1]);
%  temp = nc{'TEMP'}(:);temp = squeeze(nanmean(temp)); temp = permute(temp,[2 3 1]);
% % ptemp = nc{'PTEMP'}(:); ptemp = permute(ptemp,[2 3 1]);
%  addep = nc{'ADDEP'}(:); addep = squeeze(nanmean(addep));addep = permute(addep,[2 3 1]);
% close(nc)

sal = ncread(filename,'SALT'); sal = squeeze(nanmean(sal,4));%sal = permute(sal,[2 3 1]);
temp = ncread(filename,'TEMP');temp = squeeze(nanmean(temp,4));% temp = permute(temp,[2 3 1]);
% ptemp = nc{'PTEMP'}(:); ptemp = permute(ptemp,[2 3 1]);
addep = ncread(filename,'ADDEP'); addep = squeeze(nanmean(addep,4));%addep = permute(addep,[2 3 1]);
else
%For monthly data. 
%filename = [direc,'argo_CLIM_2005-2010_grd.nc']; %THis FILE GOT CORUPTED
%filename = [direc,'argo_CLIM_2005-2012_grd.nc'];
filename = [direc,'argo_CLIM_2005-2016_grd.nc'];

% nc = netcdf(filename,'nowrite');
% sal = nc{'SALT'}(month,:,:,:); sal = permute(sal,[2 3 1]);
% temp = nc{'TEMP'}(month,:,:,:); temp = permute(temp,[2 3 1]);
%% ptemp = nc{'PTEMP'}(month,:,:,:); ptemp = permute(ptemp,[2 3 1]);
% addep = nc{'ADDEP'}(month,:,:,:); addep = permute(addep,[2 3 1]);
 
 sal  = ncread(filename,'SALT',[1 1 1 month],[Inf Inf Inf 1]);
 temp = ncread(filename,'TEMP',[1 1 1 month],[Inf Inf Inf 1]);
 addep = ncread(filename,'ADDEP',[1 1 1 month],[Inf Inf Inf 1]);
% addep = permute(addep,[2 1 3]);
% sal = permute(sal,[2 1 3]);
% temp = permute(temp,[2 1 3]);

end


MISS = min(addep(:));
if MISS<-100
sal(sal == MISS) = nan;
temp(temp == MISS) = nan;
%ptemp(ptemp == MISS) = nan;
addep(addep == MISS) = nan;
end

% t = nc{'T'}(:);
% x = nc{'LONGITUDE'}(:);x(x>180) = x(x>180)-360;
% y = nc{'LATITUDE'}(:);
% z = nc{'LEVEL'}(:);
%t = ncread(filename,'TIME');
x = double(ncread(filename,'LONGITUDE'));
y = double(ncread(filename,'LATITUDE'));
z = ncread(filename,'LEVEL');

x(x>180) = x(x>180)-360; %FROM 0-360 to -180-180
[~,ilon] = sort(x);
%'nei',keyboard
addep = addep(ilon,:,:,:);  %SOMHOW WAS INVERTED
temp  = temp(ilon,:,:,:);   %SOMHOW WAS INVERTED
sal   = sal(ilon,:,:,:);    %SOMHOW WAS INVERTED
x = x(ilon);



%Fazendo o teste com um subconjunto
% [~,bb] = min(abs(y-nanmedian(lat)));
% [~,aa] = min(abs(x-nanmin(lon)));
% [~,cc] = min(abs(x-nanmax(lon)));
% if aa<cc, vec = aa:cc;else vec = sort(cc:aa);end
% ad = squeeze(addep(bb,vec,:)); 

%Use intepolation instead
%[lon,lat,temp] = interp_sat2xbt(x,y,temp,lon,lat);
%[lon,lat,sal] = interp_sat2xbt(x,y,sal,lon,lat);
[lon,lat,addep] = interp_sat2xbt(x,y,addep,lon,lat,[],'linear');%,'nearest');
%'key1',keyboard   %UNTIL HERE IS RIGHT
addep = addep*100/10;  %Transform to dyn cm and geopotential anomaly

%addep = interp1(x(vec),ad,lon)*100/10;   

return

