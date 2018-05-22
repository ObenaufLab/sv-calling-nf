/*
* MIT License
*
* Copyright (c) 2018 Lukas Leiendecker
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

def helpMessage() {
    log.info"""
    ================================================================
    sv-calling-nf
    ================================================================
    DESCRIPTION
    Usage:
    nextflow run obenauflab/sv-calling-nf
    Options:
        --name      Name for sample
        --tumor     Path to tumor BAM file
        --normal    Path to normal BAM file
        --ref				Path to reference fasta file
    Profiles:
        standard            local execution
        sge			            SGE execution with singularity on IMPIMBA1
        slurm               SLURM execution with singularity on IMPIMBA2

    Author:
    Lukas Leiendecker (lukas.leiendecker@imp.ac.at)
    """.stripIndent()
}


Channel
    .fromPath( params.samples )
    .splitCsv(sep: '\t', header: true)
    .set { samples }


// delly
// https://hub.docker.com/r/dellytools/delly/

process delly {

    publishDir "results/!{params.name}/"

    input:
    val(parameters) from samples

    output:
    file('*.bcf') into outDelly
    file('*.vcf') into outDelly

    """
    export OMP_NUM_THREADS=2
    delly call \
    -g !{params.ref} \
    -o !{params.name}.bcf \
    -n \
    !{params.tumor} !{params.normal}

    bcftools view !{params.name}.bcf > !{params.name}.vcf

    """
}



// manta








// lumpy






// BRASS
