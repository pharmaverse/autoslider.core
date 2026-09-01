# Test listing creation of l_vs_slide (Vital Signs Listing)

    Code
      l_vs_slide(adsl = adsl, advs = advs, trt_var = "TRT01A")
    Output
      Listing of Vital Signs: Safety-Evaluable Patients
      
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
                                                                                                                                      Diastolic Blood                                                         
                                                                                                                                         Pressure,      Systolic Blood                                        
                                                                                                    Weight                                Sitting          Pressure,                          Respiratory Rate
                                                                                                    Result       Temperature Result       Result            Sitting       Pulse Rate Result        Result     
                                                                                        Study       (Kg);               (C);               (Pa);             (Pa);          (beats/min);       (breaths/min); 
      Treatment    Center/Subject ID            Age/Sex/Race                Visit        Day    Range:(40-100)   Range:(36.1-37.2)    Range:(80-120)    Range:(120-180)    Range:(60-100)      Range:(12-20)  
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      A: Drug X        BRA-1/93                  34/F/ASIAN             WEEK 1 DAY 8     402         47.51             35.50/L             94.27            98.82/L             72.44               14.97     
                                                                        WEEK 2 DAY 15    460         67.64             37.96/H            109.98           104.21/L           104.70/H              14.90     
                                                                        WEEK 3 DAY 22    464         53.06              36.33              90.17            139.66            111.13/H             22.86/H    
                                                                        WEEK 4 DAY 29    496         61.68             33.52/L            112.76            128.82              72.89              20.77/H    
                                                                        WEEK 5 DAY 36    538         53.98             35.71/L             80.20            137.16              96.63               18.10     
      B: Placebo       BRA-1/236       32/M/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     486        37.04/L             36.11            120.31/H           146.04              65.75              22.69/H    
                                                                        WEEK 2 DAY 15    678         80.66             35.64/L            106.20            146.80              82.04               16.89     
                                                                        WEEK 3 DAY 22    762         86.71              36.16             104.63            76.01/L             70.13               19.70     
                                                                        WEEK 4 DAY 29    773         48.43             35.38/L            111.13            134.79              80.78               17.98     
                                                                        WEEK 5 DAY 36    901        24.05/L            35.90/L            108.01            137.95              68.35               8.48/L    
                       BRA-1/65        25/F/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     546         60.68             34.67/L            113.72            132.45              76.37               16.70     
                                                                        WEEK 2 DAY 15    604         55.85             38.63/H           127.03/H           133.52              93.95               15.08     
                                                                        WEEK 3 DAY 22    723         47.66              37.02             116.06            91.36/L             62.00               3.89/L    
                                                                        WEEK 4 DAY 29    791       116.89/H            37.90/H            113.53            170.65              96.86               6.73/L    
                                                                        WEEK 5 DAY 36    800         56.73              36.81            141.54/H           165.15              75.85              23.02/H    
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      
      Baseline is the patient's last observation prior to initiation of study drug. Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range.

