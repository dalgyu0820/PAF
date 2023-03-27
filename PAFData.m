function [sig_PA, FFN, FileName] = PAFData(Datapath)

[file,DATAPATH] = uigetfile([Datapath '\*.bin'],...
   'Select One or More Files', ...
   'MultiSelect', 'on');
FFN = -1;
sig_PA = zeros(20480,size(file,2));
sig_trig = zeros(20480,size(file,2));
temp = split(file{1,1},'_');
temp2 = split(temp{2,1},'.');
temp3 = string(temp2{1,1});
FileName = string(temp{1,1});
FFN = str2num(temp3);%1st file name

for numFile = 1:size(file,2)
    FILENAME = file{1,numFile};
    fID = fopen([DATAPATH '\' FILENAME], 'r');

    sizePixel = fread(fID, 1, 'int32','ieee-le');
    dataPixel = fread(fID,sizePixel, 'double', 'ieee-le');
    rawdata = reshape(dataPixel, sizePixel/2, 2);
    sig_PA(:,numFile) = rawdata(:,1);
    sig_trig(:,numFile) = rawdata(:,2);
    fclose(fID);
end

