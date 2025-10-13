#!/bin/bash

#SBATCH --job-name=plot
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=72
#SBATCH --cpus-per-task=2
#SBATCH --time=1-00:00:00
#SBATCH --partition=72c512g
#SBATCH --output=sbatch_log/res_kharma_%j.out
#SBATCH --error=sbatch_log/res_kharma_%j.err

spack env activate pyharm
conda init
source activate
conda activate ~/opt/conda_env/pyharm

# FILE_PATH_LIST=("/home/zhangzelin/projects/kharma/output/20241018_hip_mad_09375_192-96-96"
#                 "/home/zhangzelin/projects/kharma/output/20241018_hip_mad_05000_192-96-96"
#                 "/home/zhangzelin/projects/kharma/output/20241018_hip_mad_00000_192-96-96"
#                 "/home/zhangzelin/projects/kharma/output/20241018_hip_mad_-05000_192-96-96"
#                 "/home/zhangzelin/projects/kharma/output/20241018_hip_mad_-09375_192-96-96"
#                 "/home/zhangzelin/projects/kharma/output/20241029_hip_mad_09375_192-96-96")

# FILE_PATH_LIST=(
#     "/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a05000_eta+00_128-96-96_10-20"
#     "/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a05000_eta+05_128-96-96_10-20"
#     "/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a05000_eta+00_128-96-96_10-20_mix"
#     "/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a09375_eta+00_128-96-96_10-20"
#     "/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a09375_eta+05_128-96-96_10-20"
#     )

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

# FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241216_cuda_sane_a05000_288-192-128_6-12_rout1000_min020_gamma13"

for FILE_PATH in "${FILE_LIST[@]}"; do
    pyharm-analysis basic,dynamo,efluxes,omega_bz,outfluxes,r_flux_profiles,r_profiles,rth_profiles,th_profiles "$FILE_PATH" -e 7000 --nthreads=72
    sleep 1
done