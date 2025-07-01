function [varargout] = get_props_from_varargin(caller_varargin, soughtprop_names, soughtprop_defaultvals)

% an example use in the caller function: 
% [chosenframe, isubframe] = get_props_from_varargin(varargin, {'ChosenFrame', 'SubFrameNo'}, {'lmframe', 1});
% if the caller's varargin includes any of the specified props 
% (i.e., 'ChosenFrame' or 'SubFrameNo'), then they are parsed and mapped to
% output. otherwise, default vals are used.

deletelist = [];
caller_varargin_remaining = caller_varargin;
varargout = soughtprop_defaultvals;
coder.unroll();

for iarg = 2:length(caller_varargin)
    if isstr(caller_varargin{iarg-1})
        soughtprop_matches = strcmp(caller_varargin{iarg-1}, soughtprop_names);
    else
        continue;
    end
    if any(soughtprop_matches)
        varargout{soughtprop_matches} = caller_varargin{iarg};
        deletelist = [deletelist, iarg-1, iarg];
    end
end

caller_varargin_remaining(deletelist) = [];
varargout{end+1} = caller_varargin_remaining;