from os.path import basename, join

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from classes.utils import COMPARISON_FILE, PLOTS_DIR
from colorama import Fore, init

sizes = ["16", "32", "64", "128", "256", "512"]
x = [i for i in range(len(sizes))]


def size_vs(field, df):
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
    plt.figure(figsize=(10, 6))
    sns.barplot(x="Size", y=field, data=df, hue="Version", palette="Set2")
    plt.xlabel("Infrastructure Size")
    plt.ylabel(field)
    plt.title("{} vs Size".format(field))
    plt.legend(loc='upper left')
    plt.savefig(join(PLOTS_DIR, "{}_vs_size.png".format(field.lower())), dpi=600)
    plt.close()
    print("{} vs Size, DONE".format(field))


if __name__ == '__main__':
    init(autoreset=True)

    try:
        df = pd.read_csv(COMPARISON_FILE)
        size_vs("Time", df)
        size_vs("Change", df)
        size_vs("Bins", df)
    except FileNotFoundError as e:
        print(Fore.LIGHTRED_EX + "File not found: {}.".format(basename(e.filename)))