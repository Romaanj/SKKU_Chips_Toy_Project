#pragma GCC optimize ("O3,unroll-loops")
#pragma GCC target ("avx,avx2,fma")
#include <immintrin.h>

#include <stdio.h>
#include <math.h>
#include <sys/time.h>

#define NUM_INPUT_CHANNEL 3

#define NUM_CONV_FIRST_RESULT_CHANNEL 56
#define CONV_FIRST_KERNEL_SIZE 5

#define NUM_CONV_SHRINK_RESULT_CHANNEL 12
#define CONV_SHRINK_KERNEL_SIZE 1

#define NUM_CONV_MAPPING_RESULT_CHANNEL 12
#define CONV_MAPPING_KERNEL_SIZE 3

#define NUM_CONV_EXPANDING_RESULT_CHANNEL 56
#define CONV_EXPANDING_KERNEL_SIZE 1

#define NUM_CONV_LAST_RESULT_CHANNEL 3
#define CONV_LAST_KERNEL_SIZE 9

#define INPUT_HSIZE 84
#define INPUT_VSIZE 84

double input[NUM_INPUT_CHANNEL][INPUT_VSIZE][INPUT_HSIZE];

double conv_first_weight[NUM_CONV_FIRST_RESULT_CHANNEL][NUM_INPUT_CHANNEL][CONV_FIRST_KERNEL_SIZE * CONV_FIRST_KERNEL_SIZE];
double conv_first_bias[NUM_CONV_FIRST_RESULT_CHANNEL];
double conv_first_slope[NUM_CONV_FIRST_RESULT_CHANNEL];
double conv_first_result[NUM_CONV_FIRST_RESULT_CHANNEL][INPUT_VSIZE][INPUT_HSIZE];

double conv_shrink_weight[NUM_CONV_SHRINK_RESULT_CHANNEL][NUM_CONV_FIRST_RESULT_CHANNEL];
double conv_shrink_bias[NUM_CONV_SHRINK_RESULT_CHANNEL];
double conv_shrink_slope[NUM_CONV_SHRINK_RESULT_CHANNEL];
double conv_shrink_result[NUM_CONV_SHRINK_RESULT_CHANNEL][INPUT_VSIZE][INPUT_HSIZE];

double conv_mapping_0_weight[NUM_CONV_MAPPING_RESULT_CHANNEL][NUM_CONV_SHRINK_RESULT_CHANNEL][CONV_MAPPING_KERNEL_SIZE * CONV_MAPPING_KERNEL_SIZE];
double conv_mapping_0_bias[NUM_CONV_MAPPING_RESULT_CHANNEL];
double conv_mapping_0_result[NUM_CONV_MAPPING_RESULT_CHANNEL][INPUT_VSIZE][INPUT_HSIZE];

double conv_mapping_1_weight[NUM_CONV_MAPPING_RESULT_CHANNEL][NUM_CONV_MAPPING_RESULT_CHANNEL][CONV_MAPPING_KERNEL_SIZE * CONV_MAPPING_KERNEL_SIZE];
double conv_mapping_1_bias[NUM_CONV_MAPPING_RESULT_CHANNEL];
double conv_mapping_1_result[NUM_CONV_MAPPING_RESULT_CHANNEL][INPUT_VSIZE][INPUT_HSIZE];

double conv_mapping_2_weight[NUM_CONV_MAPPING_RESULT_CHANNEL][NUM_CONV_MAPPING_RESULT_CHANNEL][CONV_MAPPING_KERNEL_SIZE * CONV_MAPPING_KERNEL_SIZE];
double conv_mapping_2_bias[NUM_CONV_MAPPING_RESULT_CHANNEL];
double conv_mapping_2_result[NUM_CONV_MAPPING_RESULT_CHANNEL][INPUT_VSIZE][INPUT_HSIZE];

