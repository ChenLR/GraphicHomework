function [olset,inout]=traceinoutol(p)
%olset是闭合边界点集，为一个N*1的cell
%inout是代表各点集是外轮廓或内轮廓长度为N的数组，外轮廓为0，内轮廓为1
%p为被读取的二值图像，其中边界点为0，空白为1

olset={};
inout=[];
count=0;
[imgx,imgy]=size(p);
trace=zeros(imgx,imgy);
for i=2:length(p(:,1))-1
    for j=2:length(p(1,:))-1
        if ~trace(i,j)&&~p(i,j)
            count=count+1;
            olset=[olset;[i,j]];
            trace(i,j)=count;
            direction=1;
            flag=1;
            a=i-1;
            b=j;
            while flag
                if direction==1
                    Anext=a;
                    Bnext=b+1;
                elseif direction==2
                    Anext=a+1;
                    Bnext=b;
                elseif direction==3
                    Anext=a;
                    Bnext=b-1;
                else
                    Anext=a-1;
                    Bnext=b;
                end
                if ~p(Anext,Bnext) %blocked
                    direction=absidx(direction-1,4);
                    if trace(Anext,Bnext)
                        flag=0;
                        if length(olset{end})<=2
                            olset(end)=[];
                        end
                    else 
                        olset{end}=[olset{end};[Anext,Bnext]];
                        trace(Anext,Bnext)=count;
                    end
                else
                    if direction==1
                        Aside=a+1;
                        Bside=b+1;
                    elseif direction==2
                        Aside=a+1;
                        Bside=b-1;
                    elseif direction==3
                        Aside=a-1;
                        Bside=b-1;
                    else
                        Aside=a-1;
                        Bside=b+1;
                    end
                    if p(Aside,Bside)
                        a=Aside;
                        b=Bside;
                        direction=absidx(direction+1,4);
                    else
                        if trace(Aside,Bside)
                            flag=0;
                            if length(olset{end})<=2
                                olset(end)=[];
                            end
                        else 
                            olset{end}=[olset{end};[Aside,Bside]];
                            trace(Aside,Bside)=count;
                            a=Anext;
                            b=Bnext;
                        end
                    end
                end
            end
        end
    end
end

d=1;
while d<=length(olset)
    if length(olset{d}(:,1))<=3||abs(olset{d}(1,1)-olset{d}(end,1))>1||abs(olset{d}(1,2)-olset{d}(end,2))>1
        olset(d)=[];
    else d=d+1;
    end
end

for i=1:length(olset)
    up=[];
    down=[];
    left=[];
    right=[];
    start=olset{i}(1,:);
    a=start(1);b=start(2);
    while a>1
        a=a-1;
        if trace(a,b)
            up=[up trace(a,b)];
        end
    end
    a=start(1);b=start(2);
    while a<imgx
        a=a+1;
        if trace(a,b)
            down=[down trace(a,b)];
        end
    end
    a=start(1);b=start(2);
    while b>1
        b=b-1;
        if trace(a,b)
            left=[left trace(a,b)];
        end
    end
    a=start(1);b=start(2);
    while b<imgx
        b=b+1;
        if trace(a,b)
            right=[right trace(a,b)];
        end
    end
    if isempty(up)||isempty(down)||isempty(left)||isempty(right)
        inout=[inout 0];
    else
        bdnum=0;
       for u=1:length(up)
           flag1=0;flag2=0;flag3=0;
           for v=1:length(down)
               if down(v)==up(u)
                   flag1=1;
                   break;
               end
           end
           if flag1
           for v=1:length(left)
               if left(v)==up(u)
                   flag2=1;
                   break;
               end
           end
           end
           if flag1&&flag2
           for v=1:length(right)
               if right(v)==up(u)
                   flag3=1;
                   break;
               end
           end
           end
           bdnum=bdnum+double(flag1&&flag2&&flag3);
       end
       inout=[inout mod(bdnum,2)];
    end
end

