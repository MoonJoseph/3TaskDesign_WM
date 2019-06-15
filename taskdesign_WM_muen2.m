%developed by Muen Zhao, in BNU,2019,used for CBD data which has no year
%floder.
%used to do taskdesign for WM of AMDD project
%data is used to get onset  data
%database is used to get sub id
%data.xlx could get from the merged e-data,It's is very important that you
%need delete the first roll,which is string. in the marged e-data ecpect 'subject''stimulate.OnesetTime''Text'.


clear all;
clc;
[~,~,data]=xlsread('edata_WM.xlsx');
[~,~,database]=xlsread('WM.xlsx','WM','H:H');
database(1,:)=[]
data_id=database(:,1);
outpath1='/brain/iCAN_admin/home/zhaomuen/Data_CBD_noFM/';
outpath2='/fmri/NB/';

%delete first rol
data(1,:)=[];

%change data cell to double
a=find(strcmp(data(:,3),'+'));
b=find(strcmp(data(:,3),'0-back'));
c=find(strcmp(data(:,3),'1-back'));
d=find(strcmp(data(:,3),'2-back'));
for i=1:length(a);
    data{a(i),3}=0;%not sure if it work ??????
end
for i=1:length(b);
    data{b(i),3}=11;
end
for i=1:length(c);
    data{c(i),3}=22;
end
for i=1:length(d);
    data{d(i),3}=33;
end
  data=cell2mat(data);
  data_id=cell2mat(data_id);


%get onset time
for id=1:length(data_id);
      
%         ismember(data{i,1},data_id(:,1))==1;%ismember:lia=ismember(a,b) a belongs to b,a is double ,b is cell
%         id=find(data_id{i,1}==data{:,1});%find specific id from data
%         temp=data(data{:,1}==data_id{id,1});
    dataid=str2double(data_id(id,isstrprop(data_id(id,:),'digit')));
    temp=data(data(:,1)==dataid,:);%get id   use one item to find a collection items!!!
    temp(:,4)=(temp(:,2)-temp(1,2))/1000;%make time to second
    %get onsettime
    m=find(temp(:,3)==11); n=find(temp(:,3)==22); w=find(temp(:,3)==33);
    onset0=temp(m+1,4);
    onset1=temp(n+1,4);
    onset2=temp(w+1,4);
    %get durations
    durations0=[ones(size(onset0,1), 1)*27];%make a matrix for duration
    durations1=[ones(size(onset1,1), 1)*27];%[]will make no change for a matrix,for example:A,B are cells,A=[B]is same as A=B 
    durations2=[ones(size(onset2,1), 1)*27];%and it is same for a=1 and a=[1]
    
    %make dir
    tem=cell2mat(database(:,1));
   % index=find(ismember(tem,data_id(id,:)));%make sure this subject is in data and data_id both
    file_id=database(id);%get fold name
    %year_id=['20',file_id(1:2)];% a way to write year id!!!!!!!!!!!!!!!!!!
    outpath=fullfile(outpath1,file_id,outpath2,'taskdesign');
    mkdir(outpath{1});
    
    %make flieload
    cd(outpath{1});
    %fileID=fopen(filename,permission)  permission 'w' :open or creat a new
    %file,and write in,ignore the existing .%s output stings ,/n means
    %change a row to write
    fp=fopen('taskdesign.m','w');
    fprintf(fp,'%s\n','sess_name=''WM'';');
    
    
    fprintf(fp,'%s\n','names{1}  = [''0_back''];');
    onset0=num2cell(onset0);
    %...in [] tell computer input is in the next row .%f is one kind of
    %type. it put 
    fprintf(fp,[...
        'onsets{1}    = [', repmat('%f ', 1, length(onset0)), '];\n'], onset0{:});%16*1double??????????
    durations0 = num2cell(durations0);
    fprintf(fp,[...
        'durations{1}     =[', repmat('%f ', 1, length(durations0)), '];\n'], durations0{:});
    
    
    fprintf(fp,'%s\n','names{2}  = [''1_back''];');
    onset1=num2cell(onset1);
    fprintf(fp,[...
        'onsets{2}    = [',repmat('%f ', 1, length(onset1)), '];\n'], onset1{:});
    
    durations1 = num2cell(durations1);
    fprintf(fp,[...
        'durations{2}    =[', repmat('%f ', 1, length(durations1)), '];\n'], durations1{:});
    
    
    fprintf(fp,'%s\n','names{3}  = [''2_back''];');
    onset2=num2cell(onset2);
    fprintf(fp,[...
        'onsets{3}    = [', repmat('%f ', 1, length(onset2)), '];\n'], onset2{:});
    durations2 = num2cell(durations2);
    fprintf(fp,[...
        'durations{3}    =[', repmat('%f ', 1, length(durations2)), '];\n'],durations2{:});
    
    
    fprintf(fp,'%s\n','rest_exists=1;');
    fprintf(fp,'%s\n','save taskdesign.mat sess_name names onsets durations rest_exists');
    
end
