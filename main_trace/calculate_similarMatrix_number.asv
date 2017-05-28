function [correct_minus_wrong, wrongNum] = calculate_similarMatrix_number(W)
% calculate similar matrix number for correct size minus wrong size

totalNum = sum(sum(W));
correctSum = 0;
for picNum = 1:40
    for i = 1:10
        for j = 1:10
            baseNum = 10*(picNum-1);
            correctSum = correctSum + W(baseNum+i,baseNum+j);
        end
    end
end
            
wrongNum = totalNum - correctNum;
correct_minus_wrong = correctNum - wrongNum;