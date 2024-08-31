#!/bin/bash

# spack env activate pyharm
# conda activate /home/zzl/opt/conda_env/pyharm

FILE_PATH="/home/zzl/kx-4t/kharma/output/20240824_cuda_mad_a09375_128-64-64/continue_2"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240826_cuda_mad_a09375_192-96-96_PATOKA"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240828_cuda_mad_a09375_384-192-192_continue0824-00019"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240829_cuda_mad_a09375_384-192-192"
mpiexec -n 6 pyharm-movie log_rho "$FILE_PATH" --vmin=-9 --vmax=0. --overlay_field -r

# 设置帧率
FPS=30

# 检查 frames_log_rho 文件夹是否存在
if [ -d "$FILE_PATH/frames_log_rho" ]; then
    echo "Encoding frames_log_rho"
    ffmpeg -hide_banner -loglevel error -y -r ${FPS} -f image2 -pattern_type glob -i "$FILE_PATH/frames_log_rho/*.png" -vcodec libx264 -crf 22 -pix_fmt yuv420p "$FILE_PATH/frames_log_rho.mp4"
else
    echo "frames_log_rho directory not found!"
fi