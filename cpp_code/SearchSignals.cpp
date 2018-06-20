#include <algorithm>
#include <chrono>
#include <ctime>
#include <iostream>
#include <fstream>
#include <math.h>
#include <stdlib.h> 
#include <stdio.h>
#include <time.h>
#include <random>
#include <map>
#include <utility>
#include <sstream>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <vector>
using namespace std;
#define PI 3.1415926535

std::vector<float> sync_sig{0.182822,0.180846,0.17858,0.175943,0.17306,0.170036,0.16677,0.163104,0.15905,0.154742,
0.15024,0.145501,0.14049,0.135202,0.129631,0.12382,0.117893,0.111927,0.105852,0.0995894,0.0932344,0.086947,0.0807295,
0.0744827,0.0682484,0.0622063,0.0564217,0.0507891,0.0452643,0.0399739,0.0350251,0.0303823,0.0260115,0.0219692,0.0182646,
0.0148101,0.0116085,0.00878794,0.006341,0.00409774,0.00214239,0.000990044,0.00103183,0.00195397,0.00300242,0.00372632,
0.00418108,0.0045126,0.00469458,0.0047121,0.00469058,0.00470136,0.0046316,0.00437761,0.00402736,0.00372788,0.00347601,
0.00317205,0.00280745,0.00247803,0.00223555,0.00203115,0.00181196,0.0015985,0.00143409,0.00130307,0.00115692,0.00100869,
0.000930678,0.000930535,0.000909999,0.000798979,0.000664138,0.000610503,0.000626928,0.000619944,0.000561616,0.000510814,
0.000496037,0.000477063,0.000444346,0.000467631,0.00058774,0.000727835,0.000779376,0.000732881,0.000645489,0.000524627,
0.000347096,0.000195429,0.000276341,0.000743993,0.00154386,0.00249824,0.00353984,0.00479259,0.00638874,0.00827548,
0.010294,0.0124254,0.0148435,0.0176902,0.020896,0.0242992,0.0278785,0.0317588,0.0360071,0.0405492,0.0453165,0.0503554,
0.05572,0.0613504,0.0671523,0.0731255,0.0793149,0.0856852,0.0921373,0.0986243,0.105168,0.111782,0.118425,0.125044,
0.131586,0.13797,0.144101,0.149955,0.155614,0.161151,0.166469,0.171344,0.175672,0.179578,0.183208,0.186501,0.189304,
0.191609,0.193486,0.194883,0.195697,0.195997,0.195923,0.195397,0.194201,0.192325,0.189934,0.187014,0.183367,0.178955,
0.17391,0.168204,0.161691,0.154434,0.14657,0.137929,0.128315,0.118023,0.10745,0.0963279,0.0842174,0.0715963,0.0592714,
0.0467752,0.0331617,0.0201731,0.0128049,0.014927,0.0250887,0.0381616,0.0505372,0.062151,0.0739543,0.0856261,0.0963643,
0.106268,0.115841,0.12497,0.133246,0.140748,0.147808,0.154362,0.160136,0.165186,0.169786,0.173964,0.177561,0.180599,
0.183252,0.185569,0.18748,0.189012,0.190269,0.191264,0.191944,0.19235,0.1926,0.192738,0.192736,0.192596,0.192363,
0.192037,0.191603,0.191118,0.190666,0.190245,0.189788,0.189296,0.188849,0.188484,0.18815,0.187801,0.187476,0.18725,
0.187131,0.187056,0.186975,0.18691,0.186907,0.186978,0.187094,0.18724,0.187428,0.187665,0.187912,0.188122,0.18832,
0.188584,0.188932,0.189253,0.189427,0.189492,0.189601,0.189822,0.190045,0.190137,0.190104,0.19004,0.190002,0.189964,
0.189877,0.1897,0.189432,0.189123,0.18884,0.188593,0.18833,0.188027,0.187715,0.187411,0.187108,0.186845,0.186703,
0.186694,0.186723,0.186715,0.186722,0.186847,0.187095,0.187383,0.187671,0.188014,0.1885,0.189131,0.189789,0.190352,
0.190854,0.191442,0.192136,0.192751,0.193159,0.193473,0.19383,0.194137,0.19423,0.194143,0.193967,0.193562,0.192721,
0.191537,0.190248,0.18878,0.186811,0.184273,0.181372,0.178095,0.174204,0.169708,0.164831,0.159459,0.153221,0.146168,
0.138696,0.130735,0.121819,0.112035,0.101969,0.0915738,0.0802239,0.0681184,0.0562074,0.0443308,0.0314222,0.0188581,
0.0116949,0.0142214,0.0250276,0.0385476,0.0509709,0.0625544,0.0745351,0.0864681,0.0973848,0.107486,0.117387,0.126861,
0.135371,0.143037,0.150246,0.156926,0.162848,0.168149,0.173019,0.17731,0.180889,0.183968,0.18674,0.18908};

