%%
clearvars;
close all;
%%
nbrActions = 4;
map = 1;
gwinit(map);              % gives random start position
state = gwstate;
Q = rand(state.xsize, state.ysize, nbrActions)*(-1)-0.1;  % Look-up table
gwdraw

% constants
gamma = 0.99;
alpha = 0.7;
exploration = 0.7;

stationary = [0;0];
up = [-1; 0];
down = [1; 0];
left = [0; -1];
right = [0; 1];

directions = [down up right left stationary];

Q(1,:,2)=-inf; %edges
Q(end,:,1)=-inf;
Q(:,1,4)=-inf;
Q(:,end,3)=-inf;


%%
if map == 1
    Q(1:8,4,3)=-inf;
    Q(9,5:8,2)=-inf;
    Q(1:8,9,4)=-inf;
end
if (map == 3 || map== 4)
    Q(4:7,3,3)=-inf;
    Q(9:10,3,3)=-inf;
    Q(3,4:12,1)=-inf;
    Q(8,4:12,1)=-inf;
    Q(8,4:12,2)=-inf;
    Q(4:7,13,4)=-inf;
    Q(9:10,13,4)=-inf;
end

%%
count = 0;
numit=50000;

for episodes =  1:numit
    
    alpha=0.9*(numit-episodes)/numit;
    epsilon=0.5*(numit-episodes)/numit+0.3;
    count = count +1;
    
    % choosing action/direction
    while 1
        if(rand(1,1)<epsilon)
            action=ceil(rand(1,1)*4);
            if Q(state.pos(1), state.pos(2), action) == -inf
                [~,action]=max(Q(state.pos(1), state.pos(2),:));
                %                 state.isvalid=0;
            end
        else
            [~,action]=max(Q(state.pos(1), state.pos(2),:)); %best action
        end
        oldstate=state;
        state = gwaction(action);
        if state.isvalid
            
            break;
        end
        %         state.isvalid=1;
    end
    reward=state.feedback; %checking reward for last action
    
    % updating Q
    Q(oldstate.pos(1), oldstate.pos(2),action) = (1-alpha)*Q(oldstate.pos(1), oldstate.pos(2),action) + ...
        alpha*(reward + gamma*max(Q(state.pos(1), state.pos(2),:)));
    %     state.pos = newstate;
    %     state = gwaction(action);
   if state.isterminal
      episodes
      Qmax = 0;
      Q(state.pos(1),state.pos(2),:) = 0;
      Q(oldstate.pos(1),oldstate.pos(2),action)=(1-alpha)*Q(oldstate.pos(1),oldstate.pos(2),action)+alpha*reward;
      gwinit(map);
      state = gwstate;
%       beep
  else
      Qmax=max(Q(state.pos(1),state.pos(2),:));
  end

    Q(oldstate.pos(1),oldstate.pos(2),action)=(1-alpha)*Q(oldstate.pos(1),oldstate.pos(2),action)+alpha*(reward+gamma*Qmax);
    
end
gwdraw

    
figure
    gwdraw();
    for x = 1:state.xsize
      for y = 1:state.ysize
         a = find(max(Q(x,y,:)) == Q(x,y,:));
         a = a(1);
         gwplotarrow([x y]',a);
      end
    end