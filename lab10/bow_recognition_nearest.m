function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor (using knnsearch) in the positive and negative sets
  % and decide based on this neighbor
  [~ , DistPos] = knnsearch(histogram,vBoWPos);
  [~ , DistNeg] = knnsearch(histogram,vBoWNeg);
  DistPos = min(DistPos);
  DistNeg = min(DistNeg);
  if (DistPos<DistNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
