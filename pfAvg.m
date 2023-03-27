function pfAvg = pfAvg(sig,numavg)
    pfAvg = zeros(size(sig,1),size(sig,2)-(numavg-1));
    for i = 1:size(sig,2)-(numavg-1)
        pfAvg(:,i) = mean(sig(:,i:i+(numavg-1)),2);
    end
end
