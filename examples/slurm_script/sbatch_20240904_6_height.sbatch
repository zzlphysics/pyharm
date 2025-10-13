#!/bin/bash

#SBATCH --job-name=plot
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH --cpus-per-task=2
#SBATCH --time=1-00:00:00
#SBATCH --partition=debug
#SBATCH --output=sbatch_log/res_kharma_%j.out
#SBATCH --error=sbatch_log/res_kharma_%j.err

spack env activate pyharm
conda init
source activate
conda activate ~/opt/conda_env/pyharm

# FILE_PATH1="/home/zhangzelin/projects/kharma-data-sync/20241216_cuda_sane_a05000_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH2="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_sane_a09375_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH3="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_kz_sane_a05000_eta-05_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH4="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_kz_sane_a05000_eta+05_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH5="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_kz_sane_a09375_eta-01_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH6="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_kz_sane_a09375_eta+05_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH_LIST=($FILE_PATH1 $FILE_PATH2 $FILE_PATH3 $FILE_PATH4 $FILE_PATH5 $FILE_PATH6)

FILE_PATH1="/home/zhangzelin/projects/kharma/output/20241216_hip_kz_sane_a05000_eta-05_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH2="/home/zhangzelin/projects/kharma/output/20241216_hip_kz_sane_a05000_eta+05_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH3="/home/zhangzelin/projects/kharma/output/20241216_hip_kz_sane_a09375_eta-01_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH4="/home/zhangzelin/projects/kharma/output/20241216_hip_kz_sane_a09375_eta+05_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH5="/home/zhangzelin/projects/kharma/output/20241216_hip_sane_a05000_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH6="/home/zhangzelin/projects/kharma/output/20241216_hip_sane_a09375_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_LIST=($FILE_PATH1 $FILE_PATH2 $FILE_PATH3 $FILE_PATH4 $FILE_PATH5 $FILE_PATH6)

for FILE_PATH in "${FILE_PATH_LIST[@]}"; do
    echo "Processing $FILE_PATH"
    pyharm-analysis basic,density_scale_height  "$FILE_PATH" --nthreads=36 -f density_scale_height.h5 -e 7000 
done

