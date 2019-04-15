# Bayesian Models of Psychopathy

This repository contains Matlab code for modelling and analysis written by Andreea Diaconescu:

BAMP: Bayesian Models of Psychopathy (Collaboration with I. Brazil)


Getting Started
---------------

- BAMP: Load analysis settings `options = BAMP_options(options)`.
- Fitting of experimental data: The main function is `loop_analyze_behaviour_local.m`
    - Note that this part of the code will only run, if you have access to the 
      acquired behavioral data.

- Model selection: `bamp_behav_model_evidence(options)` (Need SPM for model selection).
- Extract MAPs and test model internal validity: `bamp_extract_parameters_create_table(options)` and `bamp_plot_parameter_estimate_results(options)`. 