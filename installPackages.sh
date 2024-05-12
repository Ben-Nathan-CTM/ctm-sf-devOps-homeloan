#!/bin/bash 
 #sfdx force:auth:web:login -a DevHubAlias 
 package_ids=(
04t960000000S8kAAE 
04t960000000S5gAAE 
04t960000000S5lAAE
04t960000000S5WAAU
04t960000000SfLAAU 
04tOm0000000HGzIAM   
04t3m000002D9hu
04t5Y0000023R28QAE
04t6g000008So61AAC
04tOm0000000FqHIAU  
04tOm0000000GBFIA2    
04tOm0000000PsrIAE  
04tOm0000000Bt7IAE
04t6g000008C6lwAAC
04t0o000002qOIyAAM   
04t5w000003gWWBAA2
)
 for package_id in "${package_ids[@]}"; do 
 # Install the package with --noprompt(-r) --wait 10 min  if needed -can be changed
  sfdx force:package:install -p "$package_id" -w 10 -r
done