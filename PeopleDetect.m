detector = peopleDetectorACF;

I = imread('visionteam.jpg');
imshow(I)

[bbox,scores] = detect(detector,I);
if ~isempty(bbox)
    detected = insertObjectAnnotation(I,'rectangle',bbox,scores);
    n = size(bbox);
    n = num2str(n(:,1));
    y = strcat('Peeople detected are: ',n);
    detected = insertText(detected,[10 385],y);
    imshow(detected)
end

%% Tracking A face in a size
FaceDetector = vision.CascadeObjectDetector();
videoreader = vision.VideoFileReader('visionface.avi');
videoplayer = vision.DeployableVideoPlayer();

frame = step(videoreader);
bbox = step(FaceDetector,frame);
%I = insertShape(frame,'rectangle',bbox,'Color','g');
%imshow(I)

%% To find the MinEigenFeatures on the Image and plot it
points = detectMinEigenFeatures(rgb2gray(I),'ROI',bbox);
pointImage = insertMarker(frame,points.Location,'+','Color','white');
%imshow(pointImage);

%% Now to Track the detected Region

tracker = vision.PointTracker('MaxBidirectionalError',1);

initialize(tracker,points.Location,frame);

while ~isDone(videoreader)
   frame = step(videoreader);
   [points,validity] = tracker(frame);
   
   out = insertMarker(frame,points(validity,:),'+');
   videoplayer(out)
    
    pause(0.1)
    
end


%%
while true
  frame = step(videoreader);
   bbox = step(FaceDetector,frame);
  if ~isempty(bbox)
      faceregion = insertShape(frame,'rectangle',bbox);
      step(videoplayer,faceregion);
      pause(0.1);
   end
   
    
end
