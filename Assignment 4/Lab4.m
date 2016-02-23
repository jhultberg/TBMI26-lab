%% Assignment 4
close all;
clear all;
% initialization
nbrActions = 4;
map = 2;
% gives random start position
gwinit(map);
state = gwstate;

gamma = 0.80;
alpha = 0.3;
epsilon=0.9;

% Look-up table
Q = rand(state.xsize, state.ysize, nbrActions);
%edges
Q(1,:,2)=-inf;
Q(state.xsize,:,1)=-inf;
Q(:,1,4)=-inf;
Q(:,state.ysize,3)=-inf;
gwdraw
decisionVector = [];
numIterations = 1000;
numstate=zeros(numIterations,1);

for episodes = 1:numIterations
    episodes
    % gives random start position
    gwinit(map);
    state = gwstate;
    epsilon=epsilon-epsilon*episodes/numIterations;
    
    % repeat until goal found
    while (state.isterminal ~=1 )
        % chose an action
        if(rand(1)<epsilon)
            action = ceil(rand(1)*4);
            while Q(state.pos(1), state.pos(2), action) == -inf
                action = ceil(rand(1)*4);
            end
        else
            [~,action]=max(Q(state.pos(1), state.pos(2),:));
        end
        oldstate=gwstate;
        state=gwaction(action);
        numstate(episodes)=numstate(episodes)+1;
        reward=oldstate.feedback;
        Q(oldstate.pos(1),oldstate.pos(2), action)=...
            (1-alpha)*Q(oldstate.pos(1),oldstate.pos(2),action)+...
            alpha*(reward+gamma*max(Q(state.pos(1), state.pos(2),:)));
    end
    Q(state.pos(1),state.pos(2),:) = 0;
end

%% plot decisions
% [~,bestdec]=max(Q,[],3);
% gwdraw
% 
% for x=1:state.xsize
%     for y=1:state.ysize
%         gwplotarrow([x,y]',bestdec(x,y));
%     end
% end
% figure(5)
% imagesc(max(Q,[],3))
% title('max(Q) for map 4')
% colorbar

%% plot convergence
% figure(6)
% plot(numstate)
% title('Plot for convergation, map 4')
