function calculateTimes(stops,days,minutes)
load('Departures');
load('times');

n_stops=max(size(Dep));

t1=zeros(size(stops,2),1);
t2=zeros(size(stops,2)*size(days,2),1);
t3=zeros(size(stops,2)*size(days,2)*size(minutes,2),1);
l=1; m=1; n=1;

tic1=tic;
for stop=stops
    disp(['Bus stop: ' num2str(stop)]);
    tic2=tic;
    for day=days
        disp(['Day: ' num2str(day)]);
        tic3=tic;
        for time=minutes
            if mod(time,100)==0
                disp(['Time: ' num2str(time)]);
            end
            tic4=tic;
            if ~calculated(stop,day,time)
                times(:,stop,day,time)=allToOne(Dep,stop,day,time,n_stops);
                calculated(stop,day,time)=1;
            end
            t3(l)=toc(tic4); l=l+1;
        end
        t2(m)=toc(tic3); m=m+1;
    end
    t1(n)=toc(tic2); n=n+1;
end

T=toc(tic1);
disp(['Total elapsed time (in seconds): ' num2str(T)])

figure(1)
plot(t3);
ylabel 'time [s]'
title 'time elapsed for each calculated minute'

figure(2)
plot(t2, '-*');
ylabel 'time [s]'
title 'time elapsed to calculate each day with all minutes'

figure(3)
plot(t1, '-*');
ylabel 'time [s]'
title 'time elapsed to calculate each stop with all days and all minutes'

save('times.mat','times','calculated');
end