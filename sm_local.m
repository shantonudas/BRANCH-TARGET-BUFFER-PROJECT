function pred = sm_local(prev_pred, local_pred)

if prev_pred == 3 && local_pred == 0
    pred = 2; % 2 = weakly taken
elseif prev_pred == 3 && local_pred == 1
    pred = 3; % 3 = strongly taken
elseif prev_pred == 2 && local_pred == 0
    pred = 0; % 1 = strongly not taken
elseif prev_pred == 2 && local_pred == 1
    pred = 3; % 3 = strongly taken
elseif prev_pred == 1 && local_pred == 0
    pred = 0; % 0 = strongly not taken
elseif prev_pred == 1 && local_pred == 1
    pred = 3; % 2 = strongly taken
elseif prev_pred == 0 && local_pred == 1
    pred = 1; % 1 = weakly not taken
elseif prev_pred == 0 && local_pred == 0
    pred = 0; % 0 = strongly not taken
end
    