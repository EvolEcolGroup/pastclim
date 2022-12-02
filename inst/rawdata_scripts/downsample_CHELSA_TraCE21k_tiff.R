# ran in bash
# this takes 3 files downloaded at high resolution and downsamples so that they can be
# used as example files
gdalwarp -tr 1 1 -r average CHELSA_TraCE21k_bio01_-1_V1.0.tif CHELSA_TraCE21k_bio01_-1_V1.0.small.tif
gdalwarp -tr 1 1 -r average CHELSA_TraCE21k_bio01_-2_V1.0.tif CHELSA_TraCE21k_bio01_-2_V1.0.small.tif
gdalwarp -tr 1 1 -r average CHELSA_TraCE21k_bio01_-3_V1.0.tif CHELSA_TraCE21k_bio01_-3_V1.0.small.tif
