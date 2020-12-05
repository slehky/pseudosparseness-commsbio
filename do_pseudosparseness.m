function pseudosparseness = do_pseudosparseness(dataarray)
%
%FUNCTION PSEUDOSPARSENESS = DO_PSEUDOSPARSENESS(DATAARRAY)
%
% Input: dataarray   each column is a variable, each row is an observation
%                   (each column is a neuron, each row is a stimulus)
% Output: pseudosparseness   
%
% Calculates the average correlation across the population of variables
% (average correlation between rows of dataarray)
%
% Sidney Lehky
% RIKEN Center for Brain Science
% Wako-shi, Saitama, JAPAN
% October 2, 2020


% Pairwise correlation for rows of dataarray
% Corrmatrix is the square matrix of correlation coefficients
corrmatrix = corr(dataarray');


% Corr coeffs are mirrored above and below the diagonal of corrmatrix. 
% Take the lower triangular corrmatrix, remove the 1.0's on the diagonal.
corrResp = corrmatrix(~tril(ones(size(corrmatrix))));

% If using do_pseudosparseness function when bootstraping pseudosparseness 
% estimates, the same row may be replicated in the bootstraped dataarray
% producing a corr of 1.0 and a Fisher z-transform of infinity. Therefore,
% remove 1.0's in corrResp here.
corrResp = corrResp(corrResp ~= 1);

% Fisher’s z-transform serves to normalize the sampling of correlation 
% coefficients, making the estimate of mean correlation less affected by 
% distribution skew.

% Fisher z-transform (tanh) of corrResp)
zcorrResp = atanh(corrResp);

% inverse Fisher z transform of mean of transformed corrResp
pseudosparseness = tanh(mean(zcorrResp));
