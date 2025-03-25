import pandas as pd
import json
from pathlib import Path
from eclypse.utils import DEFAULT_SIM_PATH


def merge_ray_tune_results(root_dir: str, prefix: str = "edgewise_"):
    """
    Merges results from multiple Ray Tune grid search runs into a single DataFrame.

    Args:
        root_dir (str): Root directory containing subdirectories with Ray Tune results.
        output_file (str): Path to save the merged Parquet file.
    """
    root_path = Path(root_dir)
    experiment_dirs = [
        subdir
        for subdir in root_path.iterdir()
        if subdir.is_dir() and subdir.name.startswith(prefix)
    ]

    all_data = []
    tot_processed = 0
    tot_skipped = 0

    for exp_dir in experiment_dirs:
        print("Processing experiment:", exp_dir, end="\n")
        i = 0
        skipped = 0
        processed = 0
        exp_subdirs = [subdir for subdir in exp_dir.iterdir() if subdir.is_dir()]
        total = len(exp_subdirs)
        for exp in exp_subdirs:
            i += 1
            app_csv_path = exp / "output/stats/application.csv"
            params_path = exp / "params.json"

            if not app_csv_path.exists():
                print(f"Skipping {exp}: application.csv not found")
                skipped += 1
                continue  # Skip if application.csv is missing (experiment not ended)

            df = pd.read_csv(app_csv_path)

            if params_path.exists():
                with open(params_path, "r", encoding="utf-8") as f:
                    params = json.load(f)
                    for key, value in params.items():
                        df[key] = value

            all_data.append(df)
            print(
                f"Processed {i}/{total}", end=("\r" if i < total else "\n"), flush=True
            )
            processed += 1

        tot_processed += processed
        tot_skipped += skipped

    print(f"Processed: {tot_processed}, Skipped: {tot_skipped}")
    df = pd.concat(all_data, ignore_index=True)
    return df


def clean_and_dump(df: pd.DataFrame, output_file: str = "merged_results.parquet"):

    # Cast values to correct dtypes
    bool_columns = ["cr", "declarative", "preprocess"]
    for col in bool_columns:
        df[col] = df[col].astype(bool)

    def assign_version(row):
        if not row["preprocess"] and not row["declarative"] and not row["cr"]:
            return "EdgeWise (num)"
        elif row["preprocess"] and not row["declarative"] and not row["cr"]:
            return "EdgeWise"
        elif row["preprocess"] and not row["declarative"] and row["cr"]:
            return "EdgeWise (cr)"
        elif not row["preprocess"] and row["declarative"] and not row["cr"]:
            return "prolog (num)"
        elif row["preprocess"] and row["declarative"] and not row["cr"]:
            return "prolog"
        elif row["preprocess"] and row["declarative"] and row["cr"]:
            return "prolog (cr)"
        else:
            return "unknown"  # Just in case there are unexpected values

    df["version"] = df.apply(assign_version, axis=1)

    df.to_parquet(output_file, index=False)
    print(f"Successfully saved merged results to {output_file}")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Merge Ray Tune results into a single Parquet file."
    )
    parser.add_argument(
        "--root_dir",
        type=str,
        default=DEFAULT_SIM_PATH,
        help="Root directory containing experiment subdirectories.",
    )
    parser.add_argument(
        "--output",
        type=str,
        default="merged_results.parquet",
        help="Output Parquet file path.",
    )
    parser.add_argument(
        "-p",
        "--prefix",
        type=str,
        default="edgewise_",
        help="Prefix for experiment directories.",
    )

    args = parser.parse_args()

    df = merge_ray_tune_results(args.root_dir, args.prefix)
    if not df.empty:
        clean_and_dump(df, args.output)
    else:
        print(f"No results found in {args.root_dir}")
