#!/bin/bash

# spack env activate pyharm
# conda activate /home/zzl/opt/conda_env/pyharm

# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240826_cuda_mad_a09375_192-96-96_PATOKA"
FILE_PATH="/home/zzl/kx-4t/kharma/output/20240829_cuda_mad_a09375_384-192-192"
mpiexec -n 6 pyharm-movie log_beta "$FILE_PATH" --vmin=-2.5 --vmax=2.5 -r

# 设置帧率
FPS=30

# 检查 frames_log_beta 文件夹是否存在
if [ -d "$FILE_PATH/frames_log_beta" ]; then
    echo "Encoding frames_log_beta"
    ffmpeg -hide_banner -loglevel error -y -r ${FPS} -f image2 -pattern_type glob -i "$FILE_PATH/frames_log_beta/*.png" -vcodec libx264 -crf 22 -pix_fmt yuv420p "$FILE_PATH/frames_log_beta.mp4"
else
    echo "frames_log_beta directory not found!"
fi