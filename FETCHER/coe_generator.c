#include <stdio.h>

#define IMG_WIDTH        84
#define IMG_HEIGHT       84
#define TOTAL_PIXELS     (IMG_WIDTH * IMG_HEIGHT)  // 7056

#define CONV_FIRST_0_WEIGHT_SIZE  4200  // 75x56 = 4200
#define CONV_FIRST_0_BIAS_SIZE    56    // output channel
#define CONV_FIRST_1_ALPHA_SIZE   56    //

#define CONV_SHRINK_0_WEIGHT_SIZE 1*1*56*12
#define CONV_SHRINK_0_BIAS_SIZE   12
#define CONV_SHRINK_1_ALPHA_SIZE  12

#define CONV_MAPPING_WEIGHT_SIZE 3*3*12*12
#define CONV_MAPPING_BIAS_SIZE   12
#define CONV_MAPPING_NUM         4
#define CONV_MAPPING_ALPHA_SIZE  12 

#define CONV_EXPAND_0_WEIGHT_SIZE 1*1*12*56
#define CONV_EXPAND_0_BIAS_SIZE   56
#define CONV_EXPAND_1_ALPHA_SIZE  56

#define CONV_LAST_WEIGHT_SIZE     9*9*56*3
#define CONV_LAST_BIAS_SIZE       3

char conv_first_weight[4200][3];
char conv_first_bias[56][3];
char conv_first_slope[56][3];

int main() {
	
	FILE* fp_coe = fopen("fetcher.coe", "w");
	
	fprintf(fp_coe, "memory_initialization_radix=16;\n");
	
	fprintf(fp_coe, "memory_initialization_vector=\n");
	
	FILE* fp_input_0 = fopen("input_0.txt", "r");
	FILE* fp_input_1 = fopen("input_1.txt", "r");
	FILE* fp_input_2 = fopen("input_2.txt", "r");
	
	for (int i = 0; i < TOTAL_PIXELS; i++) {
		char string[9] = {};
		
		char temp[6] = {};
		fscanf(fp_input_0, "%s", temp);
		string[0] = temp[1];
		string[1] = temp[2];
		
		fscanf(fp_input_1, "%s", temp);
		string[2] = temp[1];
		string[3] = temp[2];
		
		fscanf(fp_input_2, "%s", temp);
		string[4] = temp[1];
		string[5] = temp[2];
		
		string[6] = '0';
		string[7] = '0';
		
		fprintf(fp_coe, "%s,\n", string);
	}

	fclose(fp_input_0);
	fclose(fp_input_1);
	fclose(fp_input_2);

	FILE* fp_conv_first_weight[56];
	for (int i = 0; i < 56; i++) {
		char dirname[] = "..\\File Extractor\\result_butterfly\\conv_first\\";
		char filename_pre_idx[] = "conv_first_weight_";
		char filename_postfix[] = ".txt";
		
		char filename_idx[3];
		sprintf(filename_idx, "%d", i);
		
		char filename[100];
		sprintf(filename, "%s%s%s%s", dirname, filename_pre_idx, filename_idx, filename_postfix);
		
		fp_conv_first_weight[i] = fopen(filename, "r");
		
		for (int j = 0; j < 75; j++) {
			fscanf(fp_conv_first_weight[i], "%s", conv_first_weight[i * 75 + j]);
		}
		
		fclose(fp_conv_first_weight[i]);
	}
	
	for (int i = 0; i < 4200; i += 4) {
		fprintf(fp_coe, "%s%s%s%s,\n", conv_first_weight[i], conv_first_weight[i+1], conv_first_weight[i+2], conv_first_weight[i+3]);
	}
	
	FILE* fp_conv_first_bias[56];
	for (int i = 0; i < 56; i++) {
		char dirname[] = "..\\File Extractor\\result_butterfly\\conv_first\\";
		char filename_pre_idx[] = "conv_first_bias_";
		char filename_postfix[] = ".txt";
		
		char filename_idx[3];
		sprintf(filename_idx, "%d", i);
		
		char filename[100];
		sprintf(filename, "%s%s%s%s", dirname, filename_pre_idx, filename_idx, filename_postfix);
		
		fp_conv_first_bias[i] = fopen(filename, "r");

		fscanf(fp_conv_first_bias[i], "%s", conv_first_bias[i]);

		fclose(fp_conv_first_bias[i]);
	}
	
	for (int i = 0; i < 56; i += 4) {
		fprintf(fp_coe, "%s%s%s%s,\n", conv_first_bias[i], conv_first_bias[i+1], conv_first_bias[i+2], conv_first_bias[i+3]);
	}
	
	FILE* fp_conv_first_slope[56];
	for (int i = 0; i < 56; i++) {
		char dirname[] = "..\\File Extractor\\result_butterfly\\conv_first\\";
		char filename_pre_idx[] = "conv_first_slope_";
		char filename_postfix[] = ".txt";
		
		char filename_idx[3];
		sprintf(filename_idx, "%d", i);
		
		char filename[100];
		sprintf(filename, "%s%s%s%s", dirname, filename_pre_idx, filename_idx, filename_postfix);
		
		fp_conv_first_slope[i] = fopen(filename, "r");
		
		fscanf(fp_conv_first_slope[i], "%s", conv_first_slope[i]);
		
		fclose(fp_conv_first_slope[i]);
	}
	
	for (int i = 0; i < 56; i += 4) {
		fprintf(fp_coe, "%s%s%s%s,\n", conv_first_slope[i], conv_first_slope[i+1], conv_first_slope[i+2], conv_first_slope[i+3]);
	}
	
	FILE* fp_conv_shrink_weight = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_shrink.0_weight.csv", "r");
	FILE* fp_conv_shrink_bias = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_shrink.0_bias.csv", "r");
	FILE* fp_conv_shrink_slope = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_shrink.1_alpha.csv", "r");
	
	FILE* fp_conv_mapping_0_weight = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.0_weight.csv", "r");
	FILE* fp_conv_mapping_0_bias = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.0_bias.csv", "r");
	
	FILE* fp_conv_mapping_1_weight = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.1_weight.csv", "r");
	FILE* fp_conv_mapping_1_bias = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.1_bias.csv", "r");
	
	FILE* fp_conv_mapping_2_weight = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.2_weight.csv", "r");
	FILE* fp_conv_mapping_2_bias = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.2_bias.csv", "r");
	
	FILE* fp_conv_mapping_3_weight = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.3_weight.csv", "r");
	FILE* fp_conv_mapping_3_bias = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.3_bias.csv", "r");
	FILE* fp_conv_mapping_3_slope = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_mapping.4_alpha.csv", "r");
	
	FILE* fp_conv_expanding_weight = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_expanding.0_weight.csv", "r");
	FILE* fp_conv_expanding_bias = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_expanding.0_bias.csv", "r");
	FILE* fp_conv_expanding_slope = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_expanding.1_alpha.csv", "r");
	
	FILE* fp_conv_last_weight = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_last_weight.csv", "r");
	FILE* fp_conv_last_bias = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_last_bias.csv", "r");
	
	fclose(fp_coe);
	
	return 0;
}
