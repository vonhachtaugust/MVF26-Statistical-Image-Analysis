function Ir = binaryResample(I, widthExtend, heightExtend);

[Ny,Nx] = size(I);

% New image sizes
Nx_new = round(Nx*widthExtend);
Ny_new = round(Ny*heightExtend);
Ir = ones(Ny_new,Nx_new);


% Width expand: Check each row (y), and store column (x) sequence.
Ir_widthExpand = ones(Ny,Nx_new);
len = zeros(1,2);

for i = 1:Ny % For each row:
    sequence = [];
    
    j = 1;
    while j <= Nx % column loop
        count = true;
        if I(i,j) == 0 % black pixel
            len(1) = j; % store start position
            while count && j < Nx% count the sequence length
                j = j + 1;
                if I(i,j) ~= 0
                    len(2) = j; % store end position
                    count = false;
                end
            end
        end
        sequence = [sequence; len]; % Add to sequence list for row i
        j = j + 1;
    end
    sequence = round(widthExtend.*sequence); % Extend the sequence length
    
    for k = 1:size(sequence,1)
        start = sequence(k,1);
        End = sequence(k,2);
        if abs(End - start) >= 1 && End > start
            for m = start:End
                Ir_widthExpand(i,m) = 0; % Set to black pixel
            end
        end
    end
end
Ir = Ir_widthExpand;



% for i = 1:Ny_new % row
%     for j = 1:Nx_new % col
%         col = round(j/widthExtend); % Orig. col pos
%         row = round(i/heightExtend); % Orig. row pos
%
%         if row >= 1 && row <= Ny_new && col >= 1 && col <= Nx_new
%             Ir(i,j) = I(row,col);
%         elseif row < 1
%             Ir(i,j) = I(1,col);
%         elseif row > Ny_new
%             Ir(i,j) = I(Ny_new,col);
%         elseif col < 1
%             Ir(i,j) = I(row,1);
%         elseif col > Nx_new
%             Ir(i,j) = I(row,Nx_new);
%         end
%
%     end
% end