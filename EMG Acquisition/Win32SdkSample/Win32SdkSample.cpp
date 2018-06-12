
/* Trigno SDK Example.  Copyright (C) 2011-2012 Delsys, Inc.
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to 
* deal in the Software without restriction, including without limitation the 
* rights to use, copy, modify, merge, publish, and distribute the Software, 
* and to permit persons to whom the Software is furnished to do so, subject to 
* the following conditions:
* 
* The above copyright notice and this permission notice shall be included in 
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
* IN THE SOFTWARE.
*/
#pragma Comment (lib, "Winmm.lib")
#include "stdafx.h"
#include <NIDAQmx.h>
#include <thread>
#include <mutex>
#include <chrono>
#include <mmSystem.h>  
SOCKET commSock;	//command socket
SOCKET emgSock;		//EMG socket
SOCKET accSock;		//ACC socket
SOCKET imemgSock;   //IM EMG socket
SOCKET auxSock;  //IM AUX socket
#define DAQmxErrChk(functionCall) if( DAQmxFailed(error=(functionCall)) ) goto Error; else

bool quitFlag = false;

//Prompt for an input line using a default value
void QueryResponse(char * prompt, char * default, char * response)
{
	printf("%s [%s]: ", prompt, default);
	gets_s(response, sizeof(response));
	if(strlen(response)==0)	//use default value if empty line
		strcpy(response, default);
}

//Send a command to the server and wait for the response
void SendCommandWithResponse(char * command, char * response)
{
	int n;
	char tmp[128];

	strcpy(tmp, command);
	tmp[strlen(command)-2]=0;	//trip last CR/LF
	printf("Command: %s", tmp);	//display to user

	if (send(commSock, command, strlen(command), 0) == SOCKET_ERROR) 
	{
		printf("Can't send command.\n");
		_exit(1);	//bail out on error
	}

	//wait for response
	//note - this implementation assumes that the entire response is in one TCP packet
	n=recv(commSock, tmp, sizeof(tmp), 0);
	tmp[n-2]=0;	//strip last CR/LF
	printf("Response: %s", tmp);	//display to user
	strcpy(response, tmp);	//return the response line

	return;
}

