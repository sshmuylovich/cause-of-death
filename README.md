# Predicting Artwork Size to aid Museum Workers with Exhibition Curation: The Influence of Gender, Nationality, and Year of Completion at the Museum of Modern Art.

## Overview
This paper explores the determinants of artwork size within the Museum of Modern Art (MoMA) collection, focusing on the effects of artist gender, nationality, and year of completion. Utilizing the MoMA Artworks dataset, a linear regression model was employed to analyze how these factors influence the physical dimensions of artworks. The study reveals that artworks by male artists and those identified with multiple artists tend to be smaller in size, challenging conventional expectations about gender and artistic production. Notably, artworks from Algerian and Ghanaian artists are significantly larger, possibly reflecting unique cultural and artistic traditions that favor grand-scale works. The analysis also indicates a clear trend of increasing artwork size over time, suggesting an evolution in artistic practices and the spaces available for art display. These findings not only enhance our understanding of the factors influencing artistic expression but also have practical implications for museum curators and cultural historians in planning exhibitions and interpreting artistic trends. The paper recommends further research using non-linear models and a broader set of variables to more accurately reflect the complex variables that determine artwork size.

## File Structure
The repo is structured as:

- `data/raw_data` contains the raw data.
- `data/analysis_data` contains the cleaned datasets that were constructed.
- `models` contains the models that were constructed.
- `other/sketches` includes sketches of the datasets and graphs used in this report.
- `other/issues` includes documentation of any encountered issues. 
- `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
- `scripts` contains the R scripts used to simulate, download, clean, and test data as well as the Shiny Web application.

# LLM Usage Statement
None of the components of this work involved the use of LLMs.

# Parquet Issues
Attempted to use arrow's parquet feature but was met with unexpected difficulties regarding C++ compiler version compatability. The terminal can be found below and a screenshot of the issue is documented in `other/issues`.

`Error in parquet___WriterProperties___Builder__create() : Cannot call parquet___WriterProperties___Builder__create(). See https://arrow.apache.org/docs/r/articles/install.html for help installing Arrow C++ libraries.`