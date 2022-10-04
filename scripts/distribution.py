from scipy.stats import truncnorm
import numpy

def normal_distribution(min_value=32, max_value=1024, center=512, size_of_federation=128, stepping=32, deviation=None):

    def get_truncated_normal(mean=0, sd=1, low=0, upp=10):
        return truncnorm((low - mean) / sd, (upp - mean) / sd, loc=mean, scale=sd)
    
    if min_value > max_value:
        print('error: min should be smaller than max')
        return
    
    if not max_value/stepping:
        print('error: max_value should be a multiple of stepping')
        return

    if not min_value/stepping:
        print('error: min_value should be a multiple of stepping')
        return

    if not min_value < center < max_value:
        print('error: center should be within max_value and min_value')
        return

    if size_of_federation < 1:
        print('error: federation size should be a positive number')
        return

    max_step = int(max_value/stepping)
    if min_value == 0: 
        min_step = int(min_value/stepping)
    else:
        min_step = max(1, int(min_value/stepping)) # to avoid min_value = 0 when stepping is greater than min_value
    mean_step = int(center/stepping)

    if deviation is None:
        m = max(max_step-mean_step, mean_step-min_step)
        deviation = m/3

    x = get_truncated_normal(mean=mean_step, sd=deviation, low=min_step, upp=max_step)

    result = numpy.rint(x.rvs(size_of_federation)) * stepping
    return result