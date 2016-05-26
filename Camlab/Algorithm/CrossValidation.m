clear all;
clc;
%clf;

% Add source files to path
if strcmp(computer,'PCWIN')
    path(path,'.\src');
    path(path,'.\images');
    path(path,'.\database');
    path(path,'.\database\ClassificationDatabase');
else
    path(path,'./src');
    path(path,'./images');
    path(path,'./database');
    path(path,'./database/ClassificationDatabase');
end

% Number of images to cross validate

D = dir('images');
Num = length(D(not([D.isdir])));
NumNotImages = length(D([D.isdir]));

classificationDatabase = struct;
occurance = struct;

for i = NumNotImages+1:Num
    name = D(i).name;
    
    if ~strcmp(name,'.') && ~strcmp(name,'..')
        I = imread(D(i).name);
        letters = getLetters(I);
        fields = fieldnames(letters);
        
        for j = 1:numel(fields);
            % Show letter:
            figure(1), imshow(letters.(fields{j}));
            
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
%%
