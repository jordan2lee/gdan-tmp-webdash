## Web Dashboard For Viewing GDAN TMP Machine Learning Results
https://www.synapse.org/#!Synapse:syn8011998/wiki/411602

## General Organization

```
data/
├── download_data.sh       <- download tarball
├── load_sqlite.R          <- prepare feature database
├── features.sqlite        <- output database
|
├── v8-cv-matrices          <- raw tarball contents
├── v8-feature-matrices     <- raw tarball contents
├── v8-qc                   <- raw tarball contents
|
├── original_pred_matrices  <- group results (previous group results raw, will be rm later)
├── tmpdir                  <- obj3 tsv
├── feature-sets            <- MAIN: unified feature set of all group results
|   ├── ...
|   └── ...
└── predictions             <- MAIN: group results
|   ├── ...
|   └── ...
|   
|
├── GROUP_RESULTS_RAW_FINAL
|   ├── AKLIMATE
|       └── aklimate_predictions_and_features_20200430.tar.gz
|   ├── CloudForest
|       └──
|   ├── GEXP_NN
|       ├── Features-20200320_allCOHORTS_20200203Tarball_JasleenGrewal.txt
|       └── 2020-03-20-allCOHORTS_20200203Tarball_JasleenGrewal.gz
|   ├── Gnosis_results
|       ├── 2020-04-08.zip
|       └── 2020-04-08_extracted
|           ├── ${tumor}_features_sets.tsv
|           └── ${tumor}_single_sample_predictions.tsv
|   └── OHSU_results
|       ├── fbed_rfe_feats.csv       <- feature set
|       └── reprocess.tgz            <- prediction files
|           ├── fbed_ada
|           ├── fbed_bnb
|           ├── fbed_dt
|           ├── fbed_et
|           ├── fbed_gnb
|           ├── fbed_gp
|           ├── fbed_knn
|           ├── fbed_logreg
|           ├── fbed_pa
|           ├── fbed_rf
|           ├── fbed_sgd
|           ├── fbed_svm
|           ├── rfe_ada
|           ├── rfe_bnb
|           ├── rfe_dt
|           ├── rfe_et
|           ├── rfe_gnb
|           ├── rfe_knn
|           ├── rfe_logreg
|           ├── rfe_pa
|           ├── rfe_rf
|           ├── rfe_sgd
|           ├── rfe_svm
```

## Quick Start: Start the Shiny Application

- Create dirs with prefix `v8-` and fill contents (see General Organization)
- Prepare feature database `Rscript load_sqlite.R ./v8-feature-matrices/ ./features.sqlite`. Pulls only files ending in .tsv in v8-feature-matrices/
- Add prediction file(s) to: `data/predictions`. These are the classifier results.
- Add feature set file(s) to: `data/feature-sets`. These are the features the model was shown when producing classifier results
- Create obj3 of prediction and feature-set dirs. Reduces memory usage when running app
```
Rscript gen-obj3.R <path/to/predictions_dir> <path/to/featureset_dir> <path>/data/tmpdir/tmp--combo_rf-gnosis_obj3.tsv
```

- Run the app

  ```
  docker-compose up
  ```

