% writen by zhaomuen to delete the taskdesign you do not want. This is
% useally do when wo run uncorrectly you taskdesign for firstlevel.

clear all;clc
%get dir
path1='.../Data_AMDD_noFM/'
path2='.../NB/'
year='2018/'
[~,~,sub]=xlsread('WM.xlsx',1);
sub_id=sub(:,1);  sub_id=cell2mat(sub_id);
sub_name=sub(:,1);

for i=1:length(sub_id)
    try 
    task_dir=fullfile(path1,year,sub_name{i,1},path2);%bug
    cd(task_dir);
    if ~exist('taskdesign_Lu.m');
        disp(['no',sub_name{i,1}]);
    end
    unix(['rm -r taskdesign_Lu.m']);
    catch
    end

end