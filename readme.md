Pytorch implementation of **Rotated Binary Neural Network**  
torch.\_\_version\_\_=1.1.0 


## Tips

Any problem, please contact the authors via emails: lmbxmu@stu.xmu.edu.cn or ianhsu@stu.xmu.edu.cn or adding the first author's wechat as friends (id: linmb007 if you are using wechat) for convenient communications. Do not post issues with github as much as possible, just in case that I could not receive the emails from github thus ignore the posted issues.


## Training on CIFAR-10
```bash
python -u main.py \
--gpus 0 \
--model resnet20_1w1a \
--results_dir ./result \
--data_path ./data \
--dataset cifar10 \
--epochs 1000 \
--lr 0.1 \
-b 256 \
-bt 128 \
--Tmin 1e-2 \
--Tmax 1e1 \
--lr_type cos \
--warm_up \
```
`--results_dir` &emsp;Path to save directory  
`--save` &emsp;Path to save folder    
`--resume` &emsp;Load checkpoint    
`--evaluate / -e`  &emsp;Evaluate  
`--model / -a` &emsp;Choose model   
&emsp;&emsp; default:&emsp;resnet20_1w1a,   
&emsp;&emsp; options:&emsp;resnet18_1w1a;&emsp;vgg_small_1w1a       
`--dataset` &emsp;Choose dataset，default: cifar10，options: cifar100 / tinyimagenet / imagenet  
`--data_path` &emsp;Path to dataset    
`--gpus` &emsp;Specify gpus, e.g. 0,1  
`--lr` &emsp;Learning rate，default: 0.1  
`--weight_decay` &emsp;Weight decay, default: 1e-4  
`--momentum` &emsp;Momentum, default: 0.9  
`--workers` &emsp;Data loading workers，default: 8  
`--epochs` &emsp;Number of training epochs，default:1000  
`--batch_size / -b` &emsp;Batch size，default: 256   
`--batch_size_test / -bt` &emsp;Evaluating batch size, default: 128  
`--print_freq` &emsp;Print frequency，default: 100  
`--time_estimate` &emsp;Estimate finish time of the program，set to 0 to disable，default: 1     
`--rotation_update` &emsp;Update rotaion matrix every n epoch，default: 1   
`--Tmin` &emsp;The minimum of param T in gradient approximation function，default: 1e-2  
`--Tmax` &emsp;The maximum of param T in gradient approximation function，default: 1e1  
`--lr_type` &emsp;Type of learning rate scheduler，default: cos (which means CosineAnnealingLR)，options: step (which means MultiStepLR)  
`--lr_decay_step` &emsp;If choose MultiStepLR, set milestones，eg: 30 60 90    
`--a32` &emsp;Don't binarize activation, namely w1a32    
`--warm_up` &emsp;Use warm up  

#### Results on CIFAR-10. To ensure the reproducibility, please refer to our training details provided in the model link.
args | resnet20_1w1a | resnet18_1w1a | vgg_small_1w1a
-|:-:|:-:|:-:
lr | 0.1 | 0.1 | 0.1
weight_decay | 1e-4 | 1e-4 | 1e-4 
momentum | 0.9 | 0.9 | 0.9
epochs | 1000 | 1000 | 1000
batch_size | 256 | 256 | 256
batch_size_test | 128 | 128 | 128
Tmin | 1e-2 | 1e-2 | 1e-2 
Tmax | 1e1 | 1e1 | 1e1
lr_type | cos | cos | cos
rotation_update | 1 | 1 | 1
warm_up | True | True | True

To ensure the reproducibility, please refer to our training details provided in the links for our quantized models. \
If it takes too much time to finish a total of 1,000 epochs on your platform, you can consider 400 epochs instead. It can feed back impressive performance as well, better than the compared methods in the paper.

To verify our quantized model performance on CIFAR-10, please use the following command:
```
python ......
```


## Training on ImageNet
```bash
python -u main.py \
--gpus 0,1,2,3 \
--model resnet18_1w1a \
--results_dir ./result \
--data_path ./data \
--dataset imagenet \
--epochs 150 \
--lr 0.1 \
-b 512 \
-bt 256 \
--Tmin 1e-2 \
--Tmax 1e1 \
--lr_type cos \
--use_dali \
```   
Other arguments are the same as those on CIFAR-10 
`--model / -a` &emsp;Choose model，  
&emsp;&emsp;default: resnet18_1w1a.   
&emsp;&emsp;options: resnet34_1w1a     

We provide two types of dataloaders by [nvidia-dali](https://docs.nvidia.com/deeplearning/dali/user-guide/docs/index.html) and [Pytorch](https://pytorch.org/docs/stable/data.html) respectively. They use the same data augmentations, including random crop and horizontal flip. We empirically find that the dataloader by Pytorch can offer a better accuracy performance. They may have different code implementations. Anyway, we haven't figured it out yet. However, nvidia-dali shows its extreme efficiency in processing data which well accelerates the network training. The reported experimental results are on the basis of nvidia-dali due to the very limited time in preparation of NeurIPS submission. If interested, you can try dataloader by Pytorch via removing the optional augment ```-- use_dali``` to obtain a better performance.
 
 \
nvidia-dali package
```
#for cuda9.0
pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/cuda/9.0 nvidia-dali
#for cuda10.0
pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/cuda/10.0 nvidia-dali
```


#### Results on ImageNet.

| batch_size | batch_size_test | epochs| use_dali| Top-1| Top-5 |quantized model Link | Paper data|
|:----------:|:---------------:|:-----:|:-------:|:----:|:-----:|:-------------------:|:---------:|
|   256      |  256            |  120  | Yes     |58.757|80.935 |resnet18_1w1a        |  No | 
|   512      |  256            |  120  | Yes     |59.550|81.581 |resnet18_1w1a        |  Yes| 
|   512      |  256            |  150  | Yes     |59.941|81.892 |resnet18_1w1a        |  No | 
|   512      |  256            |  150  | Yes     |63.141|84.379 |resnet34_1w1a        |  Yes|

To ensure the reproducibility, please refer to our training details provided in the links for our quantized models. \
Small tips for further increasing the performance of our method: (1) removing the optional augment ```-- use_dali``` as discussed above; (2) increasing the training epochs (200 in most existing works for binary neural network); (3) enlarging the batch size for training (2048 for example if you have a powerful platform, as done in some existing works). 

To verify our quantized model performance on ImageNet, please use the following command:
```
python ......
```
