% HOW TO USE THIS SCRIPT

% 1. In command bar run implay('_videotitlehere_.mp4'), run video until when first ring appears, note down frame number in bottom right corner and write this in StartFrame variable

% 2. Write the video title in the V variable

% 3. Run this script. A window should appear with the tank. Draw a line from the top inner left wall of the tank to the top inner right wall of the tank (account for parallax).

% 4. A new window will open. Double click the bottom of the ring vortex, repeat this until a new ring starts.

% 5. Repeat step 4 with each subsequent ring vortex.

% 6. Take the final outputted table and import to Excel for analysis.


% VARIABLES NEEDED TO ALTER FOR EACH EXPERIMENT

StartFrame=5402;       %Found by implay function on separate script. Frames in bottom right
V=VideoReader('C1591.mp4');   %Change file name here 


% DECLARATIONS -- DO NOT CHANGE

excelOutput= [];

Points=[];  %Creates blank array for position coord
Times=[]; %Creates blank arrays for graph time axis
TankLength=35;         %Must be calibrated from wall to wall. DO NOT CHANGE.
FrameRate=100;          % Frame rate of camera. DO NOT CHANGE.

SkipFrame=20;       % Frames skipped between each presented image. DO NOT CHANGE.

ringNo=1;         %ring starting number -- iterated for each ring. DO NOT CHANGE.               
FrameNo=300;  %How many frames to analyse on each ring. DO NOT CHANGE.

FrameTime=1/FrameRate;  %Don't alter
StartTime=0;            %Don't alter                  


% CALIBRATION

video1=read(V,(StartFrame-10));           %Selects  frame for calibration
imshow(video1,'InitialMagnification', 'fit')                         
roi1=imline                               %Draw line between interior walls (waterline)
Calibration=getPosition(roi1);           
PixelLength=Calibration(2,1)-Calibration(1,1);  %Pixels between x coords
CMPerPixel=TankLength/PixelLength;  %Calculates cm/pixel for conversion
imshow(video1,'InitialMagnification', 'fit')
[originX,originY]=getpts;           %First frame: select origin
% ITERATING TO PRESENT EACH IMAGE FOR EACH RING

for ringNo = 1 : 16
    LoopStartFrame=StartFrame+((ringNo-1)*2713); %27.13 sec between rings
    LoopEndFrame=LoopStartFrame+FrameNo;

    clear Points
    Points=[];

    for i=LoopStartFrame:SkipFrame:LoopEndFrame   
        video=read(V,i);                    %Reads and displays frames in loop
        imshow(video, 'InitialMagnification', 'fit')
        [xPT,yPT]=getpts;                     %double click on ring each time 
        
        Points=[Points;xPT];                  %Adds x coord to end of array
                                 
    end 
    close %Closes window
    clear Diff
    Diff=[]
    for N=1:length(Points)      
        X=Points(N,1)-originX;
        
        Diff=[Diff,X];
    end                                      %Find difference between x coordinates of each frame line, save to array
    
    clear CMLengths
    CMLengths=Diff*CMPerPixel;            %Convert to centimetres
    clear CMLengthsExcel
    CMLengthsExcel=transpose(CMLengths);   %Transposes to column vector for Excel use 

    % CREATE TABLE TO COPY TO EXCEL

    for i = 1: length(CMLengthsExcel)

        excelOutput(i,ringNo) = CMLengthsExcel(i)

    end

end

excelOutput()
