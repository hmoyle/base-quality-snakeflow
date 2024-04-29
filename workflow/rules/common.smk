import os
import warnings
import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version


samples = pd.read_table(config["samples"], dtype=str).set_index(["sample"], drop=False)


chroms = pd.read_table(config["chroms"], dtype=str).set_index(["chrom"], drop=False)

chrom_list=chroms.chrom.tolist()

  
def get_chunk(wc):
  return "-r " + wc.chunk
  
# expand by chroms:
CHROMBS=expand("results/{mode}/{chunk}/saf/{{samp}}.saf.idx", mode=["BY_CHROM"], chunk=chrom_list)

CHROMSFS=expand("results/{mode}/{chunk}/sfs/{{samp}}.ml", mode=["BY_CHROM"], chunk=chrom_list)



ALLBAT=expand(
  CHROMSFS,
  zip,
  samp=samples.sample.tolist()
)
