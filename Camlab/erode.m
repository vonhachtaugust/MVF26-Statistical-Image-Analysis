function erodeImage = erode(I);

[Ny,Nx] = size(I);
tmpI = I;

% Change black pixel to white if the pixel neighbors
% atleast a white, and vice versa. Not updating dynamically.

for i = 1:Ny
  for j = 1:Nx
    
    if I(i,j) == 0 % Only change object (black) pixels 
      neighbors = eightNeigbors(i,j);
      
      for n = 1:size(neighbors,1)
        k = neighbors(n,1); % Row
        l = neighbors(n,2); % Col
        
        if k >= 1 && k <= Ny && l >= 1 && l <= Nx && I(i,j) ~= I(k,l)
          tmpI(i,j) = I(k,l); % If I(i,j) != I(k,l) then it's white.
          break; % n loop.
        end
      end
      
    end
    
  end
end
erodeImage = tmpI;