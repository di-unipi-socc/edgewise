from os import makedirs
from os.path import basename, exists

import matplotlib.pyplot as plt
import seaborn as sns
from classes.utils import (COMPARE_PATTERN, PLOT_FORMAT, PLOT_PATH,
                           PLOTS_SUBDIR, merge_results)
from colorama import Fore, init

sizes = [2**i for i in range(4, 10)]
x = [i for i in range(len(sizes))]

PALETTE = "colorblind"
TIME_YLIM = (10**-2, 10**3)
BINS_YLIM = (0, 12)

PL = "declarative"
PL_NUM = f"{PL} (num)"
MILP = "MILP"
EDGEWISE = "EdgeWise"


def size_vs(field, df, name=None, legend="best", lineplot=True, logy=False, ylim=None, palette=PALETTE):
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
    plt.ylabel(field)
    plt.ylim(ylim) if ylim else None
    plt.yscale('log') if logy else None
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
    size_vs("Time", df_num, name="time_num", logy=True, ylim=TIME_YLIM)
    size_vs("Change_num", df_num, name="change_num", legend="lower right")
    size_vs("Bins", df_num, name="bins_num", lineplot=False, ylim=BINS_YLIM)

    # p = sns.color_palette(PALETTE, 2)
    # palette = {c: p[0] if c == "ortools" else p[1] for c in df.Version.unique()}
    df_no_num = df[(df.Version != PL_NUM) & (df.Version != MILP)]
    size_vs("Time", df_no_num, logy=True, ylim=TIME_YLIM)
    size_vs("Change", df_no_num, legend="lower right")
    size_vs("Bins", df_no_num, lineplot=False, ylim=BINS_YLIM)

    mean_times = df.groupby('Version')['Time'].mean()
    mean_changes = df_no_num.groupby('Version')['Change'].mean()
    mean_changes_num = df_num.groupby('Version')['Change_num'].mean()

    print("\n")
    print(Fore.LIGHTRED_EX + "Mean of TIME:\n{}\n".format(mean_times))
    print(Fore.LIGHTYELLOW_EX + "Mean of CHANGE:\n{}\n".format(mean_changes))
    print(Fore.LIGHTGREEN_EX + "Mean of CHANGE_NUM:\n{}".format(mean_changes_num))

    print("\n")
    print(Fore.LIGHTRED_EX + "Speedup of TIME (MILP/EdgeWise):{}\n".format(mean_times[MILP] / mean_times[EDGEWISE]))