# l_vs_slide works without a treatment variable

    Code
      l_vs_slide(adsl = adsl, advs = advs, trt_var = NULL)
    Output
      Listing of Vital Signs: Safety-Evaluable Patients
      
      ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
                                                                                                                         Diastolic Blood                                                         
                                                                                                                            Pressure,      Systolic Blood                                        
                                                                                       Weight                                Sitting          Pressure,                          Respiratory Rate
                                                                                       Result       Temperature Result       Result            Sitting       Pulse Rate Result        Result     
                                                                           Study       (Kg);               (C);               (Pa);             (Pa);          (beats/min);       (breaths/min); 
      Center/Subject ID            Age/Sex/Race                Visit        Day    Range:(40-100)   Range:(36.1-37.2)    Range:(80-120)    Range:(120-180)    Range:(60-100)      Range:(12-20)  
      ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
          BRA-1/236       32/M/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     486        37.04/L             36.11            120.31/H           146.04              65.75              22.69/H    
                                                           WEEK 2 DAY 15    678         80.66             35.64/L            106.20            146.80              82.04               16.89     
                                                           WEEK 3 DAY 22    762         86.71              36.16             104.63            76.01/L             70.13               19.70     
                                                           WEEK 4 DAY 29    773         48.43             35.38/L            111.13            134.79              80.78               17.98     
                                                           WEEK 5 DAY 36    901        24.05/L            35.90/L            108.01            137.95              68.35               8.48/L    
          BRA-1/65        25/F/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     546         60.68             34.67/L            113.72            132.45              76.37               16.70     
                                                           WEEK 2 DAY 15    604         55.85             38.63/H           127.03/H           133.52              93.95               15.08     
                                                           WEEK 3 DAY 22    723         47.66              37.02             116.06            91.36/L             62.00               3.89/L    
                                                           WEEK 4 DAY 29    791       116.89/H            37.90/H            113.53            170.65              96.86               6.73/L    
                                                           WEEK 5 DAY 36    800         56.73              36.81            141.54/H           165.15              75.85              23.02/H    
          BRA-1/93                  34/F/ASIAN             WEEK 1 DAY 8     402         47.51             35.50/L             94.27            98.82/L             72.44               14.97     
                                                           WEEK 2 DAY 15    460         67.64             37.96/H            109.98           104.21/L           104.70/H              14.90     
                                                           WEEK 3 DAY 22    464         53.06              36.33              90.17            139.66            111.13/H             22.86/H    
                                                           WEEK 4 DAY 29    496         61.68             33.52/L            112.76            128.82              72.89              20.77/H    
                                                           WEEK 5 DAY 36    538         53.98             35.71/L             80.20            137.16              96.63               18.10     
      ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      
      Baseline is the patient's last observation prior to initiation of study drug. Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range.

