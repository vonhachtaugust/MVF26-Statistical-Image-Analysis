function dilateImage = dilate(I);

[Ny,Nx] = size(I);
tmpI = I;

% Change white pixel to black if the pixel neighbors
% atleast a black, and vice versa. Not updating dynamically.

for i = 1:Ny
  for j = 1:Nx
    
    if I(i,j) == 1 % Only change background (white) pixels 
      neighbours = Neighbours(i,j);
      
      for n = 1:size(neighbours,1)
        k = neighbours(n,1); % Row
        l = neighbours(n,2); % Col
        
        if k >= 1 && k <= Ny && l >= 1 && l <= Nx && I(i,j) ~= I(k,l)
          tmpI(i,j) = I(k,l); % If I(i,j) !=  I(k,l) then it's black
          break; % n loop.
        end
      end
      
    end
    
  end
end
dilateImage = tmpI;