double conv_mapping_3_weight[NUM_CONV_MAPPING_RESULT_CHANNEL][NUM_CONV_MAPPING_RESULT_CHANNEL][CONV_MAPPING_KERNEL_SIZE * CONV_MAPPING_KERNEL_SIZE];
double conv_mapping_3_bias[NUM_CONV_MAPPING_RESULT_CHANNEL];
double conv_mapping_3_slope[NUM_CONV_MAPPING_RESULT_CHANNEL];
double conv_mapping_3_result[NUM_CONV_MAPPING_RESULT_CHANNEL][INPUT_VSIZE][INPUT_HSIZE];

double conv_expanding_weight[NUM_CONV_EXPANDING_RESULT_CHANNEL][NUM_CONV_MAPPING_RESULT_CHANNEL];
double conv_expanding_bias[NUM_CONV_EXPANDING_RESULT_CHANNEL];
double conv_expanding_slope[NUM_CONV_EXPANDING_RESULT_CHANNEL];
double conv_expanding_result[NUM_CONV_EXPANDING_RESULT_CHANNEL][INPUT_VSIZE][INPUT_HSIZE];

double conv_last_weight[NUM_CONV_LAST_RESULT_CHANNEL][NUM_CONV_EXPANDING_RESULT_CHANNEL][CONV_LAST_KERNEL_SIZE * CONV_LAST_KERNEL_SIZE];
double conv_last_bias[NUM_CONV_LAST_RESULT_CHANNEL];
double conv_last_result[NUM_CONV_LAST_RESULT_CHANNEL][INPUT_VSIZE * 3][INPUT_HSIZE * 3];

char temp_output_hex[6];

double Q4_15_to_Double(char* q) {
	// sizeof(q) must be 5
	// q must be '0'-'9' or 'A'-'F'
	
	double result = 0.0;
	for (int i = 4, power = 1; i >= 0; i--, power *= 16) {
		int temp;
		if (q[i] <= '9') {
			temp = q[i] - '0';
		}
		else {
			temp = q[i] - 'A' + 10;
		}
		result += temp * power;
	}

	/*
	if (result >= (1 << 19)) {
		result -= (1 << 19);
	}
	*/

	result /= (1 << 15);
	
	return result;
}