/*std::vector<float> end_sig{0.178737,0.175199,0.170978,0.16627,0.161029,0.154975,0.14815,0.140857,0.13298,0.124105,
0.114384,0.104376,0.09396,0.0825179,0.0703598,0.058527,0.0467855,0.0337976,0.0206165,0.0122131,0.0132514,0.0229735,
0.0361668,0.0487514,0.0604799,0.0724369,0.0843654,0.0953637,0.10548,0.115291,0.124735,0.133363,0.141204,0.148579,
0.155429,0.161477,0.166801,0.171696,0.176161};*/

std::vector<float> end_sig{0.183207,0.178482,0.173172,0.167458,0.16115,0.154045,0.146358,0.138286,0.129505,0.119735,
0.109405,0.0989798,0.088075,0.0762483,0.0641169,0.0523571,0.0402144,0.0271408,0.0159588,0.0119072,0.0173331,0.0289859,
0.0417408,0.0534873,0.0650489,0.0769225,0.0882816,0.0986338,0.108478,0.118135,0.127221,0.135465,0.14311,0.150305,0.156842,
0.162636,0.167886,0.172667,0.176828,0.180367,0.183493,0.186288,0.188623,0.190449,0.191891,0.193055,0.193953,0.194591,
0.194983,0.195115,0.195023,0.194826,0.194594,0.194257,0.193742,0.193102,0.192441,0.191815,0.191242,0.190725,0.190212,
0.189647,0.189098,0.18871,0.188496,0.188303,0.188055,0.187866,0.187825,0.18784,0.187825,0.187863,0.188043,0.188275,0.188433,
0.188577,0.188841,0.18919,0.189462,0.189634,0.189844,0.190146,0.190417,0.190546,0.190595,0.190691,0.19086,0.191007,0.191031,
0.190923,0.190755,0.190611,0.190499,0.190373,0.190201,0.190001,0.189787,0.189552,0.189331,0.189185,0.189099,0.188979,0.188792,
0.188625,0.18854,0.188492,0.188453,0.188481,0.188602,0.188719,0.188761,0.188814,0.188991,0.189262,0.189526,0.189777,0.190052,
0.190293,0.190429,0.190542,0.190789,0.191162};

std::vector<float> B0_down{0.150674,0.150343,0.150559,0.150739,0.150597,0.150606,0.151064,0.151552,0.151597,0.151439,
0.151557,0.151683,0.151259,0.150552,0.150288};

std::vector<float> B0_up{0.150567,0.150779,0.151357,0.151725,0.151616,0.15145,0.151557,0.151623,0.151209,0.150595,
0.150434,0.150663,0.150711,0.150559,0.150723};

std::vector<float> B1_up{0.150559,0.150844,0.151378,0.151747,0.1517,0.151502,0.151503,0.151672,0.151781,0.151705,
0.151568,0.151603,0.15175,0.15172,0.151381};

std::vector<float> B1_down{0.151592,0.151149,0.150644,0.15044,0.150562,0.150695,0.150675,0.150584,0.150513,0.150529,
0.150584,0.150541,0.150441,0.15053,0.150971};

