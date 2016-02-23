%% Assignment 4
close all;
clear all;
% initialization
nbrActions = 4;
map = 1;
% gives random start position
gwinit(map);
state = gwstate;

gamma = 0.99;
alpha = 0.3;

% as long as start position is not allowed generate a new one
while state.posval(state.pos(1), state.pos(2))<-1
    gwinit(map);
    state = gwstate;
end
Q = rand(state.xsize, state.ysize, nbrActions)*(-1)-0.1;  % Look-up table
Q(1,:,2)=-inf; %edges
%Q(state.xsize,:,1)=-inf;
Q(:,1,4)=-inf;
%Q(:,state.ysize,3)=-inf;
gwdraw
decisionVector = [];
numIterations = 500;
for episodes = 1:numIterations
    % gives random start position
    gwinit(map);
    state = gwstate;
    epsilon=episodes/numIterations;
    % as long as start position is not allowed generate a new one
    while state.posval(state.pos(1), state.pos(2))<-1
        gwinit(map);
        state = gwstate;
    end
    
    % repeat until goal found
    while (state.isterminal ~=1 )
        % chose an action
        if(rand(1)>epsilon)
            action = ceil(rand(1)*4);
            if Q(state.pos(1), state.pos(2), action) == -inf
                [~,action]=max(Q(state.pos(1), state.pos(2),:));
            end
        else
            [~,action]=max(Q(state.pos(1), state.pos(2),:));
        end
        oldstate=gwstate;
        state=gwaction(action);
        reward=oldstate.feedback;
        Q(oldstate.pos(1),oldstate.pos(2), action)=...
            (1-alpha)*Q(oldstate.pos(1),oldstate.pos(2),action)+...
            alpha*(reward+gamma*max(Q(state.pos(1), state.pos(2),action)));
    end
    
end
%gwdraw

%% plot decisions
[~,bestdec]=max(Q,[],3);
gwdraw

for x=1:state.xsize
    for y=1:state.ysize
        gwplotarrow([x,y]',bestdec(x,y));
    end
end
