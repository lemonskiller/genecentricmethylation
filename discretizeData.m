function y= discretizeData(y0)
%Data discretization method used for TCGA data in paper 
%1.2 fold change wrt median
%assumes log-transformed data
y0 = 2.^(y0);
[a,b] =  size(y0);
y = zeros(a,1);

median = nanmedian(y0); %compute median of y0, ignoring nan values.  

y0 = log2(y0./median);


for j=1:a
    if y0(j,1) > log2(1.2)
       y(j,1) = 2;
    elseif y0(j,1) < -log2(1.2)
       y(j,1) = 1;
    else
       y(j,1) = 0;
    end
end

end
