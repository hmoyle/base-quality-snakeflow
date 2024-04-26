import os
import warnings
import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version


bams = pd.read_table(config["bams"], dtype=str).set_index(["sample"], drop=False)


batches = pd.read_table(config["batches"], dtype=str).set_index(["batch"], drop=False)


chroms = pd.read_table(config["chroms"], dtype=str).set_index(["chrom"], drop=False)

chrom_list=chroms.chrom.tolist()


def get_bams_in_batch(wc):
  b=bams.loc[(bams["batch"] == wc.bat)]
  return b.path.tolist()
  
def get_chunk(wc):
  return "-r" + wc.chunk
  
# expand by chroms:
CHROMBS=expand("results/{mode}/{chunk}/saf/{{bat}}.saf.idx", mode=["BY_CHROM"], chunk=chrom_list)



ALLBAT=expand(
  CHROMBS,
  zip,
  bat=batches.batch.tolist()
)