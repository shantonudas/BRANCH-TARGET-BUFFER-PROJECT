clear all; 
data =  fopen('Spice_FP.txt','r');          % reading trace
PC = fscanf(data,'%X');                         % storing trace in PC (hex)
fclose(data);
BTB = zeros(1024,9);                            % initializing the branch transfer buffer
histry = 0;

hit = 0;                                        % initializing other metrics
miss = 0;
right_pred = 0;
wrong_pred = 0;
collision = 0;
select = 0;
wrong_address = 0;

for i = 1:length(PC)-1
    entry = floor(mod(PC(i), hex2dec('1000'))/4);
    if PC(i) == BTB(entry+1,2) % PC alreaady in BTB Step 1, Yes condition
        hit = hit+1 ; % step 1 hit
        if BTB(entry+1,3) == (PC(i+1)) %PC_next matches in BTB Step 2B
            actual_pred = 1; % 1 =  taken
            prev_pred_local = BTB(entry+1,4);
            prev_pred_global = BTB(entry+1,5+histry);
            final_pred = tournament(select, prev_pred_local, prev_pred_global);
            pred = floor(final_pred/2);
            if pred == actual_pred
                right_pred = right_pred + 1;
            else
                wrong_pred = wrong_pred + 1;
            end
            BTB(entry+1,9) = selector(select, prev_pred_local, prev_pred_global, actual_pred);
            BTB(entry+1,4) = sm_local(prev_pred_local, actual_pred);
            BTB(entry+1,5+histry) = sm_global_1(prev_pred_global, actual_pred);
            histry = history(histry, actual_pred);
            %%selector remains%%
        else
            if (PC(i+1)-PC(i)) == 4 %PC_next does not match with BTB entry, no branch taken step 2C
                prev_pred_local = BTB(entry+1,4);
                prev_pred_global = BTB(entry+1,5+histry);
                final_pred = tournament(select, prev_pred_local, prev_pred_global);
                actual_pred = 0; % 0 =  not taken
                pred = floor(final_pred/2);
                if pred == actual_pred
                    right_pred = right_pred + 1;
                else
                    wrong_pred = wrong_pred + 1;
                end
                BTB(entry+1,9) = selector(select, prev_pred_local, prev_pred_global, actual_pred);
                BTB(entry+1,4) = sm_local(prev_pred_local, actual_pred);
                BTB(entry+1,5+histry) = sm_global_1(prev_pred_global, actual_pred);
                histry = history(histry, actual_pred);
            else %PC_next does not match with BTB entry, branch exists, BTB wrong
                wrong_address = wrong_address + 1;
                BTB(entry+1,1) = entry;
                BTB(entry+1,2) = (PC(i));
                BTB(entry+1,3) = (PC(i+1));
                actual_pred = 1; % 1 =  taken
                prev_pred_local = BTB(entry+1,4);
                prev_pred_global = BTB(entry+1,5+histry);
                final_pred = tournament(select, prev_pred_local, prev_pred_global);
                pred = floor(final_pred/2);
                if pred == actual_pred
                    right_pred = right_pred + 1;
                else
                    wrong_pred = wrong_pred + 1;
                end
                BTB(entry+1,9) = selector(select, prev_pred_local, prev_pred_global, actual_pred);
                BTB(entry+1,4) = sm_local(prev_pred_local, actual_pred);
                BTB(entry+1,5+histry) = sm_global_1(prev_pred_global, actual_pred);
                histry = history(histry, actual_pred);
            end
        end
    else % PC_Current not in BTB 2A
        if (PC(i+1)-PC(i)) ~= 4 % branch exists step 2A yes
            if entry == BTB(entry+1,1) 
                collision =  collision + 1 ; % step 3A Collision
            end
            miss = miss + 1 ; % step 2A miss
            BTB(entry+1,1) = entry;
            BTB(entry+1,2) = (PC(i));
            BTB(entry+1,3) = (PC(i+1));
            BTB(entry+1,4) = 3; % 3 = strongly taken
            BTB(entry+1,5) = 3; % 3 = strongly taken, global 00
            BTB(entry+1,6) = 3; % 3 = strongly taken, global 01
            BTB(entry+1,7) = 3; % 3 = strongly taken, global 10
            BTB(entry+1,8) = 3; % 3 = strongly taken, global 11
            BTB(entry+1,9) = 2; % 2 = selector weak non-correlator
            % Step 3A done            
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
collision
BTB_new = BTB; 
BTB_new( ~any(BTB_new,2), : ) = [];