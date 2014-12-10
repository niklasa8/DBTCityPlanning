
for i=1:length(table)
    if isempty(table(i).pos)
        table(i).MT=[]; table(i).F=[]; table(i).L=[]; table(i).S=[];
    end
    table(i).waiting_time=[];
end



%Function timeToMin 5.05 (h.min)->305 (min)
timeToMin = @(t) mod(t,1)*100+floor(t)*60;
minToTime = @(t) floor(t/60)+rem(t,60)/100;
for i=1:length(table) %For each pair.
    %Identify pair.
    if ~isempty(table(i).pos) && i~= length(table)
        for j=i+1:length(table)
            if ~isempty(table(j).pos)
                break
            end
        end
        if isempty(j)
            break
        end
        
        %Extract times.
        days1={table(i).MT, table(i).F, table(i).L, table(i).S};
        days2={table(j).MT, table(j).F, table(j).L, table(j).S};
        for k=1:4 %For each day
            if ~isempty(days1{k})
                t1=days1{k}(1); t1=timeToMin(t1); t1=mod(t1-239,1440);
                t2=days2{k}(1); t2=timeToMin(t2); t2=mod(t2-239,1440);
                t1-t2
                x=j-i+1;

                %Extract and round up travel times.
                bt=[];
                for l=i+1:j
                    bt=[bt table(l).travel_time];
                end
                bt=ceil(bt);
                B=sum(bt);

                V=(t2-t1)-B;
                v=V/(x-1);
            end
        end

        for k=1:length(bt)
            table(i+k).travel_time=bt(k);
            table(i+k).waiting_time=v;
        end
        
%        for k=i+1:j-1
        for k=1:0
            if ~isempty(table(k-1).L)
                table(k+1).waiting_time=table(k+1).waiting_time+...
                    rem(table(k).waiting_time,1);
                table(k).waiting_time=table(k).waiting_time-...
                    rem(table(k).waiting_time,1);
                
                 times=timeToMin(table(k-1).L);
                 times=times+table(k).travel_time+table(k).waiting_time;
                 times=minToTime(times);
                 table(k).L = times;
            end
            
            if ~isempty(table(k-1).MT)
                table(k+1).waiting_time=table(k+1).waiting_time+...
                    rem(table(k).waiting_time,1);
                table(k).waiting_time=table(k).waiting_time-...
                    rem(table(k).waiting_time,1);
                
                 times=timeToMin(table(k-1).MT);
                 times=times+table(k).travel_time+table(k).waiting_time;
                 times=minToTime(times);
                 table(k).MT = times;
            end
            if ~isempty(table(k-1).S)
                table(k+1).waiting_time=table(k+1).waiting_time+...
                    rem(table(k).waiting_time,1);
                table(k).waiting_time=table(k).waiting_time-...
                    rem(table(k).waiting_time,1);
                
                 times=timeToMin(table(k-1).S);
                 times=times+table(k).travel_time+table(k).waiting_time;
                 times=minToTime(times);
                 table(k).S = times;
            end    
            if ~isempty(table(k-1).F)
                table(k+1).waiting_time=table(k+1).waiting_time+...
                    rem(table(k).waiting_time,1);
                table(k).waiting_time=table(k).waiting_time-...
                    rem(table(k).waiting_time,1);
                
                 times=timeToMin(table(k-1).F);
                 times=times+table(k).travel_time+table(k).waiting_time;
                 times=minToTime(times);
                 table(k).F = times;
            end
        end
        
        for k=i:j
            table(k).waiting_time=int16(table(k).waiting_time);
        end
        
    end
end