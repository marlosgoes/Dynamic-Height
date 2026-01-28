function [gpan,addep2,addep] = add_abs_gpan(gpan,lat2,lon2,Pn,pref,addep,month_in)
%NOW ACCEPTS 3-D filed
%DEPTH HAS TO BE FIRST DIMENSION
sizeg = size(gpan);
%dep = find(Pn==pref);
[~,dep] = min(abs(Pn-pref));

ndep = length(Pn);

if exist('month_in','var')

    month = month_in;
    
    addep = load_abs_gpan_section(lat2,lon2,Pn,month);
    
    
    
    
    
    
elseif exist('addep','var')

else    
    
    addep = load_abs_gpan_section(lat2,lon2,Pn);
    
    
    
    
    
    
end

%gpan = gpan - ones(ndep,1)*gpan(dep,:);
% 'add' %,keyboard
gpan = ones(ndep,1)*gpan(1,:)-gpan(:,:);             % display('Mudei ADDEP')
gpan = ones(ndep,1)*gpan(dep,:)-gpan(:,:);       %     display('Mudei ADDEP')
gpan = gpan + ones(ndep,1)*addep(dep,:);
%keyboard
%gpan = gpan - ones(ndep,1)*addep(dep,:);

gpan = reshape(gpan,sizeg);
addep2 = reshape(addep,sizeg);

return
