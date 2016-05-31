function potgui()
mainWindow = figure(1);
set(mainWindow,'name','Graphic','MenuBar','none');
set(mainWindow,'keypressfcn',@keypressfcn);
b1 = uicontrol(gcf, 'style', 'pushbutton', ...
    'units', 'normalized', ...
    'position', [0.04,0.05,0.2,0.05], ...
    'string', 'Detail', ...
    'Callback', @Detail);
b2 = uicontrol(gcf, 'style', 'pushbutton', ...
    'units', 'normalized', ...
    'position', [0.28,0.05,0.2,0.05], ...
    'string', 'Render', ...
    'Callback', @Render);
b3 = uicontrol(gcf, 'style', 'pushbutton', ...
    'units', 'normalized', ...
    'position', [0.52,0.05,0.2,0.05], ...
    'string', 'Texture', ...
    'Callback', @Texture);
b4 = uicontrol(gcf, 'style', 'pushbutton', ...
    'units', 'normalized', ...
    'position', [0.76,0.05,0.2,0.05], ...
    'string', 'DIY', ...
    'Callback', @DIY);

basemodel = teapotModel(0.5, 0.5, pi / 10);
basemodel = translateModel(basemodel,[0 -1.5 0]);
model_high = [];

Y = 0;
X = 20;
cam_depth = 5;
x_step = 10;
y_step = 10;
cam_step = 0.1;
light = [4 2 10];

rendered = [];
r_zbuffer = [];
renderFlag = 0;
textured = [];
t_zbuffer = [];

show();

    function show()
        figure(1)
        model_low = rotateModel(basemodel, [X, Y, 0], [2 1 3]);
        opt = gridView(zeros(300, 400), model_low, cam_depth, 90);
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
        elseif a == 'w'
            fprintf('forward\n');
            cam_depth = cam_depth - cam_step;
            show();
        elseif a == 's'
            fprintf('backward\n');
            cam_depth = cam_depth + cam_step;
            show();
        elseif a == 'q'
            close all;
        end
    end
    function Detail(source,callbackdata)
        figure(2);
        teapotModel(0.05, 0.05, pi / 50, 1);
    end
    function Render(source,callbackdata)
        set(b2,'String','Waiting');
        drawnow;
        model_high = teapotModel(0.05, 0.05, pi / 50);
        model_high = translateModel(model_high, [0 -1.5 0]);
        model_high = rotateModel(model_high, [X, Y, 0], [2 1 3]);
        [rendered, r_zbuffer] = renderSurfaces(zeros(600,800,3),model_high, ...
            light,cam_depth,90);
        renderFlag = 1;
        figure(3)
        imshow(rendered);
        set(b2,'String','Render');
        drawnow;
    end
    function Texture(source,callbackdata)
        if ~renderFlag
            Render();
        end
        set(b3,'String','Waiting');
        drawnow;
        [textured, t_zbuffer] = renderTexture( rendered, r_zbuffer, ...
            model_high, light,cam_depth,90);
        figure(4)
        imshow(textured);
        set(b3,'String','Texture');
        drawnow;
    end
    function DIY(source,callbackdata)
        if ~renderFlag
            Render();
        end
        set(mainWindow,'visible','off');
        if facedetect()
            set(mainWindow,'visible','on');
            set(b4,'string','Waiting');
            drawnow;
            [textured, t_zbuffer] = renderTexture( rendered, r_zbuffer, ...
                model_high, light,cam_depth,90,'name.PNG','face.jpg');
            set(b4,'string','DIY');
            figure(4);
            imshow(textured);
        end
        set(mainWindow,'visible','on');
    end
end