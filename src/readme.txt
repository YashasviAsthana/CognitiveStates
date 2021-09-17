To run the scripts, relevant data.mat should be present in the data folder
For this project I am using the data of subject 04799; link:
http://www.cs.cmu.edu/afs/cs.cmu.edu/project/theo-81/www/data-starplus-04847-v7.mat
Place the downloaded data inside the data folder.

-clustering.m is used for clustering part and contains various segments of code, whose purpose are commented there itself.

-classification.m is used for the classification part and contains various segments of code, whose purpose are commented there itself.

-createMovie.m is function used in clustering and can be uncommented to create a brain movie with activations.

-rankingfeat.m is used for feature ranking using Variance Ratio Score.

-trainTestSplit.m is used to create proportional train test split based on classes.