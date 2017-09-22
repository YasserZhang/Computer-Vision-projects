% outputVideo = VideoWriter('shuttle_out.avi');
% outputVideo.FrameRate = 2;
% open(outputVideo)
% 
% for ii = 1:10
%     fname = sprintf('SampleOutput%03d.jpg', ii);
%     img = imread(fname);
%     writeVideo(outputVideo,img)
% end

% N = length(fileNames);
% C
% for ii = 1:10
%     fname = sprintf('SampleOutput%03d.jpg', ii);
%     C(:,:,ii) = imread(filename);
% end
% mplay(C)


%Create Video with Image Sequence
clear all
clc
%Make the Below path as the Current Folder
%cd('C:\Documents and Settings\AARON\My Documents\MATLAB\Images');

%Obtain all the JPEG format files in the current folder
%Files = dir('*.jpg');


%Find the total number of JPEG files in the Current Folder
%NumFiles= size(Files,1);

%Preallocate a 4-D matrix to store the Image Sequence
%Matrix Format : [Height Width 3 Number_Of_Images]
Megamind_Images = uint8(zeros([800 1200 3 5*15]));

%To write Video File
VideoObj = VideoWriter('Output_Video.wmv');
%Number of Frames per Second
VideoObj.FrameRate = 15; 
%Define the Video Quality [ 0 to 100 ]
VideoObj.Quality   = 80;  
% for ii = 1:10
%     fname = sprintf('SampleOutput%03d.jpg', ii);
%     img = imread(fname);
%     writeVideo(outputVideo,img)
% end

count=1;

for i = 1 : 2 : 10
  
    %Read the Images in the Current Folder one by one using For Loop
   
    fname = sprintf('SampleOutput%03d.jpg', i);
    I = imread(fname);
  
    %The Size of the Images are made same
    ResizeImg = imresize(I,[800 1200]);
  
    %Each Image is copied 5 times so that in a second 1 image can be viewed
    for j = 1 : 7
        Megamind_Images(:,:,:,count)=ResizeImg;
        count = count + 1;
    end
   
    fname = sprintf('SampleOutput%03d.jpg', i + 1);
    I = imread(fname);
   
    %The Size of the Images are made same
    ResizeImg = imresize(I,[800 1200]);

    %Each Image is copied 5 times so that in a second 1 image can be viewed
    for j = 1 : 8
        Megamind_Images(:,:,:,count)=ResizeImg;
        count = count + 1;
    end
end

%Open the File 'Create_Video.avi'
open(VideoObj);


%Write the Images into the File 'Create_Video.avi'
writeVideo(VideoObj, Megamind_Images);


%Close the file 'Create_Video.avi'
close(VideoObj);