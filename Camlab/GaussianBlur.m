function blur = GaussianBlur(img,k,sigma)

blur = zeros(size(img));
gauss = @(i,j) 1/(2*pi*sigma) * exp(-((i-k-1)^2 + (j-k-1)^2)/(2*sigma));

gaussMatrix = zeros(2*k+1);
for i1 = 1:2*k+1
    for j1 = 1:2*k+1
        gaussMatrix(i1,j1) = gauss(i1,j1);
    end
end
A = sum(sum(gaussMatrix));
gaussMatrix = gaussMatrix/A;

horSize = size(img,2);
verSize = size(img,1);
for iColor = 1:size(img,3)
    for iHor = 1:horSize
        for iVer = 1:verSize
            tmpBlur = 0;
            for xPos = 1:2*k+1
                hor = iHor + xPos - k - 1;
                for yPos = 1:2*k+1
                    ver = iVer + yPos - k - 1;
                    if (hor > 0) && (hor <= horSize)
                        if (ver > 0) && (ver <= verSize)
                            tmpBlur = tmpBlur + gaussMatrix(xPos,yPos)*img(ver,hor,iColor);
                        end
                    end
                end
            end
            blur(iVer,iHor,iColor) = tmpBlur;
        end
    end
end