void READ_INPUT() {
	// three txt files must be in the same directory as this code.
	FILE* fp_input_0 = fopen("input_0.txt", "r");
	FILE* fp_input_1 = fopen("input_1.txt", "r");
	FILE* fp_input_2 = fopen("input_2.txt", "r");

	FILE* fp_conv_first_weight = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_first.0_weight.csv", "r");
	FILE* fp_conv_first_bias = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_first.0_bias.csv", "r");
	FILE* fp_conv_first_slope = fopen("..\\..\\int8_params_scale_fixed_retraining\\conv_first.1_alpha.csv", "r");

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
	
	for (int ch = 0; ch < NUM_INPUT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				char temp[6];
				
				if (ch == 0) {
					fscanf(fp_input_0, "%s", temp);
				}
				else if (ch == 1) {
					fscanf(fp_input_1, "%s", temp);
				}
				else {
					fscanf(fp_input_2, "%s", temp);
				}

				double dtemp = Q4_15_to_Double(temp);
				input[ch][i][j] = dtemp;
			}
		}
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_FIRST_RESULT_CHANNEL; o_ch++) {
		for (int i_ch = 0; i_ch < NUM_INPUT_CHANNEL; i_ch++) {
			for (int i = 0; i < CONV_FIRST_KERNEL_SIZE * CONV_FIRST_KERNEL_SIZE; i++) {
				int temp;
				fscanf(fp_conv_first_weight, "%d,", &temp);
				conv_first_weight[o_ch][i_ch][i] = temp;
			}
		}
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_FIRST_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_first_bias, "%d,", &temp);
		conv_first_bias[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_FIRST_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_first_slope, "%d,", &temp);
		conv_first_slope[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_SHRINK_RESULT_CHANNEL; o_ch++) {
		for (int i_ch = 0; i_ch < NUM_CONV_FIRST_RESULT_CHANNEL; i_ch++) {
			for (int i = 0; i < CONV_SHRINK_KERNEL_SIZE * CONV_SHRINK_KERNEL_SIZE; i++) {
				int temp;
				fscanf(fp_conv_shrink_weight, "%d,", &temp);
				conv_shrink_weight[o_ch][i_ch] = temp;
			}
		}
	}

	for (int o_ch = 0; o_ch < NUM_CONV_SHRINK_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_shrink_bias, "%d,", &temp);
		conv_shrink_bias[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_SHRINK_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_shrink_slope, "%d,", &temp);
		conv_shrink_slope[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		for (int i_ch = 0; i_ch < NUM_CONV_SHRINK_RESULT_CHANNEL; i_ch++) {
			for (int i = 0; i < CONV_MAPPING_KERNEL_SIZE * CONV_MAPPING_KERNEL_SIZE; i++) {
				int temp;
				fscanf(fp_conv_mapping_0_weight, "%d,", &temp);
				conv_mapping_0_weight[o_ch][i_ch][i] = temp;
			}
		}
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_mapping_0_bias, "%d,", &temp);
		conv_mapping_0_bias[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		for (int i_ch = 0; i_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; i_ch++) {
			for (int i = 0; i < CONV_MAPPING_KERNEL_SIZE * CONV_MAPPING_KERNEL_SIZE; i++) {
				int temp;
				fscanf(fp_conv_mapping_1_weight, "%d,", &temp);
				conv_mapping_1_weight[o_ch][i_ch][i] = temp;
			}
		}
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_mapping_1_bias, "%d,", &temp);
		conv_mapping_1_bias[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		for (int i_ch = 0; i_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; i_ch++) {
			for (int i = 0; i < CONV_MAPPING_KERNEL_SIZE * CONV_MAPPING_KERNEL_SIZE; i++) {
				int temp;
				fscanf(fp_conv_mapping_2_weight, "%d,", &temp);
				conv_mapping_2_weight[o_ch][i_ch][i] = temp;
			}
		}
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_mapping_2_bias, "%d,", &temp);
		conv_mapping_2_bias[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		for (int i_ch = 0; i_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; i_ch++) {
			for (int i = 0; i < CONV_MAPPING_KERNEL_SIZE * CONV_MAPPING_KERNEL_SIZE; i++) {
				int temp;
				fscanf(fp_conv_mapping_3_weight, "%d,", &temp);
				conv_mapping_3_weight[o_ch][i_ch][i] = temp;
			}
		}
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_mapping_3_bias, "%d,", &temp);
		conv_mapping_3_bias[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_mapping_3_slope, "%d,", &temp);
		conv_mapping_3_slope[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_EXPANDING_RESULT_CHANNEL; o_ch++) {
		for (int i_ch = 0; i_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; i_ch++) {
			for (int i = 0; i < CONV_EXPANDING_KERNEL_SIZE * CONV_EXPANDING_KERNEL_SIZE; i++) {
				int temp;
				fscanf(fp_conv_expanding_weight, "%d,", &temp);
				conv_expanding_weight[o_ch][i_ch] = temp;
			}
		}
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_EXPANDING_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_expanding_bias, "%d,", &temp);
		conv_expanding_bias[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_EXPANDING_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_expanding_slope, "%d,", &temp);
		conv_expanding_slope[o_ch] = temp;
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_LAST_RESULT_CHANNEL; o_ch++) {
		for (int i_ch = 0; i_ch < NUM_CONV_EXPANDING_RESULT_CHANNEL; i_ch++) {
			for (int i = 0; i < CONV_LAST_KERNEL_SIZE * CONV_LAST_KERNEL_SIZE; i++) {
				int temp;
				fscanf(fp_conv_last_weight, "%d,", &temp);
				conv_last_weight[o_ch][i_ch][i] = temp;
			}
		}
	}
	
	for (int o_ch = 0; o_ch < NUM_CONV_LAST_RESULT_CHANNEL; o_ch++) {
		int temp;
		fscanf(fp_conv_last_bias, "%d,", &temp);
		conv_last_bias[o_ch] = temp;
	}

	fclose(fp_input_0);
	fclose(fp_input_1);
	fclose(fp_input_2);
	
	fclose(fp_conv_first_weight);
	fclose(fp_conv_first_bias);
	fclose(fp_conv_first_slope);
	
	fclose(fp_conv_shrink_weight);
	fclose(fp_conv_shrink_bias);
	fclose(fp_conv_shrink_slope);
	
	fclose(fp_conv_mapping_0_weight);
	fclose(fp_conv_mapping_0_bias);
	
	fclose(fp_conv_mapping_1_weight);
	fclose(fp_conv_mapping_1_bias);
	
	fclose(fp_conv_mapping_2_weight);
	fclose(fp_conv_mapping_2_bias);
	
	fclose(fp_conv_mapping_3_weight);
	fclose(fp_conv_mapping_3_bias);
	fclose(fp_conv_mapping_3_slope);
	
	fclose(fp_conv_expanding_weight);
	fclose(fp_conv_expanding_bias);
	fclose(fp_conv_expanding_slope);
	
	fclose(fp_conv_last_weight);
	fclose(fp_conv_last_bias);

	return;
}

