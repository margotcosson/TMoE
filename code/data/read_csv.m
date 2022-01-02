%T=csvread('MonthlyTemperatureAnomaly.csv');
%save('MonthlyTemperatureAnomaly.mat', "T");

load 'data/MonthlyTemperatureAnomaly.mat';
x = MonthlyTemperatureAnomaly(:,1);
y = MonthlyTemperatureAnomaly(:,2);