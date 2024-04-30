import os
import warnings
import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version



bams = pd.read_table(config["bams"], dtype=str).set_index(
  ["sample", "path"], drop=False
)


chroms = pd.read_table(config["chroms"], dtype=str).set_index(
  ["chrom"], drop=False
)

chrom_list=chroms.chrom.tolist()

def get_chunk(wc):
  return "-r " + wc.chunk
  

CHROMSF=expand("results/{mode}/{{sample}}/{chunk}---{{sample}}.saf.idx", mode=["BY_CHROM"], chunk=chrom_list)

ALLSAF=expand(
  CHROMSF,
  zip,
  sample=bams.sample
)