void Double_to_Q4_15 (double operand) {
	int temp = round(operand * (1 << 15));
	sprintf(temp_output_hex, "%05X", temp);
	//printf("%s\n", temp_output_hex);
	return;
}

void WRITE_OUTPUT() {
	FILE* fp_output_0 = fopen("C_model_output_0.txt", "w");
	FILE* fp_output_1 = fopen("C_model_output_1.txt", "w");
	FILE* fp_output_2 = fopen("C_model_output_2.txt", "w");
	
	for (int o_ch = 0; o_ch < NUM_CONV_LAST_RESULT_CHANNEL; o_ch++) {
		for (int i = 0; i < INPUT_VSIZE * 3; i++) {
			for (int j = 0; j < INPUT_HSIZE * 3; j++) {
				Double_to_Q4_15(conv_last_result[o_ch][i][j]);
				if (o_ch == 0) {
					fprintf(fp_output_0, "%s\n", temp_output_hex);
				}
				else if (o_ch == 1) {
					fprintf(fp_output_1, "%s\n", temp_output_hex);
				}
				else {
					fprintf(fp_output_2, "%s\n", temp_output_hex);
				}
			}
		}
	}
	
	fclose(fp_output_0);
	fclose(fp_output_1);
	fclose(fp_output_2);
	return;
}

void CONV_FIRST() {
	for (int o_ch = 0; o_ch < NUM_CONV_FIRST_RESULT_CHANNEL; o_ch++) {
		double current_bias = conv_first_bias[o_ch];
		double current_slope = conv_first_slope[o_ch];
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				double temp = 0.0;
				for (int i_ch = 0; i_ch < NUM_INPUT_CHANNEL; i_ch++) {
					for (int ii = i - 2; ii <= i + 2; ii++) {
						for (int jj = j - 2; jj <= j + 2; jj++) {
							if (!((ii < 0) || (jj < 0) || (ii >= INPUT_VSIZE) || (jj >= INPUT_HSIZE))) {
								temp = temp + conv_first_weight[o_ch][i_ch][(ii - i) * 5 + (jj - j) + 12] * input[i_ch][ii][jj];
							}
						}
					}
				}
				temp = (temp + current_bias) / 256;
				conv_first_result[o_ch][i][j] = temp < 0 ? (temp / 128) * current_slope : temp;
			}
		}
	}
	return;
}

void CONV_SHRINK() {
	for (int o_ch = 0; o_ch < NUM_CONV_SHRINK_RESULT_CHANNEL; o_ch++) {
		double current_bias = conv_shrink_bias[o_ch];
		double current_slope = conv_shrink_slope[o_ch];
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				double temp = 0.0;
				for (int i_ch = 0; i_ch < NUM_CONV_FIRST_RESULT_CHANNEL; i_ch++) {
					temp = temp + conv_shrink_weight[o_ch][i_ch] * conv_first_result[i_ch][i][j];
				}
				temp = (temp + current_bias) / 256;
				conv_shrink_result[o_ch][i][j] = temp < 0 ? (temp / 256) * current_slope : temp;
			}
		}
	}
	return;
}