The app will be available at [http://localhost:3838](http://localhost:3838)

## (Optional) Download Data From Synapse

If you want to be able to examine feature values in the app do the following:

- Install the synapse python client:
  ```
  pip install synapseclient boto3
  ```
- Download the V8 tarball and place contents in appropriate `v8-` prefix dirs :

  ```
  cd data
  bash download_data.sh
  ```

- Prepare the feature database:

  ```
  Rscript load_sqlite.R ./v8-feature-matrices/ ./features.sqlite
  ```

- Run the app

  ```
  docker-compose up
  ```

# Reformat Gnosis files (20200408)

- [x] Reformat Gnosis feature set files
- [x] Reformat Gnosis prediction matrices

1. Reformat feature set matrices

Run:

```
cd reformat
./wrapper_ftset-gnosis.sh ../data/GROUP_RESULTS_RAW_FINAL/Gnosis_results/2020-04-08_extracted ./TEMP_DIR ../data/library_reformating/features_reformatted_gnosis20200408.tsv
```
outputs `data/library_reformating/features_reformatted_gnosis20200408.tsv`


 2. Reformat prediction matrices

```
cd reformat
./wrapper_preds-gnosis.sh ../data/GROUP_RESULTS_RAW_FINAL/Gnosis_results/2020-04-08_extracted TEMP_DIR ../data/library_reformating
```

outputs `data/library_reformating/predictions_reformatted_gnosis20200408-${tumor}.tsv`

# Reformat GEXP_NN files (2020-03-20-allCOHORTS_20200203Tarball_JasleenGrewal)

- [x] Make sure to reformat all 26 tumors 
- [x] Reformat GEXP_NN feature set file
- [x] Reformat GEXP_NN prediction matrices


1. Reformat GEXP_NN feature set file

Raw file contains 2 different feature sets (nn_jg_2020-03-20_bootstrapfeatures,nn_jg_2020-03-20_top1kfreq)

TODO:
- [x] Remove row on `nn_jg_2020-03-20_bootstrapfeatures` because this feature_set_id is not present in prediction file (viewer requires all featuresets in file to also be in prediction file)
- [x] Remove # commented out lines at head of file (specific to viewer input)
- [x] Remove Feature_importances col (specific to viewer input)
- [x] col TCGA_Projects -- ' -> " and rm spaces between list items
- [x] col Features -- "['ft', 'ft', ...]" -> ["ft","ft",..]

```
cd reformat
bash wrapper_ftset-gexpnn.sh ../data/GROUP_RESULTS_RAW_FINAL/GEXP_NN/Features-20200320_allCOHORTS_20200203Tarball_JasleenGrewal.txt ../data/library_reformating/features_reformatted_gexpnn20200320allCOHORTS.tsv
```

2. Reformat GEXP_NN prediction files

Decided to sep into individual tumor files (viewer requires this input), note that GEXP_NN is a pan-cancer method not a tumor level method

Results column in file `nn_jg_2020-03-20|nn_jg_2020-03-20_top1kfreq|2020-03-20|p`

TODO:
- [x] convert from prob to crisp predictions (ACC:ACC_2)
- [x] convert Label col entries ACC:2 --> ACC:ACC_2
- [x] update model col header: p --> c
- [x] one unified file --> split files for each cancer type (just note this method applied a pan-cancer approach even though we are spliting by tumor)
- [x] updat header add TUMOR:____ prefix, add time stamp where is 2020-03-20 --> 2020-03-20T00:00.00.000 (will just pick time 00 for timestamp)


```
cd reformat
bash wrapper_preds-gexpnn.sh ../data/GROUP_RESULTS_RAW_FINAL/GEXP_NN/2020-03-20-allCOHORTS_20200203Tarball_JasleenGrewal TEMP_DIR ../data/library_reformating
```

# Reformat Aklimate files (aklimate_predictions_and_features_20200430)

- [x] Reformat feature set file
- [x] Reformat prediction matrices


1. Reformat feature set files

TODO:

- [x] concat into one file (purely for speed in taking time to read in one file vs 26)

```
cd reformat
bash wrapper_ftset-aklimate.sh ../data/GROUP_RESULTS_RAW_FINAL/AKLIMATE/aklimate_predictions_and_features_20200430 ../../library_reformating/features_reformatted_aklimate20200430.tsv
```

2. Reformat prediction files

TODO:

- [x] rm # commented out lines, first 19 lines (specific to viewer input)
- [x] convert from prob to crisp predictions (ACC:ACC_2)
- [x] convert Label col entries ACC:2 --> ACC:ACC_2
- [x] update model col header: p --> c
- [x] update header add TUMOR:____ prefix, add time stamp where is 20200214 --> 2020-02-14T00:00.00.000 (will just pick time 00 for timestamp)

```
cd reformat
bash wrapper_preds-aklimate.sh ../data/GROUP_RESULTS_RAW_FINAL/AKLIMATE/aklimate_predictions_and_features_20200430 TEMP_DIR ../data/library_reformating
```

# Reformat OHSU files (fbed_rfe_feats.csv and reprocess.tgz)

- [x] Reformat feature set file (fbed_rfe_feats.csv)
- [ ] Reformat prediction matrices (sklrn_shiny_20200508) (old == reprocess.tgz)

Using prediction files `sklrn_shiny_20200508` that are the same as the most recent date in reprocess BUT that have consolidated all models for ONE tumor into one file

Old note == Note that there are two iterations in `reprocess.tgz`, we will only be using the most recent date files (20200331) thus will ignore (20200227)

1. Reformat feature set files

TODO:

- [x] convert csv --> tsv
- [x] rm 2 sets of double quotes in TCGA_Projects col. "[""ACC""]" --> ["ACC"]
- [x] rm 2 sets of double quotes in Features col. "[""B:MUTA:COMP:ERBB2::"", ""B:MUTA:COMP:FOXA1::"",..]" --> ["B:MUTA:COMP:ERBB2::,"B:MUTA:COMP:FOXA1::",..]
- [x] rm spaces between items in list under col Features ["B:MUTA:COMP:ERBB2::, "B:MUTA:COMP:FOXA1::",..] --> ["B:MUTA:COMP:ERBB2::,"B:MUTA:COMP:FOXA1::",..]

```
cd reformat
bash wrapper_ftset-ohsu.sh ../data/GROUP_RESULTS_RAW_FINAL/OHSU_results/fbed_rfe_feats.csv ../data/library_reformating/features_reformatted_ohsu20200331.tsv
```

1. Reformat prediction files

TODO:

- [ ] convert Label col. ACC:2 --> ACC:ACC_2
- [ ] convert model prediction col. ACC:2 --> ACC:ACC_2
- [ ] change model col header timestamp. 2020-02-27 --> 2020-02-27T00:00:00.000 (will just pick time 00 for timestamp)
