#!/bin/bash

# spack env activate pyharm
# conda activate /home/zzl/opt/conda_env/pyharm

# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240826_cuda_mad_a09375_192-96-96_PATOKA"
# FILE_PATH="/home/zzl/kx-4t/kharma/output/20240826_cuda_mad_a09375_192-96-96_PATOKA"
FILE_PATH="/home/zzl/kx-4t/kharma/output/20240829_cuda_mad_a09375_384-192-192"

# Run pyharm-analysis
pyharm-analysis basic,dynamo "$FILE_PATH" --nthreads=6

sleep 10

# Define plot types 
plot_types="simplest,simpler,simple,traditional,floors,fails,energies,prims,vecs_prim,vecs_con,ejection,e_ratio"
# 
# Iterate over each plot type
IFS=',' read -ra TYPES <<< "$plot_types"  # Split plot_types into an array

for plot_type in "${TYPES[@]}"; do
# Run pyharm-movie for each plot type
    mpiexec -n 6 pyharm-movie "$plot_type" "$FILE_PATH" -sz 800 -r
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
