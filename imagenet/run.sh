python -u main.py \
--gpus 0,1,2 \
--model resnet18_1w1a \
--results_dir DIR \
--data_path /home/sda1/data/ImageNet2012 \
--dataset imagenet \
--epochs 120 \
--lr 0.1 \
-b 64 \
-bt 128 \
--rotation_update 1 \
--Tmin 1e-2 \
--Tmax 1e1 \
--lr_type cos \
--warm_up \
--mixup \
--ba