# l_vs_slide is generated correctly from the spec.yml

    Code
      outputs
    Output
      $l_vs_slide_PP128
      Listing of Vital Signs: Safety-Evaluable Patients
      
      —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
                                                                                                                   Diastolic Blood                                                         
                                                                                                                      Pressure,      Systolic Blood                                        
                                                                                 Weight                                Sitting          Pressure,                          Respiratory Rate
                                                                                 Result       Temperature Result       Result            Sitting       Pulse Rate Result        Result     
                                                                     Study       (Kg);               (C);               (Pa);             (Pa);          (beats/min);       (breaths/min); 
      Treatment   Center/Subject ID   Age/Sex/Race       Visit        Day    Range:(40-100)   Range:(36.1-37.2)    Range:(80-120)    Range:(120-180)    Range:(60-100)      Range:(12-20)  
      —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      A: Drug X       CHN-3/128        32/M/ASIAN    WEEK 1 DAY 8     408         85.96              37.06             77.15/L           160.71              77.01               12.71     
                                                     WEEK 2 DAY 15    662       104.28/H             36.99             101.50            136.92             51.40/L              13.86     
                                                     WEEK 3 DAY 22    776         74.19             37.90/H           121.95/H           135.94              74.71               17.84     
                                                     WEEK 4 DAY 29    923         80.48              36.51              81.22           115.51/L             83.30               15.45     
                                                     WEEK 5 DAY 36   1015         61.36             38.22/H            76.83/L           164.55              90.36              10.36/L    
      —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      
      Baseline is the patient's last observation prior to initiation of study drug. Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range.
      
      $l_vs_slide_PP262
      Listing of Vital Signs: Safety-Evaluable Patients
      
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
                                                                                                                                          Diastolic Blood                                                         
                                                                                                                                             Pressure,      Systolic Blood                                        
                                                                                                        Weight                                Sitting          Pressure,                          Respiratory Rate
                                                                                                        Result       Temperature Result       Result            Sitting       Pulse Rate Result        Result     
                                                                                            Study       (Kg);               (C);               (Pa);             (Pa);          (beats/min);       (breaths/min); 
        Treatment      Center/Subject ID            Age/Sex/Race                Visit        Day    Range:(40-100)   Range:(36.1-37.2)    Range:(80-120)    Range:(120-180)    Range:(60-100)      Range:(12-20)  
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      C: Combination      CHN-15/262       35/M/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     428         96.54             38.18/H           123.51/H           132.81              79.73               15.30     
                                                                            WEEK 2 DAY 15    471         65.91             34.89/L            109.00            130.82              65.32              11.56/L    
                                                                            WEEK 3 DAY 22    483         93.99             35.14/L             82.01            161.65              61.17              22.53/H    
                                                                            WEEK 4 DAY 29    661         68.79              37.00            127.87/H           155.19             56.88/L              19.64     
                                                                            WEEK 5 DAY 36   1025         73.16             38.41/H             95.87           113.91/L             84.02               18.41     
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      
      Baseline is the patient's last observation prior to initiation of study drug. Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range.
      
      $l_vs_slide_PP378
      Listing of Vital Signs: Safety-Evaluable Patients
      
      ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
                                                                                                                        Diastolic Blood                                                         
                                                                                                                           Pressure,      Systolic Blood                                        
                                                                                      Weight                                Sitting          Pressure,                          Respiratory Rate
                                                                                      Result       Temperature Result       Result            Sitting       Pulse Rate Result        Result     
                                                                          Study       (Kg);               (C);               (Pa);             (Pa);          (beats/min);       (breaths/min); 
        Treatment      Center/Subject ID   Age/Sex/Race       Visit        Day    Range:(40-100)   Range:(36.1-37.2)    Range:(80-120)    Range:(120-180)    Range:(60-100)      Range:(12-20)  
      ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      C: Combination       RUS-3/378        30/F/ASIAN    WEEK 1 DAY 8     428         95.11             37.57/H             90.52           113.37/L             83.55               17.54     
                                                          WEEK 2 DAY 15    501         71.73             38.00/H             96.79            145.53            111.55/H             21.99/H    
                                                          WEEK 3 DAY 22    701         59.10              36.67             77.14/L           149.26              68.95               17.32     
                                                          WEEK 4 DAY 29    745         57.88             37.67/H           132.52/H           142.93              86.05               6.36/L    
                                                          WEEK 5 DAY 36    885         43.44              36.40              97.38           183.98/H             82.18               19.05     
      ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      
      Baseline is the patient's last observation prior to initiation of study drug. Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range.
      
      $l_vs_slide_PP220
      Listing of Vital Signs: Safety-Evaluable Patients
      
      ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
                                                                                                                    Diastolic Blood                                                         
                                                                                                                       Pressure,      Systolic Blood                                        
                                                                                  Weight                                Sitting          Pressure,                          Respiratory Rate
                                                                                  Result       Temperature Result       Result            Sitting       Pulse Rate Result        Result     
                                                                      Study       (Kg);               (C);               (Pa);             (Pa);          (beats/min);       (breaths/min); 
      Treatment    Center/Subject ID   Age/Sex/Race       Visit        Day    Range:(40-100)   Range:(36.1-37.2)    Range:(80-120)    Range:(120-180)    Range:(60-100)      Range:(12-20)  
      ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      B: Placebo      CHN-11/220        26/F/ASIAN    WEEK 1 DAY 8     284         93.75             33.03/L           132.89/H           165.75              78.09               18.00     
                                                      WEEK 2 DAY 15    403         64.44             35.93/L            116.93           101.12/L             92.92               18.57     
                                                      WEEK 3 DAY 22    634         86.18             36.07/L            115.34            134.15              66.07               16.20     
                                                      WEEK 4 DAY 29    685         70.70              37.16             108.18            145.76              92.05               13.04     
                                                      WEEK 5 DAY 36   1027         67.53              36.85            137.64/H          187.10/H             74.17               18.61     
      ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
      
      Baseline is the patient's last observation prior to initiation of study drug. Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range.
      

