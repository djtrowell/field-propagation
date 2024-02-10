classdef field
   properties
     x;y;               % matrices outlining the area over which the field spans
     c;                 % speed of continuity
     dat = zeros(1,3);  % array of points on the field holding data
     dat_time = 0;
     prune_length = 0;  % max time a piece of data could take to spread through the field
   endproperties

   methods
     function f = field (x_range, y_range, c = 3e8)
       [ f.x f.y ] = meshgrid(x_range, y_range);
       f.c = c;
       f.prune_length = sqrt((numel(x_range))^2 + (numel(y_range))^2) / c;
     endfunction

     function obj = add_field_data (obj, x, y, data)
         obj.dat = vertcat(obj.dat, [ x y data ]);
         obj.dat_time = vertcat(obj.dat_time, tic);
     endfunction

     function obj = prune_field_data (obj)

       i = 0; % index of current row
       do
         i++;
         exceeds_length = toc(obj.dat_time(i)) > obj.prune_length;
       until (exceeds_length == 0) % i - 1 represents last value where exceeds_length = 1
       obj.dat = obj.dat((i - 1):rows(obj.dat),:);
       obj.dat_time = obj.dat_time((i-1):rows(obj.dat_time),:);
     endfunction

     function f = get_field(obj)
       f = zeros(size(obj.x));
       % iterate through all data points in order and add them to the field
       for i = 1:rows(obj.dat)
         mask = (obj.x - obj.dat(i, 1)).^2 + (obj.y - obj.dat(i, 2)).^2 <= (obj.c * toc(obj.dat_time(i)))^2;
         f(mask) = obj.dat(i,3);
       endfor
     endfunction
   endmethods
endclassdef
