function pred = history(prev_history, last_pred)

if prev_history == 3 && last_pred == 0
    pred = 2; % 10
elseif prev_history == 3 && last_pred == 1
    pred = 3; % 11
elseif prev_history == 2 && last_pred == 0
    pred = 0; % 00
elseif prev_history == 2 && last_pred == 1
    pred = 1; % 01
elseif prev_history == 1 && last_pred == 0
    pred = 2; % 10
elseif prev_history == 1 && last_pred == 1
    pred = 3; % 11
elseif prev_history == 0 && last_pred == 1
    pred = 1; % 01
elseif prev_history == 0 && last_pred == 0
    pred = 0; % 00
end
    