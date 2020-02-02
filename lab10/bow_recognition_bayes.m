function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

Prob_pos = 0;
Prob_neg = 0;

for i=1:size(vBoWPos,2)
    Pos_add = log(normpdf(histogram(i),muPos(i),sigmaPos(i)));
    Neg_add = log(normpdf(histogram(i),muNeg(i),sigmaNeg(i)));
    
    if ~isnan(Pos_add)
        Prob_pos = Prob_pos + Pos_add;
    end
    if ~isnan(Neg_add)
        Prob_neg = Prob_neg + Neg_add;
    end
    
end

Prob_pos = exp(Prob_pos);
Prob_neg = exp(Prob_neg);

Prob_pos = Prob_pos * 0.5;
Prob_neg = Prob_neg * 0.5;

if Prob_pos > Prob_neg
    label = 1;
else
    label = 0;
end


end