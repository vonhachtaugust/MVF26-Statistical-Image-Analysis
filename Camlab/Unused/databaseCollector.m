%% Automatically read and add all letters to database
%%%%%% Read and paint character %%%%%%
charNumber = 2;
texter = ocr(textbox)
disp(texter.Text(charNumber));
Bpos = texter.CharacterBoundingBoxes(charNumber,:);
newTextbox = textbox(Bpos(2):Bpos(2)+Bpos(4)-1,Bpos(1):Bpos(1)+Bpos(3)-1);
% figure(7),imshow(newTextbox)
% texter.Text

%%%%%% Put all characters with glyph into database %%%%%%
load('database_highres.mat')
for i = 1:size(texter.Text,2)-2
    structName = texter.Text(i);
    if isletter(structName)%(structName ~= ' ')% && ~(strcmp(structName, '\n'))
        Bpos = texter.CharacterBoundingBoxes(i,:);
        newTextbox = textbox(Bpos(2):Bpos(2)+Bpos(4)-1,Bpos(1):Bpos(1)+Bpos(3)-1);
        database.(structName).glyph = newTextbox;
    end
end

save('database_highres.mat','database');