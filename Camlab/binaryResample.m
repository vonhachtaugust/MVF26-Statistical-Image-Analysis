function Ir = binaryResample(I, width, height);

[Ny,Nx] = size(I);

widthExtend = width/Nx;
heightExtend = height/Ny;

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
        if ~I(i,j) % black pixel
            len(1) = j; % store start position
            while count % count the sequence length
                
                if I(i,j)
                    len(2) = j; % store end position
                    count = false;
                elseif j == Nx
                    len(2) = Nx;
                    count = false;
                end
                j = j + 1;
            end
            sequence = [sequence; len]; % Add to sequence list for row i
        end
        j = j + 1;
    end
    sequence = round(widthExtend.*sequence); % Extend the sequence length
    
    for k = 1:size(sequence,1)
        start = sequence(k,1);
        End = sequence(k,2);
        if abs(End - start) >= 1 && End > start %&& start > 0 && End <= Ny       
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
        if ~Iw(j,i) % black pixel
            len(1) = j; % store start position
            while count % count the sequence length
                
                if Iw(j,i)
                    len(2) = j; % store end position
                    count = false;
                elseif j == Ny
                    len(2) = Ny;
                    count = false;
                end
                j = j + 1;
            end
            sequence = [sequence; len];
        end
        j = j + 1;
    end
    sequence = round(heightExtend.*sequence);
    
    for k = 1:size(sequence,1)
        start = sequence(k,1);
        End = sequence(k,2);
        if abs(End-start) >= 1 && End > start %&& start > 0 && End <= Nx_new
            for m = start:End
                Ir_heightExpand(m,i) = 0;
            end
        end
    end
end
Ir = Ir_heightExpand;