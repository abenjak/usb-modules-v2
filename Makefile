# Top-level Makefile
#
#
# Author: Raymond Lim <raylim@mm.st>
#

export

# job-related options
NUM_ATTEMPTS ?= 1
USE_CLUSTER ?= true
NUM_JOBS ?= 100
# possible values: SGE, SLURM
CLUSTER_ENGINE ?= SLURM

NOW := $(shell date +"%F")
MAKELOG = log/$(@).$(NOW).log

ifeq ($(USE_CLUSTER),true)
MAKE = usb-modules-v2/scripts/qmake.pl -n $@.$(NOW) -r $(NUM_ATTEMPTS) -m -s -- make
endif

define RUN_MAKE_J
$(MAKE) -e -f $1 -j $2 $(TARGET) && \
	mkdir -p completed_tasks && \
	touch completed_tasks/$@
endef

RUN_MAKE = $(call RUN_MAKE_J,$1,$(NUM_JOBS))

#########################################################
## The set of targets below have been at least 
## somewhat tested
##########################################################

TARGETS += bwamem
bwamem :
	$(call RUN_MAKE,usb-modules-v2/aligners/bwamemAligner.mk)

TARGETS += bwaaln
bwaaln :
	$(call RUN_MAKE,usb-modules-v2/aligners/bwaalnAligner.mk)

TARGETS += star
star :
	$(call RUN_MAKE,usb-modules-v2/aligners/starAligner.mk)

TARGETS += hisat2
hisat2 : 
	$(call RUN_MAKE,usb-modules-v2/aligners/hisat2Aligner.mk)

TARGETS += fastqc
fastqc :
	$(call RUN_MAKE,usb-modules-v2/qc/fastqc.mk)

TARGETS += bam_metrics
bam_metrics :
	$(call RUN_MAKE,usb-modules-v2/qc/bamMetrics.mk)

TARGETS += fix_rg
fix_rg :
	$(call RUN_MAKE,usb-modules-v2/bam_tools/fixRG.mk)

TARGETS += downsample_bam
downsample_bam :
	$(call RUN_MAKE,usb-modules-v2/bam_tools/downsampleBam.mk)

TARGETS += mutect
mutect :
	$(call RUN_MAKE,usb-modules-v2/variant_callers/somatic/mutect.mk)

TARGETS += rsem
rsem :
	$(call RUN_MAKE,usb-modules-v2/rnaseq/rsem.mk)

TARGETS += process_bam
process_bam : 
	$(call RUN_MAKE,usb-modules-v2/bam_tools/processBam.mk)

TARGETS += gatk
gatk : 
	$(call RUN_MAKE,usb-modules-v2/variant_callers/gatkVariantCaller.mk)

TARGETS += genotype
genotype :
	$(call RUN_MAKE,usb-modules-v2/qc/genotype.mk)

TARGETS += mutation_summary
mutation_summary :
	$(call RUN_MAKE,usb-modules-v2/summary/mutationSummary.mk)

TARGETS += panel_of_normal
panel_of_normal:
	$(call RUN_MAKE,usb-modules-v2/variant_callers/somatic/pon.mk)

TARGETS += strelka
strelka :
	$(call RUN_MAKE,usb-modules-v2/variant_callers/somatic/strelka.mk)

TARGETS += varscan_cnv
varscan_cnv :
	$(call RUN_MAKE,usb-modules-v2/copy_number/varscanCNV.mk)

TARGETS += poolednorm_bam
poolednorm_bam :
	$(call RUN_MAKE,usb-modules-v2/bam_tools/poolednormBam.mk)

TARGETS += screen_hotspots
screen_hotspots :
	$(call RUN_MAKE,usb-modules-v2/qc/screenHotspot.mk)

TARGETS += facets
facets :
	$(call RUN_MAKE,usb-modules-v2/copy_number/facets.mk)

TARGETS += facets_poolednorm
facets_poolednorm :
	$(call RUN_MAKE,usb-modules-v2/copy_number/facets_poolednorm.mk)

TARGETS += tvc_somatic
tvc_somatic :
	$(call RUN_MAKE,usb-modules-v2/variant_callers/somatic/TVC.mk)

TARGETS += ballgown
ballgown:
	$(call RUN_MAKE,usb-modules-v2/rnaseq/ballgown.mk)

TARGETS	+= deconstruct_sigs
deconstruct_sigs :
	$(call RUN_MAKE,usb-modules-v2/mut_sigs/deconstructSigs.mk)