std::vector<float> FM0_Preamble{0.300831,0.300225,0.299777,0.299784,0.299933,0.299869,0.299706,0.299689,0.299746,0.299722,
0.299747,0.300035,0.300486,0.300834,0.301029,0.301118,0.300967,0.300496,0.299978,0.299743,
0.299777,0.299903,0.30014,0.300582,0.301051,0.301234,0.301129,0.301022,0.301047,0.301113,
0.301171,0.301212,0.301095,0.300709,0.300216,0.299899,0.299806,0.29981,0.299966,0.300446,
0.301066,0.301331,0.30112,0.300893,0.301022,0.301291,0.301305,0.301113,0.301061,0.301186,
0.301204,0.30107,0.301037,0.301119,0.300966,0.300431,0.299876,0.299701,0.299822,0.299873,
0.299744,0.299616,0.299572,0.299549,0.299593,0.299847,0.300313};

double FindMax(double x1, double x2, double x3, double x4){
    if((x1>=x2)&&(x1>=x3)&&(x1>=x4)) return x1;
    if((x2>=x1)&&(x2>=x3)&&(x2>=x4)) return x2;
    if((x3>=x1)&&(x3>=x2)&&(x3>=x4)) return x3;
    if((x4>=x1)&&(x4>=x2)&&(x4>=x3)) return x4;
    else return -1;//impossible
}

float Correlation(vector<float> &seg_A, vector<float> &seg_B, int size){
    int simi=0;
    float exp_A=0,exp_B=0;
    for(int j=0;j<size;j++){
        exp_A+=seg_A[j]/(float)size;
        exp_B+=seg_B[j]/(float)size;
    }
    float sigma_A=0,sigma_B=0;
    for(int j=0;j<size;j++){
        sigma_A+=(seg_A[j]-exp_A)*(seg_A[j]-exp_A)/(float)size;
        sigma_B+=(seg_B[j]-exp_B)*(seg_B[j]-exp_B)/(float)size;
    }
    sigma_A=sqrt(sigma_A);
    sigma_B=sqrt(sigma_B);
    float cor=0;//correlation
    for(int j=0;j<size;j++) cor+=(seg_A[j]-exp_A)*(seg_B[j]-exp_B)/(size*sigma_A*sigma_B);
    return cor;
}

void FillBuffer(vector<float> &buf, ifstream &is){
    float x;
    int length,index=-1;
    while (!is.eof()){
        index++;
        is.read((char *)&x,sizeof(float));
        buf.push_back(x);
    }
    buf.resize(index);
}

void FillBuffer2(vector<float> &buf, ifstream &is){
    float x;
    string mline,mline1;
    int number_of_lines=0;
    if(is.is_open()){
        while(!is.eof()){  
            is>>mline1;
            x=atof(mline1.c_str());
            buf.push_back(x);
            getline(is,mline);
            number_of_lines++; 
        }
    }
    number_of_lines--;
    buf.resize(number_of_lines);
}

void SegmentBuffer(vector<float> &buf, map <int,int> &segs){
    double noise_thresh=0.05;//noise threshold
    int duration_thresh=10000;//duration of a valid noise segment, threshold
    int start,end,duration;
    duration=-1;
    start=-1;
    for(int i=0;i<buf.size();i++){
        if(buf[i]<noise_thresh){ //below thresh
            if(start==-1){
                start=i;
                duration=0;
            }
            else duration++;
        }
        else{
            if(start==-1) continue;
            else{ //start already, make an end conclusion
                if((duration>duration_thresh)){
                    end=i;
                    for(int j=start;j<end;j++) buf[j]=0;
                    start=-1;
                    duration=-1;
                    end=-1;
                }
                else{ 
                    start=-1;
                    duration=-1;
                }
            }
        }
    }

    start=-1;
    for(int i=0;i<buf.size();i++){
        if(start==-1){ //not start yet
            if(buf[i]>0) start=i;
        }
        else if(buf[i]==0){ //start already
            end=i;
            segs.insert(std::pair<int,int>(start,end));
            start=-1;
            end=-1;
        }
    }
}   

