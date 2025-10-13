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


# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241121_hip_sane_a05000_1024-512-1_10-18_min020"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20250223_hip_kz_sane_a09375_eta-01_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20250224_hip_kz_sane_a09375_eta-01_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241216_hip_sane_a09375_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
# FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_sane_a09375_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/v3/SANE/a+0.94/288x128x128"
FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/v3/MAD/a+0.94/288x128x128"

SIZE=20
mpiexec -n 36 pyharm-movie log_sigma "$FILE_PATH" --vmin=-4 --vmax=2 --sz=$SIZE --fig_x=9 --fig_y=4.5 --fig_dpi=300
# --overlay_field --nlines=15

# 设置帧率
FPS=30

# 检查 frames_log_sigma 文件夹是否存在
if [ -d "$FILE_PATH/frames_log_sigma" ]; then
    echo "Encoding frames_log_sigma"
    ffmpeg -hide_banner -loglevel error -y -r ${FPS} -f image2 -pattern_type glob -i "$FILE_PATH/frames_log_sigma/*.png" -vcodec libx264 -crf 22 -pix_fmt yuv420p "$FILE_PATH/frames_log_sigma.mp4"
else
    echo "frames_log_sigma directory not found!"
fi