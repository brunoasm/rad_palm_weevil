//Parameters for the coalescence simulation program : fastsimcoal.exe
2 samples to simulate :
//Population effective sizes (number of genes)
NPOPA
NPOPB
//Samples sizes and samples age 
24
20
//Growth rates	: negative growth implies population expansion
0
0
//Number of migration matrices : 0 implies no migration between demes
2
//Migration matrix 0
0     MIG12 
MIG21 0     
//Migration matrix 1
0     0    
0     0   
//historical event: time, source, sink, migrants, new deme size, new growth rate, migration matrix index
1 historical event
T1 0 1 1 SIZE1 0 1
//Number of independent loci [chromosome] 
1 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per generation recombination and mutation rates and optional parameters
FREQ 1 0 3e-9 OUTEXP
