%function push_hold
%pushes hold state

function push_hold

%together with pop_hold
global HOLD_STATE_STACK

HOLD_STATE_STACK(length(HOLD_STATE_STACK)+1)=ishold;



