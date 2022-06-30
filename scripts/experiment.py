import os
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

from googleOR.classes.utils import DATA_DIR, EXPERIMENTS_DIR

sizes = np.array([16, 32, 64, 128, 256, 512])

def time_vs(df):
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
    plt.figure(figsize=(10, 6))
    sns.lineplot(x="Size", y="Time", data=df, hue="Version", palette="Set2")
    plt.xlabel("Infrastructure Size")
    plt.ylabel("Time")
    plt.title("Time vs Size")
    plt.legend(loc='upper left')
    plt.savefig(os.path.join(EXPERIMENTS_DIR, "time_vs_size.png"))
    plt.close()


def change_vs(df):
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
    plt.figure(figsize=(10, 6))
    sns.lineplot(x="Size", y="Change", data=df, hue="Version", palette="Set2")
    plt.xlabel("Infrastructure Size")
    plt.ylabel("Change")
    plt.title("Change vs Size")
    plt.legend(loc='upper left')
    plt.savefig(os.path.join(EXPERIMENTS_DIR, "change_vs_size.png"))
    plt.close()


def bins_vs(df):
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
    plt.figure(figsize=(10, 6))
    sns.lineplot(x="Size", y="Bins", data=df, hue="Version", palette="Set2")
    plt.xlabel("Infrastructure Size")
    plt.ylabel("Bins")
    plt.title("Bins vs Size")
    plt.legend(loc='upper left')
    plt.savefig(os.path.join(EXPERIMENTS_DIR, "bins_vs_size.png"))
    plt.close()


def time_plus(df):
    sns.set(style="whitegrid")
    sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
    plt.figure(figsize=(10, 6))
    sns.lineplot(x="Size", y="Time_plus", data=df, hue="Version", palette="Set2")
    plt.xlabel("Infrastructure Size")
    plt.ylabel("Time")
    plt.title("Time vs Size")
    plt.legend(loc='upper left')
    plt.savefig(os.path.join(EXPERIMENTS_DIR, "time_plus.png"))
    plt.close()

def main(df):
    time_vs(df)
    change_vs(df)
    """" bins_vs(df)

    time_plus(df)
    bin_cost_plus(df)
    tradeoff_plus(df) """

if __name__ == '__main__':
    df = pd.read_csv(os.path.join(DATA_DIR, 'results.csv'))
    main(df)