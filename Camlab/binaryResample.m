function Ir = binaryResample(I, widthExtend, heightExtend);

[Ny,Nx] = size(I);

% New image sizes
Nx_new = round(Nx*widthExtend);
Ny_new = round(Ny*heightExtend);

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
            while count && j < Nx % count the sequence length
                j = j + 1;
                if I(i,j) ~= 0
                    len(2) = j; % store end position
                    count = false;
                elseif j == Nx
                    len(2) = Nx;
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
Iw = Ir_widthExpand;

% Height expand: Check each column (x), and store row (x) sequence
Ir_heightExpand = ones(Ny_new,Nx_new);
len = zeros(1,2);

for i = 1:Nx_new % For each column in extended I (Iw)
    sequence = [];
    
    j = 1;
    while j <= Ny % row loop
        count = true;
        if Iw(j,i) == 0 % black pixel
            len(1) = j; % store start position
            while count && j < Ny % count the sequence length
                j = j + 1;
                if Iw(j,i) ~= 0
                    len(2) = j; % store end position
                    count = false;
                elseif j == Ny
                    len(2) = Ny;
                    count = false;
                end
            end
        end
        sequence = [sequence; len];
        j = j + 1;
    end
    sequence = round(heightExtend.*sequence);
    
    for k = 1:size(sequence,1)
        start = sequence(k,1);
        End = sequence(k,2);
        if abs(End-start) >= 1 && End > start
            for m = start:End
                Ir_heightExpand(m,i) = 0;
            end
        end
    end
end
Ir = Ir_heightExpand;