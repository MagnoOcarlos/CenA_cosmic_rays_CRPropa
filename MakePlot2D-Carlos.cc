//g++ MakePlot2D-Carlos.cc -o MakePlot2D-Carlos.exe `root-config --cflags --glibs`
//./MakePlot2D-Carlos.exe
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <vector>
#include <math.h>
#include <unistd.h>
#include "TGraph.h"
#include <TRandom3.h>
#include "TRandom.h"
#include "TRint.h"
#include "TAxis.h"
#include "TCanvas.h"
#include "TMath.h"
#include "TF1.h"
#include "TLine.h"
#include "TGraph.h"
#include "TGraphErrors.h"
#include "TStyle.h"
#include "TH2F.h"


using namespace std;

int main(int argc, char* argv[])
{
    int fargc = 1;
    TRint *rint = new TRint("", &fargc, argv);
    // Create, fill and project a 2D histogram.
    TH2F *hangXenergy = new TH2F("hangXenergy","eventos injetados",40,-2.05,3.05,10,-2.5,92.5);
    TH1F *hlogenergy = new TH1F("hlogenergy","eventos detectados",40,-1.05,3.05);
    TH1F *henergy = new TH1F("henergy","",100,0.1,1000);

    TH2F *hangXenergy_chegaram  = new TH2F("hangXenergy_chegaram","N=100k,lc=1 Mpc,ang_dist=0.15,Ec=9EeV",40,-2.05,3.05,10,-2.5,92.5);
    //for(int i=0; i< 8; i++){


    string saida="sairam_";
    string chegada="chegaram_";


    for(int i=0;i<=90;i=i+10){

    string num_i(std::to_string(i));

    string name_saida =  saida +  num_i + ".txt";
    string name_chegada =  chegada + num_i + ".txt";

        cout << name_saida << " " << name_chegada << endl;

    ifstream input_saida(name_saida);
    ifstream input_chegada(name_chegada);

       // cout << saida+ std::to_string(i) +".txt" << endl;
   // cout << chegada + std::to_string(i) + ".txt" << endl;


    double energy;
    double ang;
      
    while(!input_saida.eof()){
        input_saida >> energy;
        //ang = (gRandom->Rndm()) * 45;
        hangXenergy->Fill(log10(energy), i);
       // cout << energy << endl;
        hlogenergy->Fill(log10(energy));
        henergy->Fill(energy);

    }




    while(!input_chegada.eof()){
          input_chegada >> energy;
          //ang = (gRandom->Rndm()) * 45;
          hangXenergy_chegaram->Fill(log10(energy), i);

      }

   
    //Dividing hist   hangXenergy_chegaram per hangXenergy
     TCanvas *c3 = new TCanvas("c3", "c3",600,400);

    TH2F *hFraction = new TH2F("h3","Fração eventos chegaram/Saíram",40,-2.05,3.05,10,-2.5,92.5);
    hFraction  = (TH2F*)hangXenergy_chegaram->Clone();
    hFraction->Divide(hangXenergy);


    hFraction->GetZaxis()->SetLimits(1e-25,1e0);
    hFraction->Draw("colz");
    hFraction->SetFillColorAlpha(kRed, 0.35);
    hFraction->GetXaxis()->SetTitle("log(E/EeV)");
    hFraction->GetYaxis()->SetTitle("angle (degrees)");
    hFraction->GetZaxis()->SetTitle("Ratio N_{det}/N_{inj}");
    hFraction->GetZaxis()->SetRangeUser(1e-8,1e-1);


    c3->SetLogz();
    gStyle->SetPalette(55);
    hFraction->SetStats(0);
    c3->SaveAs("plot_B10_Lc1Mpc.pdf");


    gStyle->SetOptStat(0);
    rint->Run(kTRUE);
