function test_mouse_track()
figure;
axes('Parent',gcf,... % �����µ�axe�� ��'parent' ��������Ϊ��ǰ����gcf
    'Units','pixels',...  %���õ�λΪpixels
    'Position',[10 10 500 400]);

set(gca,'xtick',[],'xticklabel',[]);
set(gca,'ytick',[],'yticklabel',[]);
set(gcf,'WindowButtonDownFcn',@ButttonDownFcn);

function ButttonDownFcn(src,event)
pt = get(gca,'CurrentPoint');
x = pt(1,1);
y = pt(1,2);
fprintf('x=%f,y=%f\n',x,y);