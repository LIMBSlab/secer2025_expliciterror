function r_deg = circ_dist_degrees(x_deg, y_deg)

x = deg2rad(x_deg);
y = deg2rad(y_deg);

r = circ_dist(x,y);

r_deg = rad2deg(r);