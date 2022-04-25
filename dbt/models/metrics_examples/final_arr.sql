select * from {{metrics.metric(
            metric_name = 'west_arr',
            grain = 'day',
            dimensions=['region'])}}