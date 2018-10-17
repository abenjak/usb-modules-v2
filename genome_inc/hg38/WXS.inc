# Bed files and annotation files
TARGETS_FILE_COVERED_INTERVALS ?= $(BED_DIR)/wxs.bed
TARGETS_FILE_INTERVALS ?= $(BED_DIR)/wxs.padded.bed
TARGETS_FILE_MUTATIONS ?= $(BED_DIR)/wxs.padded.bed
TARGETS_FILE_GENES ?= $(BED_DIR)/wxs.GeneSymbols.txt
DBSNP_TARGETS_INTERVALS ?= $(BED_DIR)/dbsnp_146.hg38.wxs.vcf
DBSNP_TARGETS_INTERVALS_COMMON ?= $(BED_DIR)/dbsnp_146.hg38.wxs.common.vcf

# Resources
RESOURCE_REQ ?= medium

# Annotation and reporting parameters
SNP_EFF_FLAGS ?= -canon -no NEXT_PROT -no-downstream -no-intergenic -no-upstream -no-utr