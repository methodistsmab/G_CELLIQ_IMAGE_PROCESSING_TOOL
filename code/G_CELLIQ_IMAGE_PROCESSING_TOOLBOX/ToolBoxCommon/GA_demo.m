clc;
clear;
close all;

load demodata;

[selectedVars, errorRate] = varselect_GA_open(DataX, LabelY, 10);
