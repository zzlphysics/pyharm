#!/bin/bash

FILE_PATH="/home/zhangzelin/kx-4t/kharma/output/20250621_cuda_kerr_mad_a09375_384-192-192"
FRAME_SIZE=50
FPS=30

plot_types_with_vmin_vmax="simple,log_rho,traditional,log_sigma,log_beta,log_b,Gamma,vr,factorQ_r,factorQ_th,factorQ_phi"
# Iterate over each plot type
IFS=',' read -ra TYPES <<< "$plot_types_with_vmin_vmax"  # Split plot_types into an array

for plot_type in "${TYPES[@]}"; do
echo "Attempting to remove frames directories in: $FILE_PATH"
    if [ -d "$FILE_PATH" ]; then
        find "$FILE_PATH" -name "frames_${plot_type}" -exec rm -rf {} +
    else
        echo "Warning: Directory $FILE_PATH does not exist"
    fi
done

pyharm-movie simple "$FILE_PATH" -sz $FRAME_SIZE --vmin 1e-5 --vmax 2
pyharm-movie log_rho "$FILE_PATH" -sz $FRAME_SIZE --vmin 1e-5 --vmax 2
pyharm-movie traditional "$FILE_PATH" -sz $FRAME_SIZE --vmin 1e-5 --vmax 2
pyharm-movie log_sigma "$FILE_PATH" -sz $FRAME_SIZE --vmin 1e-3 --vmax 1e3
pyharm-movie log_beta "$FILE_PATH" -sz $FRAME_SIZE --vmin 1e-3 --vmax 1e3
pyharm-movie log_b "$FILE_PATH" -sz $FRAME_SIZE --vmin 1e-3 --vmax 1
pyharm-movie Gamma "$FILE_PATH" -sz $FRAME_SIZE --vmin 1 --vmax 2
pyharm-movie vr "$FILE_PATH" -sz $FRAME_SIZE --vmin -0.5 --vmax 1
pyharm-movie factorQ_r "$FILE_PATH" -sz $FRAME_SIZE --vmin 0 --vmax 20
pyharm-movie factorQ_th "$FILE_PATH" -sz $FRAME_SIZE --vmin 0 --vmax 20
pyharm-movie factorQ_phi "$FILE_PATH" -sz $FRAME_SIZE --vmin 0 --vmax 20

for plot_type in "${TYPES[@]}"; do
    frame_dir="$FILE_PATH/frames_$plot_type"  # Define the frames directory

    if [ -d "$frame_dir" ]; then
        echo "Encoding $frame_dir"
        ffmpeg -hide_banner -loglevel error -y -r ${FPS} -f image2 -pattern_type glob -i "$frame_dir/*.png" -vcodec libx264 -crf 22 -pix_fmt yuv420p "$frame_dir.mp4"
    else
        echo "$frame_dir directory not found!"
    fi
done

plot_types="floors,fails,energies,vecs_prim,vecs_con,ejection,e_ratio"
IFS=',' read -ra TYPES_VIDEO <<< "$plot_types"  # Split plot_types into an array

for plot_type in "${TYPES_VIDEO[@]}"; do
echo "Attempting to remove frames directories in: $FILE_PATH"
    if [ -d "$FILE_PATH" ]; then
        find "$FILE_PATH" -name "frames_${plot_type}" -exec rm -rf {} +
    else
        echo "Warning: Directory $FILE_PATH does not exist"
    fi
done

for plot_type in "${TYPES_VIDEO[@]}"; do
    pyharm-movie "$plot_type" "$FILE_PATH" -sz $FRAME_SIZE
    sleep 1

    frame_dir="$FILE_PATH/frames_$plot_type"  # Define the frames directory

    if [ -d "$frame_dir" ]; then
        echo "Encoding $frame_dir"
        ffmpeg -hide_banner -loglevel error -y -r ${FPS} -f image2 -pattern_type glob -i "$frame_dir/*.png" -vcodec libx264 -crf 22 -pix_fmt yuv420p "$frame_dir.mp4"
    else
        echo "$frame_dir directory not found!"
    fi
done
