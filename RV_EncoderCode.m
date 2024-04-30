% HOW TO USE THIS SCRIPT

% 1. Ensure all physical connections are correct.

% 2. Run this script according to the timings detailed in Chapter 3.2.1 of the dissertation.

% 3. Once the script has finished, save the results array with a unique name, e.g. "encoder_orificeX_ringX".

% 4. Repeat steps 2-4 according to the timings in Chapter 3.2.1.

% 5. Ensure all files are saved in an appropriate folder.


NumberofRings=1;
                
Matrix=zeros(3000,NumberofRings);
LoopTimes=zeros(1,NumberofRings);
for a=1:NumberofRings

E2019Q_ID = E2019Q.Open_COM_Port('COM3');
Power_Supply = E2019Q.EncSupply_ON(E2019Q_ID); % turn on
 
E2019Q.ClearReferenceFlag(E2019Q_ID);
E2019Q.ResetCurrentCount(E2019Q_ID);
E2019Q.ClearZeroOffset(E2019Q_ID);
 
 tic;
OneOutput=E2019Q.OneAttempt(E2019Q_ID);
pause(1)
 E2019Q.ZeroAttempt(E2019Q_ID);
toc;
 
tic;
OneOutput=E2019Q.OneAttempt(E2019Q_ID);
pause(1)
LoopTimeOne=toc;
 E2019Q.ZeroAttempt(E2019Q_ID);
 
 Power_Supply = E2019Q.EncSupply_OFF(E2019Q_ID); % turn off
 pause(1);
E2019Q.Close_COM_Port(E2019Q_ID); % before disconnecting
 
pause(1);
%clear unnecessary variables from saving in expt
clear IntervalMS Out P PosChange Positions PositionsDBL Power_Supply 
clear TimeAxis Velocity i Interval Frequency ans 
 
%create double file format from Loops #1,#2 char position readouts
PositionOne=splitlines(OneOutput);
PositionsDBLOne=str2double(PositionOne);
 
dT=LoopTimeOne/size(PositionsDBLOne,1);
PosChangeOne=[];
 
for i=2:size(PositionsDBLOne,1)
    P=abs((PositionsDBLOne(i)-PositionsDBLOne(i-1))/dT)*1e-4;
    PosChangeOne=[PosChangeOne;P];
end 
Matrix(1:size(PosChangeOne,1),a)=PosChangeOne;
end
