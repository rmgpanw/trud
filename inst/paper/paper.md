---
title: 'trud: An R interface to the NHS England Technology Reference data Update Distribution (TRUD) API'
tags:
- R
- api-wrapper
- health-data
- NHS
- clinical-coding
- electronic-health-records
date: "27 April 2025"
output: pdf_document
authors:
  - name:
      given-names: Alasdair Neil
      surname: Warwick
    orcid: 0000-0002-0800-2890
    email: alasdair.warwick.19@ucl.ac.uk
    affiliation: "1, 2"
  - name:
      given-names: Abraham
      surname: Olvera-Barrios
    orcid: 0000-0002-3305-4465
    affiliation: "2, 3"
  - name:
      given-names: Chuin Ying
      surname: Ung
    orcid: 0000-0001-8487-4589
    affiliation: 4
  - name:
      given-names: Robert
      surname: Luben
    orcid: 0000-0002-5088-6343
    affiliation: "2, 3"
bibliography: paper.bib
affiliations:
- name: University College London Institute of Cardiovascular Science, London, UK
  index: 1
- name: NIHR Biomedical Research Centre, Moorfields Eye Hospital NHS Foundation Trust
  index: 2
- name: University College London Institute of Ophthalmology, London, UK
  index: 3
- name: Guy's and St Thomas' NHS Foundation Trust
  index: 4
---

# Summary

The National Health Service (NHS) England Technology Reference data Update Distribution (TRUD) [@trudwebsite] is a comprehensive public resource that provides essential reference files underpinning electronic health record (EHR) systems. TRUD distributes clinical coding systems including ICD, Read codes, prescription codes, and the SNOMED CT ontology, with regular updates to reflect evolving clinical practice. While TRUD provides its own API access to these resources, interacting with the API directly can be complex and time-consuming for researchers working in R.

The `trud` package [@trud] streamlines access to the NHS TRUD API through a convenient R interface. It provides user-friendly functions that wrap the API endpoints for retrieving metadata about available resources and downloading release items programmatically. The package includes comprehensive documentation and working examples, enabling researchers to maintain reproducible, up-to-date analyses whether for ad-hoc studies or automated pipelines.

# Statement of need

NHS TRUD resources are extensively used across diverse areas of health research, from clinical epidemiology to health services research. For example, researchers use TRUD reference data for disease phenotyping, cohort selection, and developing risk prediction models. While TRUD offers API access, the complexity of direct API interaction can be a barrier to efficient research workflows.

Current approaches typically involve either manual downloads through the web interface or custom scripts to interact with the API, both of which are time-consuming and prone to version inconsistencies. The `trud` package [@trud] simplifies this process by providing researchers with a straightforward R interface to the TRUD API, facilitating reproducible research and automated data pipelines.

Key features include:
- Retrieval of metadata for available TRUD items and releases
- Automated downloading of latest or specific versions of reference files
- Simple API key management through environment variables
- Comprehensive documentation and examples

# Acknowledgements

We acknowledge NHS England for providing the TRUD service that this package accesses. A.N.W. is supported by the Wellcome Trust (220558/Z/20/Z; 224390/Z/21/Z). This research was supported by the National Institute for Health and Care Research (NIHR) Biomedical Research Centre based at Moorfields Eye Hospital NHS Foundation Trust and UCL Institute of Ophthalmology. The views expressed are those of the author(s) and not necessarily those of the NHS, the NIHR or the Department of Health and Social Care.

# References
