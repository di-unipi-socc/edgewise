from os import makedirs
from os.path import basename, exists

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from classes.utils import (COMPARE_PATTERN, EDGEWISE, MILP, PL, PL_NUM,
                           PLOT_FORMAT, PLOT_PATH, PLOTS_SUBDIR, RESULTS_PATH,
                           df_to_file, merge_results)
from colorama import Fore, init
from tabulate import tabulate

sizes = [2**i for i in range(4, 10)]
x = [i for i in range(len(sizes))]

PALETTE = "colorblind"
TIME_YLIM = (10**-2, 10**3)
BINS_YLIM = (0, 12)

def groupby(df, field):
    df = df.groupby('Version')[field].agg(['mean', 'min', 'max'])
    df.columns = [f"{field}Avg", f"{field}Min", f"{field}Max"]
    return df


def size_vs(field, df, name=None, legend="best", lineplot=True, ylog=False, ylim=None, ylabel=None, palette=PALETTE):
    # set seaborn context
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})

    # choose plot
    plt.figure(figsize=(10, 6))
    if lineplot:
        sns.lineplot(x="Size", y=field, data=df, markers=True, style='Version', hue="Version", palette=palette)
    else:
        sns.barplot(x="Size", y=field, data=df, hue="Version", palette=PALETTE)
        plt.xticks(x, sizes)
    
    # set labels and y-scale
    plt.xlabel("Infrastructure Size")
    plt.ylabel(ylabel if ylabel else field)
    plt.ylim(ylim) if ylim else None
    plt.yscale('log') if ylog else None
    # plt.title("{} vs Size".format(field))
    plt.legend(loc=legend) if legend else plt.legend([],[], frameon=False)

    # save plot
    plt.savefig(PLOT_PATH.format(name="{}".format((name if name else field).lower())), format=PLOT_FORMAT, dpi=600)
    plt.close()
    print(Fore.LIGHTCYAN_EX + "✅ {} vs Size".format(name if name else field))


if __name__ == '__main__':
    init(autoreset=True)

    try:
        df = merge_results()
        # create plots directory, if not exists
        makedirs(PLOTS_SUBDIR) if not exists(PLOTS_SUBDIR) else None
    except FileNotFoundError as e:
        print(Fore.LIGHTRED_EX + "File not found: {}.".format(basename(e.filename)))
        exit(0)
    except ValueError:
        print(Fore.LIGHTRED_EX + "No file with pattern: {}".format(COMPARE_PATTERN))
        exit(0)

    df['Version'] = df['Version'].str.replace('binpack_num', PL_NUM, regex=False)
    df['Version'] = df['Version'].str.replace('ortools_num', MILP, regex=False)
    df['Version'] = df['Version'].str.replace('binpack', PL, regex=False)
    df['Version'] = df['Version'].str.replace('ortools', EDGEWISE, regex=False)

    # remove 'ortools' and 'binpack' Version from df
    df_num = df[(df.Version != PL) & (df.Version != EDGEWISE)]
    size_vs("Time", df_num, name="time_num", ylog=True, ylim=TIME_YLIM, ylabel="Time (s)")
    size_vs("Change_num", df_num, name="change_num", legend="lower right")
    size_vs("Bins", df_num, name="bins_num", lineplot=False, ylim=BINS_YLIM)

    # p = sns.color_palette(PALETTE, 2)
    # palette = {c: p[0] if c == "ortools" else p[1] for c in df.Version.unique()}
    df_no_num = df[(df.Version != PL_NUM) & (df.Version != MILP)]
    size_vs("Time", df_no_num, ylog=True, ylim=TIME_YLIM, ylabel="Time (s)")
    size_vs("Change", df_no_num, legend="lower right")
    size_vs("Bins", df_no_num, lineplot=False, ylim=BINS_YLIM)

    print("\n")
    df_time = groupby(df, 'Time')
    df_bins = groupby(df, 'Bins')
    df_change = groupby(df_no_num, 'Change')
    df_change_num = groupby(df_num, 'Change_num')

    df_agg = pd.concat([df_time, df_bins, df_change, df_change_num], axis=1)
    print(Fore.LIGHTCYAN_EX + tabulate(df_agg, headers='keys', numalign='center', stralign='center'))
    
    df_to_file(df_agg, RESULTS_PATH)
    

    print("\n")
    print(Fore.LIGHTWHITE_EX + "Speedup of TIME (MILP/EdgeWise): {}\n".format(df_time.loc[MILP]['TimeAvg'] / df_time.loc[EDGEWISE]['TimeAvg']))