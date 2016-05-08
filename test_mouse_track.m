function test_mouse_track()
figure;
axes('Parent',gcf,... % 设置新的axe， 将'parent' 属性设置为当前窗口gcf
    'Units','pixels',...  %设置单位为pixels
    'Position',[10 10 500 400]);

set(gca,'xtick',[],'xticklabel',[]);
set(gca,'ytick',[],'yticklabel',[]);
set(gcf,'WindowButtonDownFcn',@ButttonDownFcn);

function ButttonDownFcn(src,event)
pt = get(gca,'CurrentPoint');
x = pt(1,1);
y = pt(1,2);
fprintf('x=%f,y=%f\n',x,y);