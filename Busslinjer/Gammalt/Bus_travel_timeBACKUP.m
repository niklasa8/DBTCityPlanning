%
%function Bus_trave = Bus_travel(dirName)
datafiles={};
k=1;
BussData=dir('BussData')
for i=3:max(size(BussData))
    directory=['BussData/' BussData(i).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:max(size(A))
        datafiles(k)={[directory A(j).name]};
        k=k+1;
    end
end
datafiles;
TimeToMin=@(t)mod(t,1)*100+floor(t)*60; %t=7.56-> 7 h 56 min omvandlar detta till antal minuter fr�n 00:00
MinToTime=@(m)floor(m/60)+mod(m,60)/100; % 155 min-> 02.35
for file=1:max(size(datafiles))
    char(datafiles(file))
    load(char(datafiles(file)));
    nr_stop=size(table);
    l=1;
    tt=0;%nr of stops in interval
    
    for k=2:nr_stop(2)

        from=table(k-1).id{1};
        to=table(k).id{1};
        time=car_all_shortest_path(intnd_map(id_map(from)),intnd_map(id_map(to)))*60;%time in minutes
        table(k).travel_time=time;

        if ~isempty(table(k).MT) & ~isempty(table(1).MT) %assume same traveltime all day, not depending on traffic etc.
            arr=TimeToMin(table(k).MT(1));  %arrivaltime according to XML files
            dep=TimeToMin(table(l).MT(1));  %departure/arrival time according to XML files
            wait_time=((arr-dep)-sum([table(l:k).travel_time]))/tt;
            if wait_time<0
                wait_time=0;
            end
            [table([k-tt:k-1]).waiting_time]=deal(wait_time);
            l=k;
            tt=0;
        elseif ~isempty(table(k).F) & ~isempty(table(1).F)
            arr=TimeToMin(table(k).F(1));  %arrivaltime according to XML files
            dep=TimeToMin(table(l).F(1));  %departure/arrival time according to XML files
            wait_time=((arr-dep)-sum([table(l:k).travel_time]))/tt;  
            if wait_time<0
                wait_time=0;
            end
            [table([k-tt:k-1]).waiting_time]=deal(wait_time);
            l=k;
            tt=0;
        elseif ~isempty(table(k).L) & ~isempty(table(1).L)
            arr=TimeToMin(table(k).L(1));  %arrivaltime according to XML files
            dep=TimeToMin(table(l).L(1));  %departure/arrival time according to XML files
            wait_time=((arr-dep)-sum([table(l:k).travel_time]))/tt;  
            if wait_time<0
                wait_time=0;
            end
            [table([k-tt:k-1]).waiting_time]=deal(wait_time);
            l=k;
            tt=0;
        elseif ~isempty(table(k).S) & ~isempty(table(1).S)
            arr=TimeToMin(table(k).S(1));  %arrivaltime according to XML files
            dep=TimeToMin(table(l).S(1));  %departure/arrival time according to XML files
            wait_time=((arr-dep)-sum([table(l:k).travel_time]))/tt;  
            if wait_time<0
                wait_time=0;
            end 
            [table([k-tt:k-1]).waiting_time]=deal(wait_time);
            l=k;
            tt=0;
        end
        tt=tt+1;
    end
    
    %wait={table.waiting_time};
    
    for j=1:max(size(table))-1%size(wait,2)-1
        if isempty(table(j).waiting_time)%isempty(wait{j})
            table(j).waiting_time=0;%wait{j}=0;
        end
        if isempty(table(j+1).waiting_time)%isempty(wait{j+1})
            table(j+1).waiting_time=0;%wait{j+1}=0;
        end
        table(j+1).waiting_time=table(j+1).waiting_time+table(j).waiting_time-round(table(j).waiting_time);%wait{j+1}=wait{j+1}+wait{j}-round(wait{j});
        table(j).waiting_time=round(table(j).waiting_time);%wait{j}=round(wait{j});
        %table(j).waiting_time=wait{j};
        %table(j+1).waiting_time=wait{j+1};
    end

    %travel={table.travel_time};
    for j=1:max(size(table))-1;%size(travel,2)-1
        if isempty(table(j).travel_time)%wait{j})
            table(j).travel_time=0;%travel{j}=0;
        end
        if isempty(table(j+1).travel_time)%wait{j+1})
            table(j+1).travel_time=0;%travel{j+1}=0;
        end
        table(j+1).travel_time=table(j+1).travel_time+table(j).travel_time-round(table(j).travel_time);% travel{j+1}=travel{j+1}+travel{j}-round(travel{j});
        table(j).travel_time=round(table(j).travel_time);% travel{j}=round(travel{j});
        %table(j).travel_time=travel{j};
        %table(j+1).travel_time=travel{j+1};
    end
    
    
    for i=2:nr_stop(2)
        %travel_time=sum([table(1:i).travel_time]);
        %wait_time=sum([table(1:i-1).waiting_time]);
        if ~isempty(table(1).MT) & isempty(table(i).MT)
            arr_time=TimeToMin(table(i-1).MT);
            if isempty(table(i-1).waiting_time)
               table(i-1).waiting_time=0; 
            end
            arr_time=round(arr_time+table(i).travel_time+table(i-1).waiting_time); %better to always round up?
            arr_time=MinToTime(arr_time);
            table(i).MT=arr_time;
        end
        if ~isempty(table(1).F) & isempty(table(i).F)
            %arr_time=TimeToMin(table(1).F);
            arr_time=TimeToMin(table(i-1).F);
            if isempty(table(i-1).waiting_time)
               table(i-1).waiting_time=0; 
            end
            arr_time=round(arr_time+table(i).travel_time+table(i-1).waiting_time); %better to always round up?
            %arr_time=round(arr_time+travel_time+wait_time);
            arr_time=MinToTime(arr_time);
            table(i).F=arr_time;            
        end
        if ~isempty(table(1).L) & isempty(table(i).L)
            %arr_time=TimeToMin(table(1).L);
            arr_time=TimeToMin(table(i-1).L);
            if isempty(table(i-1).waiting_time)
               table(i-1).waiting_time=0; 
            end
            arr_time=round(arr_time+table(i).travel_time+table(i-1).waiting_time); %better to always round up?            
            %arr_time=round(arr_time+travel_time+wait_time);
            arr_time=MinToTime(arr_time);
            table(i).L=arr_time;        
        end
        if~isempty(table(1).S) & isempty(table(i).S)
            %arr_time=TimeToMin(table(1).S);
            arr_time=TimeToMin(table(i-1).S);
            if isempty(table(i-1).waiting_time)
               table(i-1).waiting_time=0; 
            end
            arr_time=round(arr_time+table(i).travel_time+table(i-1).waiting_time); %better to always round up?            
            %arr_time=round(arr_time+travel_time+wait_time);
            arr_time=MinToTime(arr_time);
            table(i).S=arr_time;        
        end
    end
    
    
    total_waiting_time=sum([table.waiting_time]);
    total_travel_time=sum([table.travel_time]);
    total_time_calculated=total_waiting_time+total_travel_time
 %   total_time_XML=TimeToMin(table(end).MT(1))-TimeToMin(table(1).MT(1));
%     if abs(total_time_calculated-total_time_XML)>2 | abs(total_time_XML-total_waiting_time)>(2/3)*total_time_XML
%         disp('Suspicious values')
%     end
    save(char(datafiles(file)), 'table','-append')
end