%This function adds the gpan from ARGO to the bottom level
function addep = load_abs_gpan_section(lat,lon,Pn,month)
%month is format 20101010
   
    
        sgpan = length(lat);
%modo = 'month'
modo = 'clim';

if nargin > 3
   if strcmp(modo,'month')

      smon = size(month,1);

      [addep_aux1,z] = load_Argo_monthly(lon,lat,month);
      addep = interp1(z,addep_aux1,Pn);

   elseif  strcmp(modo,'clim')

      smon = size(month,1);
      month = str2num(month(1:smon,5:6));
     if smon > 1
        addep = zeros(length(Pn),smon,sgpan);
      
      for i = 1:12;
        acha = (month == i);
        if any(acha)
            [addep_aux1,z] = load_Argo(lon,lat,i);
            addep_aux1 = interp1(z,addep_aux1,Pn);
            addep_aux(:,1,:) = addep_aux1;
         addep(:,acha,:) = addep_aux(:,ones(1,nnz(acha)),:);
        end
      end

     else
        sgpan = length(lat);
        [addep_aux1,z] = load_Argo(lon,lat,month);

      %Convert to depth instead
        addep = zeros(length(Pn),sgpan);
      for jj = 1:sgpan
          zn = Pn; %sw_pres(Pn,lat(jj));
          addep(1:length(Pn),jj) = interp1(z,addep_aux1(:,jj),zn);
      end

     end
   end %modo
else
            [addep_aux1,z] = load_Argo(lon,lat);
            addep = interp1(z,addep_aux1,Pn);
end
  
