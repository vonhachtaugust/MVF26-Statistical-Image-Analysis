clear all;
clc;
%clf;

% Add source files to path
if strcmp(computer,'PCWIN')
    path(path,'.\src');
    path(path,'.\images\High_res');
    path(path,'.\database');
    path(path,'.\database\ClassificationDatabase');
else
    path(path,'./src');
    path(path,'./images/High_res');
    path(path,'./database');
    path(path,'./database/ClassificationDatabase');
end

% Number of images to cross validate

D = dir('images');
Num = length(D(not([D.isdir])));
NumNotImages = length(D([D.isdir]));

classificationDatabase = struct;
occurance = struct;

for i = 1:(Num+NumNotImages)
    name = D(i).name;
    if ~strcmp(name,'.') && ~strcmp(name,'..')
      I = imread(D(i).name);
        letters = getLetters2(I);
        fields = fieldnames(letters);
        
        for j = 1:numel(fields);
            % Show letter:
            figure(1), movegui(imshow(letters.(fields{j})),'northwest');
            
            
            % Dialog box
            prompt = {'Enter letter:'};
            dlg_title = 'Input';
            num_lines = 1;
            answer = inputdlg(prompt,dlg_title,num_lines);
            
            if ~isempty(answer)
                if ~isfield(occurance,(char(answer)))
                    occurance.(char(answer)).occ = 1;
                else
                    occurance.(char(answer)).occ = occurance.(char(answer)).occ + 1;
                end
                formatSpec = 'glyph%d';
                A = occurance.(char(answer)).occ;
                str = sprintf(formatSpec,A);
                
                classificationDatabase.(char(answer)).(str) = letters.(fields{j});
            end
        end
    end
end
save('classificationDatabase.mat','classificationDatabase');