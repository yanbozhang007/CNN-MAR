# CNN-MAR
## Convolutional neural network based metal artifact reduction (CNN-MAR) in x-ray computed tomography

**Version 1.0**
 
Dr. Yanbo Zhang (yanbozhang07@gmail.com) 

Dr. Hengyong Yu (hengyong_yu@uml.edu) 

University of Massachusetts Lowell

2018.03.24
 
### Description:
 
This code was written in Matlab. It was tested on a PC with a Windows 10 operation system, Matlab R2016a, Microsoft Visual C++ 2012, and a GeForce GTX 970 GPU card. Because the code used the MatConvNet toolbox, please refer to instructions in the MatConvNet homepage (http://www.vlfeat.org/matconvnet/) if you encounter compatible issues in your testing environment. 

You can use this code in either CPU or GPU mode to train your own neural network. We also provided a well trained neural network, a sample of small-size training data and three example data. Therefore, you can directly run Demo_CNNMAR.m to get results of sample data. 

 

### Folder structure:

* Demo_CNNMAR.m : an example code that applies the methods and evaluation
* cnnmar        : CNN-MAR functions
* data          : example training data and metal artifact data 
* dependent     : dependent codes
  * matconvnet: MatConvNet Toolbox, http://www.vlfeat.org/matconvnet/
  * practical-cnn-reg-2016a: an application example of MatConvNet, https://github.com/vedaldi/practical-cnn-reg
* evaluation    : evaluation functions and a competing NMAR method
* model         : save well trained neural network
  * MAR_net : (empty) neural networks at each training epoch will   be saved in this folder   


### Citation:

Please consider citing following articles if you use this code for the research purpose. Please contact authors if you use it for the commercial purpose.
 
1. Yanbo Zhang, Ying Chu, and Hengyong Yu, "Reduction of metal artifacts in x-ray CT images using a convolutional neural network," Proc. SPIE 10391, Developments in X-Ray Tomography XI, 103910V, San Diego, California, USA, September, 2017.
     
2. Yanbo Zhang and Hengyong Yu, "Convolutional Neural Network Based Metal Artifact Reduction in X-ray Computed Tomography," arXiv preprint arXiv:1709.01581, 2017.
    
3. Yanbo Zhang and Hengyong Yu, "Convolutional Neural Network Based Metal Artifact Reduction in X-ray Computed Tomography," IEEE Transactions on Medical Imaging, 2018. (Accepted)
     
     
