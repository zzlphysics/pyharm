#!/bin/bash

# spack env activate pyharm
# conda activate /home/zzl/opt/conda_env/pyharm

# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240826_cuda_mad_a09375_192-96-96_PATOKA"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240826_cuda_mad_a09375_192-96-96_PATOKA"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240829_cuda_mad_a09375_384-192-192"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240904_host_sane_a09375_128-64-64_imex_continue-40"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240904_host_sane_a09375_192-128-128_imex"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240916_hip_sane_a09375_288-128-128_continue_1"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240916_host_sane_a09375_288-128-128_patoka"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240917_hip_sane_a09375_144-64-64_up-floors"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240917_hip_sane_a09375_144-64-64_normal_compare"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240918_hip_sane_a09375_144-64-64_iharm3d_patoka"

# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho3"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho10"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho3_geom"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_mad_a09375_144-64-64_urho3_normal"

# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_sane_a09375_144-64-64_urho3"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_sane_a09375_144-64-64_urho10"
# FILE_PATH="/home/zhangzelin/projects/kharma/cluster/20240928_hip_sane_a09375_144-64-64_urho3_geom"

# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241009_hip_sane_a09375_288-128-128"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241009_cpu_sane_a09375_288-128-128"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241009_hip_sane_a09375_288-128-128_cfl"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241009_hip_sane_a09375_288-128-128_trans"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241009_hip_sane_a09375_288-128-128_two-sync"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241013_hip_mad_a09375_288-128-128"

# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_00000_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_05000_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_09375_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_09375_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241029_hip_mad_09375_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_-05000_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_-09375_192-96-96"

FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a05000_eta+00_128-96-96_10-20"
FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a05000_eta+05_128-96-96_10-20"
FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a09375_eta+00_128-96-96_10-20"
FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a09375_eta+05_128-96-96_10-20"



# Run pyharm-analysis
# pyharm-analysis basic,dynamo "$FILE_PATH" --nthreads=36

# sleep 10

# Define plot types 
plot_types="simple,traditional,floors,fails,energies,prims,vecs_prim,vecs_con,ejection,e_ratio"
# plot_types="simplest,simpler,"
# 
# Iterate over each plot type
IFS=',' read -ra TYPES <<< "$plot_types"  # Split plot_types into an array

for plot_type in "${TYPES[@]}"; do
# Run pyharm-movie for each plot type
    mpiexec -n 36 pyharm-movie "$plot_type" "$FILE_PATH" -sz 50
# done

    sleep 2

# Set frame rate for video encoding
    FPS=30

# for plot_type in "${TYPES[@]}"; do
    frame_dir="$FILE_PATH/frames_$plot_type"  # Define the frames directory

    if [ -d "$frame_dir" ]; then
        echo "Encoding $frame_dir"
        # Encode frames to video
        ffmpeg -hide_banner -loglevel error -y -r ${FPS} -f image2 -pattern_type glob -i "$frame_dir/*.png" -vcodec libx264 -crf 22 -pix_fmt yuv420p "$frame_dir.mp4"
    else
        echo "$frame_dir directory not found!"
    fi
done
