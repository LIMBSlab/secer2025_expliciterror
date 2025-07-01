function dxnetwork = fullnetwork_vf(xnetwork, uleftspeed, urightspeed, uvisualring, statusvisual, ratspeed, paramsnetwork)

pcentralring = paramsnetwork.centralring;
xcentralring = map_x_to_centralringstates(xnetwork, pcentralring);
ucentralring = get_activitystates_centralring(xcentralring);

pleftring = paramsnetwork.leftring;
xleftring = map_x_to_leftringstates(xnetwork, pleftring);
uleftring = get_activitystates_rotring(xleftring);

prightring = paramsnetwork.rightring;
xrightring = map_x_to_rightringstates(xnetwork, prightring);
urightring = get_activitystates_rotring(xrightring);

Nneurons = length(ucentralring);

%%
if isfield(paramsnetwork,'visualassocring')
    pvisualassoc = paramsnetwork.visualassocring;
    xvisualassoc = map_x_to_visualassocringstates(xnetwork, pvisualassoc);
    uvisualassoc = get_activitystates_visualassocring(xvisualassoc);
    
    dxvisualassoc = visualassoc_vf(xvisualassoc, ucentralring, uvisualring, statusvisual, pvisualassoc);
    
    dxcentralring = centralring_vf(xcentralring, uleftring, urightring, uvisualassoc, statusvisual, pcentralring);
    
    dxleftring = leftring_vf(xleftring, ucentralring, urightring, uvisualassoc, uleftspeed, statusvisual,  pleftring);
    
    dxrightring = rightring_vf(xrightring, ucentralring, uleftring, uvisualassoc, urightspeed, statusvisual,  prightring);
    
    dxring = combine_ringstates_to_x(dxcentralring, dxleftring, dxrightring);
    
    dxnetwork = [dxring; dxvisualassoc];
    
else
    dxcentralring = centralring_vf(xcentralring, uleftring, urightring, uvisualring, statusvisual, pcentralring);

    dxleftring = rotring_vf(xleftring, ucentralring, urightring, uvisualring, uleftspeed, statusvisual, ratspeed, pleftring);

    dxrightring = rotring_vf(xrightring, ucentralring, uleftring, uvisualring, urightspeed, statusvisual,  ratspeed, prightring);
    
    dBleftspeed = (get_synapticweightstates_rotring(dxleftring));
    dBrightspeed = (get_synapticweightstates_rotring(dxrightring));

    dBspeed = (dBleftspeed + dBrightspeed)/2;
    dxleftring(Nneurons+1:2*Nneurons) = dBspeed;
    dxrightring(Nneurons+1:2*Nneurons) = dBspeed;
    
    
    % if abs(mean(dBrightspeed)) < abs(mean(dBleftspeed))
    %     dxleftring(Nneurons+1:2*Nneurons) = dBrightspeed;
    %     dxrightring(Nneurons+1:2*Nneurons) = dBrightspeed;
    % else
    %     dxleftring(Nneurons+1:2*Nneurons) = dBleftspeed;
    %     dxrightring(Nneurons+1:2*Nneurons) = dBleftspeed;
    % end

    uleftring = get_activitystates_rotring(xleftring);
    urightring = get_activitystates_rotring(xrightring);

    dxnetwork = combine_ringstates_to_x(dxcentralring, dxleftring, dxrightring);

    % 
    % if abs(angcenter - 130) < 0.1
    %     figure(1);
    %     plot(circshift(dxcentralring,-2),'g');
    %     hold on;
    % 
    %     figure(2);
    %     plot(circshift(dxleftring,-2),'g');
    %     hold on;
    % 
    %     figure(3);
    %     plot(circshift(dxrightring,-2),'g');
    %     hold on;
    % 
    %     debug;
    % elseif abs(angcenter - 180) < 0.1
    %     debug;
    % elseif abs(angcenter - (-130)) < 0.1
    %     figure(1);
    %     plot(circshift(dxcentralring,-2),'g');
    %     hold on;
    % 
    %     figure(2);
    %     plot(circshift(dxleftring,-2),'g');
    %     hold on;
    % 
    %     figure(3);
    %     plot(circshift(dxrightring,-2),'g');
    %     hold on;
    % 
    %     debug;            
    % end

end
