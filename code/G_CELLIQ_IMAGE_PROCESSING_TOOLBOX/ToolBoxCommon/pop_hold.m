%function pop_hold
%pops hold state

function pop_hold

%together with push_hold
global HOLD_STATE_STACK

hstate=HOLD_STATE_STACK(length(HOLD_STATE_STACK));

HOLD_STATE_STACK=HOLD_STATE_STACK(1:length(HOLD_STATE_STACK)-1);

if (hstate)
	hold on
else
	hold off
end;


