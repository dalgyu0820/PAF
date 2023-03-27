function pfBp = pfBp(sig,s,e,fs)
    pfBp = zeros(size(sig,1),size(sig,2));
        parfor i = 1:size(sig,2)
        pfBp(:,i) = bandpass(sig(:,i),[s e].*1e06,fs*1e06);
        end
end