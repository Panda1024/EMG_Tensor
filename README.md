# Force Prediction by EMG Signals and Arm Posture: Tensor Decomposition Based Approach

This modules are to predict grasping force from EMG signals by using tensor decomposition based algorithm.

This mouldes are based on MATLAB R2018a and Tensor Toolbox.

This modules are work-in-progress.

We cannot upload our dataset of EMG and force data, because of the IRB at SNU. 

Author: Sanghyun Kim (ggory15@snu.ac.kr) 

``` EMG Acquisition ```

	1. This is source code in Visual Studio 2015 in order to obtain the real-time force data and EMG data.
    2. We use the force sensor as ATI-mini45 and the emg sensors (Delsys wireless sensons).
    3. In order to get analog signal of the force senor, we use NI-DAQ board.
    4. Requirement: NIDAQ-MX, Delsys EMGworks 

``` EMG Preprosessing ```

	1. This is module in Matlab for filtering EMG and force data which are obtained by EMG Acquisition module.
	2. EMG data is refined by using MAV filter, zero-phase low pass filter, and DTW algorithm (for align time-series)
    3. Force data is filtered by using low pass filter.
	
    	
