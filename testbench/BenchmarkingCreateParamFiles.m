function [] = BenchmarkingCreateParamFiles()
%BENCHMARKING Script used to create param files to benchmark real videos.
%   Script used to benchmark ReVAS.
%   When prompted, user should select the pre-processed videos.

%%
clc;
clear;
close all;
addpath(genpath('..'));

filenames = uipickfiles;
if ~iscell(filenames)
    if filenames == 0
        fprintf('User cancelled file selection. Silently exiting...\n');
        return;
    end
end

load('testbench/template_params', ...
    'coarseParameters', 'fineParameters', 'stripParameters');

for i = 1:length(filenames)
    originalVideoPath = filenames{i};
    
    nameEnd = strfind(originalVideoPath,'bandfilt');
    paramsPath = [originalVideoPath(1:nameEnd+length('bandfilt')-1) '_params'];
    
    % Remember video path to make it more convenient to compare params
    % files.
    coarseParameters.originalVideoPath = originalVideoPath;
    fineParameters.originalVideoPath = originalVideoPath;
    stripParameters.originalVideoPath = originalVideoPath;
    
    % Read the videos
    videoArray = VideoPathToArray(originalVideoPath);
    frameHeight = size(videoArray, 1);
    frameWidth = size(videoArray, 2);
    
    % Strip Width
    fineParameters.stripWidth = frameWidth;
    stripParameters.stripWidth = frameWidth;
    
    % Calculate Sampling Rate based on Strip Height
    stripsPerFrame = floor(frameHeight/fineParameters.stripHeight);
    framesPerSecond = 30;
    fineParameters.samplingRate = stripsPerFrame * framesPerSecond;
    
    stripsPerFrame = floor(frameHeight/stripParameters.stripHeight);
    stripParameters.samplingRate = stripsPerFrame * framesPerSecond;
    
    
    % Blink Params (Can be customized)
    % thresholdvalue was 0.7 for last video in AOSLO
    coarseParameters.thresholdValue = 1.4;
    coarseParameters.upperTail = true;
    %coarseParameters.removalAreaSize = [60, 100];
    
    % Customized params (for AOSLO)
    coarseParameters.minimumPeakThreshold = 0.1;
    coarseParameters.maximumPeakRatio = 0.85;
    coarseParameters.searchWindowPercentage = 0.33;
    
    fineParameters.searchWindowPercentage = 0.33;
    stripParameters.searchWindowPercentage = 0.33;
    fineParameters.numberOfIterations = 3;
    % End of AOSLO parameters
    
    % Other customized params (for TSLO)
    %coarseParameters.searchWindowPercentage = 0.4;
%     fineParameters.searchWindowPercentage = 0.33;
%     stripParameters.searchWindowPercentage = 0.33;
%     
%     coarseParameters.enableGaussianFiltering = 1;
%     coarseParameters.gaussianStandardDeviation = 10;
%     coarseParameters.maximumSD = 30;
%     coarseParameters.SDWindowSize = 25;
%     
%     fineParameters.enableGaussianFiltering = 1;
%     fineParameters.numberOfIterations = 3;
%     fineParameters.gaussianStandardDeviation = 10;
%     fineParameters.maximumSD = 30;
%     fineParameters.SDWindowSize = 25;
%     
%     stripParameters.enableGaussianFiltering = 1;
%     stripParameters.gaussianStandardDeviation = 10;
%     stripParameters.maximumSD = 30;
%     stripParameters.SDWindowSize = 25;
    % End of custom params (for TSLO)
    
    save(paramsPath, 'coarseParameters', 'fineParameters', 'stripParameters');
    fprintf('%d of %d completed.\n', i, length(filenames));
end
fprintf('Process Completed.\n');

end