TARGETS += lst
lst :
	$(call RUN_MAKE,usb-modules-v2/mut_sigs/lst.mk)

TARGETS += msisensor
msisensor :
	$(call RUN_MAKE,usb-modules-v2/mut_sigs/msiSensor.mk)

TARGETS += mosaics
mosaics :
	$(call RUN_MAKE,usb-modules-v2/chipseq/mosaics.mk)

TARGETS += absolute_seq
absolute_seq :
	$(call RUN_MAKE,usb-modules-v2/clonality/absoluteSeq.mk)

TARGETS += pyclone
pyclone : 
	$(call RUN_MAKE,usb-modules-v2/clonality/pyclone.mk)

TARGETS += expands
expands :
	$(call RUN_MAKE,usb-modules-v2/clonality/expands.mk)

TARGETS += star_fusion
star_fusion :
	$(call RUN_MAKE,usb-modules-v2/sv_callers/starFusion.mk)

TARGETS += contest
contest :
	$(call RUN_MAKE,usb-modules-v2/qc/contest.mk)

# annotate external vcfs
TARGETS += ann_ext_vcf
ann_ext_vcf: 
	$(call RUN_MAKE,usb-modules-v2/vcf_tools/annotateExtVcf.mk)

TARGETS += tvc
tvc :
	$(call RUN_MAKE,usb-modules-v2/variant_callers/TVC.mk)

TARGETS += sufam_screen
sufam_screen :
	$(call RUN_MAKE,usb-modules-v2/variant_callers/sufam.mk)

#########################################################
## The set of targets below have NOT been tested,
## or are known to be broken/obsolete.
##########################################################


TARGETS += merge_fastq
merge_fastq : 
	$(call RUN_MAKE,modules/fastq_tools/mergeFastq.mk)

TARGETS += tophat_fusion
tophat_fusion : 
	$(call RUN_MAKE,usb-modules/sv_callers/tophatFusion.mk)

TARGETS += cufflinks
cufflinks : 
	$(call RUN_MAKE,usb-modules-v2/rnaseq/cufflinks.mk)

# not tested on the cluster
# requires x11 for graphics
#TARGETS += interval_qc
#interval_qc :
#	$(call RUN_MAKE,modules/qc/intervalBamQC.mk)

#TARGETS += jsm
#jsm :
#	$(call RUN_MAKE,modules/variant_callers/somatic/jsm.mk)

TARGETS += mutect2
mutect2 :
	$(call RUN_MAKE,usb-modules-v2/variant_callers/somatic/mutect2.mk)


#TARGETS += varscan_fpfilter
#varscan_fpfilter :
#	$(call RUN_MAKE,modules/variant_callers/varscanFpfilter.mk)

TARGETS += varscanTN
varscanTN :
	$(call RUN_MAKE,usb-modules-v2/variant_callers/somatic/varscanTN.mk)

TARGETS += varscan
varscan :
	$(call RUN_MAKE,modules/variant_callers/varscan.mk)

# single sample mutation seq

TARGETS += merge_vcfTN
merge_vcfTN :
	$(call RUN_MAKE,modules/vcf_tools/vcfMergeTN.mk)

TARGETS += compare_vcf
compare_vcf :
	$(call RUN_MAKE,modules/vcf_tools/vcfCompare.mk)

TARGETS += merge_vcf_platform
merge_vcf_platform :
	$(call RUN_MAKE,modules/vcf_tools/vcfMergePlatform.mk)

TARGETS += compare_vcfTN
compare_vcfTN :
	$(call RUN_MAKE,modules/vcf_tools/vcfCompareTN.mk)

TARGETS += qualimap
qualimap :
	$(call RUN_MAKE,modules/qc/qualimap.mk)

TARGETS += hmmcopy
hmmcopy :
	$(call RUN_MAKE,modules/copy_number/hmmCopy.mk)

TARGETS += nfuse_wgss_wtss
nfuse_wgss_wtss :
	$(call RUN_MAKE,modules/copy_number/nfuseWGSSWTSS.mk)

TARGETS += sum_reads
sum_reads :
	$(call RUN_MAKE,usb-modules-v2/rnaseq/sumRNASeqReads.mk)

TARGETS += gistic
gistic :
	$(call RUN_MAKE,modules/copy_number/gistic.mk)