void FindBackscatterRange(vector<float> &buf, map<int, std::pair<int,int> > &sig_range, int starting, int ending){
    int W0=sync_sig.size();
    std::vector<float> tmp_sig;
    std::vector<float> sync_index_list;
    std::map<int, std::pair<int,float> > corres;
    std::map<int, std::pair<int,float> > corres_end;
    sync_index_list.clear();
    corres.clear();
    float simi,max_simi;
    float simi_thresh=0.9, simi_thresh2=0.9;
    int comp_win=100;//[50,1000] for this time
    int comp_win_end=40;

    int index=0;
    for(int i=starting;i<=(ending-W0);i++){
        tmp_sig.clear();
        for(int j=0;j<W0;j++) tmp_sig.push_back(buf[i+j]);
        simi=Correlation(tmp_sig,sync_sig,W0);
        if(simi>simi_thresh){
            corres.insert(std::pair<int,std::pair<int,float> > (index, std::pair<int,float>(i,simi)));
            index++;
        }
    }
    
    int start=-1,end=-1,opt_index;
    max_simi=0;
    for(int i=0;i<corres.size();i++){
        if(i==0){
            start=corres[i].first;
            max_simi=corres[i].second;
            opt_index=corres[i].first;
        }
        else if(i==corres.size()-1){
            end=corres[i].first;
            if(corres[i].second>max_simi){
                max_simi=corres[i].second;
                opt_index=corres[i].first;
            }
            sync_index_list.push_back(opt_index);
        }
        else{
            if(corres[i].first-start<comp_win){
                if(corres[i].second>max_simi){
                    max_simi=corres[i].second;
                    opt_index=corres[i].first;
                }
            }
            else{
                end=corres[i-1].first;
                sync_index_list.push_back(opt_index);
                start=corres[i].first;
                max_simi=corres[i].second;
                opt_index=corres[i].first;
            }
        }
    } 
    //check from here
    
    int no_sig;
    int diff_time_thresh=1400;//a safe threshold
    int front_tuning=122;
    int back_tuning=12;
    for(int i=sync_index_list.size()-2;i>=0;i--){
        index=0;
        corres_end.clear();
        for(int j=(sync_index_list[i+1]-1);j>sync_index_list[i];j--){//end is the first best match of the ending sig
            tmp_sig.clear();
            for(int k=0;k<end_sig.size();k++) tmp_sig.push_back(buf[j+k]);
            simi=Correlation(tmp_sig,end_sig,end_sig.size());
            if(simi>simi_thresh2){
                corres_end.insert(std::pair<int,std::pair<int,float> > (index, std::pair<int,float>(j,simi)));
                index++;
            }
        }        
        opt_index=corres_end[0].first;
        max_simi=corres_end[0].second;
        for(int s=1;s<corres_end.size();s++){
            if(fabs(corres_end[s].first-start)<comp_win_end){
                if(corres_end[s].second>max_simi){
                    max_simi=corres_end[s].second;
                    opt_index=corres_end[s].first;
                }
            }
            else break;
        }
        no_sig=sig_range.size();
        if(sync_index_list[i+1]-1-back_tuning-opt_index-front_tuning>diff_time_thresh){
            sig_range.insert(std::pair<int, std::pair<int,int> > (no_sig,std::pair<int,int> (opt_index+45,sync_index_list[i+1]-1-back_tuning)));//keep the front to detect the FM0 preamble
            //sig_range.insert(std::pair<int, std::pair<int,int> > (no_sig,std::pair<int,int> (opt_index+front_tuning,sync_index_list[i+1]-1-back_tuning)));
        }
    }
}

