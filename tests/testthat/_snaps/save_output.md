# Test save_output (Save an Output)

    Code
      print(save_output(decorate(t_ae_pt_slide(adsl, adae, "TRT01A", 2), title = "Serious Adverse Events, Safety-Evaluable Patients",
      footnote = "", paper = "P8", for_test = TRUE), file_name = file.path(output_dir,
        "t_ae_SER_SE"), save_rds = TRUE))
    Output
      An object of class "dVTableTree"
      Slot "tbl":
      Serious Adverse Events, Safety-Evaluable Patients
      
      ———————————————————————————————————————————————————————————————————————
         MedDRA Preferred Term N (%)   A: Drug X    B: Placebo   All Patients
      ———————————————————————————————————————————————————————————————————————
      dcd D.2.1.5.3                    37 (27.6%)   46 (34.3%)   133 (33.2%) 
      dcd A.1.1.1.1                    45 (33.6%)   31 (23.1%)   128 (32.0%) 
      dcd A.1.1.1.2                    41 (30.6%)   39 (29.1%)   122 (30.5%) 
      dcd B.2.2.3.1                    38 (28.4%)   40 (29.9%)   123 (30.8%) 
      dcd D.1.1.1.1                    42 (31.3%)   32 (23.9%)   120 (30.0%) 
      dcd B.2.1.2.1                    39 (29.1%)   34 (25.4%)   119 (29.8%) 
      dcd B.1.1.1.1                    38 (28.4%)   37 (27.6%)   111 (27.8%) 
      dcd D.1.1.4.2                    38 (28.4%)   34 (25.4%)   112 (28.0%) 
      dcd C.1.1.1.3                    36 (26.9%)   34 (25.4%)   106 (26.5%) 
      dcd C.2.1.2.1                    28 (20.9%)   36 (26.9%)   112 (28.0%) 
      
      Slot "titles":
      Serious Adverse Events, Safety-Evaluable Patients
      
      Slot "footnotes":
      [1] ""
      
      Slot "usernotes":
      [1] ""
      
      Slot "paper":
      [1] "P8"
      
      Slot "width":
      [1] 30 10 10 12
      

