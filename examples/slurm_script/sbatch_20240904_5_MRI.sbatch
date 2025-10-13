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

FILE_PATH="/home/zhangzelin/projects/kharma/output/20241109_hip4_sane_a5000_288-128-128"

pyharm-analysis basic,dynamo,factorQ,factorQ_mass_weighted  "$FILE_PATH" --nthreads=36 -f factorQ.h5

# sleep 10

# # Define plot types 
# plot_types="factorQ_r,factorQ_th,factorQ_phi"

# # Iterate over each plot type
# IFS=',' read -ra TYPES <<< "$plot_types"  # Split plot_types into an array

# for plot_type in "${TYPES[@]}"; do
# # Run pyharm-movie for each plot type
#     if [ "$plot_type" == "factorQ_phi" ]; then
#         mpiexec -n 6 pyharm-movie "$plot_type" "$FILE_PATH" -sz 50 --vmin 0.0 --vmax 20.0
#     else
#         mpiexec -n 6 pyharm-movie "$plot_type" "$FILE_PATH" -sz 50 --vmin 0.0 --vmax 10.0
#     fi
# # done

#     sleep 2

# # Set frame rate for video encoding
#     FPS=30

# # for plot_type in "${TYPES[@]}"; do
#     frame_dir="$FILE_PATH/frames_$plot_type"  # Define the frames directory

#     if [ -d "$frame_dir" ]; then
#         echo "Encoding $frame_dir"
#         # Encode frames to video
#         ffmpeg -hide_banner -loglevel error -y -r ${FPS} -f image2 -pattern_type glob -i "$frame_dir/*.png" -vcodec libx264 -crf 22 -pix_fmt yuv420p "$frame_dir.mp4"
#     else
#         echo "$frame_dir directory not found!"
#     fi
# done