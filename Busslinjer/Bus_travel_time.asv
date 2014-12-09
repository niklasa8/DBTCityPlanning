%
datafiles={};
k=1;
BussData=dir('BussData');
for i=3:max(size(BussData))
    directory=['BussData/' BussData(i).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:max(size(A))
        datafiles(k)={[directory A(j).name]};
        k=k+1;
    end
end
datafiles;
TimeToMin=@(t)mod(t,1)*100+floor(t)*60; %t=7.56-> 7 h 56 min omvandlar detta till antal minuter från 00:00
MinToTime=@(m)floor(m/60)+mod(m,60)/100; % 155 min-> 02.35
for file=1:max(size(datafiles))
    disp(char(datafiles(file)))
    load(char(datafiles(file)));
    nr_stop=size(table);
    l=1;
    tt=0;%nr of stops in interval
    calc_wait_time=0;
    for k=2:nr_stop(2)

        from=table(k-1).id{1};
        to=table(k).id{1};
        time=car_all_shortest_path(intnd_map(id_map(from)),intnd_map(id_map(to)))*60;%time in minutes
        table(k).travel_time=time;
        
        if ~isempty(table(k).MT) & ~isempty(table(1).MT) %Om det finns XML data i table(k) -> beräkna väntetid utifrån föregånde XML data
            arr=TimeToMin(table(k).MT);  %arrivaltime according to XML files
            dep=TimeToMin(table(l).MT);  %departuretime according to XML files        
            ind=find(arr<dep);%Kontrollerar om man kliver över 23.59 isfall plussas det på ett dygn på arrival tiden.
            arr(ind)=arr(ind)+1440; 
            
            wait_time=((arr-dep)-sum([table(l+1:k).travel_time]))/tt;
            ind=find(wait_time<0);  %negativ väntetid-> 0 väntetid. Ex linje 81
            wait_time(ind)=0;
            
            [table([k-tt:k-1]).waiting_time_MT]=deal(wait_time);
            calc_wait_time=1;
        end
        if ~isempty(table(k).F) & ~isempty(table(1).F)
            arr=TimeToMin(table(k).F);  
            dep=TimeToMin(table(l).F);  
            ind=find(arr<dep);
            arr(ind)=arr(ind)+1440;

            wait_time=((arr-dep)-sum([table(l+1:k).travel_time]))/tt;
            ind=find(wait_time<0); 
            wait_time(ind)=0;
            
            [table([k-tt:k-1]).waiting_time_F]=deal(wait_time);
            calc_wait_time=1;
        end
        if ~isempty(table(k).L) & ~isempty(table(1).L)
            arr=TimeToMin(table(k).L); 
            dep=TimeToMin(table(l).L);                       
            ind=find(arr<dep);
            arr(ind)=arr(ind)+1440;           

            wait_time=((arr-dep)-sum([table(l+1:k).travel_time]))/tt;
            ind=find(wait_time<0);
            wait_time(ind)=0;

            [table([k-tt:k-1]).waiting_time_L]=deal(wait_time);
            calc_wait_time=1;
        end
        if ~isempty(table(k).S) & ~isempty(table(1).S)
            arr=TimeToMin(table(k).S); 
            dep=TimeToMin(table(l).S);
            ind=find(arr<dep);
            arr(ind)=arr(ind)+1440;
            
            wait_time=((arr-dep)-sum([table(l+1:k).travel_time]))/tt;             
            ind=find(wait_time<0);  
            wait_time(ind)=0;
            
            [table([k-tt:k-1]).waiting_time_S]=deal(wait_time);
            calc_wait_time = 1;
        end
        if calc_wait_time == 1
            l=k;
            tt=0;
            calc_wait_time=0;
        end    
        tt=tt+1;
    end
    
    %wait={table.waiting_time};
%     
%     for j=1:max(size(table))-1%size(wait,2)-1
%         for h=1:max(size(table(j).waiting_time))
%             if isempty(table(j).waiting_time())%isempty(wait{j})
%                 table(j).waiting_time=0;%wait{j}=0;
%             end
%             if isempty(table(j+1).waiting_time)%isempty(wait{j+1})
%                 table(j+1).waiting_time=0;%wait{j+1}=0;
%             end
%             table(j+1).waiting_time=table(j+1).waiting_time+table(j).waiting_time-round(table(j).waiting_time);%wait{j+1}=wait{j+1}+wait{j}-round(wait{j});
%             table(j).waiting_time=round(table(j).waiting_time);%wait{j}=round(wait{j});
%             %table(j).waiting_time=wait{j};
%             %table(j+1).waiting_time=wait{j+1};
%         end
%     end
% 
%     %travel={table.travel_time};
%     for j=1:max(size(table))-1;%size(travel,2)-1
%         if isempty(table(j).travel_time)%wait{j})
%             table(j).travel_time=0;%travel{j}=0;
%         end
%         if isempty(table(j+1).travel_time)%wait{j+1})
%             table(j+1).travel_time=0;%travel{j+1}=0;
%         end
%         table(j+1).travel_time=table(j+1).travel_time+table(j).travel_time-round(table(j).travel_time);% travel{j+1}=travel{j+1}+travel{j}-round(travel{j});
%         table(j).travel_time=round(table(j).travel_time);% travel{j}=round(travel{j});
%         %table(j).travel_time=travel{j};
%         %table(j+1).travel_time=travel{j+1};
%     end
    
    
    for i=2:nr_stop(2)
        if ~isempty(table(1).MT) & isempty(table(i).MT)
           
            table(1).waiting_time_MT=0; %sätter väntetiden på första hållplatsen till 0
            arr_time=TimeToMin(table(i-1).MT); %ankomsttiden från föregående hållplats
            
            arr_time=round(arr_time+table(i).travel_time+table(i-1).waiting_time_MT); 
            ind=find(arr_time>=1440); 
            arr_time(ind)=arr_time(ind)-1440;

            arr_time=MinToTime(arr_time);
            table(i).MT=arr_time;
        end
        if ~isempty(table(1).F) & isempty(table(i).F)
            table(1).waiting_time_F=0;
            arr_time=TimeToMin(table(i-1).F);

            arr_time=round(arr_time+table(i).travel_time+table(i-1).waiting_time_F);
            ind=find(arr_time>=1440); 
            arr_time(ind)=arr_time(ind)-1440;

            arr_time=MinToTime(arr_time);
            table(i).F=arr_time;            
        end
        if ~isempty(table(1).L) & isempty(table(i).L)
            table(1).waiting_time_L=0;
            arr_time=TimeToMin(table(i-1).L);

            arr_time=round(arr_time+table(i).travel_time+table(i-1).waiting_time_L);            
            ind=find(arr_time>=1440); 
            arr_time(ind)=arr_time(ind)-1440;

            arr_time=MinToTime(arr_time);
            table(i).L=arr_time;        
        end
        if~isempty(table(1).S) & isempty(table(i).S)
            table(1).waiting_time_S=0;
            arr_time=TimeToMin(table(i-1).S);

            arr_time=round(arr_time+table(i).travel_time+table(i-1).waiting_time_S);            
            ind=find(arr_time>=1440); 
            arr_time(ind)=arr_time(ind)-1440;

            arr_time=MinToTime(arr_time);
            table(i).S=arr_time;        
        end
    end
    save(char(datafiles(file)), 'table','-append')
end