//The main function. Program starts here.
int _tmain(int argc, _TCHAR* argv[])
{
	char response[32];	//buffer for response
	char tmp[128];	//string buffer for various uses
	char * onoff;	//used to hold the trigger state	
	int collectionTime;	//time to collect data in samples (seocnds * 2000)
	int sensor;	//sensor to save data
	char sensortype; // sensor type
	FILE *emgdata;	//the files to be written with EMG and ACC data from standard snesor & EMG, ACC, GYRO and MAG data from IM sensor

	printf("Delsys Digital SDK Win32 Demo Applicatioln\n");

	//Open output files
	emgdata = fopen("EmgData.csv", "w"); 

	if(emgdata == NULL)
	{
		printf("Can't open data files.\n");
		return 1;	//bail out id we can't open the data files
	}

	//Create headers for CSV files
	fprintf(emgdata, "Sample Number,Value\n");

	WSADATA wsaData;	//Windows socket data
	int iResult;	//result of call

	// Initialize Winsock
	iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
	if (iResult != 0) {
		printf("WSAStartup failed: %d\n", iResult);
		return 1;	//could not open Windows sockets library
	}

	//Get the server URL. This can be a FQDN or IP address
	strcpy(response, "localhost");

	// Declare and initialize variables used for DNS resolution.
	char* ip = response;
	char* port = NULL;
	struct addrinfo aiHints;
	struct addrinfo *aiList = NULL;
	int retVal;

	// Setup the hints address info structure
	// which is passed to the getaddrinfo() function
	memset(&aiHints, 0, sizeof(aiHints));
	aiHints.ai_family = AF_INET;
	aiHints.ai_socktype = SOCK_STREAM;
	aiHints.ai_protocol = IPPROTO_TCP;

	// Call getaddrinfo(). If the call succeeds,
	// the aiList variable will hold a linked list
	// of addrinfo structures containing response
	// information about the host
	if ((retVal = getaddrinfo(ip, port, &aiHints, &aiList)) != 0)
	{
		printf("Invalid URL.\n");
		return 1;	//could not resolve URL
	}

	// Set up the connection to server for communication
	commSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	sockaddr_in sinRemote;
	sinRemote.sin_family = AF_INET;
	sinRemote.sin_addr.s_addr = ((sockaddr_in*)(aiList->ai_addr))->sin_addr.s_addr;
	sinRemote.sin_port = htons(50040);

	//Try to connect
	if (connect(commSock, (sockaddr*)&sinRemote, sizeof(sockaddr_in)) == SOCKET_ERROR)
	{
		printf("Can't connect to Trigno Server!\n");
		return 1;	//server is not responding
	}
	else
	{
		printf("Connected to Trigno Server.\n");
	}

	int n;	//byte count
			//Get response from the server after connecting
	n = recv(commSock, tmp, sizeof(tmp), 0);
	tmp[n - 2] = 0;	//back up over second CR/LF
	printf(tmp);	//display to user


					// Set up the connection to server for EMG data
	emgSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	sinRemote.sin_port = htons(50041);
	if (connect(emgSock, (sockaddr*)&sinRemote, sizeof(sockaddr_in)) == SOCKET_ERROR)
	{
		printf("Error initializing Trigno EMG data connection (can't connect).\n");
		return 1;
	}

	// Set up the connection to server for ACC data
	accSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	sinRemote.sin_port = htons(50042);
	if (connect(accSock, (sockaddr*)&sinRemote, sizeof(sockaddr_in)) == SOCKET_ERROR)
	{
		printf("Error initializing Trigno ACC data connection (can't connect).\n");
		return 1;
	}
	//Set up the connection to server for IM EMG data
	imemgSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	sinRemote.sin_port = htons(50043);
	if (connect(imemgSock, (sockaddr*)&sinRemote, sizeof(sockaddr_in)) == SOCKET_ERROR)
	{
		printf("Error initializing Trigno IM sensor EMG data connection (can't connect).\n");
		return 1;
	}

	//Set up the connection to server for IM ACC, GYRO , MAG data
	auxSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	sinRemote.sin_port = htons(50044);
	if (connect(auxSock, (sockaddr*)&sinRemote, sizeof(sockaddr_in)) == SOCKET_ERROR)
	{
		printf("Error initializing Trigno IM AUX data connection (can't connect).\n");
		return 1;
	}

	printf("1");
	sprintf(tmp, "TRIGGER START %s\r\n\r\n", "OFF");
	SendCommandWithResponse(tmp, tmp);

	sprintf(tmp, "TRIGGER STOP %s\r\n\r\n", "OFF");
	SendCommandWithResponse(tmp, tmp);
	
	sensor = atoi("1");

	//Get the type of the sensor
	sprintf(tmp,"SENSOR %d TYPE?\r\n\r\n",sensor);
	SendCommandWithResponse(tmp,&sensortype);

	collectionTime = 20.0;
	collectionTime *= 2000;	//adjuect to number of samples

	//Send command to start data acquisition
	SendCommandWithResponse("UPSAMPLE OFF\r\n\r\n", tmp);
	SendCommandWithResponse("START\r\n\r\n", tmp);

	printf("Please wait\n ");

	int k;	//byte count
	char emgbuf[4*16];		//buffer for one sample from each sensor
	char accbuf[4*3*16];	//buffer for one sample on each axis for each sensor
	char imemgbuf[4*16];   //buffer for one sample from each IM sensor
	char auxbuf[4*9*16];   //buffer for one sample on 9 axis for each IM sensor
	unsigned long bytesRead;	//bytes available for reading
	float emgSampleArray[6];	//EMG sample
	float accsample[3];	//ACC sample (x, y, z axis)
	float imemgsample;  //IM EMG sample
	float auxsample[9]; // ACC sample (x, y, z axis), GYRO sample (x, y, z axis), MAG sample (x, y, z axis)
	int emgSampleNumber = 1;	//current sample number
	int accSampleNumber = 1;	//current sample number
	int imemgSampleNumber=1;	//current sample number
	int auxSampleNumber=1;		//current sample number
	//Read data from standard sensor

	int         error = 0;
	int cnt2 = 0;
	TaskHandle  taskHandle = 0;
	float64     data[1000];
	char        errBuff[2048] = { '\0' };
	const int nSamples = 10;
	int32       read;
	const double NI_DAQ_SCALE = 1.5;
	DAQmxErrChk(DAQmxCreateTask("FT Sensor", &taskHandle));
	DAQmxErrChk(DAQmxCreateAIVoltageChan(taskHandle, "Dev1/ai0", "", DAQmx_Val_Cfg_Default, -10.0, 10.0, DAQmx_Val_Volts, NULL));
	DAQmxErrChk(DAQmxCreateAIVoltageChan(taskHandle, "Dev1/ai1", "", DAQmx_Val_Cfg_Default, -10.0, 10.0, DAQmx_Val_Volts, NULL));
	DAQmxErrChk(DAQmxCreateAIVoltageChan(taskHandle, "Dev1/ai2", "", DAQmx_Val_Cfg_Default, -10.0, 10.0, DAQmx_Val_Volts, NULL));
	DAQmxErrChk(DAQmxCreateAIVoltageChan(taskHandle, "Dev1/ai3", "", DAQmx_Val_Cfg_Default, -10.0, 10.0, DAQmx_Val_Volts, NULL));
	DAQmxErrChk(DAQmxCreateAIVoltageChan(taskHandle, "Dev1/ai4", "", DAQmx_Val_Cfg_Default, -10.0, 10.0, DAQmx_Val_Volts, NULL));
	DAQmxErrChk(DAQmxCreateAIVoltageChan(taskHandle, "Dev1/ai5", "", DAQmx_Val_Cfg_Default, -10.0, 10.0, DAQmx_Val_Volts, NULL));
	DAQmxSetAITermCfg(taskHandle, "Dev1/ai0", DAQmx_Val_Diff);
	DAQmxSetAITermCfg(taskHandle, "Dev1/ai1", DAQmx_Val_Diff);
	DAQmxSetAITermCfg(taskHandle, "Dev1/ai2", DAQmx_Val_Diff);
	DAQmxSetAITermCfg(taskHandle, "Dev1/ai3", DAQmx_Val_Diff);
	DAQmxSetAITermCfg(taskHandle, "Dev1/ai4", DAQmx_Val_Diff);
	DAQmxSetAITermCfg(taskHandle, "Dev1/ai5", DAQmx_Val_Diff);

	double voltage[6] = { 0 };
	const double CALIB_Fx[6] = { 0.59713, 0.26231, -12.33542, 96.61564, 5.22911, -95.18076 };
	const double CALIB_Fy[6] = { 4.10839, -108.82837, -8.84707, 55.74506, -4.93665, 54.76603 };
	const double CALIB_Fz[6] = { -137.49104, -7.30461, -135.87213, -9.01061, -132.08442, -8.77291 };
	const double CALIB_Tx[6] = { 0.02151, -0.75729, 2.12815, 0.52754, -2.25296, 0.23384 };
	const double CALIB_Ty[6] = { -2.46697, -0.10883, 1.31906, -0.59636, 1.29006, 0.73518 };
	const double CALIB_Tz[6] = { 0.00098, 1.37554, -0.21931, 1.41844, -0.14445, 1.39258 };
	double force_torque[6] = { 0 };

	if(sensortype=='M')
	{
		while(collectionTime>0)	//loop until all samples acquired
	{			
			//See if we have enough data
				ioctlsocket(emgSock, FIONREAD, &bytesRead);	//peek at data available
				int cnt = 0;
				while(bytesRead >= sizeof(emgbuf))
				{
					k=recv(emgSock, emgbuf, sizeof(emgbuf), 0);
					//process data
					for (int i=0; i<6; i++)
						memcpy(&emgSampleArray[i], &emgbuf[4*(i)], sizeof(emgSampleArray[i]));


					if (cnt % 4 == 0) {
						DAQmxErrChk(DAQmxReadAnalogF64(taskHandle, nSamples, 1.0, DAQmx_Val_GroupByChannel, data, 1000, &read, 0));
						for (int i = 0; i < 6; i++)
						{
							voltage[i] = 0.0f;
							force_torque[i] = 0.0f;
						}

						for (int i = 0; i < 6; i++)
						{
							for (int j = 0; j < read; j++)
							{
								voltage[i] += data[i * read + j] / NI_DAQ_SCALE;
							}
							voltage[i] /= read;
						}
						for (int i = 0; i < 6; i++)
						{
							force_torque[0] += CALIB_Fx[i] * voltage[i];
							force_torque[1] += CALIB_Fy[i] * voltage[i];
							force_torque[2] += CALIB_Fz[i] * voltage[i];
							force_torque[3] += CALIB_Tx[i] * voltage[i];
							force_torque[4] += CALIB_Ty[i] * voltage[i];
							force_torque[5] += CALIB_Tz[i] * voltage[i];
						}

						//Write to file
						fprintf(emgdata, "%lf, %e, %e, %e, %e, %e, %e, %e \n", (cnt2+1)/500.0, emgSampleArray[0], emgSampleArray[1], emgSampleArray[2], emgSampleArray[3], emgSampleArray[4], emgSampleArray[5], force_torque[2]);
						cnt2++;
					}

					if (collectionTime % 1000 == 0)
						printf("Time: %.1f, Force: %.3lf, EMG: %.3lf\n", emgSampleNumber / 2000., force_torque[2], emgSampleArray[0] * 1000000);	//indicate progress to user


					--collectionTime; ++emgSampleNumber;
					ioctlsocket(emgSock, FIONREAD, &bytesRead);	//peek at data available

					cnt++;
				}
		
			//Look for stop from server
			ioctlsocket(commSock, FIONREAD, &bytesRead);
			if (bytesRead > 0)
			{
				recv(commSock, tmp, bytesRead, 0);
				tmp[bytesRead] = '\0';
				if (strstr(tmp, "STOPPED\r\n") != NULL)
					collectionTime=0;//we are done
			}

			Sleep(10);	//let other threads run
		}


	}	
Error:
	if (DAQmxFailed(error))
		DAQmxGetExtendedErrorInfo(errBuff, 2048);
	if (taskHandle != 0) {
		/*********************************************/
		// DAQmx Stop Code
		/*********************************************/
		DAQmxStopTask(taskHandle);
		DAQmxClearTask(taskHandle);
	}
	if (DAQmxFailed(error))
		printf("DAQmx Error: %s\n", errBuff);

	printf("\nData collection complete, disconnecting.\n");

	//Stop data collection and disconnect
	SendCommandWithResponse("QUIT\r\n\r\n", tmp);

	//Close sockets and files
	fclose(emgdata);

	closesocket(commSock);
	closesocket(emgSock);
	closesocket(accSock);
	closesocket(imemgSock);
	closesocket(auxSock);

	printf("Press enter to exit:");
	getchar();	//allow other threads to run

	return 0;
}


