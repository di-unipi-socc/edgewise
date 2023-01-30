import os

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from classes.utils import OUTPUT_DIR, PLOTS_DIR

sizes = ["16", "32", "64", "128", "256", "512"]
x = [i for i in range(len(sizes))]

def time_vs(df):
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
    plt.figure(figsize=(10, 6))
    sns.lineplot(x="Size", y="Time", data=df, hue="Version", palette="Set2")
    plt.xlabel("Infrastructure Size")
    plt.yscale("log")
    plt.ylabel("Time")
    plt.title("Time vs Size")
    plt.legend(loc='upper left')
    plt.savefig(os.path.join(PLOTS_DIR, "time_vs_size.png"), dpi=600)
    plt.close()
    print("Time vs Size, DONE")


def change_vs(df):
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
    plt.figure(figsize=(10, 6))
    sns.lineplot(x="Size", y="Change", data=df, hue="Version", palette="Set2")
    plt.xlabel("Infrastructure Size")
    plt.ylabel("Change")
    plt.title("Change vs Size")
    plt.legend(loc='lower right')
    plt.savefig(os.path.join(PLOTS_DIR, "change_vs_size.png"), dpi=600)
    plt.close()
    print("Change vs Size, DONE")


def bins_vs(df):
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
    plt.figure(figsize=(10, 6))
    sns.barplot(x="Size", y="NDistinct", data=df, hue="Version", palette="Set2")
    plt.xlabel("Infrastructure Size")
    plt.ylabel("Bins")
    plt.title("Bins vs Size")
    plt.legend(loc='upper left')
    plt.savefig(os.path.join(PLOTS_DIR, "bins_vs_size.png"), dpi=600)
    plt.close()
    print("Bins vs Size, DONE")


if __name__ == '__main__':
    df = pd.read_csv(os.path.join(OUTPUT_DIR, 'results.csv'))
    time_vs(df)
    change_vs(df)
    bins_vs(df)