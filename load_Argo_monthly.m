%Load Argo data and interpolates tp the lat,lon specified.
%ADDEP output is in cm/dyn

%NEED TO FIX TO ADD CLIMATOLOGY OUT OF BOUNDS
function [addep,z]= load_Argo(lon,lat,month)
%function [addep,z,temp,sal]= load_Argo(lon,lat,month)
if exist('/data/mgoes','dir')
    preffix = '/data/';
else
    preffix = '/automount1/';
end

addpath([preffix,'mgoes/matlab/'])

%FOR PHODNET
%addpath([preffix,'mgoes/matlab/netcdf'])
%addpath([preffix,'mgoes/matlab/netcdf/nctype'])
%addpath([preffix,'mgoes/matlab/netcdf/ncsource'])
%addpath([preffix,'mgoes/matlab/netcdf/ncutility'])
%addpath([preffix,'mgoes/matlab/netcdf/mexnc'])

direc = [preffix,'mgoes/ARGO/IPRC/'];
%year0  = str2num(month(1,1:4));
year1  = str2num(month(end,1:4));
%month0 = str2num(month(1,5:6));
month1 = str2num(month(end,5:6)); 

years =  str2num(month(:,1:4));
months = str2num(month(:,5:6));

indy0 = years(1)-2005;
indm0 = months(1);
indy1 = min(16,years(end)-2005);
indm1 = months(end);%12;

ind0 = max(0,indy0)*12+indm0;
ind1 = max(0,indy1)*12+indm1;
%ind1 = min(184,max(0,indy1)*12+indm1) - ind0;% +1;
indi = ind1 - ind0 + 1;
indall = min(184,max(0,years-2005)*12+indm1)-ind0+1;

  filename = [direc,'argo_2005-2020_grd.nc'];
%NOT WORKING ~~~~~~~~~~~~~~~~~~~~~~~~~~~
clim = false;
if indy0<=0
   clim = true
%   ind1 = 1;% (ind1<=0)=ind1(ind1<=0)+11;
%   indall = ind1;
%  filename = [direc,'argo_CLIM_2005-2012_grd.nc'];
  filename = [direc,'argo_CLIM_2005-2016_grd.nc'];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%keyboard
%For monthly data. 
% sal   = ncread(filename,'SALT', [1 1 1 ind0],[Inf Inf Inf ind1]);
% temp  = ncread(filename,'TEMP', [1 1 1 ind0],[Inf Inf Inf ind1]);
 addep = ncread(filename,'ADDEP',[1 1 1 ind0],[Inf Inf Inf indi]);
% addep = permute(addep,[2 1 3 4]);
% sal   = permute(sal,[2 1 3 4]);
% temp = permute(temp,[2 1 3 4]);


MISS = min(addep(:));
if MISS<-100
%   sal(sal == MISS) = nan;
%   temp(temp == MISS) = nan;
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
%keyboard

x(x>180) = x(x>180)-360;
[~,ilon] = sort(x);
addep = addep(ilon,:,:,:);
%addep = addep(:,ilon,:,:);
%temp  = temp(:,ilon,:,:);
%sal   = sal(:,ilon,:,:);
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
addep2 = z*lon*nan;
for ii=1:length(indall)
   [lon,lat,addei] = interp_sat2xbt(x,y,addep(:,:,:,indall(ii)),lon,lat,[],'linear');%,'nearest');
   addep2(:,:,ii) = addei*100/10;  %Transform to dyn cm and geopotential anomaly
end
addep = addep2; %permute(addep2,[1 3 2]);
%addep = interp1(x(vec),ad,lon)*100/10;   

return

