function y= discretizeData(y0) 
%% y0和它自己中位数（非nan）计算fold change
%离散化原始基因表达数据y0(样本*特征）为y()
%Data discretization method used for TCGA data in paper 
%1.2 fold change wrt median
%assumes log-transformed data
y0 = 2.^(y0);
[a,b] =  size(y0); %与b无关，计算y0的行数
y = zeros(a,1);

median = nanmedian(y0); %compute median of y0, ignoring nan values.  输入m*n矩阵，求得1*n每列中位数

y0 = log2(y0./median); %每个特征除以该特征的中位数

%%%%%%%%%%%%%%%%%%%%%%  ？？？？？？？？？？？？？？？？？？ %%%

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
