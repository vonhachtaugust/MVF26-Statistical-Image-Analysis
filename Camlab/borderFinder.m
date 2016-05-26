function borderDepth = borderFinder(img, searchResolution)

height = size(img,1);
width = size(img,2);
step = searchResolution;
flag = 0;

for i = 1 : width
    j = 1;
    while j < height
        if img(j,i) == 0
            borderDepth = i-1;
            flag = 1;
        end
        j = j + step;
    end
    if flag == 1;
        break;
    end
    if i == width
        borderDepth = 0;
    end
end

