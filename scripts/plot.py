from os import makedirs
from os.path import basename, exists, join

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from classes.utils import (COMPARE_PATTERN, PLOT_PATH, PLOTS_SUBDIR,
                           get_latest_file)
from colorama import Fore, init

sizes = ["16", "32", "64", "128", "256", "512"]
x = [i for i in range(len(sizes))]


def size_vs(field, df, legend=True, lineplot=True, logy=False):
    # set seaborn context
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})

    # choose plot
    plt.figure(figsize=(10, 6))
    if lineplot:
        sns.lineplot(x="Size", y=field, data=df, hue="Version", palette="Set2")
    else:
        sns.barplot(x="Size", y=field, data=df, hue="Version", palette="Set2")
    
    # set labels and y-scale
    plt.xlabel("Infrastructure Size")
    plt.ylabel(field)
    plt.yscale('log') if logy else None
    plt.title("{} vs Size".format(field))
    plt.legend(loc='upper left') if legend else plt.legend([],[], frameon=False)

    # save plot
    plt.savefig(PLOT_PATH.format("{}_vs_size.png".format(field.lower())), dpi=600)
    plt.close()
    print(Fore.LIGHTCYAN_EX + "✅ {} vs Size".format(field))


if __name__ == '__main__':
    init(autoreset=True)
    
    # create plots directory, if not exists
    makedirs(PLOTS_SUBDIR) if not exists(PLOTS_SUBDIR) else None

    try:
        filename = get_latest_file(COMPARE_PATTERN)
        df = pd.read_csv(filename)
        print(Fore.LIGHTGREEN_EX + "Plotting from file:", end=" ")
        print(Fore.LIGHTYELLOW_EX + basename(filename), end="\n")
        size_vs("Time", df, logy= True)
        size_vs("Change", df)
        size_vs("Bins", df, lineplot=False)
    except (ValueError, FileNotFoundError) as e:
        print(Fore.LIGHTRED_EX + "File not found: {}.".format(basename(e.filename)))