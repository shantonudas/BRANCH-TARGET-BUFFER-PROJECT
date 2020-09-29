clear all; 

data =  fopen('Espresso_int.txt','r');          % reading trace
PC = fscanf(data,'%X');                         % storing trace in PC (hex)
fclose(data);
BTB = zeros(1024,4);                            % initializing the brance transfer buffer

hit = 0;                                        % initializing other metrics
miss = 0;
right_pred = 0;
wrong_pred = 0;
collision = 0;
wrong_address = 0;

for i = 1:length(PC)-1
    entry = floor(mod(PC(i), hex2dec('1000'))/4);
    if PC(i) == BTB(entry+1,2)
        hit = hit+1 ; % step 1 hit
        if BTB(entry+1,3) == (PC(i+1))
            prev_pred = BTB(entry+1,4);
            pred = floor(prev_pred/2);
            local_pred = 1; % 1 =  taken
            if pred == local_pred
                right_pred = right_pred+1;
            else
                wrong_pred =  wrong_pred+1;
            end
            BTB(entry+1,4) = sm_local(prev_pred, local_pred);
        else
            if (PC(i+1)-PC(i)) == 4
                prev_pred = BTB(entry+1,4);
                local_pred = 0; % 0 =  not taken
                pred = floor(prev_pred/2);
                if pred == local_pred
                    right_pred = right_pred+1;
                else
                    wrong_pred =  wrong_pred+1;
                end
                BTB(entry+1,4) = sm_local(prev_pred, local_pred); 
            else
                wrong_address = wrong_address + 1;
                BTB(entry+1,1) = entry;
                BTB(entry+1,2) = (PC(i));
                BTB(entry+1,3) = (PC(i+1));
                local_pred = 1; % 1 =  taken
                prev_pred = BTB(entry+1,4);
                pred = floor(prev_pred/2);
                if pred == local_pred
                    right_pred = right_pred+1;
                else
                    wrong_pred =  wrong_pred+1;
                end
                prev_pred = BTB(entry+1,4);
                BTB(entry+1,4) = sm_local(prev_pred, local_pred); 
            end
        end
    else
        if (PC(i+1)-PC(i)) ~= 4
            if entry == BTB(entry+1,1)
                collision =  collision + 1 ; % step 3A Collision
            end
            miss = miss + 1 ; % step 2A miss
            BTB(entry+1,1) = entry;
            BTB(entry+1,2) = (PC(i));
            BTB(entry+1,3) = (PC(i+1));
            BTB(entry+1,4) = 3; % 3 = strongly taken
        end      
    end
end
hit_rate = (hit*100)/(hit+miss)
hit
miss
accuracy = (right_pred*100)/(right_pred+wrong_pred)
right_pred
wrong_pred
wrong_address

BTB_new = BTB;
BTB_new( ~any(BTB_new,2), : ) = [];