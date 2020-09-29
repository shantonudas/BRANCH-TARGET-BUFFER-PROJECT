function tour_pred = tournament(selector, local_pred, global_pred)
if selector == 0 || selector == 1
    tour_pred = global_pred;
else 
    tour_pred = local_pred;
end