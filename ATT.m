clear all;
close all;
clc;

%% Load Image 
faceDatabase = imageSet('FaceDatabaseATT','recursive');

%% Collage di immagini di uno stesso individuo
figure;
montage(faceDatabase(1).ImageLocation);
title('Collage di un singolo individuo');

%% Qual'è il nostro obbiettivo
personToQuery = 1;
galleryImage = read(faceDatabase(personToQuery),1);
figure;
for i=1:size(faceDatabase,2)
    imageList(i) = faceDatabase(i).ImageLocation(5);
end
subplot(1,2,1);imshow(galleryImage);
title('Vogliamo identificare lui');
subplot(1,2,2);montage(imageList);
title('Dove sono?');

%% Split Database in Training e Test Sets
[training,test] = partition(faceDatabase,[0.8 0.2]); 

%% Histogram of Oriented Gradient(HoG) Features di una singola faccia di es.
person = 5;
[hogFeature, visualization]= ...
    extractHOGFeatures(read(training(person),1));

figure;
imshow(read(training(person),1)); hold on;
plot(visualization);title('Sovrapposte');

figure;
subplot(2,1,1);imshow(read(training(person),1));title('Volto in input');
subplot(2,1,2);plot(visualization);title('HoG Feature');

%% Extract HOG Features 
trainingFeatures = zeros(size(training,2)*training(1).Count,4680);
featureCount = 1;
for i=1:size(training,2)
    for j = 1:training(i).Count
        trainingFeatures(featureCount,:) = extractHOGFeatures(read(training(i),j));
        trainingLabel{featureCount} = training(i).Description;    
        featureCount = featureCount + 1;
    end
    personIndex{i} = training(i).Description;
end

%% Crea 40 class classifier con fitcecoc 
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);
 
%% Primo test 
person = 1;
queryImage = read(test(person),1);
queryFeatures = extractHOGFeatures(queryImage);
personLabel = predict(faceClassifier,queryFeatures);
% Map back to training set to find identity 
booleanIndex = strcmp(personLabel, personIndex);
integerIndex = find(booleanIndex);
subplot(1,2,1);imshow(queryImage);title('Query Face');
subplot(1,2,2);imshow(read(training(integerIndex),1));title('Matched');

%% Test le prime 5 persone
figure;
figureNum = 1;
for person=1:5
    for j = 1:test(person).Count
        queryImage = read(test(person),j);
        queryFeatures = extractHOGFeatures(queryImage);
        personLabel = predict(faceClassifier,queryFeatures);
        %disp(personLabel); 'sx'
        booleanIndex = strcmp(personLabel, personIndex);
        integerIndex = find(booleanIndex);
        subplot(2,2,figureNum);imshow(imresize(queryImage,3));title('Query Face');
        subplot(2,2,figureNum+1);imshow(imresize(read(training(integerIndex),1),3));title('Matched');
        figureNum = figureNum+2;
    end
    figure;
    figureNum = 1;

end