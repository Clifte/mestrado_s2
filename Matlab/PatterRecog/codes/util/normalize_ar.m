 function normalized = normalize_ar(array, lim)
    
     % Normalize to [0, 1]:
     m = min(array);
     range = max(array) - m;
     array = (array - m) / range;

     % Then scale to [x,y]:
     x = lim(1);
     y = lim(2);
     range2 = y - x;
     normalized = (array*range2) + x;
 end