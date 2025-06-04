#!/bin/bash

# spack env activate pyharm
# conda activate /home/zzl/opt/conda_env/pyharm

# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240905_host_sane_a09375_128-64-64_imex_continue-40"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240826_cuda_mad_a09375_192-96-96_PATOKA"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240828_cuda_mad_a09375_384-192-192_continue0824-00019"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240829_cuda_mad_a09375_384-192-192"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240904_host_sane_a09375_192-128-128_imex"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240906_host_sane_a09375_128-64-64_imex_continue-40"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240913_hip_mad_a09375_256-128-128"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240916_host_sane_a09375_288-128-128_patoka"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240916_hip_sane_a09375_288-128-128_continue_1"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240917_hip_sane_a09375_144-64-64_normal_compare"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240918_hip_sane_a09375_144-64-64_fluid_hlle"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240918_hip_sane_a09375_144-64-64_iharm3d_patoka"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240920_hip_mad_a09375_144-64-64_iharm3d"

# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho3"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho10"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho3_geom"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho3_normal"

# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_sane_a09375_144-64-64_urho3"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_sane_a09375_144-64-64_urho10"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_sane_a09375_144-64-64_urho3_geom"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho3_normal"

# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_09375_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_00000_192-96-96"
FILE_PATH="/home/zhangzelin/projects/kharma/output/20241029_hip_mad_09375_192-96-96"

SIZE=50
mpiexec -n 36 pyharm-movie log_rho "$FILE_PATH" --vmin=-9 --vmax=0.5 --sz=$SIZE #--overlay_field --nlines=15

# 设置帧率
FPS=30

# 检查 frames_log_rho 文件夹是否存在
if [ -d "$FILE_PATH/frames_log_rho" ]; then
    echo "Encoding frames_log_rho"
    ffmpeg -hide_banner -loglevel error -y -r ${FPS} -f image2 -pattern_type glob -i "$FILE_PATH/frames_log_rho/*.png" -vcodec libx264 -crf 22 -pix_fmt yuv420p "$FILE_PATH/frames_log_rho.mp4"
else
    echo "frames_log_rho directory not found!"
fi