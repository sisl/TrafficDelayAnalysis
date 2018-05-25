%% This function gets mean value from EDS
function mean = getStatAvg(part,POLICY)
mean = 0;
switch POLICY
    case 'FIFO'
        for i = 1:size(part,1)
            mean = mean + max(part(i,:));
        end
        mean = mean / size(part,1);
    case 'FO'
    otherwise
end