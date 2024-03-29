range = -80:1:80;
c = 3;
fields = 40;
x_width = 40;

freq = 0.1;
wavel = 25;

x_spread = linspace(-(x_width/2), x_width/2, fields);
y_spread = zeros(1, fields);

function z = superpose_fields(f, f_size)
  z = zeros(rows(f{1}), columns(f{1}));
  for i = 1:f_size
    z = z + f{i}.get_field;
  endfor
endfunction

function f = prune_fields(f, f_size)
  for i = 1:f_size
    f{i} = f{i}.prune_field_data;
  endfor
endfunction

tic_id = tic();

f = cell(fields, 1);
for i = 1:fields
   f{i} = field(range, range, c);
endfor

[x y] = meshgrid(range, range);
z = superpose_fields(f, fields);

fig = surf(x, y, z);
colormap("viridis");
shading("interp");
zlim([ -10 10 ]);


n = 0;
t = 0;
while true
  %pause(0.025);
  pause(0);
  dt = toc(tic_id)
  tic_id = tic();

  n += (freq * 2 * pi)/dt;
  t += dt;

  z_val = (5/fields)*sin(n);
  for i = 1:fields
    f{i} = f{i}.add_field_data(x_spread(i), y_spread(i), z_val);
  endfor

  z = superpose_fields(f, fields);
  set(fig,'zdata', z, 'cdata', z);

  if (t >= 2)
    f = prune_fields(f, fields);
    t = 0;
  endif
endwhile
