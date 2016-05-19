function [letter,backtrack] = letterFiller(image, Y, X) %input image containing letter and a pixel position in wanted letter

Q = [Y,X];
minX = X;
tmpImage = ones(size(image));
backtrack = 0;
while ~isempty(Q)
    Y = Q(1,1);
    X = Q(1,2);
    Q(1,:) = [];
    
    neigh = Neighbours(Y,X);
    for i = 1:size(neigh,1)
        if image(neigh(i,1),neigh(i,2)) == 0
            if tmpImage(neigh(i,1),neigh(i,2)) ~= 0
                
                %%%% Check backtracking %%%%
                if neigh(i,2) == minX - 1
                    minX = neigh(i,2);
                    backtrack = backtrack + 1;
                end
                
                %%%% Add to queue %%%%
                Q = [Q; neigh(i,:)];
                tmpImage(neigh(i,1),neigh(i,2)) = 0;
            end
        end
    end
end

letter = extendBorders(tmpImage,1);