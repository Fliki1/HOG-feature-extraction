%% Display Face Gallery
function displayFaceGallery(faceGallery,galleryNames)
figure
for i = 1:length(faceGallery)
    I = cell(1, faceGallery(i).Count);
    % concatenate all the images of a person side-by-side
    for j = 1:faceGallery(i).Count
        image = read(faceGallery(i), j);        
        scaleFactor = 150/size(image, 1); % scalo l'immagine 
        image = imresize(image, scaleFactor);        
        I{j} = image;
    end   
    subplot(length(faceGallery), 1, i);
    imshow(cell2mat(I));
    title(galleryNames{i}, 'FontWeight', 'normal'); %nomi
end

annotation('textbox', [0.02 0.9 1 0.1], 'String', 'Data Base (Gallery di riferimento)', ...
     'EdgeColor', 'none', 'FontWeight', 'bold', ...
     'FontSize', 12, 'HorizontalAlignment', 'center')
