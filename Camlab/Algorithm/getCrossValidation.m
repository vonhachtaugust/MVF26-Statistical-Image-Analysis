function error = getCrossValidation(training, reference, featurelist)

databaseFields = fieldnames(reference);

fields = fieldnames(training);
errorRate = struct;

% For each database letter
for i = 1:numel(fields)
  % The accual letter
  correctLetter = fields{i};
  
  % Number of data fields of this letter
  validatFields = fieldnames(training.(fields{i}));
  
  % For each data field
  for j = 1:numel(validatFields)
    glyph = training.(fields{i}).(validatFields{j});
    
    
    features = getFeatures(glyph, featurelist);
    [height, width] = size(glyph);
    
    len = numel(fieldnames(reference));
    euclidean = zeros(len,2);
    
    for k = 1:len
      databaseGlyph = binaryResample(reference.(databaseFields{k}).glyph, width, height);
      
      databaseFeatures = getFeatures(databaseGlyph, featurelist);
      densityMatrix = (~glyph).*(databaseGlyph);
      
      euclidean(k,1) = norm(databaseFeatures-features);
      euclidean(k,2) = (sum(sum(densityMatrix))/(height*width))^2;
    end
    
    min = 10000;
    let = -1;
    for m = 1:len
      val = euclidean(m,1) * euclidean(m,2);
      if val < min
        min = val;
        let = databaseFields{m};
      end
    end
    errorRate.(correctLetter).(validatFields{j}) = let;
  end
end

errorFields = fieldnames(errorRate);

Sum = 0;
correct = 0;
for i = 1:numel(errorFields)
  glyphFields = fieldnames(errorRate.(errorFields{i}));
  for j = 1:numel(glyphFields)
    s1 = errorFields{i};
    s2 = errorRate.(errorFields{i}).(glyphFields{j});
    if strcmp(s1,s2)
      correct = correct + 1;
    end
    Sum = Sum + 1;
  end
end
error = 1-correct/Sum;