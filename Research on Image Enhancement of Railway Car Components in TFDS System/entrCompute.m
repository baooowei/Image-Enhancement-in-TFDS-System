function [entr,ind] = entrCompute(InImg,groupNum)
% Output the entropy of InImg 
% ========= INPUT ============
%       InImg       size: cell(numImg * 1);  each cell: m * n
%       groupNum    the number of images in each group 
% ========= OUTPUT ===========
%       entr        entropies of all images
%       ind         the sort of all entropies
entr = cell(numel(InImg)/groupNum,1);  %每groupNum个一组记录entropy
for id = 1 :  numel(entr)
    for jd = 1 : groupNum
       entr{id}(jd) = Imentropy(InImg{(id - 1) * groupNum + jd});
    end    
end
%对信息熵进行排序
trash = cell(numel(entr),1);
ind = cell(numel(entr),1); 
for id = 1 : numel(entr)
    [trash{id} ind{id}] = sort(entr{id},'descend');
end
end
