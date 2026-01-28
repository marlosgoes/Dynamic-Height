function [gpan,addep2,addep] = add_abs_gpan(gpan,lat2,lon2,Pn,pref,addep,month_in)
%NOW ACCEPTS 3-D filed
%DEPTH HAS TO BE FIRST DIMENSION IN GPAN

% INPUT: gpan- geopotential height (in cm)
%        lat2- latitude array
%        lon2- longitude array
%        Pn- Pressure (db)
%        pref- refernece pressure (db) [optional]
%        month_in- month (1-12) [optional]
% OUTPUT:
%        gpan-Absolute geopotential height
%        addep- Absolute geopotential height at reference level
%        addep2- Absolute geopotential height at reference level (same size as INPUT)

%By Marlos Goes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sizeg = size(gpan);

%Match depth reference;
[~,dep] = min(abs(Pn-pref));

ndep = length(Pn);

if exist('month_in','var')

    month = month_in;
    
    addep = load_abs_gpan_section(lat2,lon2,Pn,month);
    
    
    
    
    
    
elseif exist('addep','var')
   disp('Don't load')
else    
    
    addep = load_abs_gpan_section(lat2,lon2,Pn);
    
    
    
    
    
    
end

% 'add absolute DH to the reference level' 
gpan = ones(ndep,1)*gpan(1,:)-gpan(:,:);             % Reference to zero
gpan = ones(ndep,1)*gpan(dep,:)-gpan(:,:);           % Reference to absolute
gpan = gpan + ones(ndep,1)*addep(dep,:);
gpan = reshape(gpan,sizeg);
addep2 = reshape(addep,sizeg);

return
