function [ train,test,trainRaw,testRaw ] = splitTrainTest( data,dataRaw, ratio )
%SPLITTRAINTEST Summary of this function goes here
%   Detailed explanation goes here
train=data(1,:);
trainRaw=dataRaw(1,:);
test=data(1,:);
testRaw=dataRaw(1,:);
rng('shuffle')
for i=2:size(data,1)
if rand()<=ratio
    train=[train;data(i,:)];
	trainRaw=[trainRaw;dataRaw(i,:)];
else
     test=[test;data(i,:)];
 	testRaw=[testRaw;dataRaw(i,:)];
end
end

