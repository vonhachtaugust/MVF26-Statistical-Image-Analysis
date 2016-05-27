load('database_highres.mat');

fields = char(fieldnames(database));
for i = 1:size(fields,1)
    currField = database.(fields(i));
    currField.ratio = size(currField.glyph,1)/size(currField.glyph,2);
    database.(fields(i)) = currField;
end

save('database_highres.mat','database');