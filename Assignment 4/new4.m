%%
clearvars;
%close all;
%%
nbrActions = 4;
map = 1;
% gives random start position
gwinit(map);
state = gwstate;
% as long as start position is not allowed generate a new one
while state.posval(state.pos(1), state.pos(2))<-1
    gwinit(map);
    state = gwstate;
end
Q = rand(state.xsize, state.ysize, nbrActions)*(-1)-0.1;  % Look-up table
gwdraw

% constants
gamma = 0.99;
alpha = 0.7;
exploration = 0.7;

% stationary = [0;0];
up = [-1; 0];
down = [1; 0];
left = [0; -1];
right = [0; 1];

directions = [down up right left];% stationary];

Q(1,:,2)=-inf; %edges
Q(end,:,1)=-inf;
Q(:,1,4)=-inf;
Q(:,end,3)=-inf;


%%
% if map == 1
%     Q(1:8,4,3)=-inf;
%     Q(9,5:8,2)=-inf;
%     Q(1:8,9,4)=-inf;
% end
% if (map == 3 || map== 4)
%     Q(4:7,3,3)=-inf;
%     Q(9:10,3,3)=-inf;
%     Q(3,4:12,1)=-inf;
%     Q(8,4:12,1)=-inf;
%     Q(8,4:12,2)=-inf;
%     Q(4:7,13,4)=-inf;
%     Q(9:10,13,4)=-inf;
% end

%%
count = 0;
numit=2000;
decisionVector=[];

for episodes =  1:numit
 
    % init start state
    state = gwstate;
    while state.posval(state.pos(1), state.pos(2))<-1
        gwinit(map);% gives random start position
        state = gwstate;
        
    end
    
    alpha=0.9*(numit-episodes)/numit;
    epsilon=0.5*(numit-episodes)/numit+0.3;
    count = count +1;
    
    % choosing action/direction
    while 1
        if(rand(1,1)<epsilon)
            action=ceil(rand(1)*4);
            if Q(state.pos(1), state.pos(2), action) == -inf
                [~,action]=max(Q(state.pos(1), state.pos(2),:));
            end
        else
            [~,action]=max(Q(state.pos(1), state.pos(2),:)); %best action
        end
        decisionVector =[decisionVector ;state.pos(1), state.pos(2), action];
        oldstate=state;
        state = gwaction(action);
        if state.isvalid
            break;
        end
    end
    reward=state.feedback; %checking reward for last action
    
    % updating Q
    Q(oldstate.pos(1), oldstate.pos(2),action) = (1-alpha)*Q(oldstate.pos(1), oldstate.pos(2),action) + ...
        alpha*(reward + gamma*max(Q(state.pos(1), state.pos(2),:)));
    if state.isterminal
        episodes
        Qmax = 0;
        Q(state.pos(1),state.pos(2),:) = 0;
        Q(oldstate.pos(1),oldstate.pos(2),action)=(1-alpha)*Q(oldstate.pos(1),oldstate.pos(2),action)+alpha*reward;
        gwinit(map);
        state = gwstate;
    else
        Qmax=max(Q(state.pos(1),state.pos(2),:));
    end
    
    Q(oldstate.pos(1),oldstate.pos(2),action)=(1-alpha)*Q(oldstate.pos(1),oldstate.pos(2),action)+alpha*(reward+gamma*Qmax);
    
end
gwdraw



%%
figure(1)
gwdraw();
for x = 1:size(decisionVector, 1)
    %          a = find(max(Q(x,y,:)) == Q(x,y,:));
    %          a = a(1);
%     if(state.posval(decisionVector(x,1),decisionVector(x,2))>-1)
        xpos = decisionVector(x,1);
        ypos = decisionVector(x,2);
        act = decisionVector(x,3);
        gwplotarrow([xpos ypos]',act);
%     end
end

%%
figure(2)
    gwdraw();
    for x = 1:state.xsize
      for y = 1:state.ysize
         a = find(max(Q(x,y,:)) == Q(x,y,:));
         a = a(1);
         gwplotarrow([x y]',a);
      end
    end