void CONV_MAPPING_0() {
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		double current_bias = conv_mapping_0_bias[o_ch];
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				double temp = 0.0;
				for (int i_ch = 0; i_ch < NUM_CONV_SHRINK_RESULT_CHANNEL; i_ch++) {
					for (int ii = i - 1; ii <= i + 1; ii++) {
						for (int jj = j - 1; jj <= j + 1; jj++) {
							if (!((ii < 0) || (jj < 0) || (ii >= INPUT_VSIZE) || (jj >= INPUT_HSIZE))) {
								temp = temp + conv_mapping_0_weight[o_ch][i_ch][(ii - i) * 3 + (jj - j) + 4] * conv_shrink_result[i_ch][ii][jj];
							}
						}
					}
				}
				conv_mapping_0_result[o_ch][i][j] = (temp + current_bias) / 1024;
			}
		}
	}
	return;
}

void CONV_MAPPING_1() {
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		double current_bias = conv_mapping_1_bias[o_ch];
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				double temp = 0.0;
				for (int i_ch = 0; i_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; i_ch++) {
					for (int ii = i - 1; ii <= i + 1; ii++) {
						for (int jj = j - 1; jj <= j + 1; jj++) {
							if (!((ii < 0) || (jj < 0) || (ii >= INPUT_VSIZE) || (jj >= INPUT_HSIZE))) {
								temp = temp + conv_mapping_1_weight[o_ch][i_ch][(ii - i) * 3 + (jj - j) + 4] * conv_mapping_0_result[i_ch][ii][jj];
							}
						}
					}
				}
				conv_mapping_1_result[o_ch][i][j] = (temp + current_bias) / 1024;
			}
		}
	}
	return;
}

void CONV_MAPPING_2() {
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		double current_bias = conv_mapping_2_bias[o_ch];
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				double temp = 0.0;
				for (int i_ch = 0; i_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; i_ch++) {
					for (int ii = i - 1; ii <= i + 1; ii++) {
						for (int jj = j - 1; jj <= j + 1; jj++) {
							if (!((ii < 0) || (jj < 0) || (ii >= INPUT_VSIZE) || (jj >= INPUT_HSIZE))) {
								temp = temp + conv_mapping_2_weight[o_ch][i_ch][(ii - i) * 3 + (jj - j) + 4] * conv_mapping_1_result[i_ch][ii][jj];
							}
						}
					}
				}
				conv_mapping_2_result[o_ch][i][j] = (temp + current_bias) / 512;
			}
		}
	}
	return;
}

void CONV_MAPPING_3() {
	for (int o_ch = 0; o_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; o_ch++) {
		double current_bias = conv_mapping_3_bias[o_ch];
		double current_slope = conv_mapping_3_slope[o_ch];
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				double temp = 0.0;
				for (int i_ch = 0; i_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; i_ch++) {
					for (int ii = i - 1; ii <= i + 1; ii++) {
						for (int jj = j - 1; jj <= j + 1; jj++) {
							if (!((ii < 0) || (jj < 0) || (ii >= INPUT_VSIZE) || (jj >= INPUT_HSIZE))) {
								temp = temp + conv_mapping_3_weight[o_ch][i_ch][(ii - i) * 3 + (jj - j) + 4] * conv_mapping_2_result[i_ch][ii][jj];
							}
						}
					}
				}
				temp = (temp + current_bias) / 1024;
				conv_mapping_3_result[o_ch][i][j] = temp < 0 ? (temp / 512) * current_slope : temp;
			}
		}
	}
	return;
}

