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


# FILE_PATH1="/home/zhangzelin/projects/kharma-data-sync/v3/SANE/a+0.94/288x128x128"
# FILE_PATH2="/home/zhangzelin/projects/kharma-data-sync/v3/SANE/a+0.5/288x128x128"
FILE_PATH1="/home/zhangzelin/projects/kharma-data-sync/v3/MAD/a+0.94/288x128x128"
FILE_PATH2="/home/zhangzelin/projects/kharma-data-sync/v3/MAD/a+0.5/288x128x128"
FILE_LIST=($FILE_PATH1 $FILE_PATH2)

# FILE_LIST=($FILE_PATH0 $FILE_PATH1 $FILE_PATH2 $FILE_PATH3 $FILE_PATH4 $FILE_PATH5 $FILE_PATH6)

for FILE_PATH in "${FILE_LIST[@]}"; do

    

    # Run pyharm-analysis
    pyharm-analysis basic,dynamo "$FILE_PATH" --nthreads=36

    sleep 10

    # Define plot types 
    plot_types="simplest,simple"
    # plot_types="simplest,simple,traditional,floors,e_ratio"
    # plot_types="simplest,simpler,"
    # 
    # Iterate over each plot type
    IFS=',' read -ra TYPES <<< "$plot_types"  # Split plot_types into an array

    for plot_type in "${TYPES[@]}"; do
    echo "Attempting to remove frames directories in: $FILE_PATH"
    
    # 使用更安全的删除命令
        if [ -d "$FILE_PATH" ]; then
            find "$FILE_PATH" -name "frames_${plot_type}" -exec rm -rf {} +
        else
            echo "Warning: Directory $FILE_PATH does not exist"
        fi
    # Run pyharm-movie for each plot type
        mpiexec -n 36 pyharm-movie "$plot_type" "$FILE_PATH" -sz 20 --vmin=-2 --vmax=0 --fig_x=8 --fig_y=4.5 --fig_dpi=300
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
done
