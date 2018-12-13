#!/bin/bash

#-- select PARTITION --#
if [ "SH-IDC1-10-5-30-231" == $HOSTNAME ];then
  DEFAULT_PARTITION=Segmentation
elif [ "SH-IDC1-10-5-34-21" == $HOSTNAME ];then
  DEFAULT_PARTITION=Segmentation1080
elif [ "BJ-IDC1-10-10-11-22" == $HOSTNAME ];then
  DEFAULT_PARTITION=bj11part
elif [ "BJ-IDC1-10-10-15-115" == $HOSTNAME ];then
  DEFAULT_PARTITION=Segmentation
fi

if [ $# -eq 2 ]; then
  PARTITION=$DEFAULT_PARTITION
else
  PARTITION=$3
fi

echo "PARTITION is $PARTITION"

#-- set number of GPU and node_per_GPU --#
N_GPU=$1
N_GPU_per_NODE=$2
JOB_NAME=wheat_unet_ljp

srun -p $PARTITION \
 -n${N_GPU} --gres=gpu:${N_GPU_per_NODE} --ntasks-per-node=${N_GPU_per_NODE} \
    --job-name=${JOB_NAME} --kill-on-bad-exit=1 \
python evalpyt.py --gpu0 0 --testIMpath /mnt/lustre/lijupan/dataset/msra-fixed/valid/image --snapPrefix VOC12_scenes_ --testGTpath /mnt/lustre/lijupan/dataset/msra-fixed/valid/label --NoLabels 2 --predictPath ./result/msra/ 

