
% plot the data
center(1,:) = r(:,1);
center(2,:) = r(:,2);

for xcoord=1:N
    circle(center(:,xcoord),r0,200,'g-');
    hold on
end

%for xcoord=0:nCel-1
%    for ycoord=0:nCel-1
%        rectangle('Position',[a0*xcoord a0*ycoord a0 a0])
%    end
%end


%xlim([0, 24]);
%ylim([0, 24]);
axis square
