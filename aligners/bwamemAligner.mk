# vim: set ft=make :
# BWA-mem alignment of short reads
# OPTIONS: NO_MARKDUP = true/false (default: false)
# 		   EXTRACT_FASTQ = true/false (default: false)
# 		   BAM_NO_RECAL = true/false (default: false)
ALIGNER := bwamem

include usb-modules-v2/Makefile.inc
include usb-modules-v2/aligners/align.inc

LOGDIR ?= log/bwamem.$(NOW)

VPATH ?= unprocessed_bam

..DUMMY := $(shell mkdir -p version; $(BWA) &> version/bwamem.txt; echo "options: $(BWA_ALN_OPTS)" >> version/bwamem.txt )
.SECONDARY:
.DELETE_ON_ERROR: 
.PHONY: bwamem

ifeq ($(strip $(PRIMARY_ALIGNER)),bwamem)
BWA_BAMS = $(foreach sample,$(SAMPLES),bam/$(sample).bam)
else
BWA_BAMS = $(foreach sample,$(SAMPLES),bwamem/bam/$(sample).bwamem.bam)
endif

bwamem : $(BWA_BAMS) $(addsuffix .bai,$(BWA_BAMS))

bam/%.bam : bwamem/bam/%.bwamem.$(BAM_SUFFIX)
	$(INIT) ln -f $< $@

#$(call align-split-fastq,name,split-name,fastqs)
define align-split-fastq
bwamem/bam/$2.bwamem.bam : $3
	$$(call RUN,$$(BWA_NUM_CORES),$$(RESOURCE_REQ_LOW_MEM),$$(RESOURCE_REQ_MEDIUM),$$(BWA_MODULE) $$(SAMTOOLS_MODULE),"\
	$$(BWA_MEM) -t $$(BWA_NUM_CORES) $$(BWA_ALN_OPTS) \
	-R \"@RG\tID:$2\tLB:$1\tPL:$${SEQ_PLATFORM}\tSM:$1\" $$(REF_FASTA) $$^ | \
	$$(SAMTOOLS) view -bhS - > $$@")
endef
$(foreach ss,$(SPLIT_SAMPLES),$(if $(fq.$(ss)),$(eval $(call align-split-fastq,$(split.$(ss)),$(ss),$(fq.$(ss))))))

bwamem/bam/%.bwamem.bam : fastq/%.1.fastq.gz $(if $(findstring true,$(PAIRED_END)),fastq/%.2.fastq.gz)
	LBID=`echo "$*" | sed 's/_[A-Za-z0-9]\+//'`; \
	$(call RUN,$(BWA_NUM_CORES),$(RESOURCE_REQ_LOW_MEM),$(RESOURCE_REQ_MEDIUM),$(BWA_MODULE) $(SAMTOOLS_MODULE),"\
	$(BWA_MEM) -t $(BWA_NUM_CORES) $(BWA_ALN_OPTS) \
	-R \"@RG\tID:$*\tLB:$${LBID}\tPL:${SEQ_PLATFORM}\tSM:$${LBID}\" $(REF_FASTA) $^ | \
	$(SAMTOOLS) view -bhS - > $@")

fastq/%.fastq.gz : fastq/%.fastq
	$(call RUN,1,$(RESOURCE_REQ_LOW_MEM),$(RESOURCE_REQ_SHORT),,"gzip -c $< > $(@) && $(RM) $<")

include usb-modules-v2/fastq_tools/fastq.mk
include usb-modules-v2/bam_tools/processBam.mk
include usb-modules-v2/aligners/align.mk
