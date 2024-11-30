#!/bin/bash

# spack env activate pyharm
# conda activate /home/zzl/opt/conda_env/pyharm

FILE_PATH="/home/zzl/kx-4t/kharma/output/20241117_cuda_sane_a09375_192-192-192_6-12_gamma13"



# Run pyharm-analysis
pyharm-analysis basic,dynamo,factorQ "$FILE_PATH" --nthreads=6
# pyharm-analysis basic,dynamo,efluxes,omega_bz,outfluxes,r_flux_profiles,r_profiles,rth_profiles,th_profiles "$FILE_PATH" --nthreads=6

sleep 10

# Define plot types 
plot_types="factorQ_r,factorQ_th,factorQ_phi"

# Iterate over each plot type
IFS=',' read -ra TYPES <<< "$plot_types"  # Split plot_types into an array

for plot_type in "${TYPES[@]}"; do
# Run pyharm-movie for each plot type
    if [ "$plot_type" == "factorQ_phi" ]; then
        mpiexec -n 6 pyharm-movie "$plot_type" "$FILE_PATH" -sz 50 --vmin 0.0 --vmax 20.0
    else
        mpiexec -n 6 pyharm-movie "$plot_type" "$FILE_PATH" -sz 50 --vmin 0.0 --vmax 10.0
    fi
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
