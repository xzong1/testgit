 %% Created in May 2015 by Xi Zong

function varargout = startle(varargin)
% STARTLE MATLAB code for startle.fig
%      STARTLE, by itself, creates a new STARTLE or raises the existing
%      singleton*.
%
%      H = STARTLE returns the handle to a new STARTLE or the handle to
%      the existing singleton*.
%
%      STARTLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STARTLE.M with the given input arguments.
%
%      STARTLE('Property','Value',...) creates a new STARTLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before startle_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to startle_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help startle

% Last Modified by GUIDE v2.5 07-Jul-2015 15:39:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @startle_OpeningFcn, ...
                   'gui_OutputFcn',  @startle_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before startle is made visible.
function startle_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to startle (see VARARGIN)

% Choose default command line output for startle
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes startle wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = startle_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in pushbutton1.
%New block
function pushbutton1_Callback(hObject, eventdata, handles)
%% Initiate DAQ
global tn 
if tn == 15

tn =15;
siren = daq.createSession('ni')%siren supply
daqinput = daq.createSession('ni')%daqinput
%Syn cue channel between two DAQs

syncue = daq.createSession('ni');%syncue output
addAnalogOutputChannel(syncue,'Dev1','ao0','Voltage');
syncue.Rate= 4000;
outputSingleScan(syncue,0);


%siren output
addDigitalChannel(siren,'Dev1','Port0/Line1','OutputOnly');

%Other inputs
ch11=addAnalogInputChannel(daqinput,'Dev1','ai11','Voltage');%Syncue
ch20=addAnalogInputChannel(daqinput,'Dev1','ai20','Voltage');%Siren
ch10=addAnalogInputChannel(daqinput,'Dev1','ai10','Voltage');%Speaker
%
ch11.InputType = 'SingleEnded';
ch20.InputType = 'SingleEnded';
ch10.InputType = 'SingleEnded';

%EMG inputs
ch1=addAnalogInputChannel(daqinput,'Dev1','ai1','Voltage'); %LSCM
ch8=addAnalogInputChannel(daqinput,'Dev1','ai8','Voltage'); 
ch12=addAnalogInputChannel(daqinput,'Dev1','ai12','Voltage');
ch5=addAnalogInputChannel(daqinput,'Dev1','ai5','Voltage');
ch13=addAnalogInputChannel(daqinput,'Dev1','ai13','Voltage');
ch6=addAnalogInputChannel(daqinput,'Dev1','ai6','Voltage');
ch14=addAnalogInputChannel(daqinput,'Dev1','ai14','Voltage');
ch7=addAnalogInputChannel(daqinput,'Dev1','ai7','Voltage');

ch23=addAnalogInputChannel(daqinput,'Dev1','ai23','Voltage'); %yellow y
ch31=addAnalogInputChannel(daqinput,'Dev1','ai22','Voltage');%blue z

%
ch8.InputType = 'SingleEnded';
ch1.InputType = 'SingleEnded';
ch12.InputType = 'SingleEnded';
ch5.InputType = 'SingleEnded';
ch13.InputType = 'SingleEnded';
ch6.InputType = 'SingleEnded';
ch14.InputType = 'SingleEnded';
ch7.InputType = 'SingleEnded';

ch23.InputType = 'SingleEnded';
ch31.InputType = 'SingleEnded';






%% Non-startle

%Speaker input
speaker = daq.createSession('ni');
speaker.Rate = 441000;
addAnalogOutputChannel(speaker,'Dev1','ao1','Voltage');




daqinput.Rate=3000;
daqinput.NotifyWhenDataAvailableExceeds=200;
daqinput.DurationInSeconds =8;

%% others
[sad,sss]=audioread('sad.mp3');
[happy,hhh]=audioread('happy.mp3');
[ready,hhh]=audioread('ready.mp3');




%Generating trial array
t0=str2double(get(handles.edit2,'string'));
t1=str2double(get(handles.edit3,'string'));
t2=get(handles.checkbox1,'Value');


 if (t0+t1)~=15
 msgbox(' :(  Type0 Plus Type1 Must Equal To 15');
 end

