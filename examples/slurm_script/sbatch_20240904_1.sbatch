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

# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241009_hip_sane_a09375_288-128-128_trans"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_-05000_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_-09375_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_00000_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_05000_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241018_hip_mad_09375_192-96-96"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241029_hip_mad_09375_192-96-96"

# FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a05000_eta+00_128-96-96_10-20"
# FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a05000_eta+05_128-96-96_10-20"
# FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a05000_eta+00_128-96-96_10-20_mix"
# FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a09375_eta+00_128-96-96_10-20"
# FILE_PATH="/home/zhangzelin/projects/kharma-data-sync/20241104_cuda_kz_sane_a09375_eta+05_128-96-96_10-20"

# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241105_hip_kz_sane_05000_eta-05_512-384-1"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241105_hip_kz_sane_05000_eta+00_512-384-1"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241105_hip_kz_sane_05000_eta+05_512-384-1"
# FILE_PATH="/home/zhangzelin/projects/kharma/output/20241105_hip_kz_sane_09375_eta+05_512-384-1"

# FILE_PATH0="/home/zhangzelin/projects/kharma/output/20241109_hip4_sane_a5000_288-128-128"
# FILE_LIST=($FILE_PATH0)

# FILE_PATH1="/home/zhangzelin/projects/kharma/output/20241121_hip_sane_a05000_1024-512-1_10-18_min020"
# FILE_PATH2="/home/zhangzelin/projects/kharma/output/20241121_hip_sane_a05000_1024-512-1_10-18_min025"
# FILE_PATH3="/home/zhangzelin/projects/kharma/output/20241121_hip_sane_a09375_1024-512-1_10-18_min020"
# FILE_PATH4="/home/zhangzelin/projects/kharma/output/20241121_hip_sane_a09375_1024-512-1_10-18_min025"
# FILE_PATH5="/home/zhangzelin/projects/kharma/output/20241121_hip_sane_a09375_1024-512-1_10-18_min020_ujitter1"
# FILE_PATH6="/home/zhangzelin/projects/kharma/output/20241121_hip_sane_a09375_1024-512-1_10-18_min020_ujitter8"

# FILE_PATH1="/home/zhangzelin/projects/kharma/output/20241125_hip_sane_a05000_1024-512-1_6-12_rout2500_min020_gamma13"
# FILE_PATH2="/home/zhangzelin/projects/kharma/output/20241125_hip_sane_a05000_1024-512-1_6-12_rout2500_min020_gamma16"
# FILE_PATH3="/home/zhangzelin/projects/kharma/output/20241125_hip_sane_a09375_1024-512-1_6-12_rout2500_min010_gamma16"
# FILE_PATH4="/home/zhangzelin/projects/kharma/output/20241125_hip_sane_a09375_1024-512-1_6-12_rout2500_min020_gamma13"
# FILE_PATH5="/home/zhangzelin/projects/kharma/output/20241125_hip_sane_a09375_1024-512-1_6-12_rout2500_min020_gamma16"
# FILE_PATH6="/home/zhangzelin/projects/kharma/output/20241125_hip_sane_a09375_1024-512-1_6-12_rout2500_min030_gamma16"

# FILE_PATH1="/home/zhangzelin/projects/kharma/output/20241202_hip_sane_a5000_512-512-1_smr-2_6-12_rout1000_min020_gamma13"
# FILE_PATH2="/home/zhangzelin/projects/kharma/output/20241202_hip_sane_a09375_512-512-1_smr-2_6-12_rout1000_min020_gamma13"
# FILE_PATH3="/home/zhangzelin/projects/kharma/output/20241203_hip_kz_sane_a05000_eta-05_512-512-1_smr-2_6-12_rout1000_min020_gamma13"
# FILE_PATH4="/home/zhangzelin/projects/kharma/output/20241203_hip_kz_sane_a05000_eta+08_512-512-1_smr-2_6-12_rout1000_min020_gamma13"
# FILE_PATH5="/home/zhangzelin/projects/kharma/output/20241203_hip_kz_sane_a09375_eta-01_512-512-1_smr-2_6-12_rout1000_min020_gamma13"
# FILE_PATH6="/home/zhangzelin/projects/kharma/output/20241203_hip_kz_sane_a09375_eta+08_512-512-1_smr-2_6-12_rout1000_min020_gamma13"

# FILE_PATH1="/home/zhangzelin/projects/kharma-data-sync/20241216_cuda_sane_a05000_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH2="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_sane_a09375_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH3="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_kz_sane_a05000_eta-05_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH4="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_kz_sane_a05000_eta+05_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH5="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_kz_sane_a09375_eta-01_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_PATH6="/home/zhangzelin/projects/kharma-data-sync/20241217_cuda_kz_sane_a09375_eta+05_288-192-128_6-12_rout1000_min020_gamma13"
# FILE_LIST=($FILE_PATH1 $FILE_PATH2 $FILE_PATH3 $FILE_PATH4 $FILE_PATH5 $FILE_PATH6)
# FILE_LIST=($FILE_PATH2 $FILE_PATH5 $FILE_PATH6)
# FILE_LIST=($FILE_PATH3)

FILE_PATH1="/home/zhangzelin/projects/kharma/output/20241216_hip_kz_sane_a05000_eta-05_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH2="/home/zhangzelin/projects/kharma/output/20241216_hip_kz_sane_a05000_eta+05_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH3="/home/zhangzelin/projects/kharma/output/20241216_hip_kz_sane_a09375_eta-01_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH4="/home/zhangzelin/projects/kharma/output/20241216_hip_kz_sane_a09375_eta+05_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH5="/home/zhangzelin/projects/kharma/output/20241216_hip_sane_a05000_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_PATH6="/home/zhangzelin/projects/kharma/output/20241216_hip_sane_a09375_576-512-1_smr-2_6-12_rout1000_min020_gamma13"
FILE_LIST=($FILE_PATH1 $FILE_PATH2 $FILE_PATH3 $FILE_PATH4 $FILE_PATH5 $FILE_PATH6)

# FILE_PATH1="/home/zhangzelin/projects/kharma-data-sync/v3/SANE/a+0.94/288x128x128"
# FILE_PATH2="/home/zhangzelin/projects/kharma-data-sync/v3/SANE/a+0.5/288x128x128"
# FILE_LIST=($FILE_PATH1 $FILE_PATH2)

# FILE_LIST=($FILE_PATH0 $FILE_PATH1 $FILE_PATH2 $FILE_PATH3 $FILE_PATH4 $FILE_PATH5 $FILE_PATH6)

for FILE_PATH in "${FILE_LIST[@]}"; do

    

    # Run pyharm-analysis
    pyharm-analysis basic,dynamo "$FILE_PATH" --nthreads=36

    sleep 10

    # Define plot types 
    plot_types="simple,traditional,floors,fails,energies,ejection,e_ratio"
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
done
