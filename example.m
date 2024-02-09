range = -20:0.25:20;

f = field(range, range, 12);
[x y] = meshgrid(range, range);

fig = surf(x, y, f.get_field);

n = 0;
m = 0;
t = 0;
while true
  pause(0.05);
  n += 0.2;
  m += 0.1;
  t += 0.05;

  f = f.add_field_data(10*sin(m), 10*cos(m), 10*sin(n));
  z = f.get_field;
  set(fig,'zdata', z, 'cdata', z);

  if (t >= 2)
    f = f.prune_field_data
    t = 0;
  endif
endwhile