if t1==0
    tsum=t0;
    tArray=zeros(1,t0);
else
tsum=t0+t1;
tArray=zeros(1,tsum);
allP=combnk(1:t0,t1);
cbnIndex=ceil(length(allP)*rand);
cbn=allP(cbnIndex,:);
 
% for k=1:length(cbn)
%     tArray(k+cbn(k))=1;
%     if k==3 && t2==1
%         tArray(k+cbn(k))=2;
%     end
% end

rd=ceil(rand*2)+2;
%mod 3/29/16
rd2 = ceil(rand*2);
for k=1:length(cbn)
    if k==rd && t2==1
        tArray(k+cbn(k))=2;
    elseif k==rd2 && t2==1
        tArray(k+cbn(k))=2;
    else
    tArray(k+cbn(k))=1;
    end
end
%Outputing array
end
out=['Generated trials: '];
for k=1:tsum
    out=[out num2str(tArray(k)) ' '];   
end
set(handles.text6,'string',out);

%Initial couters
splus=0;
sminus=0;


%pass handles
handles.daqinput=daqinput;
handles.siren=siren;

handles.speaker=speaker;
% handles.sa=sa;
handles.tArray= tArray;
handles.sad=sad;
handles.happy=happy;
handles.ready=ready;
handles.syncue=syncue;

handles.output = hObject;
guidata(hObject,handles);
else
    msgbox('please check if the block is completed yet')
end


% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





%Start
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% sa=handles.sa;
global LastT
global tn

if tn == 15
    tn=0;
%this if avoid double click on start


setlastT=get(handles.checkbox2,'Value');
if setlastT==1
    lt=get(handles.edit12, 'string');
    LastT=str2num(lt);
end
setlastT=0;
%the syncue channel output
syncue=handles.syncue;
ready=handles.ready;




tArray=handles.tArray;
siren=handles.siren;
daqinput=handles.daqinput;
speaker=handles.speaker;
t=0:3*pi/500:80*pi;
output=-0.2+cos(t)';
output2=-0.2+0.3*cos(t)';
%extract info
subjectID=get(handles.edit1, 'string');
date=get(handles.edit8,'string');
tg=get(handles.edit11,'string');
foldername=[date '_' subjectID];
mkdir(foldername)

for tn=1:length(tArray)
% %% Initiate UDP 
% ipA = '129.219.77.110';   
% portA = 8000;   
% %local port
% portB=8001;
% %set up the udp object
% u = udp(ipA,portA,'LocalPort',portB);
% u.Timeout=0;
%open logs

type=num2str(tArray(tn));

%adding on the last trial
% LastT=get(handles.edit6, 'string');
% LastT=str2num(LastT);
tr=tn+LastT;
tn2=num2str(tr);
if tr<10
    tn2=strcat('0',tn2);
end

%encoding syncue
synt=1:pi/500:2*pi;
cue=(1+tn*0.2)*square(synt);
cue0=zeros(1,100);
cue=[cue cue0]';


