% HOW TO USE THIS SCRIPT

% 1. Run the position tracker script first, import those results into Excel.

% 2. Write StartFrame variable as found previously using implay.

% 3. Write the video title in the V variable.

% 4. Run this script. A window should appear with the tank. Draw a line from the top inner left wall of the tank to the top inner right wall of the tank (account for parallax).

% 5. A new window will open showing the ring at the 5cm point. Double click the top of the ring vortex, then the bottom of the ring vortex, then the most left point of the ring vortex, and then the most right point of the ring vortex. The 20cm point will then appear, repeat this process.

% 6. Repeat step 4 with each subsequent ring vortex.

% 7. Take the final outputted table and import to Excel for analysis.


% VARIABLES TO BE CHANGED FOR EACH EXPERIMENT

% shapeFrames array: Use table in excel to find which shown frames out of the 16 were at 5cm point and 20cm point
shapeFrames = [3 12; 3 12; 3 12; 3 12; 3 13; 3 13; 4 13; 4 13; 3 13; 4 13; 3 13; 3 13; 3 13; 4 13; 4 13; 4 13];
StartFrame=7701;       %Found by implay function on separate script. Frames in bottom right. MUST MATCH POSITION TRACKER SCRIPT.
V=VideoReader('C1584.mp4');   %Change file name here 


% DECLARATIONS -- DO NOT CHANGE

excelOutput= [];

Points=[];  %Creates blank array for position coord
Times=[]; %Creates blank arrays for graph time axis
TankLength=35;         %Must be calibrated from wall to wall. DO NOT CHANGE
FrameRate=100;  % Frame rate of camera. DO NOT CHANGE

top5=[];
bottom5=[];
left5=[];
right5=[];
length5=[];
width5=[];

top20=[];
bottom20=[];
left20=[];
right20=[];
length20=[];
width20=[];

SkipFrame=20;   % how many frames were used between each shown image of the ring. MUST MATCH SkipFrame IN POSITION TRACKER SCRIPT

ringNo=1;              % first ring to analyse. DO NOT CHANGE               
FrameNo=300;  %How many frames to analyse on each ring. DO NOT CHANGE. MUST MATCH FrameNo IN POSITION TRACKER SCRIPT.

FrameTime=1/FrameRate;  %Don't alter
StartTime=0;            %Don't alter                  


% CALIBRATION

video1=read(V,(StartFrame-10));           %Selects frame for calibration
imshow(video1,'InitialMagnification', 'fit')                         
roi1=imline                         %Draw line between interior walls (waterline)
Calibration=getPosition(roi1);           
PixelLength=Calibration(2,1)-Calibration(1,1);  %Pixels between x coords
CMPerPixel=TankLength/PixelLength;  %Calculates cm/pixel for conversion


% DISPLAYING FRAMES AT 5CM AND 20CM FOR EACH RING

for ringNo = 1 : 16
    
    clear cm5
    cm5 = shapeFrames(ringNo,1);
    clear cm20
    cm20 = shapeFrames(ringNo,2);
    
    video=read(V,(StartFrame + ((ringNo-1) * 2713) + (cm5 * SkipFrame)));  %Reads and displays frames in loop

    imshow(video, 'InitialMagnification', 'fit')
    clear xPT
    clear yPT
    [xPT,yPT] = getpts;                     %double click on top of ring
    top5(ringNo) = yPT;

    imshow(video, 'InitialMagnification', 'fit')
    clear xPT
    clear yPT
    [xPT,yPT] = getpts;                     %double click on bottom of ring 
    bottom5(ringNo) = yPT;

    imshow(video, 'InitialMagnification', 'fit')
    clear xPT
    clear yPT
    [xPT,yPT] = getpts;                     %double click on left of ring 
    left5(ringNo) = xPT;

    imshow(video, 'InitialMagnification', 'fit')
    clear xPT
    clear yPT
    [xPT,yPT] = getpts;                     %double click on right of ring 
    right5(ringNo) = xPT;

    length5(ringNo) = bottom5(ringNo)-top5(ringNo);
    width5(ringNo) = right5(ringNo)-left5(ringNo);
    video=read(V,(StartFrame + ((ringNo-1) * 2713) + (cm20 * SkipFrame)));  %Reads and displays frames in loop

    imshow(video, 'InitialMagnification', 'fit')
    clear xPT
    clear yPT
    [xPT,yPT] = getpts;                     %double click on top of ring
    top20(ringNo) = yPT;

    imshow(video, 'InitialMagnification', 'fit')
    clear xPT
    clear yPT
    [xPT,yPT] = getpts;                     %double click on bottom of ring 
    bottom20(ringNo) = yPT;

    imshow(video, 'InitialMagnification', 'fit')
    clear xPT
    clear yPT
    [xPT,yPT] = getpts;                     %double click on left of ring 
    left20(ringNo) = xPT;

    imshow(video, 'InitialMagnification', 'fit')
    clear xPT
    clear yPT
    [xPT,yPT] = getpts;                     %double click on right of ring 
    right20(ringNo) = xPT;

    length20(ringNo) = bottom20(ringNo)-top20(ringNo);
    width20(ringNo) = right20(ringNo)-left20(ringNo);

end

excelPixels=[];
excelOutputTransposed=[];

% CONSTRUCTING TABLE

for i = 1:16
    excelPixels(i,1) = top5(i);
    excelPixels(i,2) = bottom5(i);
    excelPixels(i,3) = left5(i);
    excelPixels(i,4) = right5(i);
    excelPixels(i,5) = top20(i);
    excelPixels(i,6) = bottom20(i);
    excelPixels(i,7) = left20(i);
    excelPixels(i,8) = right20(i);
    excelPixels(i,9) = length5(i);
    excelPixels(i,10) = width5(i); 
    excelPixels(i,11) = length20(i);
    excelPixels(i,12) = width20(i);
    
    for j = 1:12
    excelOutput(i,j) = excelPixels(i,j)*CMPerPixel;
    end
end
close

% OUTPUT TABLE
excelOutputTransposed=transpose(excelOutput)
