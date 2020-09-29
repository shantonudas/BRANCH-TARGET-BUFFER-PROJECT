function select = selector(prev_selector, local_pred, global_pred, actual_pred)

if actual_pred == floor(global_pred/2)
    global_pred = 1;
else
    global_pred = 0;
end
 
if actual_pred == floor(local_pred/2)
    local_pred = 1;
else
    local_pred = 0;
end

if prev_selector == 0 && local_pred == 0 && global_pred == 0
    select = 0; % 00
elseif prev_selector == 0 && local_pred == 0 && global_pred == 1
    select = 0; % 00
elseif prev_selector == 0 && local_pred == 1 && global_pred == 1
    select = 0; % 00
elseif prev_selector == 0 && local_pred == 1 && global_pred == 0
    select = 1; % 01
elseif prev_selector == 1 && local_pred == 0 && global_pred == 1
    select = 0; % 00
elseif prev_selector == 1 && local_pred == 0 && global_pred == 0
    select = 1; % 01
elseif prev_selector == 1 && local_pred == 1 && global_pred == 1
    select = 1; % 01
elseif prev_selector == 1 && local_pred == 1 && global_pred == 0
    select = 2; % 10
elseif prev_selector == 2 && local_pred == 0 && global_pred == 1
    select = 1; % 01
elseif prev_selector == 2 && local_pred == 0 && global_pred == 0
    select = 2; % 10
elseif prev_selector == 2 && local_pred == 1 && global_pred == 1
    select = 2; % 10
elseif prev_selector == 2 && local_pred == 1 && global_pred == 0
    select = 3; % 11
elseif prev_selector == 3 && local_pred == 0 && global_pred == 1
    select = 2; % 10    
elseif prev_selector == 3 && local_pred == 0 && global_pred == 0
    select = 3; % 11
elseif prev_selector == 3 && local_pred == 1 && global_pred == 0
    select = 3; % 11
elseif prev_selector == 3 && local_pred == 1 && global_pred == 1
    select = 3; % 11
end
    