subjectIDEMG=[pwd '\' foldername '\' date '_' subjectID '_trial' tn2 '_' tg '.txt'];
nowrun=['now runing trial#' tn2 ' type' type];
set(handles.text8,'string',nowrun);


% subjectIDROB=[subjectID '_type' type '_trial' tn2 '_ROB.txt'];
emglog=fopen(subjectIDEMG,'w');
% udplog=fopen(subjectIDROB,'w');
lh = addlistener(daqinput,'DataAvailable',@(src,event)saveemg(src,event,emglog,tArray(tn)));

%determine if the subject is near the center
% tg=0;
% ready=0;
% 
% while(ready==0)
% a=fscanf(u);
% [k1 k2]=size(a);
% if k2>20
% a=str2num(a)
% if abs(a(1))<0.015&&abs(a(2))<0.015&&tg==0
%     tic;
%     tg=1;
% elseif abs(a(1))<0.015&&abs(a(2))<0.015&&tg==1
%     b=toc
%     if b>4
%         ready=1;
%     end
% else
%     tg=0;
%     ready=0;
% end
% end
% end
% fclose(u);

pause(0.5)
fprintf('Starting.....\r\n')

% u.InputBufferSize=8192;
% u.DatagramReceivedFcn = {@saveudp,udplog};
daqinput.startBackground
if tArray(tn)==2
    queueOutputData(syncue,cue);
    startForeground(syncue);
    pause(1)
    outputSingleScan(siren,1);
pause(0.005)
outputSingleScan(siren,0);   
else
% fopen(u);
% u.RecordName='record.txt';
% u.RecordDetail='verbose';
% record(u)
queueOutputData(syncue,cue);
startForeground(syncue);
pause(0.5)
stt=rand*1+2.5;
queueOutputData(speaker,output2);
startForeground(speaker);
pause(stt)
if tArray(tn)==0
queueOutputData(speaker,output2);
startForeground(speaker);
else
outputSingleScan(siren,1);
pause(0.002)
outputSingleScan(siren,0);
end
fprintf('Giving Reward Sound and Ploting Result.....\r\n')
end
wait(daqinput)
fclose(emglog);
delete(lh);
handles.subjectIDEMG=subjectIDEMG;

updateaxis(handles)
fprintf('Select Plus or Minus\r\n')


waitforbuttonpress 
%to go out of the loop
setlastT=get(handles.checkbox2,'Value');
if setlastT==1
   break
end



end
fprintf('end of this block\n')
LastT=LastT+length(tArray);
handles.output = hObject;
guidata(hObject,handles);
else
    msgbox('Invalid Start, check if it is the end of the block')
end



% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function updateaxis(handles)
subjectIDEMG=handles.subjectIDEMG;
emglog=fopen(subjectIDEMG);
[data,count]=fread(emglog,[15,inf],'double');%pay attention to column number
data=data';
sad=handles.sad;
happy=handles.happy;
ready=handles.ready;
%if it is a non-startle or a startle
w1=[59/1500,61/1500];
w2=[30/1500];
[b,a]=butter(4,w1,'stop');
[d,c]=butter(4,w2,'high');
filt1=filtfilt(b,a,data(:,5:12));
%demean
filt1=filtfilt(d,c,filt1);

data(:,5:12)=abs(bsxfun(@minus,filt1,nanmean(filt1)));



%need to change when column number changed 
if data(1,end)==0%go trial look at colum4
    
    %determine reaction time
%     goindex=find(data(:,4)<-0.8,1);%go sample number
%     moveindex=find(data(:,2)<4);
    
    goindex=find(data(:,4)<-0.3)%
    goindex=goindex(find(goindex(:,1)>9000,1))
%     m=find(moveindex>goindex,1);

    %Uncomment following to enable feed back
%     react=moveindex(m);
%     reactiontime=data(react,1)-data(goindex,1);
%     ptime=get(handles.edit7,'string');
%     ptime=str2num(ptime);
%     if ptime<reactiontime
%         sound(sad,44100)
%     else
%         sound(happy,44100)
%     end
%     result=['the reaction time is: ' num2str(reactiontime)];
%     set(handles.text13,'string',result);
%     
    id=goindex-0.1*3000:goindex+0.5*3000;
    t=data(id,1)-data(goindex,1);
    
 axes(handles.axes4)
    cla
    plot(t,data(id,5),'b')
    axis tight
    hold on;
    plot(t,data(id,4),':r')
    title('CH1')
    
    axes(handles.axes5)
    cla
    plot(t,data(id,6),'b')
    axis tight
    hold on;
    plot(t,data(id,4),':r')
    title('CH2')
    
    axes(handles.axes6)
    cla
    plot(t,data(id,7),'b')
    axis tight
    hold on;
    plot(t,data(id,4),':r')
    hold on;
    
    
    title('CH3')
    
    axes(handles.axes7)
    cla
    plot(t,data(id,8),'b')
    axis tight
    hold on;
    plot(t,data(id,4),':r')
    hold on;
    
    title('CH4')
    
    axes(handles.axes8)
    cla
    plot(t,data(id,9),'b')
    axis tight
    hold on;
    plot(t,data(id,4),':r')
    hold on;

    title('CH5')
    
    
    axes(handles.axes9)
    cla
    plot(t,data(id,10),'b')
    axis tight
    hold on;
    plot(t,data(id,4),':r')
    hold on;

    title('CH6')
    
    
    axes(handles.axes10)
    cla
    plot(t,data(id,11),'b')
    axis tight
    hold on;
    plot(t,data(id,4),':r')
    hold on;

    title('CH7') 
    
    axes(handles.axes11)
    cla
    plot(t,data(id,12),'b')
    axis tight
    hold on;
    plot(t,data(id,4),':r')
    hold on;
    title('CH8') 
   
    
else  %startle trial
    goindex=find(data(:,3)>3,1);
    
%     moveindex=find(data(:,2)<4);
%     m=find(moveindex>goindex,1);
%     react=moveindex(m);
    
    %uncomment following to enable feed back
%     reactiontime=data(react,1)-data(goindex,1);
%     ptime=get(handles.edit7,'string');
%     ptime=str2num(ptime);
%  
%     result=['the reaction time is: ' num2str(reactiontime)];
%     set(handles.text13,'string',result);
%     
    
    
    
    
    id=goindex-0.1*3000:goindex+0.5*3000;
    t=data(id,1)-data(goindex,1);
    
    axes(handles.axes4)
    cla
    plot(t,data(id,5),'b')
    axis tight
    hold on;
    plot(t,data(id,3),':r')
    title('CH1')
    
    axes(handles.axes5)
    cla
    plot(t,data(id,6),'b')
    axis tight
    hold on;
    plot(t,data(id,3),':r')
    title('CH2')
    
    axes(handles.axes6)
    cla
    plot(t,data(id,7),'b')
    axis tight
    hold on;
    plot(t,data(id,3),':r')
    hold on;
    
    title('CH3')
    
    axes(handles.axes7)
    cla
    plot(t,data(id,8),'b')
    axis tight
    hold on;
    plot(t,data(id,3),':r')
    hold on;
    
    title('CH4')
    
    axes(handles.axes8)
    cla
    plot(t,data(id,9),'b')
    axis tight
    hold on;
    plot(t,data(id,3),':r')
    hold on;

    title('CH5')
    
    
    axes(handles.axes9)
    cla
    plot(t,data(id,10),'b')
    axis tight
    hold on;
    plot(t,data(id,3),':r')
    hold on;

    title('CH6')
    
    
    axes(handles.axes10)
    cla
    plot(t,data(id,11),'b')
    axis tight
    hold on;
    plot(t,data(id,3),':r')
    hold on;

    title('CH7')
    
    axes(handles.axes11)
    cla
    plot(t,data(id,12),'b')
    axis tight
    hold on;
    plot(t,data(id,3),':r')
    hold on;
    title('CH8') 
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global splus
splus=splus+1;
set(handles.text16,'string',num2str(splus));
handles.output = hObject;
guidata(hObject,handles);

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global sminus
sminus=sminus+1;
set(handles.text17,'string',num2str(sminus));
handles.output = hObject;
guidata(hObject,handles);
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global splus
splus=splus-1;
set(handles.text16,'string',num2str(splus));
handles.output = hObject;
guidata(hObject,handles);
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
global sminus
sminus=sminus-1;
set(handles.text17,'string',num2str(sminus));
handles.output = hObject;
guidata(hObject,handles);
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
ct=handles.ct;
ct=1;
handles.ct=ct;
handles.output = hObject;
guidata(hObject,handles);

% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
global splus
global sminus
global LastT
global tn 
tn =15;
splus=0;
sminus=0;
LastT=0;
set(handles.text30, 'string', randperm(5));


% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
