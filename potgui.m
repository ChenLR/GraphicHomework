function potgui()
figure(1);
set(gcf,'name','Graphic');
set(gcf,'keypressfcn',@keypressfcn);
hb = uicontrol(gcf, 'style', 'pushbutton', ...
    'units', 'normalized', ...
    'position', [0.4,0.1,0.2,0.05], ...
    'string', 'Render', ...
    'Callback', @Render);
basemodel = teapotModel(0.5, 0.5, pi / 10);
basemodel = translateModel(basemodel,[0 -1.5 0]);
Y = 0;
X = 0;
x_step = 10;
y_step = 10;
light = [4 0 10];
show();

    function show()
        figure(1)
        model = rotateModel(basemodel, [X, Y, 0], [2 1 3]);
        opt = gridView(zeros(200, 300), model, 5, 90);
        %opt = render(zeros(400,600),model,light,5,90);
        imshow(opt, [0 max(max(opt))]);
    end

    function keypressfcn(src, event)
        a = get(gcf,'currentcharacter');
        if strcmp(event.Key, 'uparrow')
            fprintf('up\n');
            X = X - x_step;
            show();        
        elseif strcmp(event.Key, 'downarrow')
            fprintf('down\n');
            X = X + x_step;
            show();
        elseif strcmp(event.Key, 'leftarrow')
            fprintf('left\n');
            Y = Y - y_step;
            show();
        elseif strcmp(event.Key, 'rightarrow')
            fprintf('right\n');
            Y = Y + y_step;
            show();
        elseif a == 'q'
            close all;
        end
    end
    function Render(source,callbackdata)
        model = teapotModel(0.05, 0.05, pi / 50);
        model = translateModel(model, [0 -1.5 0]);
        model = rotateModel(model, [X, Y, 0], [2 1 3]);
        texture = imread('name.PNG');
        texture = rgb2gray(texture);
        mat = renderTexture(zeros(600,800),model,light,5,90,texture);
        figure(2)
        imshow(mat, [0 150]);
    end
end