TARGETS += gistic_facets
gistic_facets :
	$(call RUN_MAKE,usb-modules-v2/copy_number/gisticFacets.mk)

NUM_DEFUSE_JOBS ?= 5
TARGETS += defuse
defuse :
	$(call RUN_MAKE_J,modules/sv_callers/defuse.mk,$(NUM_DEFUSE_JOBS))

NUM_CHIMSCAN_JOBS ?= 5
TARGETS += chimscan
chimscan :
	$(call RUN_MAKE_J,modules/sv_callers/chimerascan.mk,$(NUM_CHIMSCAN_JOBS))

TARGETS += oncofuse
oncofuse :
	$(call RUN_MAKE,modules/sv_callers/oncofuse.mk)

TARGETS += lumpy
lumpy :
	$(call RUN_MAKE,modules/sv_callers/lumpy.mk)

TARGETS += hydra
hydra :
	$(call RUN_MAKE,modules/sv_callers/hydra.mk)

TARGETS += pindel
pindel :
	$(call RUN_MAKE,modules/variant_callers/pindel.mk)

TARGETS += scalpel
scalpel :
	$(call RUN_MAKE,modules/variant_callers/somatic/scalpel.mk)

TARGETS += snp6
snp6 :
	$(call RUN_MAKE,modules/snp6/snp6.mk)

TARGETS += soapfuse
soapfuse :
	$(call RUN_MAKE,modules/sv_callers/soapFuse.mk)

TARGETS += mapsplice
mapsplice :
	$(call RUN_MAKE,modules/sv_callers/mapsplice.mk)

TARGETS += fusioncatcher
fusioncatcher :
	$(call RUN_MAKE,modules/sv_callers/fusioncatcher.mk)

TARGETS += crest
crest :
	$(call RUN_MAKE,modules/sv_callers/crest.mk)

TARGETS += extract_fastq
extract_fastq :
	$(call RUN_MAKE,modules/fastq_tools/extractFastq.mk)

TARGETS += titan
titan :
	$(call RUN_MAKE,modules/copy_number/titan.mk)

TARGETS += ann_titan
ann_titan :
	$(call RUN_MAKE,modules/copy_number/annotateTitan.mk)

TARGETS += samtools_het
samtools_het :
	$(call RUN_MAKE,modules/variant_callers/samtoolsHet.mk)

TARGETS += merge_strelka_varscan
merge_strelka_varscan :
	$(call RUN_MAKE,modules/variant_callers/somatic/mergeStrelkaVarscanIndels.mk)

TARGETS += rseqc
rseqc :
	$(call RUN_MAKE,modules/qc/rseqc.mk)

TARGETS += integrate_rnaseq
integrate_rnaseq :
	$(call RUN_MAKE,modules/sv_callers/integrateRnaseq.mk)

TARGETS += integrate
integrate :
	$(call RUN_MAKE,modules/sv_callers/integrate.mk)

TARGETS += merge_split_fastq
merge_split_fastq :
	$(call RUN_MAKE,modules/fastq_tools/mergeSplitFastq.mk)

TARGETS += virus_detection_bowtie2
virus_detection_bowtie2 :
	$(call RUN_MAKE,modules/virus/virus_detection_bowtie2.mk)


TARGETS += gatk_validation
gatk_validation :
	$(call RUN_MAKE,modules/variant_callers/somatic/gatkValidation.mk)

TARGETS += samtools_validation
samtools_validation :
	$(call RUN_MAKE,modules/variant_callers/somatic/samtoolsValidation.mk)

TARGETS += norm_copynum
norm_copynum :
	$(call RUN_MAKE,modules/copy_number/normalisedCopyNum.mk)

TARGETS += recurrent_mutations
recurrent_mutations :
	$(call RUN_MAKE,modules/recurrent_mutations/report.mk)

TARGETS += brass
brass :
	$(call RUN_MAKE,modules/sv_callers/brass.mk)

TARGETS += mutsig_report
mutsig_report :
	$(call RUN_MAKE,modules/mut_sigs/mutSigReport.mk)

# standalone bam file merger
TARGETS += merge_bam
merge_bam :
	$(call RUN_MAKE,usb-modules-v2/bam_tools/mergeBam.mk)

TARGETS += mutsigcv
mutsigcv :
	$(call RUN_MAKE,usb-modules-v2/siggenes/mutsigcv.mk)


.PHONY : $(TARGETS)
