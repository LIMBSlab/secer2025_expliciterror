function angle_wrapped = decode_bumpcenter_wrappedangle(u)

xneurons = linspace(-180,180,size(u,1)+1); 
xneurons = xneurons(1:end-1);

for idx = 1:size(u,2)
    u_this = u(:,idx);
    
    angle_wrapped(1,idx) = circ_mean_degrees(xneurons, u_this);

end