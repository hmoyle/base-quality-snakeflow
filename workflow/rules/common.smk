import os
import warnings
import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version


bams = pd.read_table(config["bams"], dtype=str).set_index(["sample"], drop=False)


chroms = pd.read_table(config["chroms"], dtype=str).set_index(["chrom"], drop=False)

chrom_list=chroms.chrom.tolist()

bam_list=bams.sample.tolist()

  
def get_chunk(wc):
  return "-r " + wc.chunk
  
def get_samp(wc):
  b=bams.loc[(bams["sample"] == wc.samp)]
  return b.path.tolist()
  
  
# expand by chroms:
CHROMBS=expand("results/{mode}/{chunk}/saf/{{samp}}.saf.idx", mode=["BY_CHROM"], chunk=chrom_list)

CHROMSFS=expand("results/{mode}/{chunk}/sfs/{{samp}}.ml", mode=["BY_CHROM"], chunk=chrom_list)



ALLBAT=expand(
  CHROMSFS,
  zip,
  samp=bams.sample.tolist()
)
