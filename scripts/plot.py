from os import makedirs
from os.path import basename, exists

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from classes.utils import (COMPARE_PATTERN, PLOT_PATH, PLOTS_SUBDIR,
                           merge_results)
from colorama import Fore, init

sizes = [2**i for i in range(4, 10)]
x = [i for i in range(len(sizes))]
PALETTE = "colorblind" # "Set2"


def size_vs(field, df, name=None, legend="best", lineplot=True, logy=False, palette=PALETTE):
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
    plt.yscale('log') if logy else None
    plt.title("{} vs Size".format(field))
    plt.legend(loc=legend) if legend else plt.legend([],[], frameon=False)

    # save plot
    plt.savefig(PLOT_PATH.format(name="{}_vs_size".format((name if name else field).lower())), dpi=600)
    plt.close()
    print(Fore.LIGHTCYAN_EX + "✅ {} vs Size".format(name if name else field))


if __name__ == '__main__':
    init(autoreset=True)
    
    # create plots directory, if not exists
    makedirs(PLOTS_SUBDIR) if not exists(PLOTS_SUBDIR) else None

    try:
        df = merge_results()
    except FileNotFoundError as e:
        print(Fore.LIGHTRED_EX + "File not found: {}.".format(basename(e.filename)))
        exit(0)
    except ValueError:
        print(Fore.LIGHTRED_EX + "No file with pattern: {}".format(COMPARE_PATTERN))
        exit(0)

    # remove 'ortools' Version from df
    df_num = df[df.Version != 'ortools']
    size_vs("Time", df_num, name="time_num", logy= True)
    size_vs("Change_num", df_num, legend="lower right")
    size_vs("Bins", df_num, lineplot=False)

    p = sns.color_palette(PALETTE, 2)
    palette = {c: p[0] if c == "ortools" else p[1] for c in df.Version.unique()}
    size_vs("Time", df, logy= True, palette=palette)