void RemoveSomeNoiseSegs(vector<float> &bufs, map<int, std::pair<int,int> > &sig_range){
    std::vector<float> tmp_sig;
    std::vector<float> seg_sig;
    std::vector<int> remove_index;
    int cnt_0,cnt_1,cnt_2,cnt_3,cnt_4;
    double sim1,sim2,sim3,sim4,sim,sim_fm;
    int W=15;
    double sim_thresh=0.8;
    for(std::map<int, std::pair<int,int> >::iterator it=sig_range.begin(); it!=sig_range.end(); ++it){
        seg_sig.clear();
        for(int i=(it->second).first;i<(it->second).second;i++) seg_sig.push_back(bufs[i]);
        cnt_0=0;
        cnt_1=0;
        cnt_2=0;
        cnt_3=0;
        cnt_4=0;
        for(int j=0;j<=(seg_sig.size()-W);j++){ //cut the window part
            tmp_sig.clear();
            for(int k=0;k<W;k++) tmp_sig.push_back(seg_sig[j+k]);
            sim1=Correlation(tmp_sig,B0_down,W);
            sim2=Correlation(tmp_sig,B0_up,W);
            sim3=Correlation(tmp_sig,B1_down,W);
            sim4=Correlation(tmp_sig,B1_up,W);
            sim=FindMax(sim1,sim2,sim3,sim4);
            if(sim>sim_thresh) cnt_0++;
            if(sim1>sim_thresh) cnt_1++;
            if(sim2>sim_thresh) cnt_2++;
            if(sim3>sim_thresh) cnt_3++;
            if(sim4>sim_thresh) cnt_4++;
        }
        if((cnt_0>120)&&(cnt_3>=10)&&(cnt_4>=10)) continue;//no need to remove
        else remove_index.push_back(it->first);
    }
    for(int i=0;i<remove_index.size();i++) sig_range.erase(remove_index[i]);
}

/*void RemoveByFM0Preamble(vector<float> &bufs, map<int, std::pair<int,int> > &sig_range){//have bugs
    std::vector<float> tmp_sig;
    std::vector<float> seg_sig;
    std::vector<int> removal_index;
    int W=FM0_Preamble.size();
    double sim_thresh=0.6;
    double sim,max_sim;
    int cnt=0;
    for(std::map<int, std::pair<int,int> >::iterator it=sig_range.begin(); it!=sig_range.end(); ++it){
        cout<<cnt++<<"\n";
        seg_sig.clear();
        max_sim=-100;
        for(int i=(it->second).first;i<(it->second).second;i++) seg_sig.push_back(bufs[i]);
        for(int j=0;j<=(bufs.size()-W);j++){
            tmp_sig.clear();
            for(int k=0;k<W;k++) tmp_sig.push_back(bufs[j+k]);
            sim=Correlation(tmp_sig,FM0_Preamble,W);
            if(sim>max_sim) max_sim=sim;
        }
        if(max_sim<0.6) removal_index.push_back(it->first);
        else cout<<it->first<<"\t"<<max_sim<<"\n";
    }
    for(int i=0;i<removal_index.size();i++) sig_range.erase(removal_index[i]);
}*/

int main(){
    std::vector<float> buffer;//all data
    std::map <int,int> segList;//signal segment [start,end), remove pure noise part
    std::map<int, std::pair<int,int> > rangeList;//possible backscatter signal range
    ifstream ifile;

    ifile.open ("low_pass_mag.txt", ios::binary);
    FillBuffer(buffer,ifile);
    ifile.close();

    /*
    long int start=612327,end=613726;
    ofstream ofile;
    ofile.open("signal_chip.txt");
    for(long int i=start;i<end;i++) ofile<<buffer[i]<<"\r\n";
    ofile.close();
    */
    SegmentBuffer(buffer,segList);
    
    for(std::map <int,int>::iterator it=segList.begin(); it!=segList.end(); ++it) FindBackscatterRange(buffer,rangeList,it->first,it->second);
    RemoveSomeNoiseSegs(buffer,rangeList);
    //RemoveByFM0Preamble(buffer,rangeList);
    /*
    ofstream ofile;
    ofile.open("rangeList.txt");
    for(std::map<int, std::pair<int,int> >::iterator it=rangeList.begin(); it!=rangeList.end(); ++it){
        ofile<<(it->second).first<<"\t"<<(it->second).second<<"\r\n";
    }
    ofile.close();
    */
    
    /*std::stringstream ss;
    std::ofstream tracefile;
    int cnt=1;
    for(std::map<int, std::pair<int,int> >::iterator it=rangeList.begin(); it!=rangeList.end(); ++it){
        ss.str(std::string());
        ss << "/home/yuxiao/Desktop/Work_Delft/Experiment/Signal_Chip/" << cnt <<".txt";
        tracefile.open(ss.str().c_str());
        for(int i=(it->second).first;i<(it->second).second;i++) tracefile<<buffer[i]<<"\r\n";
        cnt++;
        tracefile.close();
    }*/
    return 0;
}
