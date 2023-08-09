clear all;
close all;
clc;

%% Read Data Base
faceGallery = imageSet('Data_Base', 'recursive');
galleryNames = {faceGallery.Description};
displayFaceGallery(faceGallery,galleryNames);

%% Create HoG training features from gallery
trainingFeatures = zeros(19,10404); %% valori esattamente ottenuti per una ridimenzione 150x150
featureCount = 1;

for i=1:size(faceGallery,2) %%5
    for j = 1:faceGallery(i).Count %%Cala 3-Conti-3Flor_5..
        sizeNormalizedImage = imresize(rgb2gray(read(faceGallery(i),j)),[150 150]);
        %%imshow(sizeNormalizedImage); legge ogni foto
        %%->rgb2gray->ridimenziona 150x150
        trainingFeatures(featureCount,:) = extractHOGFeatures(sizeNormalizedImage);
        trainingLabel{featureCount} = faceGallery(i).Description;    
        featureCount = featureCount + 1;
    end
    personIndex{i} = faceGallery(i).Description;
end

%% Create Classifier 
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);

%% Read test data
testSet = imageSet('Data_Base_Test');
figure;
figureNum = 1;

for  i= 1: testSet.Count %%5
    queryImage = read(testSet,i);
    queryFeatures = extractHOGFeatures(imresize((rgb2gray(queryImage)),[150 150]));
    personLabel = predict(faceClassifier,queryFeatures);
    booleanIndex = strcmp(personLabel, personIndex);
    disp(booleanIndex); %%
    disp(i); %%
    integerIndex = find(booleanIndex);
    subplot(5,2,figureNum);imshow(queryImage);title('Query Face');
    subplot(5,2,figureNum+1);imshow(read(faceGallery(integerIndex),1));title('Matched');
    figureNum = figureNum+2;
end