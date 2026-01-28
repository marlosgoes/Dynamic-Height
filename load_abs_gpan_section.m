%This function adds the gpan from ARGO to the bottom level
function addep = load_abs_gpan_section(lat,lon,Pn,month)
%month is format 20101010
    %sgpan = size(lat);
        sgpan = length(lat);
%modo = 'month'
modo = 'clim';
if nargin > 3
   if strcmp(modo,'month')

  smon = size(month,1);

%'aqui'
  [addep_aux1,z] = load_Argo_monthly(lon,lat,month);
keyboard
  addep = interp1(z,addep_aux1,Pn);

   elseif  strcmp(modo,'clim')

    smon = size(month,1);
    month = str2num(month(1:smon,5:6));
    if smon > 1
 %   no_timei = find(size(gpan)~=smon);
   % addep = zeros([27,smon,sgpan(no_timei(end))]);
    addep = zeros(length(Pn),smon,sgpan);
    for i = 1:12;
        acha = (month == i);
        if any(acha)
            [addep_aux1,z] = load_Argo(lon,lat,i);
            addep_aux1 = interp1(z,addep_aux1,Pn);
            addep_aux(:,1,:) = addep_aux1;
%         addep(:,:,acha) = addep_aux(:,:,ones(1,length(nonzeros(acha)));
         addep(:,acha,:) = addep_aux(:,ones(1,nnz(acha)),:);
%         addep(:,:,acha) = addep_aux(:,:,ones(1,nnz(acha)));
        end
    end

    else
        sgpan = length(lat);
    month;
    %[addep,z] = load_Argo(lon,lat,month);
    [addep_aux1,z] = load_Argo(lon,lat,month);
  %          addep = interp1(z,addep_aux1,Pn);
    %Convert to depth instead
    addep = zeros(length(Pn),sgpan);
    for jj = 1:sgpan
        zn = Pn;%sw_pres(Pn,lat(jj));
        addep(1:length(Pn),jj) = interp1(z,addep_aux1(:,jj),zn);
    end
%'key2',keyboard
    end
 end %modo
else
            %[addep,z] = load_Argo(lon,lat);
            [addep_aux1,z] = load_Argo(lon,lat);
            addep = interp1(z,addep_aux1,Pn);
end
  
