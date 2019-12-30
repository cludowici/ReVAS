function [default, validate] = GetDefaults(module)

switch module
      
    case 'FindBlinkFrames'
        % default values
        default.overwrite = false;
        default.enableVerbosity = false;
        default.badFrames = false;
        default.axesHandles = [];
        default.stitchCriteria = 1;
        default.numberOfBins = 256;
        default.meanDifferenceThreshold = 10; 
        
        % validation functions
        validate.overwrite = @islogical;
        validate.enableVerbosity = @(x) islogical(x) | (isscalar(x) & x>=0);
        validate.badFrames = @(x) all(islogical(x));
        validate.axesHandles = @(x) isempty(x) | all(ishandle(x));
        validate.stitchCriteria = @IsPositiveInteger;
        validate.numberOfBins = @(x) IsPositiveInteger(x) & (x<=256);
        validate.meanDifferenceThreshold = @IsPositiveRealNumber;    
        
    case 'TrimVideo'
        % default values
        default.overwrite = false;
        default.badFrames = false;
        default.borderTrimAmount = [0 0 12 0];
        
        % validation functions
        validate.overwrite = @islogical;
        validate.badFrames = @(x) all(islogical(x));
        validate.borderTrimAmount = @(x) all(IsNaturalNumber(x)) & (length(x)==4);
        
    case 'RemoveStimuli'
        % default values
        default.overwrite = false;
        default.enableVerbosity = false;
        default.badFrames = false;
        default.axesHandles = [];
        default.minPeakThreshold = 0.6;
        default.frameRate = 30;
        default.fillingMethod = 'resample';
        default.removalAreaSize = [];
        default.stimulus = [];
        default.stimulusSize = 11;
        default.stimulusThickness = 1;
        default.stimulusPolarity = 1;
        
        % validation functions 
        validate.overwrite = @islogical;
        validate.enableVerbosity = @(x) islogical(x) | (isscalar(x) & x>=0);
        validate.badFrames = @(x) all(islogical(x));
        validate.axesHandles = @(x) isempty(x) | all(ishandle(x));
        validate.minPeakThreshold = @IsNonNegativeRealNumber;
        validate.frameRate = @IsPositiveRealNumber;
        validate.fillingMethod = @(x) any(contains({'resample','noise'},x));
        validate.removalAreaSize = @(x) isempty(x) | (isnumeric(x) & all(IsPositiveRealNumber(x)) & length(x)==2);
        validate.stimulus = @(x) isempty(x) | ischar(x) | ((isnumeric(x) | islogical(x)) & size(x,1)>1 & size(x,2)>1 & size(x,3)==1);
        validate.stimulusSize = @IsPositiveInteger;
        validate.stimulusThickness = @IsPositiveInteger;
        validate.stimulusPolarity = @(x) islogical(x) | (isnumeric(x) & any(x == [0 1]));
     
    case 'GammaCorrect'
        % default values
        default.overwrite = false;
        default.method = 'simpleGamma';
        default.gammaExponent = 0.6;
        default.toneCurve = uint8(0:255); 
        default.histLevels = 64;
        default.badFrames = false;
        
        % validation functions 
        validate.overwrite = @islogical;
        validate.method = @(x) any(contains({'simpleGamma','histEq','toneMapping'},x));
        validate.gammaExponent = @IsNonNegativeRealNumber;
        validate.toneCurve = @(x) isa(x, 'uint8') & length(x)==256;
        validate.histLevels = @IsPositiveInteger;
        validate.badFrames = @(x) all(islogical(x));  
        
    case 'BandpassFilter'
        % default values
        default.overwrite = false;
        default.badFrames = false;
        default.smoothing = 1;
        default.lowSpatialFrequencyCutoff = 3;
        
        % validation functions
        validate.overwrite = @islogical;
        validate.badFrames = @(x) all(islogical(x));
        validate.smoothing = @IsPositiveRealNumber;
        validate.lowSpatialFrequencyCutoff = @IsNonNegativeRealNumber;
    
    case 'StripAnalysis' 
        % default values
        default.overwrite = false;
        default.enableGPU = false;
        default.enableVerbosity = false;
        default.enableReferenceFrameUpdate = true;
        default.goodFrameCriterion = 0.8;
        default.swapFrameCriterion = 0.8;
        default.corrMethod = 'mex';
        default.referenceFrame = 1;
        default.badFrames = false;
        default.stripHeight = 11;
        default.samplingRate = 540;
        default.minPeakThreshold = 0.65;
        default.maxMotionThreshold = 0.12; % proportion of frame size
        default.adaptiveSearch = true;
        default.searchWindowHeight = 79;
        default.lookBackTime = 20;
        default.frameRate = 30;
        default.axesHandles = [];
        default.neighborhoodSize = 5;
        default.subpixelDepth = 0;
        default.trim = [0 0];

        % validation functions 
        validate.overwrite = @islogical;
        validate.enableGPU = @islogical;
        validate.enableVerbosity = @(x) islogical(x) | (isscalar(x) & x>=0);
        validate.enableReferenceFrameUpdate = @islogical;
        validate.goodFrameCriterion = @(x) IsPositiveRealNumber(x) & (x<=1);
        validate.swapFrameCriterion = @(x) IsPositiveRealNumber(x) & (x<=1);
        validate.corrMethod = @(x) any(contains({'mex','normxcorr','fft','cuda'},x));
        validate.referenceFrame = @(x) isscalar(x) | ischar(x) | (isnumeric(x) & size(x,1)>1 & size(x,2)>1);
        validate.badFrames = @(x) all(islogical(x));
        validate.stripHeight = @IsNaturalNumber;
        validate.samplingRate = @IsNaturalNumber;
        validate.minPeakThreshold = @IsNonNegativeRealNumber; 
        validate.maxMotionThreshold = @(x) IsPositiveRealNumber(x) & (x<=1);
        validate.adaptiveSearch = @islogical;
        validate.searchWindowHeight = @IsPositiveInteger;
        validate.lookBackTime = @(x) IsPositiveRealNumber(x) & (x>=2);
        validate.frameRate = @IsPositiveRealNumber;
        validate.axesHandles = @(x) isempty(x) | all(ishandle(x));
        validate.neighborhoodSize = @IsPositiveInteger;
        validate.subpixelDepth = @IsNaturalNumber;
        validate.trim = @(x) all(IsNaturalNumber(x)) & (length(x)==2);
        
        
    case 'MakeReference'
        
        % default values
        default.overwrite = false;
        default.enableVerbosity = false;
        default.badFrames = false;
        default.rowNumbers = []; % fail, if not provided
        default.positions = []; % fail, if not provided
        default.timeSec = []; % fail, if not provided
        default.peakValues = []; % fail, if not provided
        default.oldStripHeight = []; % fail, if not provided
        default.newStripHeight = 3;
        default.axesHandles = [];
        default.subpixelDepth = 0;
        default.minPeakThreshold = 0.5;
        default.maxMotionThreshold = 0.06; % proportion of frame size
        default.trim = [0 0];
        default.enhanceStrips = true;
        
        % validation functions 
        validate.overwrite = @islogical;
        validate.enableVerbosity = @(x) islogical(x) | (isscalar(x) & x>=0);
        validate.badFrames = @(x) all(islogical(x));
        validate.rowNumbers = @(x) (length(x)>=1 & IsPositiveInteger(x));
        validate.positions = @(x) (isnumeric(x) & size(x,1)>=1 & size(x,2)==2);
        validate.timeSec = @(x) (isnumeric(x) & size(x,1)>=1 & size(x,2)==1);
        validate.peakValues = @IsNonNegativeRealNumber;
        validate.oldStripHeight = @IsNaturalNumber;
        validate.newStripHeight = @IsNaturalNumber;
        validate.axesHandles = @(x) isempty(x) | all(ishandle(x));
        validate.subpixelDepth = @IsNaturalNumber;
        validate.minPeakThreshold = @IsNonNegativeRealNumber;
        validate.maxMotionThreshold = @(x) IsPositiveRealNumber(x) & (x<=1);
        validate.trim = @(x) all(IsNaturalNumber(x)) & (length(x)==2);
        validate.enhanceStrips = @islogical;
        
    otherwise
        error('GetDefaults: unknown module name.');
end


