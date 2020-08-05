sort5:	# 0xe0
	.dynsym	sort5	sto_default
	.frame	$sp, 0, $31
	.loc	1 28 21
 #  26  
 #  27  
 #  28  void sort5 (int *x) {
.BB1.sort5:	# 0xe0
 #<freq>
 #<freq> BB:1 frequency = 1.00000 (heuristic)
 #<freq>
	.loc	1 34 9
 #  30      int a0=x[0];
 #  31      int a1=x[1];
 #  32      int a2=x[2];
 #  33      int a3=x[3];
 #  34      int a4=x[4];
	lw $5,16($4)                  	# [0]  id:110
	.loc	1 33 9
	lw $24,12($4)                 	# [1]  id:109
	.loc	1 31 9
	lw $14,4($4)                  	# [2]  id:107
	.loc	1 32 9
	lw $13,8($4)                  	# [3]  id:108
	.loc	1 38 5
 #  35      int tmp;
 #  36      /* Do a minimal sort */
 #  37      MSWAP(a1,a2);
 #  38      MSWAP(a3,a4);
	or $8,$24,$0                  	# [3]  
	.loc	1 37 5
	slt $15,$5,$24                	# [3]  
	or $11,$14,$0                 	# [4]  
	movz $8,$5,$15                	# [4]  
	.loc	1 34 9
	slt $12,$13,$14               	# [5]  
	movz $5,$24,$15               	# [5]  
	movz $11,$13,$12              	# [6]  
	.loc	1 30 9
	lw $7,0($4)                   	# [7]  id:106
	movz $13,$14,$12              	# [7]  
	.loc	1 39 5
 #  39      MSWAP(a1,a3);
	or $3,$13,$0                  	# [8]  
	.loc	1 38 5
	slt $12,$5,$13                	# [8]  
	.loc	1 40 5
 #  40      MSWAP(a0,a2);
	or $25,$7,$0                  	# [9]  
	movz $3,$5,$12                	# [9]  
	movz $5,$13,$12               	# [10]  
	.loc	1 39 5
	slt $6,$11,$7                 	# [10]  
	movz $25,$11,$6               	# [11]  
	movz $11,$7,$6                	# [12]  
	.loc	1 42 5
 #  41      MSWAP(a2,a4);
 #  42      MSWAP(a0,a3);
	or $1,$11,$0                  	# [13]  
	.loc	1 41 5
	slt $6,$3,$11                 	# [13]  
	or $10,$25,$0                 	# [14]  
	movz $1,$3,$6                 	# [14]  
