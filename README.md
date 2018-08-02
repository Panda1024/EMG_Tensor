# Force Prediction by EMG Signals and Arm Posture: Tensor Decomposition Based Approach

This modules are to predict grasping force from EMG signals by using tensor decomposition based algorithm. 

The article of the detail algorithm is submited at Journal of Bionic Engineering, as a title-Grasping Force Estimation by sEMG Signals and Arm Posture: Tensor Decomposition Based Approach.

This mouldes are based on MATLAB R2018a and Tensor Toolbox.

This modules are not completed because our paper is still reviewing.

We cannot upload our dataset of EMG and force data, because of the IRB at SNU. 

Author: Sanghyun Kim (ggory15@snu.ac.kr) 

``` EMG Acquisition ```

    1. This is source code in Visual Studio 2015 in order to obtain the real-time force data and EMG data.
    2. We use the force sensor as ATI-mini45 and the emg sensors (Delsys wireless sensons).
    3. In order to get analog signal of the force senor, we use NI-DAQ board.
    4. Requirement: NIDAQ-MX, Delsys EMGworks 

``` EMG Preprosessing ```
    1. This is module in Matlab for filtering EMG and force data which are obtained by EMG Acquisition module.
    2. EMG data to train multi-factor model is refined by using MAV filter, zero-phase low pass filter, and DTW algorithm (for align time-series)
    3. Force data is filtered by using low pass filter.
	
``` EMG Main Code ```
	1. This is to train multi-factor model using Tensor Toolbox.
        2. This also contains other comparison algorithm based on multi variable regression to validate the performance of our algorithm. 