void CONV_EXPANDING() {
	for (int o_ch = 0; o_ch < NUM_CONV_EXPANDING_RESULT_CHANNEL; o_ch++) {
		double current_bias = conv_expanding_bias[o_ch];
		double current_slope = conv_expanding_slope[o_ch];
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				double temp = 0.0;
				for (int i_ch = 0; i_ch < NUM_CONV_MAPPING_RESULT_CHANNEL; i_ch++) {
					temp = temp + conv_expanding_weight[o_ch][i_ch] * conv_mapping_3_result[i_ch][i][j];
				}
				temp = (temp + current_bias) / 256;
				conv_expanding_result[o_ch][i][j] = temp < 0 ? (temp / 256) * current_slope : temp;
			}
		}
	}
	return;
}

void CONV_LAST() {
	for (int o_ch = 0; o_ch < NUM_CONV_LAST_RESULT_CHANNEL; o_ch++) {
		double current_bias = conv_last_bias[o_ch];
		for (int i = 0; i < INPUT_VSIZE * 3; i++) {
			for (int j = 0; j < INPUT_HSIZE * 3; j++) {
				double temp = 0.0;
				for (int i_ch = 0; i_ch < NUM_CONV_EXPANDING_RESULT_CHANNEL; i_ch++) {
					for (int ii = i - 4; ii <= i + 4; ii++) {
						for (int jj = j - 4; jj <= j + 4; jj++) {
							if (!((ii < 0) || (jj < 0) || (ii >= INPUT_VSIZE * 3) || (jj >= INPUT_HSIZE * 3) || (ii % 3 != 0) || (jj % 3 != 0))) {
								temp = temp + conv_last_weight[o_ch][i_ch][(ii - i) * 9 + (jj - j) + 40] * conv_expanding_result[i_ch][ii / 3][jj / 3];
							}
						}
					}
				}
				temp = (temp + current_bias) / 4096;
				conv_last_result[o_ch][i][j] = temp < 0 ? 0 : (temp > 1 ? 1 : temp);
			}
		}
	}
	return;
}

void SuperResolution() {
	CONV_FIRST();
	CONV_SHRINK();
	CONV_MAPPING_0();
	CONV_MAPPING_1();
	CONV_MAPPING_2();
	CONV_MAPPING_3();
	CONV_EXPANDING();
	CONV_LAST();
	return;
}

void BENCHMARK() {
	struct timeval start, end;
	gettimeofday(&start, NULL);
	SuperResolution();
	gettimeofday(&end, NULL);
	printf("%d micro-second!\n", (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec));
	return;
}

void EVAL_MIN_MAX_CONV_FIRST() {
	double min = 100.0;
	double max = -100.0;
	for (int ch = 0; ch < NUM_CONV_FIRST_RESULT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				if (min > conv_first_result[ch][i][j]) {
					min = conv_first_result[ch][i][j];
				}
				
				if (max < conv_first_result[ch][i][j]) {
					max = conv_first_result[ch][i][j];
				}
			}
		}
	}
	printf("conv_first min,max = %.10lf, %.10lf\n", min, max);
	return;
}

void EVAL_MIN_MAX_CONV_SHRINK() {
	double min = 100.0;
	double max = -100.0;
	for (int ch = 0; ch < NUM_CONV_SHRINK_RESULT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				if (min > conv_shrink_result[ch][i][j]) {
					min = conv_shrink_result[ch][i][j];
				}
				
				if (max < conv_shrink_result[ch][i][j]) {
					max = conv_shrink_result[ch][i][j];
				}
			}
		}
	}
	printf("conv_shrink min,max = %.10lf, %.10lf\n", min, max);
	return;
}

void EVAL_MIN_MAX_CONV_MAPPING_0() {
	double min = 100.0;
	double max = -100.0;
	for (int ch = 0; ch < NUM_CONV_MAPPING_RESULT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				if (min > conv_mapping_0_result[ch][i][j]) {
					min = conv_mapping_0_result[ch][i][j];
				}
				
				if (max < conv_mapping_0_result[ch][i][j]) {
					max = conv_mapping_0_result[ch][i][j];
				}
			}
		}
	}
	printf("conv_mapping_0 min,max = %.10lf, %.10lf\n", min, max);
	return;
}

