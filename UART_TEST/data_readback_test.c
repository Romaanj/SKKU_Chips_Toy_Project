#include "xparameters.h"
#include "xuartlite.h"
#include "xuartlite_l.h"
#include "xil_printf.h"
#include "platform.h"
#include "xil_io.h"
#include <stdint.h>

#define UART_BASEADDR    XPAR_XUARTLITE_0_BASEADDR // 0x0000_0000U
#define BRAM_BASEADDR    (XPAR_AXI_BRAM_0_BASEADDRESS) // 0xc0000000

// 이미지 관련 정의
#define IMG_WIDTH        84
#define IMG_HEIGHT       84
#define IMG_CHANNELS     4  // RGB + padding
#define QFORMAT_BYTES    1
#define TOTAL_PIXELS     (IMG_WIDTH * IMG_HEIGHT)  // 7056 픽셀
#define TOTAL_IMG_BYTES  (TOTAL_PIXELS * IMG_CHANNELS * QFORMAT_BYTES)  // 28224 바이트

// Weight 관련 정의 (예시 - 실제 크기에 맞게 조정)
#define CONV_FIRST_0_WEIGHT_SIZE  4200  // 75x56 = 4200개 weight
#define CONV_FIRST_0_BIAS_SIZE    56    // output channel 수
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

// 총 weight 개수 (conv last 제외) //11036
#define TOTAL_WEIGHTS    (CONV_FIRST_0_WEIGHT_SIZE + CONV_FIRST_0_BIAS_SIZE + CONV_FIRST_1_ALPHA_SIZE + CONV_SHRINK_0_WEIGHT_SIZE + CONV_SHRINK_0_BIAS_SIZE + CONV_SHRINK_1_ALPHA_SIZE + (CONV_MAPPING_WEIGHT_SIZE+CONV_MAPPING_BIAS_SIZE)*CONV_MAPPING_NUM+CONV_MAPPING_ALPHA_SIZE+ +CONV_EXPAND_0_WEIGHT_SIZE+ CONV_EXPAND_0_BIAS_SIZE+CONV_EXPAND_1_ALPHA_SIZE)
#define TOTAL_WEIGHT_WORDS ((TOTAL_WEIGHTS + 3) / 4)  // 2759 개

// conv last weight 개수 // 13611
#define TOTAL_CONV_LAST     CONV_LAST_WEIGHT_SIZE + CONV_LAST_BIAS_SIZE
#define TOTAL_CONV_LAST_WORDS    ((TOTAL_CONV_LAST + 3) / 4) // 3403 개

#define TOTAL_ALL_WEIGHT_WORDS   (TOTAL_WEIGHT_WORDS + TOTAL_CONV_LAST_WORDS)

// BRAM 메모리 레이아웃
#define PIXEL_START_ADDR    0
#define WEIGHT_START_ADDR   TOTAL_PIXELS  // 픽셀 데이터 다음 주소부터

int main() {
    init_platform();

    volatile uint32_t *bram32 = (uint32_t*)BRAM_BASEADDR;
    int pix_idx = 0;
    int weight_idx = 0;
    int last_idx = 0;
    uint8_t buf[4];


    // ===== STEP 1: 픽셀 데이터 수신 =====
    while (pix_idx < TOTAL_PIXELS) {
        // 4바이트 수신 (R, G, B, 0x00)
        for (int i = 0; i < 4; i++) {
            while (XUartLite_IsReceiveEmpty(UART_BASEADDR));
            buf[i] = XUartLite_RecvByte(UART_BASEADDR);
        }

        // big-endian으로 수신된 데이터를 32비트 워드로 구성
        uint32_t word = (buf[0]<<24) | (buf[1]<<16) | (buf[2]<<8) | buf[3];
        bram32[PIXEL_START_ADDR + pix_idx] = word; // 0~7055
        pix_idx++;

    }

    // 픽셀 데이터 완료 ACK 전송
    xil_printf("PIXEL_COMPLETE\r\n");

    // ===== STEP 2: Weight 데이터 수신 =====
    while (weight_idx < TOTAL_ALL_WEIGHT_WORDS) {
        // 4바이트 수신 (weight 4개씩 묶음)
        for (int i = 0; i < 4; i++) {
            while (XUartLite_IsReceiveEmpty(UART_BASEADDR));
            buf[i] = XUartLite_RecvByte(UART_BASEADDR);
        }

        // big-endian으로 수신된 데이터를 32비트 워드로 구성
        uint32_t word = (buf[0]<<24) | (buf[1]<<16) | (buf[2]<<8) | buf[3];
        bram32[WEIGHT_START_ADDR + weight_idx] = word; // 7056 ~ 9814
        weight_idx++;

    }
    // Weight 데이터 완료 ACK 전송
    xil_printf("WEIGHT_COMPLETE\r\n"); //

    // ===== STEP 3: 데이터 검증 및 Readback =====

    // 픽셀 데이터 readback
    for (int i = 0; i < pix_idx; i++) {
        uint32_t word = bram32[PIXEL_START_ADDR + i];
        // 각 32비트 word를 바이트로 쪼개서 전송 (big-endian 순서 유지)
        uint8_t byte1 = (word >> 24) & 0xFF;  // R
        uint8_t byte2 = (word >> 16) & 0xFF;  // G
        uint8_t byte3 = (word >> 8) & 0xFF;   // B
        uint8_t byte4 = word & 0xFF;          // 0x00

        XUartLite_SendByte(UART_BASEADDR, byte1);
        XUartLite_SendByte(UART_BASEADDR, byte2);
        XUartLite_SendByte(UART_BASEADDR, byte3);
        XUartLite_SendByte(UART_BASEADDR, byte4);
    }

    // 픽셀 readback 완료 신호
    xil_printf("PIXEL_READBACK_COMPLETE\r\n");

    // Weight 데이터 readback
    for (int i = 0; i < weight_idx; i++) {
        uint32_t word = bram32[WEIGHT_START_ADDR + i];
        // 각 32비트 word를 바이트로 쪼개서 전송 (big-endian 순서 유지)
        uint8_t byte1 = (word >> 24) & 0xFF;  // weight 1
        uint8_t byte2 = (word >> 16) & 0xFF;  // weight 2
        uint8_t byte3 = (word >> 8) & 0xFF;   // weight 3
        uint8_t byte4 = word & 0xFF;          // weight 4

        XUartLite_SendByte(UART_BASEADDR, byte1);
        XUartLite_SendByte(UART_BASEADDR, byte2);
        XUartLite_SendByte(UART_BASEADDR, byte3);
        XUartLite_SendByte(UART_BASEADDR, byte4);
    }

    // Weight readback 완료 신호
    xil_printf("WEIGHT_READBACK_COMPLETE\r\n");

    xil_printf("ALL_COMPLETE\r\n");

    cleanup_platform();
    return 0;
}
