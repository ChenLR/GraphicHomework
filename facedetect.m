function captured = facedetect
% Create the face detector object.
faceDetector = vision.CascadeObjectDetector();

% Create the point tracker object.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Create the webcam object.
cam = webcam();

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', ...
    [100 100 [frameSize(2), frameSize(1)]+30]);
controlWindow = figure('MenuBar','none', 'Position', ...
    [100 ,100 - 40,frameSize(2)+30, 30]);
resultWindow = figure('MenuBar','none','Visible','off','Name','Result', ...
    'Position', [100 + frameSize(2) + 200 ,100 - 40, 400, 400], ...
    'Resize','off');



hb2 = uicontrol('Parent', controlWindow, 'Units', 'Normalized', ...
    'Position', [0.4 0.05 0.2 0.9], 'String', 'Capture', 'Callback',@hb2callback );
hb1 = uicontrol('Parent', controlWindow, 'Units', 'Normalized', ...
    'Position', [0.1 0.05 0.2 0.9], 'String', 'Clear', 'Callback',@hb1callback );
hb3 = uicontrol('Parent', controlWindow, 'Units', 'Normalized', ...
    'Position', [0.7 0.05 0.2 0.9], 'String', 'Exit', 'Callback',@hb3callback );


runLoop = true;
numPts = 0;
closeflag = 1;
captured = 0;

while runLoop && closeflag
    
    % Get the next frame.
    videoFrame = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    
    if numPts < 10
        % Detection mode.
        bbox = faceDetector.step(videoFrameGray);
        
        if ~isempty(bbox)
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));
            
            % Re-initialize the point tracker.
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);
            
            % Save a copy of the points.
            oldPoints = xyPoints;
            
            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :));
            
            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);
            
            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);
            
            % Display detected corners.
            videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end
        
    else
        % Tracking mode.
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);
        
        numPts = size(visiblePoints, 1);
        
        if numPts >= 10
            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
            
            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);
            
            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);
            
            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);
            
            % Display tracked points.
            videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');
            
            % Reset the points.
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
        end
        
    end
    
    % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);
    
    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
end

% Clean up.
clear cam;
release(videoPlayer);
release(pointTracker);
release(faceDetector);

    function hb1callback(source,callbackdata)
        numPts = 0;
    end
    function hb2callback(source,callbackdata)
        captured = 1;
        figure(resultWindow);
        set(resultWindow, 'Visible','on');
        frame = snapshot(cam);
        in = double(bboxPoints);
        out = [ 1 1;400 1; 400 400; 1 400];
        tform = maketform('projective', in, out);
        % J = imtransform(frame, tform);
        % imtool(J);
        J = imtransform(frame, tform,'Xdata',[1 400],'Ydata',[1 400]);
        roi = J;
        imwrite(roi, 'face.jpg');
        imshow(roi);
    end
    function hb3callback(source,callbackdata)
        close(resultWindow);
        close(controlWindow);
        closeflag = 0;
    end
end