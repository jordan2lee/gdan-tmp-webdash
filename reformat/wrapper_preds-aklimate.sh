#!/bin/bash

raw_dir=${1} #absolute path to data/GROUP_RESULTS_RAW_FINAL/AKLIMATE/aklimate_predictions_and_features_20200430
temp_dir=${2} #absolute path to TEMP_DIR
output_dir=${3} #absolute path to data/library_reformating

mkdir ${temp_dir}

# Reformat step 1: convert prob > crips predictions, classACC:2 or ACC:2 -> ACC:ACC_2
    # TODO : add loop to process all files
echo 'starting reformat step 1'
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/ACC/predictions.tsv \
    -out ${temp_dir}/predictions-ACC.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/BLCA/predictions.tsv \
    -out ${temp_dir}/predictions-BLCA.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/BRCA/predictions.tsv \
    -out ${temp_dir}/predictions-BRCA.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/CESC/predictions.tsv \
    -out ${temp_dir}/predictions-CESC.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/COADREAD/predictions.tsv \
    -out ${temp_dir}/predictions-COADREAD.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/ESCC/predictions.tsv \
    -out ${temp_dir}/predictions-ESCC.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/GEA/predictions.tsv \
    -out ${temp_dir}/predictions-GEA.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/HNSC/predictions.tsv \
    -out ${temp_dir}/predictions-HNSC.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/KIRCKICH/predictions.tsv \
    -out ${temp_dir}/predictions-KIRCKICH.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/KIRP/predictions.tsv \
    -out ${temp_dir}/predictions-KIRP.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/LGGGBM/predictions.tsv \
    -out ${temp_dir}/predictions-LGGGBM.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/LIHCCHOL/predictions.tsv \
    -out ${temp_dir}/predictions-LIHCCHOL.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/LUAD/predictions.tsv \
    -out ${temp_dir}/predictions-LUAD.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/LUSC/predictions.tsv \
    -out ${temp_dir}/predictions-LUSC.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/MESO/predictions.tsv \
    -out ${temp_dir}/predictions-MESO.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/OV/predictions.tsv \
    -out ${temp_dir}/predictions-OV.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/PAAD/predictions.tsv \
    -out ${temp_dir}/predictions-PAAD.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/PCPG/predictions.tsv \
    -out ${temp_dir}/predictions-PCPG.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/PRAD/predictions.tsv \
    -out ${temp_dir}/predictions-PRAD.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/SARC/predictions.tsv \
    -out ${temp_dir}/predictions-SARC.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/SKCM/predictions.tsv \
    -out ${temp_dir}/predictions-SKCM.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/TGCT/predictions.tsv \
    -out ${temp_dir}/predictions-TGCT.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/THCA/predictions.tsv \
    -out ${temp_dir}/predictions-THCA.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/THYM/predictions.tsv \
    -out ${temp_dir}/predictions-THYM.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/UCEC/predictions.tsv \
    -out ${temp_dir}/predictions-UCEC.tsv
python3 reformat-aklimate-preds.py \
    -in ${raw_dir}/UVM/predictions.tsv \
    -out ${temp_dir}/predictions-UVM.tsv


# Reformat step 2: 2020-03-13 08:17:44.059 -> 2020-03-13T08:17:44.059, add "model" infront of model int
echo 'Starting reformat step 2'
python3 reformat-aklimate-preds-STEP2.py \
    -in ${temp_dir} \
    -out ${output_dir}

echo 'Cleaning up workspace'
rm -r ${temp_dir}
