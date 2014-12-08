function [a, ori_sum, new_sum, diff] = rounding( a )
ori_sum=sum(a);
for i=1:size(a,2)-1
    a(i+1)=a(i+1)+a(i)-round(a(i));
    a(i)=round(a(i));
end
new_sum=sum(a);
diff = ori_sum-new_sum;
end