void EVAL_MIN_MAX_CONV_MAPPING_1() {
	double min = 100.0;
	double max = -100.0;
	for (int ch = 0; ch < NUM_CONV_MAPPING_RESULT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				if (min > conv_mapping_1_result[ch][i][j]) {
					min = conv_mapping_1_result[ch][i][j];
				}
				
				if (max < conv_mapping_1_result[ch][i][j]) {
					max = conv_mapping_1_result[ch][i][j];
				}
			}
		}
	}
	printf("conv_mapping_1 min,max = %.10lf, %.10lf\n", min, max);
	return;
}

void EVAL_MIN_MAX_CONV_MAPPING_2() {
	double min = 100.0;
	double max = -100.0;
	for (int ch = 0; ch < NUM_CONV_MAPPING_RESULT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				if (min > conv_mapping_2_result[ch][i][j]) {
					min = conv_mapping_2_result[ch][i][j];
				}
				
				if (max < conv_mapping_2_result[ch][i][j]) {
					max = conv_mapping_2_result[ch][i][j];
				}
			}
		}
	}
	printf("conv_mapping_2 min,max = %.10lf, %.10lf\n", min, max);
	return;
}

void EVAL_MIN_MAX_CONV_MAPPING_3() {
	double min = 100.0;
	double max = -100.0;
	for (int ch = 0; ch < NUM_CONV_MAPPING_RESULT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				if (min > conv_mapping_3_result[ch][i][j]) {
					min = conv_mapping_3_result[ch][i][j];
				}
				
				if (max < conv_mapping_3_result[ch][i][j]) {
					max = conv_mapping_3_result[ch][i][j];
				}
			}
		}
	}
	printf("conv_mapping_3 min,max = %.10lf, %.10lf\n", min, max);
	return;
}

void EVAL_MIN_MAX_CONV_EXPANDING() {
	double min = 100.0;
	double max = -100.0;
	for (int ch = 0; ch < NUM_CONV_EXPANDING_RESULT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE; i++) {
			for (int j = 0; j < INPUT_HSIZE; j++) {
				if (min > conv_expanding_result[ch][i][j]) {
					min = conv_expanding_result[ch][i][j];
				}
				
				if (max < conv_expanding_result[ch][i][j]) {
					max = conv_expanding_result[ch][i][j];
				}
			}
		}
	}
	printf("conv_expanding min,max = %.10lf, %.10lf\n", min, max);
	return;
}

void EVAL_MIN_MAX_CONV_LAST() {
	double min = 100.0;
	double max = -100.0;
	for (int ch = 0; ch < NUM_CONV_LAST_RESULT_CHANNEL; ch++) {
		for (int i = 0; i < INPUT_VSIZE * 3; i++) {
			for (int j = 0; j < INPUT_HSIZE * 3; j++) {
				if (min > conv_last_result[ch][i][j]) {
					min = conv_last_result[ch][i][j];
				}
				
				if (max < conv_last_result[ch][i][j]) {
					max = conv_last_result[ch][i][j];
				}
			}
		}
	}
	printf("conv_last min,max = %.10lf, %.10lf\n", min, max);
	return;
}

void EVAL_MIN_MAX() {
	EVAL_MIN_MAX_CONV_FIRST();
	EVAL_MIN_MAX_CONV_SHRINK();
	EVAL_MIN_MAX_CONV_MAPPING_0();
	EVAL_MIN_MAX_CONV_MAPPING_1();
	EVAL_MIN_MAX_CONV_MAPPING_2();
	EVAL_MIN_MAX_CONV_MAPPING_3();
	EVAL_MIN_MAX_CONV_EXPANDING();
	EVAL_MIN_MAX_CONV_LAST();
	return;
}

int main() {
	READ_INPUT();
	BENCHMARK();
	EVAL_MIN_MAX();
	WRITE_OUTPUT();
	return 0;
}
